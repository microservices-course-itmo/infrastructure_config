######################
#ТЕСТИРУЕМ ВИДИМОСТЬ ОСТАЛЬНЫХ МАШИН GLUSTER ПУЛА
#####################

red="\033[31m"
green="\033[32m"
yellow="\033[33m"
default="\033[0m"

#!/bin/sh
for node in $(cat hosts.list);
do
echo -e $yellow$node$default
echo -e $green"[INFO]"$default"Pool list of "$node
ssh root@$node "gluster pool list"
poolListCount=$(ssh root@$node "gluster pool list | wc | awk '{print \$1}'")
if [[ "$poolListCount" == "2" ]]
then
	echo -e $red"[ERROR]"$default"Machine "$node" wasn't properly added to gluster pool!"
fi
checkStatusDisconnected=$(ssh root@$node "gluster peer status | grep "Disconnected" | wc -l")
if [[ "$checkStatusDisconnected" != "0" ]]
then
	echo -e $red"[WARNING]"$default"You have some peers from "$node" that shown as "Disconnected"! Check it with the command "$yellow" gluster peer status "$default"from "$node
fi
checkStatusRejected=$(ssh root@$node "gluster peer status | grep "Rejected" | wc -l")
if [[ "$checkStatusRejected" != "0" ]]
then
        echo -e $red"[WARNING]"$default"You have some peers from "$node" that shown as "Rejected"! Check it with the command "$yellow" gluster peer status "$default"from "$node
fi
if [[ "$poolListCount" != "2" ]]
then
	echo -e $green"[INFO]"$default"Machine successfully added to gluster pool!"
fi
echo ""
done
