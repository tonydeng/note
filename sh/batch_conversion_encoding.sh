#!/bin/bash

DIR=$1 # 转换编码文件目录
FT=$2  # 需要转换的文件类型（扩展名）
SE=$3  # 原始编码
DE=$4  # 目标编码

for file in `find $DIR -type f -name "*.$FT"`; do
	echo "conversion $file encoding $SE to $DE"
    iconv -f $SE -t $DE "$file" > "$file".tmp
    mv -f "$file".tmp "$file"
done
