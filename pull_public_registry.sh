#!/bin/bash

MIRROR_ROOT=$(dirname "${BASH_SOURCE}")

source "${MIRROR_ROOT}/util/validate_filepath.sh"
source "${MIRROR_ROOT}/util/save_not_pull_images.sh"
source "${MIRROR_ROOT}/util/save_not_push_images.sh"
source "${MIRROR_ROOT}/util/get_image_info.sh"

#循环标记
cnt=1
#标记已下载的镜像数量
msg=1
#统计pull和push成功数量
pullCnt=0
pushCnt=0
#远程仓库
fromRepo=""
#镜像名称
imagesName=""
#推送仓库
toRepo=""

#pull&tag&push镜像
pullImages(){
    #读取文件信息
    for imagesInfo in $(cat $1)
    do
        #文件信息两个一组，第一个远程仓库及镜像名，第二个私有仓库
        val=`expr $cnt % 2`
        if [ $val -eq 1 ]; then
           #获取镜像信息（远程仓库、镜像名称）
           getImageInfo $imagesInfo
        else
            #获取推送仓库
            toRepo=$imagesInfo
            #pull原镜像
            echo "Msg : No.${msg} : ${imagesName} pull begin      ***"
            sudo docker pull $fromRepo$imagesName
            saveNotPull $? $msg $fromRepo $imagesName $toRepo
            if [ "$?" -eq 0 ]; then
                pullCnt=`expr $pullCnt + 1`
                #更新标签
                echo "Msg : No.${msg} : ${imagesName} rename           ***"
                sudo docker tag $fromRepo$imagesName $toRepo/$imagesName
                #推送服务器
                echo "Msg : No.${msg} : ${imagesName} push begin       ***"
                docker push $toRepo/$imagesName
                saveNotPush $? $msg $fromRepo $imagesName $toRepo
                if [ "$?" -eq 0 ]; then
                    pushCnt=`expr $pushCnt + 1`
                    #删除新标签镜像
                    echo "Msg : No.${msg} : ${imagesName} remove begin     ***"
                    sudo docker rmi $fromRepo$imagesName
                    sudo docker rmi $toRepo/$imagesName
                    echo "Msg : No.${msg} : ${imagesName} remove end       ***"
                fi
            fi
            msg=`expr $msg + 1`
        fi
        cnt=`expr $cnt + 1`
    done
}

##################
#程序从这里开始
##################

#校验参数
hasFilepath $@
#执行镜像拉取
#判断校验结果
if [ "$?" -eq 0 ]; then
    #对文件列表进行遍历拉取镜像
    for filepath in "$@"; do
        pullImages $filepath
    done
    val=`expr $msg - $pullCnt - 1`
    if [ $val -eq 0 ]; then
        echo "Msg : All images pull complete."
    else
        echo "Msg : Some images Not pull complete,Check the log file ${MIRROR_ROOT}/not_pull_images.txt for details."
    fi
    val=`expr $pullCnt - $pushCnt`
    if [ ! $val -eq 0 ]; then
        echo "Msg : Some images Not push complete,Check the log file ${MIRROR_ROOT}/not_push_images.txt for details."
    fi
else
    #校验失败，退出脚本
    exit
fi
