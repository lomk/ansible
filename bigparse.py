#!/usr/bin/python

import json
import sys



def parse(dc = [], *args):
    key1 = "DisplayName"
    key2 = "DisplayVersion"
    key3 = "UninstallString"
    DisplayName = 0
    DisplayVersion = 0
    #UnistallString = 0
    maind = []
    lst = []

    for i in dc:
        if i.find(key1) >= 0 and DisplayName == 0:
            lst.append(i)
            DisplayName = 1
        elif  i.find(key1) >= 0 and DisplayName == 1:
            maind.append(lst)
            lst = []
            DisplayName = 1
            DisplayVersion = 0
            lst.append(i)
        if i.find(key2) >= 0 and DisplayName == 1:
            lst.append(i)
            DisplayVersion = 1
        if i.find(key3) >= 0 and DisplayName == 1 and DisplayVersion == 1:
            lst.append(i)
            maind.append(lst)
            lst = []
            DisplayName = 0
            DisplayVersion = 0
    return maind



def parse2(dc = [], *args):
    key1 = "DisplayName"
    key2 = "DisplayVersion"
#    key3 = "UninstallString"
    DisplayName = 0
    DisplayVersion = 0
    #UnistallString = 0
    maind = []
    lst = []

    for i in dc:
        if i.find(key1) >= 0 and DisplayName == 0:
            lst.append(i)
            DisplayName = 1
        elif  i.find(key1) >= 0 and DisplayName == 1:
            maind.append(lst)
            lst = []
            DisplayName = 1
            DisplayVersion = 0
            lst.append(i)
        if i.find(key2) >= 0 and DisplayName == 1:
            lst.append(i)
            maind.append(lst)
            lst = []
            DisplayName = 0
    return maind


def parse4(dc = [], patt = "", *args):
    key0 = "mylands"
    key1 = "DisplayName"
    key2 = "DisplayVersion"
#    key3 = "UninstallString"
    DisplayName = 0
    v = ""
    hs = ""
    #UnistallString = 0
    maind = []
    lst = []

    for i in dc:
	if i.find(key0) >= 0:
            hs = i
        if i.find(key2) >= 0:
#            lst.append(i)
            v = i
        if  i.find(key1) >= 0 and i.find(patt) >= 0:
#            maind.append(lst)
#            lst = []
#            DisplayName = 1
#            DisplayVersion = 0
            lst.append(hs)
            lst.append(i)
	    lst.append(v)
            maind.append(lst)
#        if i.find(key2) >= 0 and DisplayName == 1:
#            lst.append(i)
#            maind.append(lst)
#            lst = []
#            DisplayName = 0
    return maind

def parse3(dc = [], pattern = ""):
    key1 = "DisplayName"
    key2 = "DisplayVersion"
    DisplayName = 0
    maind = []
    lst = []

    for i in dc:
	if i.find(pattern) >= 0 and i.find(key1) >= 0 and DisplayName == 0:
	    lst.append(i)
            DisplayName = 1
        if i.find(key2) >= 0 and DisplayName == 1:
            lst.append(i)
            maind.append(lst)
            lst = []
            DisplayName = 0



#print maind
#s = parse(l)
#print s

filename= sys.argv[1]
#hostname = sys.argv[2]
pattern = sys.argv[2]

with open(filename) as f:
    content = f.read().splitlines()

#print content

#data = json.load(sys.stdin)
#lstr = data[list(data.keys())[0]]

s = parse4(content, pattern)
#s = parse3(h, pattern)
#print hostname
for i in s:
    print " "
    for y in i:
	print y

