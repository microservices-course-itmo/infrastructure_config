#!/bin/bash

cd "$(dirname "$0")"

#mkdir -p /etc/docker/shared/prometheus
cp -u prometheus.yml /etc/docker/shared/prometheus/prometheus.yml

docker service create --name prometheus \
--network default_network --replicas 1 \
--mount type=bind,source=/etc/docker/shared/prometheus,destination=/etc/prometheus \
prom/prometheus
