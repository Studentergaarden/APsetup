
dst=/home/paw/vlan/
mkdir $dst
cp -r /etc/systemd/network $dst
cp /etc/dhcp/dhcpd.conf $dst
cp /etc/default/isc-dhcp-server $dst
cp -r /etc/firewall.d/ $dst
cp /etc/apt/sources.list $dst

chown -R paw $dst

# mac for larmende/virkende switch
#	00-1f-33-e2-91-62 
# emacs /etc/apt/sources.list
# Backports repository
# deb http://http.debian.net/debian jessie-backports main contrib non-free

# apt-get install -t jessie-backports linux-image-amd64
# apt-get -t jessie-backports install nftables
# apt-get install isc-dhcp-server
# apt-get install dnsmasq
# systemctl stop networking.service
# update-rc.d networking remove
# systemctl enable systemd-networkd.service
# systemctl enable systemd-resolved.service
# systemctl restart systemd-networkd.service
# service isc-dhcp-server restart
# apt-get install -t jessie-backports linux-image

#mv /etc/resolv.conf{,.bak}
# ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
# apt-get install avahi-utils

# https://forum.openwrt.org/viewtopic.php?id=56570

# echo 'net.ipv4.ip_forward = 1' > /etc/sysctl.d/ip_forward.conf

#emacs /etc/default/grub
#GRUB_CMDLINE_LINUX_DEFAULT="quiet ipv6.disable_ipv6=1"
#grub-mkconfig -o /boot/grub/grub.cfg
#Warning: Disabling the IPv6 stack can break certain programs which expect it to be enabled. 
#Adding ipv6.disable=1 to the kernel line disables the whole IPv6 stack, which is likely what you want if you are experiencing issues. See Kernel parameters for more information.
#Alternatively, adding ipv6.disable_ipv6=1 instead will keep the IPv6 stack functional but will not assign IPv6 addresses to any of your network devices. 


