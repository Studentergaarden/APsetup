#!/bin/bash

# Du har brug for
# sudo apt-get install sshpass expect

ip=$1
if [[ -n "$ip" ]]; then
    rm -f etc/config/network
    rm -f etc/config/wireless
    rm -f etc/config/system
    ln -s template/${ip}_network etc/config/network
    ln -s template/${ip}_wireless etc/config/wireless
    ln -s template/${ip}_system etc/config/system
else
    echo "argument error. Husk at give ip adr"
    exit 0
fi

USERNAME=root
HOST=192.168.1.1
ID_FILE=id_rsa_loki
MAC_file=mac.txt
# dont save host and dont check key.
SSH_OPT="-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

WPAD_FILE=wpad_2015-03-25-1_ar71xx.ipk
#WPAD_FILE=wpad_2014-06-03.1-3_ar71xx.ipk

# copy config-files and ipk for using WPA2 Enterprise wifi auth.
sshpass -p "NkW39NkW" scp ${SSH_OPT} -r etc ${USERNAME}@${HOST}:/
scp ${SSH_OPT} -i $ID_FILE $WPAD_FILE ${USERNAME}@${HOST}:/tmp/

echo "------------" >> $MAC_file
# Få wan-portens mac-adresse. eth1 giver lan-portens.
ssh ${SSH_OPT} -i $ID_FILE ${USERNAME}@${HOST} '(cat /sys/class/net/eth0/address)' >> $MAC_file
echo $ip >> $MAC_file
echo "------------" >> $MAC_file
echo "" >> $MAC_file

# ssh commands to execute on remote host.
IFS='' read -r -d '' SSH_COMMAND <<'EOT'
opkg remove wpad-mini
opkg install /tmp/wpad_2015-03-25-1_ar71xx.ipk
rm /tmp/wpad_2015-03-25-1_ar71xx.ipk

#opkg install /tmp/wpad_2014-06-03.1-3_ar71xx.ipk
#rm /tmp/wpad_2014-06-03.1-3_ar71xx.ipk

/etc/init.d/telnet disable
/etc/init.d/telnet stop

# disable dhcp
/etc/init.d/dnsmasq disable
/etc/init.d/dnsmasq stop

# disable firewall
/etc/init.d/firewall disable
/etc/init.d/firewall stop

# reboot
#restart network instead of rebooting.
/etc/init.d/network restart

EOT

ssh ${SSH_OPT} -i $ID_FILE ${USERNAME}@${HOST} "${SSH_COMMAND}"

sleep 10
echo "Scriptet er fuldført. Du kan slukke routeren."