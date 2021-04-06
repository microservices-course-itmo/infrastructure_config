#!/bin/sh

green="\033[32m"
yellow="\033[33m"
red="\033[31m"
default="\033[0m"

#Удаленная установка gluster на машину
for node in $(cat hosts.list);
do
echo -e $green"Install glusterfs on "$node$default
ssh root@$node "yum install -y epel-release; yum install -y yum-priotities yum-utils; yum install -y centos-release-gluster; yum install -y glusterfs-server"
echo -e $green"Add to firewall services on "$node$default
ssh root@$node "firewall-cmd --zone=public --add-service=nfs --add-service=samba --add-service=samba-client --permanent"
echo -e $green"Add to firewall ports on "$node$default
ssh root@$node "firewall-cmd --zone=public --add-port=111/tcp --add-port=139/tcp --add-port=445/tcp --add-port=965/tcp --add-port=2049/tcp --add-port=38465-38469/tcp --add-port=631/tcp --add-port=111/udp --add-port=963/udp --add-port=24007-24009/tcp --add-port=49152-49251/tcp --permanent"
echo -e $green"Reload firewall on "$node$default
ssh root@$node "firewall-cmd --reload"
echo -e $green"Start work of glusterd.service on "$node$default
ssh root@$node "systemctl start glusterd"
echo -e $green"Create symlink on "$node$default
ssh root@$node "systemctl enable glusterd"
done

#Тест для проверки установки gluster
chmod +x ./tests/installedGluster.sh
./tests/./installedGluster.sh

#Присоединить машину, на которой сейчас был установлен gluster, к gluster-пулу
for node in $(cat hosts.list);
do
echo -e $green"Peer probe "$node" to gluster pool"$default
gluster peer probe $node
done < hosts.list

#Тест для проверки присоединенности gluster
chmod +x ./tests/peerProbe.sh
./tests/./peerProbe.sh

#Создание volume. Рекомендуется данный скрипт запускать отдельно. Если есть полная уверенность в том, что данный скрипт отработает как надо - раскомментируйте 2 строки ниже.
#chmod +x createVolumes.sh
#./createVolumes.sh

#Создать папки, к которым будут примонтированы volume
for node in $(cat hosts.list);
do
	echo -e $yellow"[NODE]"$default$node
	for service in $(cat services.list);
	do
		echo -e $green"[INFO]"$default"Creating file for "$service" service."
		ssh root@$node "mkdir -p /etc/docker/shared/$service"
	done
done

#Тест для проверки наличия созданных папок
chmod +x ./tests/mkdir.sh
./tests/./mkdir.sh

#Подключить gluster volume к созданным папкам
for node in $(cat hosts.list);
do
	echo -e $yellow"[NODE]"$default$node
	for service in $(cat services.list);
	do
		volumeName=$(gluster volume list all | grep $service)
		echo -e $green"[INFO]"$default"Mount "$volumeName" volume to /etc/docker/shared/"$service
		ssh root@$node "mount.glusterfs sp10:/$volumeName /etc/docker/shared/$service"
	done
echo ""
done

#Тест для проверки примонтированных volume к папкам
chmod +x ./tests/volumeCheck.sh
./tests/./volumeCheck.sh
