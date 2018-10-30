#!/bin/bash

MIRROR_ROOT=$(dirname "${BASH_SOURCE}")

source "${MIRROR_ROOT}/util/validate_filepath.sh"
source "${MIRROR_ROOT}/util/save_not_pull_images.sh"
source "${MIRROR_ROOT}/util/get_image_info.sh"

#循环标记
cnt=1
#标记已pull的镜像数量
msg=1
#统计pull成功数量
pullCnt=0
#远程仓库
fromRepo=""
#镜像名称
imagesName=""
#推送仓库
toRepo=""

#pull&tag镜像
pullImages(){
    #读取文件信息
    for imagesInfo in $(cat $1)
    do
        #文件信息两个一组，第一个需要修改成的tag，第二个来源仓库
        val=`expr $cnt % 2`
        if [ $val -eq 1 ]; then
           #获取镜像信息（远程仓库、镜像名称）
           getImageInfo $imagesInfo
        else
            #获取推送仓库
            toRepo=$imagesInfo
            #pull私有仓库镜像
            echo "Msg : No.${msg} : ${imagesName} pull begin       ***"
            sudo docker pull $toRepo/$imagesName
            saveNotPull $? $msg $fromRepo $imagesName $toRepo
            if [ "$?" -eq 0 ]; then
                pullCnt=`expr $pullCnt + 1`
                #更新标签tag
                echo "Msg : No.${msg} : ${imagesName} rename           ***"
                sudo docker tag $toRepo/$imagesName $fromRepo$imagesName
                #删除旧标签镜像
                echo "Msg : No.${msg} : ${imagesName}.old remove begin ***"
                sudo docker rmi $toRepo/$imagesName
                echo "Msg : No.${msg} : ${imagesName}.old remove end   ***"
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
        cat ${MIRROR_ROOT}/not_pull_images.txt
    fi
else
    #校验失败，退出脚本
    exit
fi