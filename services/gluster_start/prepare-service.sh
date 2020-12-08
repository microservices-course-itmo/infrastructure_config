#!/bin/sh

service=$1

path=/etc/docker/shared/$service 
path_brick=/etc/docker/${service}_brick 
nodes=""

# Creating remotely on other machines needed paths
while read LINE 
do 
ipaddress=$(echo $LINE | awk '{print $1}') 
ssh root@$LINE 'mkdir -p '$path 
ssh root@$LINE 'mkdir -p '$path_brick 
nodes=$nodes${LINE}:$path_brick" " 
done < hosts.list

# Creating special volumes for out services
gluster volume create $service transport tcp $nodes force 
gluster volume start $service

# Mount created volumes so we have one point
while read LINE 
do 
ssh root@$LINE 'mount.glusterfs '${LINE}:/$service' '$path
done < hosts.list
