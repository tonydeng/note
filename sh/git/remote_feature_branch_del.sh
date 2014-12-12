#!/bin/bash

WORKSPACE=$1
echo $WORKSPACE

cd $WORKSPACE

BRANCHS=`git branch -r|awk -F '/' '{if($2=="feature")print $2"/"$3"/"$4}'`
#BRANCHS=`git branch -r|awk -F '/' '{if($2=="vs1.0.0")print $2"/"$3"/"$4"/"$5}'`

for br in $BRANCHS
do
	local_result=`git branch -d $br`
	echo "git branch -d $br result: $local_result"
	remote_result=`git push origin :$br`
	echo "git push origin :$br result: $remote_result"
done
echo $BRANCHS
