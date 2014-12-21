#!/bin/sh

# 脚本使用说明
Usage(){
    echo "welcome use front-end release script
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
}

die( ){
    echo
    echo "$*"
    Usage
    echo
    exit 1
}

err( ){
    echo
    echo "------------------------------------"
    echo "$*"
    echo "------------------------------------"
    echo
    exit 1
}


# 参数数量判断
if [[ $# -ne 1 ]]; then
    die "parameters is no reght!"
fi

# get real path
cd `echo ${0%/*}`
abspath=`pwd`
echo $abspath

# OS specific support (must be 'true' or 'false').
darwin=false
linux=false
case "`uname`" in
  Linux* )
    linux=true
    ;;
  Darwin* )
    darwin=true
    ;;
esac

# 获取参数
TARGET=$1

# 定义版本
PROJECT=`underscore select .name --outfmt text < package.json`

# 同步不同环境服务器的方法
sync( ){
    case $* in
        "test" )
            echo "------------------  sync to test -----------------------"
            SyncServer="rsync://172.18.10.38/rsync"
            SyncST="rsync -avu --port=30873 --delete --progress ./dest/{images,css,js} $SyncServer/dq/resource/st/$PROJECT/"
            SyncHTML="rsync -avu --port=30873 --delete --progress ./dest/{*.html,res_tmp} $SyncServer/dq/resource/html/$PROJECT/"

            echo $SyncST
            eval $SyncST

            echo $SyncHTML
            eval $SyncHTML

            ;;
        "production" )
            echo "------------------  sync to production  ------------------"
            read  -p "input your production server account: " USER
            SCPCMD="scp $abspath/deploy/$PROJECT.tar.bz2 $USER@123.56.85.106:~/release/"

            echo $SCPCMD
            eval $SCPCMD
            ;;
    esac
}

# 发布到测试环境
test(){
    git pull

    grunt target

    STWEBServer="http:\/\/st.dq.in"
    if $darwin ; then
        echo "This is Mac OSX......"
        for p in images css js; do
            find ./dest/ -name '*.html' -exec sed -i '' "s/.\/$p\//$STWEBServer\/$PROJECT\/$p\//g" {} \;
        done
    elif $linux ; then
        echo "This is Linux......"
        for p in images css js; do
            find ./dest/ -name '*.html' -exec sed -i "s/.\/$p\//$STWEBServer\/$PROJECT\/$p\//g" {} \;
        done
    fi
    sync $TARGET
}



# 发布到生产环境
production(){
    git pull

    grunt deploy

    cd  $abspath/deploy

    tar jcvf pandora-ft.tar.bz2 pandora

    sync $TARGET
}

release(){
    # 判断是否还有修改未提交
    if [[ `git status | grep 'Changes'|wc -l` -eq  1 ]]; then
        echo "you have local modifications"
        err "`git status`"
    fi
    # 判断是否当前分支为master
    if [[ `cat .git/HEAD |awk -F '\' '{print $NF}'` != "master" ||  `cat .git/HEAD |awk -F '\' '{print $3}'` != "master" ]]; then
        echo "you current branch is not master"
        err "`git branch`"
    fi
    if [[ `cat .git/HEAD | grep 'master' |wc -l` -ne 1 ]]; then
        echo "you current branch is not master"
        err "`git branch`"
    fi

    git pull
    VERSION=`underscore select .version --outfmt text < package.json`
    CURRNET_VERSION=$VERSION
    read -p "$PROJECT current version is $VERSION : [Y/n]" key
    if [[ $key == 'n' ]]; then
        read -p "set current version : " NEW_VERSION
        VERSION=$NEW_VERSION
    fi
    if [[ $CURRENT_VERSION != $VERSION ]]; then
        echo "-------更新为指定版本---------"
        underscore -i package.json process "data.version='$VERSION'; data;"  -o package.json
        git commit -am "update package.json version to $VERSION"
    fi
    git tag -m "$PROJECT-$VERSION released" $PROJECT-$VERSION
    git push --tags

    NEXT_VERSION="${VERSION%.*}.`echo ${VERSION%%.*}+1|bc`"
    echo "NEXT_VERSION:'$NEXT_VERSION'"
    # underscore -i package.json process 'vv=data.version.split("."); vv[2]++; data.version=vv.join("."); data;' -o package.json
    underscore -i package.json process "data.version='$NEXT_VERSION'; data;"  -o package.json
    git commit -am "next package.json version to $NEXT_VERSION"
    git push
}

# 判断执行参数，调用指定方法
case $TARGET in
    test )
        test
        ;;
    production )
       production
        ;;
    release )
       release
        ;;
    * )
        die "parameters is no reght!"
        ;;
esac