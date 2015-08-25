#!/bin/bash

 awk -F';' '{k=$1;sub(/\.[^.]+$/,"",k)}NR==FNR{a[k]=$2;next}{if(a[k])print $1,a[k]}' b.txt a.txt
