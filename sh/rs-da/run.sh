#!/bin/bash

#get real path
cd `echo ${0%/*}`
abspath=`pwd`

method=$1

if [ ! -n "$method" ]; then
    echo "IS NULL"
    method="update"
fi


while read LINE
do
  echo "$method $LINE"
  echo "nohut java -jar $abspath/rs-da-1.0-SNAPSHOT-deploy.jar $method 1001p $LINE"
done < $abspath/books.txt