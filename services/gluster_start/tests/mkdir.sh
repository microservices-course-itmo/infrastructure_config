#######################################################
#ТЕСТ ДЛЯ ПРОВЕРКИ СОЗДАННЫХ ДИРЕКТОРИЙ ДЛЯ СЕРВИСОВ
#######################################################

#!/bin/sh

black="\033[30m"
red="\033[31m"
green="\033[32m"
yellow="\033[33m"
default="\033[0m"

errors="0"
for node in $(cat hosts.list);
do
echo -e $yellow"[NODE]"$default$node
createdFiles=$(ssh root@$node "ls /etc/docker/shared")
	for service in $(cat services.list);
	do
		checkCreatedService=$(echo $createdFiles | grep $service)
		if [[ -z $checkCreatedService ]]
		then
		echo -e $red"[ERROR]"$default" Directory for "$service " service wasn't created!"
		errors="1"
		fi
	done
if [[ "$errors" == "0" ]]
then
echo -e $green"[INFO]"$default" All directories for services were successfully created on node "$node"!"
echo ""
fi
done
