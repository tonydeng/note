#!/bin/bash
#RUN_DA="java -jar /dq/script/rs/da/rs-da-1.0-deploy.jar restore "
#RUN_NUM=3
#PS=`ps aux|grep rs-da|wc -l`
#RUN_MAX=31
#MAX=`ls -l /tmp/rs-da/restore/ | awk '/^[^d]/ {print $9}' | sort -nr | head -1`

#if [ $PS -le $RUN_NUM ]
#then 
#	if [ $MAX -lt $RUN_MAX ]
#	then 
#		echo "$RUN_DA"$[MAX+1]" &"
#		`$RUN_DA$[MAX+1] > /dq/script/rs/da/$[MAX+1]  2>&1 &`
#	fi            
#fi


RUN_DA="/usr/java/jdk/bin/java -jar /dq/script/rs/da/rs-da-1.0-deploy.jar restore "
RUN_NUM=3
PS=`ps aux|grep rs-da|wc -l`
RUN_MAX=31
MAX=`ls -l /tmp/rs-da/restore/ | awk '/^[^d]/ {print $9}' | sort -nr | head -1`

#if [ "$PS" -le "$RUN_NUM"  && "$MAX" -lt "$RUN_MAX" ]
#then
#       echo "$MAX"
#       `$RUN_DA$[MAX+1] &`
#fi

if [ $PS -le $RUN_NUM ]
then
        if [ $MAX -lt $RUN_MAX ]
        then
                echo "$RUN_DA"$[MAX+1]" &"
                `$RUN_DA$[MAX+1] > /dq/script/rs/da/$[MAX+1]  2>&1 &`
        fi
fi
