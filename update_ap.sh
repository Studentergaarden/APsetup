
# Break regulatations on restricted channels-
# http://luci.subsignal.org/~jow/reghack/
# http://luci.subsignal.org/~jow/reghack/

SSH_OPT="-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no  -o LogLevel=Error"
USERNAME=root

AP_UPDATE='ap_update.txt'
ID_FILE='a'

HOST=10.42.0.29

for i in $(seq 26 54); do
    HOST=10.42.0.$i
    sshpass -p "NkW39NkW"  ssh ${SSH_OPT}  ${USERNAME}@${HOST} >> $AP_UPDATE   << 'EOT'

echo -n "IP:"
ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'
sed -i "s/'DK'/'US'/g"  /etc/config/wireless

cd /tmp/
wget http://luci.subsignal.org/~jow/reghack/reghack.mips.elf
chmod +x reghack.mips.elf
./reghack.mips.elf /lib/modules/*/ath.ko
./reghack.mips.elf /lib/modules/*/cfg80211.ko
reboot

EOT

done
