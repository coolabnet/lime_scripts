#!/bin/sh

#this works by looking for a default route to the internet. 
#if it can't find, it adds a line to the ip4 dnsmasq to redirect all traffic to a local server
#the local server address is assumed to be 10.x.128.100 (change it as you like)
#the script looks up the local subnet (10.??.x.x)

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
