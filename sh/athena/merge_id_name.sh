#!/bin/sh

ID_LOG=$1
NAME_LOG=$2



while read ID; do
    # echo $ID
    BID=`echo $ID | awk -F ' ' '{print $3}'`
    # echo $BID
    # grep 'NumberLong(3050)' pandora-top-book-name.log|awk -F ':' '{print $3}' |awk  '{print $1}'
    GREP_CMD="grep 'NumberLong($BID)' $NAME_LOG | awk -F ':' '{print \$3}' |awk  '{print \$1}'"
    # echo $GREP_CMD
    NAME=`eval $GREP_CMD`
    echo "$ID $NAME"
done < $ID_LOG