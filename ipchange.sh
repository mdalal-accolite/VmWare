#!/bin/bash
hostip=$(cat ./terraform.tfstate  | grep default_ip_address | awk '{print $2}' | sed 's/"//g' | sed 's/,//g')
echo $hostip
sed -i "s/10.220.201.37/$hostip/g" ./sql/hosts
cat ./sql/hosts
