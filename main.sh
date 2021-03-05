#!/bin/bash

# yum install -y java-1.8.0-openjdk


# DO NOT LOOK AT THIS FILE
# WORK IN PROGRESS

# WHAT IS COMMENTED, REWRITTEN TO DOCKER-COMPOSE.yml

chmod u+x services/*_start/start-*.sh

./services/docker_start/start-*.sh
./services/gluster_start/start-*.sh


# ./services/registry_start/start-*.sh

# ./services/artifactory_start/start-*.sh
./services/jenkins_start/start-*.sh

# ./services/zookeeper_start/start-*.sh
# ./services/kafka_start/start-*.sh

# ./services/prometheus_start/start-*.sh
# ./services/grafana_start/start-*.sh

./services/postgres_start/start-*.sh
# ./services/mongo_start/start-*.sh

# ./services/kibana_start/start-*.sh
# ./services/logstash_start/start-*.sh
