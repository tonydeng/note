#!/bin/sh
#
# 用来合并书籍统计和支付统计的数据
#
# --------字段说明----------
# 书籍统计的字段
#   1. 日期 （格式是 20150301）
#   2. 书籍ID
#   3. PV
#   4. UV
#   5. 书籍名
#   6. 版权来源
#
# 支付统计的数据
#   1. 日期 （格式是 2015-3-1）
#   2. 书籍ID
#   3. 支付多宝数
#   5. UV
#----------------------------


BOOK_DATA=$1
PAY_DATA=$2

TMP_PAY_DATA="/tmp/$$_pay_data"
TMP_ALL_DATA="/tmp/$$_all_data"
dateformat(){
    awk -F '[- ]' '{if(length($3) >1) { day=$1"0"$2$3 } else { day=$1"0"$2"0"$3 }}  {print day,$6,$9,$12}' $PAY_DATA > $TMP_PAY_DATA
}

merge(){
    while read ID; do
        BID=`echo $ID | awk -F ' ' '{print $1,$2}'`
        GREP_PAY_CMD="grep '$BID' $TMP_PAY_DATA | awk '{print \$3,\$4}'"
        PAY=`eval $GREP_PAY_CMD`
        if [ ! -n "$PAY" ]; then
            PAY="0 0"
        fi
        echo "$ID $PAY" >> $TMP_ALL_DATA
    done < $BOOK_DATA

    rm -f $TMP_PAY_DATA
}
dateformat
merge