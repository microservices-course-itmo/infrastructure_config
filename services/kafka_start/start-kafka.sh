#!/bin/bash

cd "$(dirname "$0")"

#mkdir -p /etc/docker/shared/kafka

docker service create --name kafka \
--network default_network \
--replicas 1 \
--mount type=bind,source=/etc/docker/shared/kafka,destination=/bitnami/kafka \
--env-file environment \
bitnami/kafka:latest
