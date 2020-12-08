#!/bin/sh

chmod u+x prepare-service.sh

#generate ssh-key if it doesn't exist
FILE=~/.ssh/id_rsa 
if ! test -f "$FILE"; then  
ssh-keygen -f ~/.ssh/id_rsa -q -N "" 
fi

#send to remote machine our ssh-key and install gluster on it
while read LINE
#send our ssh-key to remote machine
sshpass -p ${ROOT_PASSWORD} ssh-copy-id -i ~/.ssh/id_rsa.pub root@$LINE

#remote install of gluster on it
ssh root@$LINE 'yum install -y epel-release; yum install -y yum-priotities yum-utils; yum install -y centos-release-gluster; yum install -y glusterfs-server'
ssh root@$LINE 'firewall-cmd --zone=public --add-service=nfs --add-service=samba --add-service=samba-client --permanent'
ssh root@$LINE 'firewall-cmd --zone=public --add-port=111/tcp --add-port=139/tcp --add-port=445/tcp --add-port=965/tcp --add-port=2049/tcp --add-port=38465-38469/tcp --add-port=631/tcp --add-port=111/udp --add-port=963/udp --add-port=24007-24009/tcp --add-port=49152-49251/tcp --permanent'
ssh root@$LINE 'firewall-cmd --reload'
ssh root@$LINE 'systemctl start glusterd; systemctl enable glusterd'

#connect our machine to 'gluster cluster'
gluster peer probe $LINE
do < hosts.list

#prepare directories for all our services
while read LINE
do
./prepare-service.sh $LINE
done < services.list
