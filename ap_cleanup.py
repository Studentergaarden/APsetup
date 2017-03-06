#!/usr/bin/env python3
# -*- coding: utf-8 -*-


import re
import fileinput

f = open('ap_list.txt', 'r')
text = f.read()
f.close()
text = re.sub(r"(?s)(?<=\#\#HEADER\#\#).*?(?=\#\#)", "", text )
text = re.sub(r"(?m)(^##.*)", "", text)
text = re.sub(r"(?m)^\s.*type.*\n?", "", text)
text = re.sub(r"(?m)^\s.*ifindex.*\n?", "", text)
text = re.sub(r"(?m)^\s.*wdev.*\n?", "", text)


with open('aps.txt', 'a') as f:
    print(text, file=f)
