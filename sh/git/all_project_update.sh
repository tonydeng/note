#!/bin/bash
#
#更新指定目录下所有的项目代码
#

WORKSPACE=$1


for project in  `find $WORKSPACE -type d -d 1`; do
    echo "update $project code"
    cd $project
    git checkout develop
    git pull
done
