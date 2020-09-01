#!/bin/bash

mkdir -p /mounts/registry
chown -R 1030 /mounts/

firewall-cmd --zone=trusted --add-port=5000/tcp --permanent
firewall-cmd --reload

docker run -d --name registry --restart=always -v /mounts/registry:/var/lib/registry -p 5000:5000 registry:2.7.1
