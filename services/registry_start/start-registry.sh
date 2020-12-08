#!/bin/bash

#mkdir -p /etc/docker/shared/registry

firewall-cmd --zone=trusted --add-port=5000/tcp --permanent
firewall-cmd --reload

docker service create \
--name registry \
--network default_network --replicas 1 \
--mount type=bind,source=/etc/docker/shared/registry,destination=/var/lib/registry \
-e REGISTRY_STORAGE_DELETE_ENABLED="true" \
registry:2.7.1
