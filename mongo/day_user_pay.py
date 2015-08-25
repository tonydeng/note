#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys,json


def readAndPrint(file):
    json_file = open(file,"r")
    json_data = json.JSONDecoder().decode(json_file.read().decode('utf-8'))

    for index in json_data:
        data = json_data[index]
        print data['date']," ",int(data['bookid'])," ",int(data['count'])," ",int(data['uv'])


if __name__ == '__main__':
    if len(sys.argv) == 2:
        readAndPrint(sys.argv[1])

