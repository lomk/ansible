#!/bin/bash

    #Set variables
DATE=$(/bin/date +"%d%m%Y_%H%M%S")
CMD="/sbin/iptables"
EXT_IF="enp1s0f0"
VM_IF="virbr0"
EXT_ADDR="92.42.110.138"
VM_ADDR="192.168.122.1"
VM_NET="192.168.122.0/24"

BITRIX="192.168.122.101"
WINSERV="192.168.122.102"
UBUNTU1="192.168.122.103"
    #Add allowed IP here
FRIENDS="93.183.239.12
	93.183.239.14
	91.232.159.226
	91.232.159.233
	77.120.242.20
	176.37.93.234
"


make_rules () {
	#Create old rules backup in /etc/iptables directory
    /sbin/iptables-save > /etc/iptables/$DATE.rules.bak

        #Set policies
    $CMD -P INPUT DROP
    $CMD -P FORWARD DROP
    $CMD -P OUTPUT ACCEPT

	#flush previos rules and chaines
    $CMD -t nat -F
    $CMD -t mangle -F
    $CMD -F
    $CMD -X

	##Allow established connection
    $CMD -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    $CMD -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

	#Allow all on local interface
    $CMD -A INPUT -i lo -j ACCEPT

	#Drop invalid packets
    $CMD -A INPUT -m conntrack --ctstate INVALID -j DROP

	#alllow icmp ping
    $CMD -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT
    $CMD -A INPUT -p icmp --icmp-type destination-unreachable -j ACCEPT
    $CMD -A INPUT -p icmp --icmp-type time-exceeded -j ACCEPT
    $CMD -A INPUT -p icmp --icmp-type echo-request -j ACCEPT


    #Add rules for allowed IP's 
    for IP in $FRIENDS; do
	$CMD -A INPUT -i $EXT_IF -s $IP -j ACCEPT
	$CMD -A FORWARD -i $EXT_IF -d $VM_NET -s $IP -j ACCEPT
    done

	#Allow all traffic from virtual network 
    $CMD -A INPUT -i $VM_IF -s $VM_NET -j ACCEPT
    $CMD -A FORWARD -i $VM_IF -s $VM_NET -j ACCEPT

	#Nat all from virtual network
    $CMD -t nat -A POSTROUTING -s $VM_NET ! -d $VM_NET -j MASQUERADE

	#### ALLOW EXTERNAL PORTS

        #Allow SSH from any
    $CMD -A INPUT -i $EXT_IF -p tcp -m tcp --dport 22 -j ACCEPT
	#Allow http from any
    $CMD -A INPUT -i $EXT_IF -p tcp -m tcp --dport 80 -j ACCEPT
	#Allow https from any
    $CMD -A INPUT -i $EXT_IF -p tcp -m tcp --dport 443 -j ACCEPT

	##Allow external port 32342 bitrix port 22 from  any
#    $CMD -A INPUT -i $EXT_IF -p tcp -m tcp --dport 32342 -j ACCEPT
#    $CMD -A FORWARD -i $EXT_IF -o $VM_IF -p tcp -m tcp --dport 22 -j ACCEPT

	##Allow external port 33342 ubuntu port 22 from  any
    $CMD -A INPUT -i $EXT_IF -p tcp -m tcp --dport 33342 -j ACCEPT
    $CMD -A FORWARD -i $EXT_IF -o $VM_IF -p tcp -m tcp --dport 22 -j ACCEPT

	#Allow external http for bitrix form any
#    $CMD -A INPUT -i $EXT_IF -p tcp -m tcp --dport 80 -j ACCEPT
#    $CMD -A FORWARD -i $EXT_IF -o $VM_IF -p tcp -m tcp --dport 80 -j ACCEPT

	#Allow external https for bitrix form any
#    $CMD -A INPUT -i $EXT_IF -p tcp -m tcp --dport 443 -j ACCEPT
#    $CMD -A FORWARD -i $EXT_IF -o $VM_IF -p tcp -m tcp --dport 443 -j ACCEPT

	## Allow external bitrix port 8893 from  any
    #$CMD -A INPUT -i $EXT_IF -p tcp -m tcp --dport 8893 -j ACCEPT
    #$CMD -A FORWARD -i $EXT_IF -o $VM_IF -p tcp -m tcp --dport 8893 -j ACCEPT

	## Allow external bitrix port 8894 from  any
    #$CMD -A INPUT -i $EXT_IF -p tcp -m tcp --dport 8894 -j ACCEPT
    #$CMD -A FORWARD -i $EXT_IF -o $VM_IF -p tcp -m tcp --dport 8894 -j ACCEPT

	## Allow external bitrix port 8895 from  any
    #$CMD -A INPUT -i $EXT_IF -p tcp -m tcp --dport 8895 -j ACCEPT
    #$CMD -A FORWARD -i $EXT_IF -o $VM_IF -p tcp -m tcp --dport 8895 -j ACCEPT

	## Allow external port 32389 windows port 3389 from  any
    #$CMD -A INPUT -i $EXT_IF -p tcp -m tcp --dport 32389 -j ACCEPT
    #$CMD -A FORWARD -i $EXT_IF -o $VM_IF -p tcp -m tcp --dport 3389 -j ACCEPT

	#### REDIRECT RULES

        #Redirect http to bitrix same port
#    $CMD -t nat -A PREROUTING --dst $EXT_ADDR -p tcp --dport 80 -j DNAT --to-destination $BITRIX

	#Redirect https to bitrix same port
#    $CMD -t nat -A PREROUTING --dst $EXT_ADDR -p tcp --dport 443 -j DNAT --to-destination $BITRIX
 
	# Redirect bitrix port 8893 to same port
#    $CMD -t nat -A PREROUTING --dst $EXT_ADDR -p tcp --dport 8893 -j DNAT --to-destination $BITRIX

	# Redirect bitrix port 8894 to same port
#    $CMD -t nat -A PREROUTING --dst $EXT_ADDR -p tcp --dport 8894 -j DNAT --to-destination $BITRIX

	# Redirect bitrix port 8895 to same port
#    $CMD -t nat -A PREROUTING --dst $EXT_ADDR -p tcp --dport 8895 -j DNAT --to-destination $BITRIX

	# Redirect bitrix port 32342 to port 22
#    $CMD -t nat -A PREROUTING --dst $EXT_ADDR -p tcp --dport 32342 -j DNAT --to-destination $BITRIX:22

	# Redirect ubuntu-1 port 33342 to port 22
    $CMD -t nat -A PREROUTING --dst $EXT_ADDR -p tcp --dport 33342 -j DNAT --to-destination $UBUNTU1:22

	# Redirect windows port 32389 to port 3389
    $CMD -t nat -A PREROUTING --dst $EXT_ADDR -p tcp --dport 32389 -j DNAT --to-destination $WINSERV:3389


    #### OTHER RULES

	#Rules for virtual network
    $CMD -t nat -A POSTROUTING -s $VM_NET -d 224.0.0.0/24 -j RETURN
    $CMD -t nat -A POSTROUTING -s $VM_NET -d 255.255.255.255/32 -j RETURN
    #$CMD -A POSTROUTING -s $VM_NET ! -d $VM_NET -p tcp -j MASQUERADE --to-ports 1024-65535
    #$CMD -A POSTROUTING -s $VM_NET ! -d $VM_NET -p udp -j MASQUERADE --to-ports 1024-65535
}    

show_info () {
	## Info section
	## Show all rules
    $CMD -S
    echo
    echo
    sleep 1
    $CMD -t nat -S
    echo
    echo "DONE!"
    sleep 1
    echo 
    echo "    ##########################################################"
    echo 
    echo " !!! ATTENTION !!! "
    echo
    echo " To restore previos rules execute: iptables-restore < /etc/iptables/$DATE.rules.bak "
    echo 
    echo " To show rules use next commands:"
    echo " iptables -S"
    echo " iptables -L -n"
    echo " iptables -t nat -S"
    echo " iptables -t nat -L -n"
    echo
    echo "    ##########################################################"
    echo
}


read -p "Are you sure? Enter Y or y to continue:  " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Creating new rules"
    sleep 1
    make_rules
    iptables-save > /etc/iptables/rules.v4
    show_info    

fi
