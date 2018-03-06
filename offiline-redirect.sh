#!/bin/sh

#this works by looking for a default route to the internet. 
#if it can't find, it adds a line to the ip4 dnsmasq to redirect all traffic to a local server
#the local server address is assumed to be 10.x.128.100 (change it as you like)
#the script looks up the local subnet (10.??.x.x)

#it is a good idea to change the default setting subnet of /etc/config/lime to 	
#   option main_ipv4_address '10.%N1.0.0/17'
#(17 instead of 16)
#this way, only addresses up to 10.x.127.254 will be distributed by dhcp and you can use ips above 10.x.128.0 for static addresses

if ! ip route | grep -q -e default # if there is no route out, then...
then
#  offline; check if redirect is already there

   if ! grep -q address=/#/10.7.0.10 /etc/dnsmasq.d/lime-proto-anygw-10-ipv4.conf
   then
      myline="address=/#/10.$(ip route |  cut -d. -f2 -s | cut -d$'\n' -f1).128.100"
      echo $myline > /etc/dnsmasq.d/lime-proto-anygw-10-ipv4.conf
#      echo "added file"
      /etc/init.d/dnsmasq restart
   fi
else
#if online, delete that line in case it is there
   if rm /etc/dnsmasq.d/lime-proto-anygw-10-ipv4.conf > /dev/null  2>&1
   then
#      echo "ok, removed"
      /etc/init.d/dnsmasq restart
   else
#      echo "couldn't find it"
   fi
fi
