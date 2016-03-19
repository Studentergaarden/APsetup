#!/bin/bash

# Du har brug for
# sudo apt-get install sshpass expect

ip=$1
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [[ -n "$ip" ]]; then
	rm -f etc/config/network
	rm -f etc/config/wireless
	rm -f etc/config/system
	ln -s $DIR/template/${ip}_network etc/config/network
	ln -s $DIR/template/${ip}_wireless etc/config/wireless
	ln -s $DIR/template/${ip}_system etc/config/system
else
	echo "argument error. Husk at give ip"
	exit 0
fi

# exit 0
# ip="25"

USERNAME=root
HOST=192.168.1.1
# HOST=10.42.0.51
ID_FILE=id_rsa_loki
MAC_file=mac.txt
# dont save host and dont check key.
SSH_OPT="-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

# copy config-files and ipk for using WPA2 Enterprise wifi auth.
sshpass -p "NkW39NkW" scp ${SSH_OPT} -r etc ${USERNAME}@${HOST}:/
scp ${SSH_OPT} -i $ID_FILE wpad_2015-03-25-1_ar71xx.ipk ${USERNAME}@${HOST}:/tmp/
echo "------------" >> $MAC_file
# Få wan-portens mac-adresse. eth1 giver lan-portens.
ssh ${SSH_OPT} -i $ID_FILE ${USERNAME}@${HOST} '(cat /sys/class/net/eth0/address)' >> $MAC_file
echo $ip >> $MAC_file
echo "------------" >> $MAC_file
echo "" >> $MAC_file

# Download wpad. Den skal bruges for at køre Enterprise auth(radius server)
# https://downloads.openwrt.org/chaos_calmer/15.05/ar71xx/generic/packages/base/wpad_2015-03-25-1_ar71xx.ipk

# ssh commands to execute on remote host.
IFS='' read -r -d '' SSH_COMMAND <<'EOT'
opkg remove wpad-mini
opkg install /tmp/wpad_2015-03-25-1_ar71xx.ipk
rm /tmp/wpad_2015-03-25-1_ar71xx.ipk

/etc/init.d/telnet disable
/etc/init.d/telnet stop

# disable dhcp
/etc/init.d/dnsmasq disable
/etc/init.d/dnsmasq stop

# disable firewall
/etc/init.d/firewall disable
/etc/init.d/firewall stop

# # reboot
# #restart network instead of rebooting.
/etc/init.d/network restart

EOT

ssh ${SSH_OPT} -i $ID_FILE ${USERNAME}@${HOST} "${SSH_COMMAND}"

sleep 10
echo "Scriptet er fuldført. Du kan slukke routeren."
