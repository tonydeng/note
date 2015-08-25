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
}

Die( ){
    echo
    echo "$*"
    Usage
    echo
    exit 1
}


# 定义脚本需要的变量
# get real path
cd `echo ${0%/*}`
abspath=`pwd`

URL=$1
WAR=${URL##*/}
PROJECT=${WAR%-*}

UrlCheck(){
    if [ ! -z $URL ] &&  [ "`echo $URL|awk -F '/' '{print $3}'`" == 'mvn.dq.in' ]; then
        echo $WAR
        echo "'${WAR##*.}'"
        if [ ! -z $WAR ] && [ "`echo ${WAR##*.}`" != 'war' ]; then
            Die "URL is not standardized , No war"
        fi
    else
        Die "URL is no standardized"
    fi
}


Build(){
    WAR_DIR=$abspath/war
    TMP_DIR=$abspath/tmp

    rm -rf $WAR_DIR
    rm -rf $TMP_DIR
    # download war
    echo
    echo "-------------------download war------------------------"
    echo
    wget -c -P $WAR_DIR $URL

    if [[ ! -f $WAR_DIR/$WAR ]]; then
        Die "$WAR_DIR/$WAR is not exist"
    fi

    # package
    mkdir -p $TMP_DIR/$PROJECT

    cd $TMP_DIR/$PROJECT

    jar xvf $WAR_DIR/$WAR

    cp -rf WEB-INF/backup/deploy/* WEB-INF/config/

    cd ../

    tar jcvf $PROJECT.tar.bz2 $PROJECT

    #Sync
    SyncCmd="scp $TMP_DIR/$PROJECT.tar.bz2 release@123.56.85.106:~/release/war/"
    echo $SyncCmd
    eval $SyncCmd

    #Clean

    rm -rf $WAR_DIR
    rm -rf $TMP_DIR
}


Main(){
    UrlCheck
    Build
}

Main

