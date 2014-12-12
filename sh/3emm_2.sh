#!/bin/sh
####V1 20130617
##ikko@foxmail.com

#INFO_FILE=info.lst
###CLASS INFO
CLASSES=(
http://www.3emm.com/xinggan/
http://www.3emm.com/meitui/
http://www.3emm.com/weimei/
http://www.3emm.com/chemo/
http://www.3emm.com/rihan/
http://www.3emm.com/mingxing/
http://www.3emm.com/youxi/
)

WEBSITE=http://www.3emm.com/
IMAGE_SITE=http://img.3emm.com/
DOWN_DIR=/home/3emm/

COOKIES_DIR=/home/config/
LOG_DIR=/opt/kologs/
TEMP_DIR=/tmp/3emm/
mkdir -p $DOWN_DIR $COOKIES_DIR $LOG_DIR $TEMP_DIR

###cookies info
COOKIES_DAT=${COOKIES_DIR}3emm.dat
LOGFILE=${LOG_DIR}3emm.log

###CURL INFO
REFER='http://www.baidu.com'
AGENT='Mozilla/5.0'

###command info
CURL="curl -sL --retry 4 --connect-timeout 120 -m 120 -b ${COOKIES_DAT} -c ${COOKIES_DAT} -A $AGENT -e $REFER"
WGET="wget -q -t 5 -T 150 -U $AGENT"
ICONV="iconv -f gbk -t utf-8"


#### MAIN
for CLASS in ${CLASSES[@]}
do
###从本页得到有多少页相册
CABINET_NUMS=$($CURL $CLASS | $ICONV | awk -F'(list_)|(.html)' '$0 ~ "末页"{print $2}')

###显示每个cabinet地址
for ((i=1;i<=${CABINET_NUMS};i++))
do
echo "${CLASS}list_${i}.html"
###遍历carbinet结束
done | \

###读取一个cabinet
while read CABINET
do
#CABINET=http://www.3emm.com/xinggan/list_1.html
#查找里面的相册地址，并处理相册内容
#echo "$CABINET -----"
$CURL $CABINET | awk -F'"' '$0 ~ "class=\"iPic2\""{print $4}' | grep '^http' | \
##读取一个相册的地址
while read ALBUM
do
#ALBUM=http://www.3emm.com/xinggan/399.html
##从这个页面需要找到2个项目
#1. title
#2. 相册页数
TEMPFILE=$TEMP_DIR${ALBUM##*/}
$CURL $ALBUM | $ICONV >$TEMPFILE
TITLE=$(awk -F'(title>)|(</title>)' '$0 ~ "title.*keywords"{print $2}' $TEMPFILE | sed 's@[ 	]*@@g')
ALBUM_NUMS=$(awk -F'(共)|(页)' '$0 ~ "contentsx"{print $2}' $TEMPFILE)

##输出标题和相册首页的链接，出问题便于查找相关内容
echo "$CLASS -- $TITLE -- $ALBUM_NUMS" >>$LOGFILE
echo "$ALBUM" >>$LOGFILE

##定义图片下载的目录并建立之
#PICTURE_DIR="${DOWN_DIR}${TITLE}/"
PICTURE_DIR="${DOWN_DIR}$(echo $CLASS | sed 's@http://www.3emm.com/@@')"
mkdir -p $PICTURE_DIR

##下载第一页的图片
#######现在的问题是，现在的方法对于第一张图片总是可以找到的，但是第二张图片用keyword的方法就找不到了，用以前的方法也找不到

#INFO 1st pic 2211 431
#<div id="contents" class="photoimg"><p><img src="http://img.3emm.com/img/3emm/201210/15/1_121015011328_1.jpg" width="500" border="0" height="660" alt="胸悍撩人可爱女生性感私图 第1张" style="cursor:pointer" /> 
#<div id="contents" class="photoimg"><img alt="让人无限遐想的丰盈美女 第1张" src="http://img.3emm.com/www/uppic/201009282041384235.jpg" >

#PICTURE_URL=http://img.3emm.com/www/uppic/201009282041173613.jpg
#PICTURE_URL=$(sed '/photoimg/!d;s@src="@&\n@g' $TEMPFILE | awk -F'"' '$0 ~ "^http://img.3emm.com.*.jpg"{print $1}')
PICTURE_URL=$(sed '/photoimg/N;s@\n@@g' $TEMPFILE | sed '/photoimg/!d;s@src="@&\n@g' | awk -F'"' '$0 ~ "^http://img.3emm.com.*.jpg"{print $1}')
#PICTURE_KEYWORD=$(echo ${PICTURE_URL##*/} | awk -F'_' '{print $2}')
$WGET $PICTURE_URL -O ${PICTURE_DIR}${PICTURE_URL##*/}

##输出图片地址，出现问题便于查找
echo "$PICTURE_URL" >>$LOGFILE

##根据相册地址、相册页数，将在每一页相册内找到图片，将图片下载到TITLE命名的文件夹内
for ((i=2;i<=$ALBUM_NUMS;i++))
do
ALBUM_URL_NUM=$(echo $ALBUM | sed "s@.html@_${i}.html@" )

#INFO 2st pic 2211_2 431_2
#<div id="contents" class="photoimg">&nbsp;<br />
#<img src="http://img.3emm.com/img/3emm/201210/15/1_121015011328_2.jpg" width="477" border="0" height="690" alt="胸悍撩人可爱女生性感私图 第2张" style="cursor:pointer" />

#<div id="contents" class="photoimg"><img alt="让人无限遐想的丰盈美女 第2张" src="http://img.3emm.com/www/uppic/201009282041384236.jpg" >

{
PICTURE_URL=$($CURL $ALBUM_URL_NUM | $ICONV | sed '/photoimg/N;s@\n@@g' | sed '/photoimg/!d;s@src="@&\n@g' | awk -F'"' '$0 ~ "^http://img.3emm.com.*.jpg"{print $1}' )
#echo "$WGET $PICTURE_URL -O ${PICTURE_DIR}${PICTURE_URL##*/} "
$WGET $PICTURE_URL -O ${PICTURE_DIR}${PICTURE_URL##*/} 
echo $PICTURE_URL >>$LOGFILE
} &

#下载完一个相册内所有图片
done &
#按照相册下载，一次下载一个相册内所有内容再继续后面的下载
wait
done
##下载完一个盒子
done
##下载完一个分类
done
exit 0



