#!/bin/sh

TARGET=$1

# sync API LOGS

RS_API_SERVERS="10.171.18.243,10.170.179.186"

RS_FRONT_SERVERS="10.163.15.68"

RS_PANDORA_SERVERS="10.172.251.236"



SyncRsApi(){
    echo "sync rs api project static logs"
    for s in ${RS_API_SERVERS//,/ } ; do
        RSYNC="rsync -avu --port=30873 --delete  --progress release@$s:/dq/logs/rs-api/static.* /dq/backlogs/api/${s##*.}/"
        echo $RSYNC
        eval $RSYNC
    done
}

SyncRsFront(){
    echo "sync rs api project static logs"
    for s in ${RS_FRONT_SERVERS//,/ } ; do
        RSYNC="rsync -avu --port=30873 --delete  --progress release@$s:/dq/logs/rs-ft/static.* /dq/backlogs/front/${s##*.}/"
        echo $RSYNC
        eval $RSYNC
    done
}

SyncRsPandora(){
    echo "sync rs api project statis logs"
    for s in ${RS_PANDORA_SERVERS//,/ } ; do
        RSYNC="rsync -avu --port=30873 --delete  --progress release@$s:/dq/logs/pandora/statis.* /dq/backlogs/pandora/${s##*.}/"
        echo $RSYNC
        eval $RSYNC
    done
}

All(){
    echo "sync all projects static logs"
    SyncRsApi
    SyncRsFront
    SyncRsPandora
}

case $TARGET in
    rs-api )
        SyncRsApi
        ;;
    rs-front )
        SyncRsFront
        ;;
    rs-pandora )
        SyncRsPandora
        ;;
    * )
        All
        ;;
esac

