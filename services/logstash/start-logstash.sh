#!/bin/bash

cd "$(dirname "$0")"

dockerManagerIp=${DOCKER_MANAGER_IP}

mkdir -p /etc/docker/shared/logstash/cfg
cp logstash.yml /etc/docker/shared/logstash/cfg/logstash.yml
mkdir -p /etc/docker/shared/logstash/cfg_d
cp logstash.conf /etc/docker/shared/logstash/cfg_d/conf.d

docker service create --name logstash --network default_network --replicas 1 \ 
--mount volume-driver=vieux/sshfs,source=logstash-cfg,target=/usr/share/logstash/config,volume-opt=sshcmd=root@${dockerManagerIp}:/etc/docker/shared/logstash/cfg,volume-opt=allow_other,volume-opt=password=${ROOT_PASSWORD} \
--mount volume-driver=vieux/sshfs,source=logstash-cfg_d,target=/etc/logstash,volume-opt=sshcmd=root@${dockerManagerIp}:/etc/docker/shared/logstash/cfg_d,volume-opt=allow_other,volume-opt=password=${ROOT_PASSWORD} \
--env LS_JAVA_OPTS='-Xmx256m -Xms256m' docker.elastic.co/logstash/logstash:7.8.0
