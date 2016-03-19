#!/usr/bin/env python2

from __future__ import print_function

for x in range(10, 22)+[30,31,40]:
    file = "vlan%d.netdev"%(x)
    with open(file, 'w') as f:
        f.write("[NetDev]\n")
        f.write("Name=vlan%d\n"%(x))
        f.write("Kind=vlan\n")
        f.write("\n")
        f.write("[VLAN]\n")
        f.write("Id=%d\n"%(x))

    file = "vlan%d.network"%(x)
    with open(file, 'w') as f:
        f.write("[Match]\n")
        f.write("Name=vlan%d\n"%(x))
        f.write("\n")
        f.write("[Network]\n")
        f.write("Address=10.42.%d.1/24\n"%(x))
        f.write("IPForward=ipv4\n")
