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

    # 下载war并替换生产环境的配置
    ./deploy.sh url
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
TMP_DIR=$abspath/tmp

rm -rf $WAR_DIR
rm -rf $TMP_DIR

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

if [[ ! -f $WAR_DIR/$WAR ]]; then
    echo "$WAR_DIR/$WAR is not exist"
    Usage
fi

# mkdir -p $WAR_DIR
# cd $WAR_DIR
echo
echo "-------------------download war------------------------"
echo
wget -c -P $WAR_DIR $URL



mkdir -p $TMP_DIR/$PROJECT

cd $TMP_DIR/$PROJECT

jar xvf $WAR_DIR/$WAR

cp -rf WEB-INF/backup/deploy/* WEB-INF/config/

cd ../

tar jcvf $PROJECT.tar.bz2 $PROJECT

