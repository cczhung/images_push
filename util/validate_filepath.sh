#!/bin/bash

#判断文件是否存在
hasFilepath(){
    #文件位置校验标记
    flag=0
    #判断参数是否为空
    if [ -z "$*" ]; then
        echo "Usage: $0 <Images_flie_list...>"
        exit
    fi
    #校验文件是否存在
    for filepath in "$@"; do
        if [ ! -f "$filepath" ]; then
            echo "Error: File:'$filepath' not exist,please confirm try again."
            flag=1
        fi
    done
    return $(($flag))
}
