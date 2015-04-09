#!/bin/sh

ID_LOG=$1
NAME_LOG=$2
PROVDER_LOG=$3


while read ID; do
    # echo $ID
    # BID=`echo $ID | awk -F ' ' '{print $3}'`
    BID=`echo $ID | awk -F ' ' '{print $2}'`
    # echo $BID
    # grep 'NumberLong(3050)' pandora-top-book-name.log|awk -F ':' '{print $3}' |awk  '{print $1}'
    # GREP_NAME_CMD="grep 'NumberLong($BID)' $NAME_LOG | awk -F ':' '{print \$3}' |awk  '{print \$1}'"
    GREP_NAME_CMD="grep 'NumberLong($BID)' $NAME_LOG | awk -F ':' '{print \$3}' |awk -F '\"' '{print \$2}'"
    # echo $GREP_NAME_CMD
    NAME=`eval $GREP_NAME_CMD`

    GREP_PROVDER_CMD="grep 'NumberLong($BID)' $NAME_LOG | awk -F ':' '{print \$4}' |awk -F '\}' '{print \$1}'"
    PROVDER_ID=`eval $GREP_PROVDER_CMD`

    GREP_PEOVDER_NAME_CMD="grep \": `echo $PROVDER_ID|tr -d '''\0'`,\" $PROVDER_LOG | awk -F ':' '{print \$3}' |awk -F '\}' '{print \$1}'"
    # echo $GREP_PEOVDER_NAME_CMD
    PROVDER_NAME=`eval $GREP_PEOVDER_NAME_CMD`

    echo "$ID $NAME $PROVDER_NAME"
done < $ID_LOG