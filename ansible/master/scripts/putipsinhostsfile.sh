#! /bin/bash

echo "enter cloud provider folder"
read provider_folder


dir="/home/danscap/Desktop/server_conf/ansible/master/"

terraformdir="/home/danscap/Desktop/server_conf/do_tutorial/"

hosts="${dir}hosts"

[[ ! -f $hosts ]] && exit 1

cp $hosts "${dir}hosts.bak"

echo '' > $hosts 

dbhostscontent=$(cat "${terraformdir}${provider_folder}/database_ips.txt")
nodehostscontent=$(cat "${terraformdir}${provider_folder}/node_ips.txt")

if [[ -n $dbhostscontent ]]; then	
  printf "[database]\n%s" "$dbhostscontent" >> $hosts
  loadbalancer=$(grep -v "database" ${terraformdir}${provider_folder}/database_ips.txt | head -1)
  printf "\n[loadbalancer]\n%s" "$loadbalancer" >> $hosts
  
fi


if [[ -n $nodehostscontent ]]; then       
  printf "\n[node]\n%s" "$nodehostscontent" >> $hosts
  
fi





