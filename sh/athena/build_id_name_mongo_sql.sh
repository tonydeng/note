#!/bin/sh

ID_LOG=$1

while read ID; do
    IDS=$ID,$IDS
done < $ID_LOG
#echo $IDS
echo "db.book.find({'_id':{\$in:[${IDS%,*}]}},{'_id':1,'name':1}).forEach(function(f){print(tojson(f, '', true));});"

