#!/bin/bash

docker service create --name zookeeper \
--network default_network \
--replicas 1 \
--mount type=bind,source=/etc/docker/shared/zookeeper,destination=/bitnami/zookeeper \
--env ALLOW_ANONYMOUS_LOGIN=yes \
bitnami/zookeeper:latest
