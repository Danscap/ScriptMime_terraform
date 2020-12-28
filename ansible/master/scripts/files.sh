#! /bin/bash

echo "enter provider folder"

read provider_folder

ansibledir="/home/danscap/Desktop/server_conf/ansible/master/"
terraformdir="/home/danscap/Desktop/server_conf/do_tutorial/"

#database_servers=$(cat "${ansibledir}hosts" | egrep "[database].*[node]" | sed '/\[/d' )
#node_servers=$(cat "${ansibledir}hosts" | egrep "[node].*" | sed '/\[/d' )

database_servers=$(cat "${terraformdir}${provider_folder}/database_ips.txt")
node_servers=$(cat "${terraformdir}${provider_folder}/node_ips.txt")


if [[ -n $database_servers ]]; then
  while read -r line ; do
    rsync -avzP  /home/danscap/ "danscap@${line}:/home/danscap/"

  done < "${terraformdir}${provider_folder}/database_ips.txt"

fi

if [[ -n $node_servers ]]; then
  while read -r line ; do
    rsync -avzP  /home/danscap/ "danscap@${line}:/home/danscap/"

  done < "${terraformdir}${provider_folder}/node_ips.txt"

fi

