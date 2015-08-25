#!/bin/sh

Platform=2
TOP_NUM=100

awk -F '\\] \\[' '{if($2=="2" && $17 !=""){++PV[$17];++UV[$17,$10]}} END {for(b in PV){ buv=0; for(u in UV){split(u,uarr,SUBSEP); if(b==uarr[1]){buv++}}  print PV[b],buv,b} }'  $1|sort -nr|head -$TOP_NUM