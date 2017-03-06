
SSH_OPT="-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no  -o LogLevel=Error"
USERNAME=root

AP_LIST='ap_list.txt'

HOST=10.42.0.29

echo "" > $AP_LIST
for i in $(seq 26 54); do
    HOST=10.42.0.$i
    echo "##HEADER##" >> $AP_LIST
sshpass -p "NkW39NkW"  ssh ${SSH_OPT}  ${USERNAME}@${HOST} >> $AP_LIST   << 'EOT'

    echo "##START##"
echo -n "** "
echo -n "IP:"
ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'
for iface in 'eth0' 'eth1'; do
    FILE=/sys/class/net/$iface/address
    if [ -f $FILE ]; then
       echo -n $iface
       echo -n ":  "
       cat $FILE
    fi
done
iw dev


EOT
done
