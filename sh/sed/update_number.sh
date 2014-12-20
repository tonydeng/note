#!/bin/sh
#sed -r '' 's/(net.ipv4.ip_forward =).*/\1 1/' test.conf
sed -i ''  '/net.ipv4.ip_forward/ s/0/1/' test.conf
