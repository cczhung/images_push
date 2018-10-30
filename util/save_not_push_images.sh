#!/bin/bash

#输出没有pull的镜像
# $1上一步命令的结果
# $2镜像的序号
#***此处注意***可能会没有来源库信息，没有的话将导致参数上移
# $3镜像的来源库
# $4镜像名
# $5目的仓库
saveNotPush(){
    if [ ! "$1" -eq 0 ]; then
    #验证传入多少个参数
        if [ "$#" -eq 4 ]; then
            echo "Msg : No.${2} : ${3} push failed      ***"
            echo "$3 $4" >> not_push_images.txt
        else
            echo "Msg : No.${2} : ${4} push failed      ***"
            echo "$3$4 $5" >> not_push_images.txt
        fi
        return 1
    else
        if [ "$#" -eq 4 ]; then
            echo "Msg : No.${2} : ${3} push end         ***"
        else
            echo "Msg : No.${2} : ${4} push end         ***"
        fi
        return 0
    fi
}