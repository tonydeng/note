#!/bin/sh
# 脚本使用说明
Usage(){
    echo "welcome use run pssh script
    -----------------------------------------
    use it require input your run script target hosts
           gook luck!
    author:
        dengtao@duoquyuedu.com
    -----------------------------------------
    Usage:

    # 执行指定脚本
    ./run_pssh_script.sh --hosts=hosts.conf --script=script.sh
    "
}

die( ){
    echo
    echo "$*"
    Usage
    echo
    exit 1
}

# 参数数量判断
if [[ $# -ne 2 ]]; then
    die "parameters is no reght!"
fi


#get real path
if [[ -z ${0%/*} ]]; then
    cd `echo ${0%/*}`
fi
abspath=`pwd`

FIR=$1
SEC=$2

KEY=`find $abspath -name 'authorized_keys'`

# list文件判断
if [ ! -z $FIR ] && [ "`echo $FIR | awk -F"=" '{print $1}'`" == "--hosts" ]; then
    LIST_FILE="`echo $FIR | awk -F"=" '{print $2}'`"
    if [[ ! -f $LIST_FILE ]]; then
        echo "$LIST_FILE is not exist"
        Usage
        exit
    fi
else
    Usage
    exit
fi

# shell文件判断
if [ ! -z $SEC ] && [ "`echo $SEC | awk -F"=" '{print $1}'`" == "--script" ]; then
    SHELL_FILE="`echo $SEC | awk -F"=" '{print $2}'`"
    if [[ ! -f $SHELL_FILE ]]; then
        echo "$SHELL_FILE is not exist"
        Usage
        exit
    fi
else
    Usage
    exit
fi

#create shell dir
CREATE_DIR="/home/taod/shells/create_release_user"
CREATE_CMD="pssh -h $LIST_FILE -l taod -P 'mkdir -p $CREATE_DIR'"
echo $CREATE_CMD
eval $CREATE_CMD

# upload keys file
if [[ -f $KEY ]]; then
    SCP_KEY="pscp -h $LIST_FILE -l taod $KEY $CREATE_DIR"
    echo $SCP_KEY
    eval $SCP_KEY
fi

# upload scripts file
while read SCRIPT; do
    SCP_SCRIPT="pscp -h $LIST_FILE  -l taod $SCRIPT $CREATE_DIR"
    echo $SCP_SCRIPT
    eval $SCP_SCRIPT
done < `find $abspath -name '*.script'`

# run remote server script
RUN_SCRIPT="pssh -h $LIST_FILE -l taod -p 'sh $CREATE_DIR/$SHELL_FILE'"