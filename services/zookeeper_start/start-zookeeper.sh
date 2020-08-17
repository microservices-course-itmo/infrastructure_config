#!/bin/bash

docker service create --name zookeeper \
--network default_network \
--replicas 1 \
--env ALLOW_ANONYMOUS_LOGIN=yes \
bitnami/zookeeper:latest
