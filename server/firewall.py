#!/usr/bin/env python2

from __future__ import print_function


navne = ["adm",
         "cosmos","kanni","abort","dyt","ug","mg","iv","bzrk","barbar","pharis","psyko"]
vlan_id = range(10,22)

andre = ["priv", "free", "wire"]
andre_id = [30, 32, 40]

ap_id = range(10, 21)

file = "firewall.txt"
f = open(file, 'w')

f.write("# our hosts\n")
f.write("define switch  = 10.42.10.2\n")
for idx, val in enumerate(ap_id):
    f.write("define ap%d = 10.42.0.%d\n"%(val, val))
f.write("\n")

f.write("# internal stuff\n")
f.write("define ext_if  = eth0\n")
f.write("define ext_ip  = 130.226.169.144\n\n")

f.write("# cover the whole range\n")
f.write("define int_net = 10.42.0.0/16\n")
f.write("define int_net6 = fde2:52b4:4a19::/48\n\n")

# vlans for gange - /24 = 254 hosts
for idx, val in enumerate(vlan_id):
    f.write("define %s_if = vlan%d\n"%(navne[idx], val))
    f.write("define %s_ip = 10.42.%d.1\n"%(navne[idx], val))
    f.write("define %s_net = 10.42.%d.0/24\n\n"%(navne[idx], val))


# vlans for wifi og generelt kablet net - /23 = 510
for idx, val in enumerate(andre_id):
    f.write("define %s_if = vlan%d\n"%(andre[idx], val))
    f.write("define %s_ip = 10.42.%d.1\n"%(andre[idx], val))
    f.write("define %s_net = 10.42.%d.0/23\n\n"%(andre[idx], val))



f.write("define ap_ips = { %s }\n" %
        ('$ap' + ', $ap'.join(str(x) for x in ap_id)))
f.write("define gange_ifs = { %s }\n\n" %
        ('$' + '_if, $'.join(navne[1:]) + '_if'))
f.write("# not free\n")
f.write("define avahi_ifs = { %s }\n" %
        ('$' + '_if, $'.join(navne) + '_if, $' +
         '_if, $'.join(andre[::len(andre)-1]) + '_if'))
f.write("define avahi_nets = { %s }\n\n" %
        ('$' + '_net, $'.join(navne) + '_net, $' +
         '_net, $'.join(andre[::len(andre)-1]) + '_net'))
f.write("define all_ifs = { %s }\n" %
        ('$' + '_if, $'.join(navne) + '_if, $' + '_if, $'.join(andre) + '_if'))
f.write("define all_nets = { %s }\n\n" %
        ('$' + '_net, $'.join(navne) + '_net, $' + '_net, $'.join(andre) + '_net'))

f.write("table ip filter {\n")
f.write("\tchain input {\n")
f.write("\t\tiif $adm_if ip saddr $ap_ips udp dport 1812 accept # RADIUS from AP\n\n")
f.write("\t\t# SSH from $wire_net and $priv_net\n")
f.write("\t\tip saddr $avahi_nets tcp dport ssh accept\n")

f.write("\tchain forward {\n")
f.write("\t\t# local traffic\n")
f.write("\t\tiif $all_ifs  ip saddr $all_nets  accept\n\n")


f.close()
