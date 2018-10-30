#!/bin/bash
getImageInfo(){
    if [[ $1 == */* ]];then
        #截取远程仓库
        fromRepo=${1%/*}/
        #截取镜像名称
        imagesName=${1##*/}
    else
        #截取远程仓库
        fromRepo=""
        #截取镜像名称
        imagesName=$1
    fi
}