#!/bin/sh

user=$1

echo $user

#get real path
cd `echo ${0%/*}`
abspath=`pwd`

echo $abspath
delkeys="pssh -h $abspath/lan_hosts.conf -l root -P \"sed -i '/$user/d' ~/.ssh/authorized_keys\""
echo $delkeys
eval $delkeys