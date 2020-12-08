#!/bin/bash

cd "$(dirname "$0")"

docker config create logstash logstash.yml
docker config create logstash_d logstash.conf

docker service create --name logstash --network default_network --replicas 1 \
--config src=logstash,target=/usr/share/logstash/config/logstash.yml \
--config src=logstash_d,target=/usr/share/logstash/pipeline/logstash.conf \
--env LS_JAVA_OPTS='-Xmx256m -Xms256m' docker.elastic.co/logstash/logstash:7.8.0
