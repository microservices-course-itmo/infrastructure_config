#!/bin/bash

yum install -y java-1.8.0-openjdk

chmod u+x services/*_start/start-*.sh

./services/docker_start/start-*.sh
./services/registry_start/start-*.sh
./services/artifactory_start/start-*.sh
./services/jenkins_start/start-*.sh
./services/zookeeper_start/start-*.sh
./services/kafka_start/start-*.sh
./services/postgres_start/start-*.sh
