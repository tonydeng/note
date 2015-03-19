#!/bin/sh

######################
## 在内网服务器批量添加用户的public key
######################
#
Usage(){
    echo "batch add publickey to lan servers
    -----------------------------------------
    use it require add your public key target hosts
           gook luck!
    author:
        dengtao@duoquyuedu.com
    -----------------------------------------
    Usage:

    # 执行指定脚本
    ./batch_add_public_key.sh keyfile hosts
    "
}


die( ){
    echo
    echo "$*"
    Usage
    echo
    exit 1
}

cd `echo ${0%/*}`
abspath=`pwd`

PUBLIC_KEY=$1
SERVERS=$2

# 参数数量判断
if [[ $# -lt 1 || $# -gt 2 ]]; then
    die "parameters is no reght!"
fi

# list文件判断

if [[ ! -f $PUBLIC_KEY ]]; then
    die "public key file $PUBLIC_KEY is not exist"
fi

# servers host文件判断
if [[ ! -f $SERVERS ]]; then
    SERVERS=$abspath/servers_host.txt
fi


KEY=`cat $PUBLIC_KEY`

LOGS_DIR=$abspath/logs

SERVERS=$abspath/servers_host.txt

CMD="pssh -h $SERVERS -l root -o $LOGS_DIR -P \"echo $KEY >> ~/.ssh/authorized_keys\""

echo $CMD

eval $CMD