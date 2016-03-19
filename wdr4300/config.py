#!/usr/bin/env python2

from __future__ import print_function

ips   = [26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37]
vlan = [ 21, 21, 21, 20, 20, 20, 19, 19, 19, 18, 18, 18]
ghz2 = [  1, 11,  6, 11,  6,  1,  6,  1, 11,  1, 11,  6]
ghz5 = [36,44,52,60,100,108,116,124,132,140,36,44]


prefix = "template"
for idx, ip in enumerate(ips):
    file = "%s/%d_network"%(prefix, ip)
    print(file)
    f = open(file, 'w')
    
    f.write("""
config interface 'loopback'
	option ifname 'lo'
	option proto 'static'
	option ipaddr '127.0.0.1'
	option netmask '255.0.0.0'

config globals 'globals'
	option ula_prefix 'fd14:301d:b4d2::/48'

config switch
	option name 'switch0'
	option reset '1'
	option enable_vlan '1'


# Port 	   	Switch port
# CPU			   0
# WAN			   1
# LAN 1			   2
# LAN 2			   3
# LAN 3 		   4
# LAN 4			   5
# (not used) 	   6

# administrations vlan. Tildeling af ip
config switch_vlan
	option device 'switch0'
	option vlan '2'
	option ports '0t 1t 2t 5t'
	option vid '10'

# wired lan, til gangene.
# brug LAN port 2 og 3 til hub.
config switch_vlan
	option device 'switch0'
	option vlan '3'
	option ports '0t 1t 2t 3 4 5t 6'
	option vid '%d'

# auth wifi
# brug LAN port 1 og 4 til de andre APs
config switch_vlan
	option device 'switch0'
	option vlan '4'
	option ports '0t 1t 2t 5t'
	option vid '30'

# free wifi
# brug LAN port 1 og 4 til til de andre APs
config switch_vlan
	option device 'switch0'
	option vlan '5'
	option ports '0t 1t 2t 5t'
	option vid '32'

config interface 'admin'
	option 'proto' 'dhcp'
	# option proto 'static'
	option ifname 'eth0.10'
	# option netmask '255.255.255.0'
	# option gateway '10.42.0.1'
	# option dns '10.42.0.1'
	# option ipaddr '10.42.0.10'

config interface 'authed'
	option proto 'static'
	option ifname 'eth0.30'
	option type 'bridge'

config interface 'free'
	option proto 'static'
	option ifname 'eth0.32'
	option type 'bridge'\n"""%(vlan[idx]))
    f.close()

    
    ### WIRELESS ###
    file = "%s/%d_wireless"%(prefix, ip)
    f = open(file, 'w')
    f.write("""
## 2.4 GHz ##
config wifi-device 'radio0'
	option type 'mac80211'
	option hwmode '11g'
	option path 'platform/ar934x_wmac'
	option htmode 'HT20'
	option txpower '20'
	option country 'DK'
	option channel '%d'

config wifi-iface
	option device 'radio0'
	option mode 'ap'
	option encryption 'wpa2+ccmp'
	option auth_server '10.42.0.1'
	option auth_port '1812'
	option auth_secret 'NkW39NkW'
	option network 'authed'
	option ssid 'Octavius'

# Free wifi
config wifi-iface
	option device 'radio0'
	option mode 'ap'
	option network 'free'
	option encryption none
	#option encryption 'psk2+ccmp'
	#option key 'labitatisawesome'
	option ssid 'OctaviusFree'

## 5 GHz ##
config wifi-device 'radio1'
	option type 'mac80211'
	option hwmode '11a'
	option path 'pci0000:00/0000:00:00.0'
	option txpower '17'
	option htmode 'HT40'
	option channel '%d'
	option country 'DK'

config wifi-iface
	option device 'radio1'
	option mode 'ap'
	option network 'free'
	option encryption none
	#option encryption 'psk2+ccmp'
	#option key 'labitatisawesome'
	option ssid 'Octavius5Free'\n"""%(ghz2[idx], ghz5[idx]))
    f.close()

    ### HOSTNAME ###
    file = "%s/%d_system"%(prefix, ip)
    f = open(file, 'w')
    f.write("""
config system
        option zonename 'Europe/Copenhagen'
        option timezone 'CET-1CEST,M3.5.0,M10.5.0/3'
        option conloglevel '8'
        option cronloglevel '8'
        option hostname 'ap%d'

config timeserver 'ntp'
        list server '0.openwrt.pool.ntp.org'
        list server '1.openwrt.pool.ntp.org'
        list server '2.openwrt.pool.ntp.org'
        list server '3.openwrt.pool.ntp.org'
        option enabled '1'

config led 'led_usb1'
        option name 'USB1'
        option sysfs 'tp-link:green:usb1'
        option trigger 'usbdev'
        option dev '1-1.1'
        option interval '50'

config led 'led_usb2'
        option name 'USB2'
        option sysfs 'tp-link:green:usb2'
        option trigger 'usbdev'
        option dev '1-1.2'
        option interval '50'

config led 'led_wlan2g'
        option name 'WLAN2G'
        option sysfs 'tp-link:blue:wlan2g'
        option trigger 'phy0tpt'\n"""%(ip))

    f.close()
