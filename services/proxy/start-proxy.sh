#!/bin/bash

firewall-cmd --zone=trusted --change-interface=docker_gwbridge
firewall-cmd --permanent --zone=trusted --add-port=2375/tcp
firewall-cmd --reload

ip = $(ip addr | grep eth0 | tail -n 1 | awk '{print $2}' | awk -F '/' '{print $1}')
docker run --name container_proxy --user root -v ${PWD}/main.conf:/etc/nginx/nginx.conf --add-host host.docker.internal:$ip --network test_network -d nginx;
