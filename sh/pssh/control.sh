#!/bin/sh

# 脚本使用说明
Usage(){
    echo "welcome use batch control script
    -----------------------------------------
    use it require input your user account
                         your user password
           gook luck!
    author:
        dengtao@duoquyuedu.com
    -----------------------------------------
    Usage:
            --list=list
            --shell=script.sh
    ./control.sh --list=list --shell=script.sh
    "
}
# 参数数量判断
if [[ $# -ne 2 ]]; then
    echo "parameters is no reght!"
    Usage
    exit
fi

FIR=$1
SEC=$2

# list文件判断
if [ ! -z $FIR ] && [ "`echo $FIR | awk -F"=" '{print $1}'`" == "--list" ]; then
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
if [ ! -z $SEC ] && [ "`echo $SEC | awk -F"=" '{print $1}'`" == "--shell" ]; then
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

# echo "input your account:"
# read -s USER
# echo "input your account $USER password:"
# read -s PASSWD
# PASSWD_MI=`echo $PASSWD | openssl base64`

# echo "user:'$USER'  password:'$PASSWD' MI:'$PASSWD_MI'"


echo "
     you will exectuion
     ./control.sh --list=$LIST_FILE --shell=$SHELL_FILE
machine list: "
head -n 10 $LIST_FILE
echo "..."
echo "..."
echo "SHELL script :"
head -n 10 $SHELL_FILE
echo "..."
echo "..."

# 执行前的最后一次提示和确认
# echo "are you sure ? are you clear ? yes/no"
# read ans
# while [[ "x"$ans != "xyes" && "x"$ans != "xno" ]]
# do
#     echo "input yes/no"
#     read ans
# done
# if [ $ans == no ] ; then
#    echo "baatch control execution cancel"
#    exit
# fi

# for host in `cat $LIST_FILE`
# do
#     echo "--------------------------------"
#     echo " "
#     echo " "
#     echo $host" execution $SHELL_FILE..."
# done

SHELLS_DIR='/tmp/shells'
#get real path
cd `echo ${0%/*}`
abspath=`pwd`
LOGS_DIR=$abspath/logs
# pssh -h $LIST_FILE -l root -P "mkdir -p $SHELLS_DIR"
echo "pssh -h $LIST_FILE -l root -o $LOGS_DIR -P \"mkdir -p $SHELLS_DIR\""
pssh -h $LIST_FILE -l root -o $LOGS_DIR -P "mkdir -p $SHELLS_DIR"
echo "pscp -h $LIST_FILE -l root -o $LOGS_DIR $SHELL_FILE  $SHELLS_DIR/$SHELL_FILE"
pscp -h $LIST_FILE -l root -o $LOGS_DIR $SHELL_FILE  $SHELLS_DIR/$SHELL_FILE

pssh -h $LIST_FILE -l root -o $LOGS_DIR -P "sh $SHELLS_DIR/$SHELL_FILE"
# for CMD in `cat $SHELL_FILE`
# do
#     echo $CMD
#     pssh -h $LIST_FILE -l root -P "$CMD"
# done

# while read CMD
# do
#     echo "execution $CMD"
# done < $SHELL_FILE