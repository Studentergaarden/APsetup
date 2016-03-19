#!/usr/bin/env python2

from __future__ import print_function


navne = ["adm",
         "cosmos","kanni","abort","dyt","ug","mg","iv","bzrk","barbar","pharis","psyko"]
vlan_id = range(10,22)

andre = ["priv wifi", "free wifi", "wire"]
andre_id = [30, 32, 40]

ap_id = range(10, 21)

file = "dhcpd.txt"
f = open(file, 'w')
for idx, val in enumerate(vlan_id):
    f.write("# %s\n"%(navne[idx]))
    f.write("subnet 10.42.%d.0 netmask 255.255.255.0 {\n"%(val))
    f.write("\trange dynamic-bootp 10.42.%d.50 10.42.%d.250;\n"%(val, val))
    f.write("\toption routers 10.42.%d.1;\n"%(val))
    f.write("\toption domain-name-servers 10.42.%d.1;\n"%(val))
    f.write("\tnext-server 10.42.%d.1;\n"%(val))
    f.write("}\n\n")

for idx, val in enumerate(andre_id):
    f.write("# %s\n"%(andre[idx]))
    f.write("subnet 10.42.%d.0 netmask 255.255.254.0 {\n"%(val))
    f.write("\trange dynamic-bootp 10.42.%d.50 10.42.%d.250;\n"%(val, val+1))
    f.write("\toption routers 10.42.%d.1;\n"%(val))
    f.write("\toption domain-name-servers 10.42.%d.1;\n"%(val))
    f.write("\tnext-server 10.42.%d.1;\n"%(val))
    f.write("}\n\n")
