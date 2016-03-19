#!/usr/bin/expect

# if something goes wrong, the script will timeout after 20 seconds.
set timeout 20
set password ROOT2_PASSWORD #insert ROOT2 password here

# set ssh_params -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no 

# example of command line arguments
#First argument is assigned to the variable name
#set name [lindex $argv 0]
#Second argument is assigned to the variable user
#set user [lindex $argv 1]


spawn telnet 192.168.1.1

send "passwd\n"
expect "Changing password for root"
expect "New password:"
send "$password\n"
expect "Retype password:"
send "$password\n"
expect "Password for root changed by root"
send "exit\n"

#spawn scp $ssh_params root@192.168.1.1:/etc

#This hands control of the keyboard over two you. For debugging
#interact
