#!/bin/bash

# yum install -y java-1.8.0-openjdk


# DO NOT LOOK AT THIS FILE
# WORK IN PROGRESS

# WHAT IS COMMENTED, REWRITTEN TO DOCKER-COMPOSE.yml

chmod u+x services/*_start/start-*.sh

./services/docker_start/start-*.sh
./services/gluster_start/start-*.sh

docker stack deploy -c ./services_new/proxy/docker-compose.yml proxies

docker stack deploy -c ./services_new/registry/docker-compose.yml registry
docker stack deploy -c ./services_new/artifactory/docker-compose.yml artifactory

./services/jenkins_start/start-*.sh

docker stack deploy -c ./services_new/zoopark/docker-compose.yml zoopark
docker stack deploy -c ./services_new/monitoring/docker-compose.yml monitoring

./services/postgres_start/start-*.sh

docker stack deploy -c ./services_new/mongo/docker-compose.yml mongo
docker stack deploy -c ./services_new/elk/docker-compose.yml elk
