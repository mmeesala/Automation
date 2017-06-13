#! /bin/bash
# Author: Murali Meesala <murali.meesala@gmail.com>
# Bigdata Solution Architect
# Script Name: create_keytab.sh
# Version :1.0
# Functionality: It will read the keyids.txt file which has principal and key information and it will create it accordingly.
# Usage: ./create_keytab.sh
# Input file: keyids.txt

for line in `cat keyids.txt`
do
        var=$(echo $line | awk -F":" '{print $1,$2}')
        set -- $var
        echo "Creating $1@LABS.MURALI.COM Keytab" ; #Password : $2";
        printf "%b" "addent -password -p $1@LABS.MURALI.COM -k 1 -e arcfour-hmac\n$2\nwrite_kt /opt/security/keytabs/$1.keytab" | ktutil
done
