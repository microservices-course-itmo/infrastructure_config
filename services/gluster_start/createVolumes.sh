##########################################
#ВНИМАНИЕ! ДЛЯ ТОГО, ЧТОБЫ ЭТОТ СКРИПТ РАБОТАЛ, ВЫ ДОЛЖНЫ ОПРЕДЕЛИТЬ, КАКОЙ ТИП VOLUME ВЫ ХОТИТЕ, ГДЕ БУДУТ РАСПОЛАГАТЬСЯ ДАННЫЕ И НА КАКИХ МАШИНАХ
#ЗДЕСЬ ПРИВЕДЕН СКРИПТ ДЛЯ СОЗДАНИЯ РЕПЛИЦИРУЕМЫХ VOLUME'ОВ, ХРАНИТЬСЯ ДАННЫЕ БУДУТ В SP03 и SP10 в /newdrive, АРБИТРОМ ВЫСТУПАТЬ БУДЕТ SP01 в /arbiter
#КОМАНДА, КОТОРАЯ ИСПОЛЬЗУЕТСЯ ДЛЯ СОЗДАНИЯ VOLUME, ПРИВЕДЕНА В СЛЕДУЮЩЕЙ СТРОКЕ:
#volume create <NEW-VOLNAME> [stripe <COUNT>] [[replica <COUNT> [arbiter <COUNT>]]|[replica 2 thin-arbiter 1]] [disperse [<COUNT>]] [disperse-data <COUNT>] [redundancy <COUNT>] [transport <tcp|rdma|tcp,rdma>] <NEW-BRICK> <TA-BRICK>... [force]
##########################################

#!/bin/sh

for node in sp03 sp10;
do
	for service in $(cat services.list);
	do
		ssh root@$node "mkdir -p /newdrive/$service"
	done
done

for service in $(cat services.list);
do
	ssh root@sp01 "mkdir -p /arbiter/$service"
done

for service in $(cat services.list);
do
	gluster volume create $service replica 3 arbiter 1 transport tcp sp03:/newdrive/$service sp10:/newdrive/$service sp01:/arbiter/$service
done
