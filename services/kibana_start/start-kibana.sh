#!/bin/bash

cd "$(dirname "$0")"

docker config create kibana kibana.yml

docker service create --name kibana --network default_network --replicas 1 -p 5601:5601 \
--config src=kibana,target=/usr/share/kibana/config/kibana.yml \
docker.elastic.co/kibana/kibana:7.8.0
