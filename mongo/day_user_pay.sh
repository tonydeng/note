#!/bin/sh

cat /tmp/count_pay_by_day.json |  python -c 'import sys; import simplejson as json; \
print "\n".join( [i for i in json.loads( sys.stdin.read() )["customer"]["properties"] ] )'