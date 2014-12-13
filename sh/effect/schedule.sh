#!/bin/sh

echo "==================自定义进度条==================="
b=''
for ((i=0;$i<=100;i+=2))
do
    printf "progress: [%-50s] %d%%\r" $b $i
    sleep 0.1
    b+='#'
done
echo