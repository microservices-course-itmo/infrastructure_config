################################################
#ТЕСТ ДЛЯ ПРОВЕРКИ ФАКТА ПРИМОНТИРОВАНИЯ VOLUME
################################################

green="\033[32m"
yellow="\033[33m"
red="\033[31m"
default="\033[0m"

#!/bin/sh

for node in $(cat hosts.list);
do
	errorsCount="0"
	echo -e $yellow"[NODE]"$node$default
	dfResult=$(ssh root@$node "df -h | awk '{print \$1}'")
	for service in $(cat services.list);
	do
        	serviceResult=$(echo $dfResult | grep $service)
	        if [[ "$serviceResult" == "" ]]
		then
			echo -e $red"[ERROR]"$default$service" volume wasn't mounted to proper directory!"
			errorsCount="1"
		fi
	done
	if [[ "$errorsCount" == "1" ]]
	then
        	echo -e $red"[WARN]"$default"On node "$node" were detected some services which are not mounted!"
	elif [[ "$errorsCount" == "0" ]]
	then
		echo -e $green"[INFO]"$default"On node "$node" all volumes were mounted successfully!"
	fi

done
