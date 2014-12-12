#!/bin/sh

# 脚本使用说明
Usage(){
    echo "welcome use war deploy script
    -----------------------------------------
    use it require input your deploy target
           gook luck!
    author:
        dengtao@duoquyuedu.com
    -----------------------------------------
    Usage:

    # 发布到测试环境
    ./deploy.sh test

    # 发布到生产环境
    ./deploy.sh production

    # 发布版本到Git
    ./deploy.sh release
    "
    exit 1
}

# 定义脚本需要的变量
# get real path
cd `echo ${0%/*}`
abspath=`pwd`

URL=$1
WAR=${URL##*/}
PROJECT=${WAR%-*}

WAR_DIR=$abspath/war

if [ ! -z $URL ] &&  [ "`echo $URL|awk -F '/' '{print $3}'`" == 'mvn.dq.in' ]; then
    echo $WAR
    echo "'${WAR##*.}'"
    if [ ! -z $WAR ] && [ "`echo ${WAR##*.}`" != 'war' ]; then
        echo "URL is not standardized , No war"
        Usage
    fi
else
    Usage
fi


mkdir -p $WAR_DIR
cd $WAR_DIR

wget $URL -o $WAR

