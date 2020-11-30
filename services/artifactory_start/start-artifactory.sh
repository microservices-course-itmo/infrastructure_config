#!/bin/bash

dockerManagerIp=${DOCKER_MANAGER_IP} 

mkdir -p /etc/docker/shared/artifactory

firewall-cmd --zone=trusted --add-port=8081/tcp --permanent
firewall-cmd --zone=trusted --add-port=8082/tcp --permanent

docker run -d --name artifactory --user root --network=default_network --restart=always -v /etc/docker/shared/artifactory/artifactory:/var/opt/jfrog/artifactory -p 8081:8081 -p 8082:8082 -e EXTRA_JAVA_OPTIONS='-Xms512m -Xmx1024m -Xss256k -XX:+UseG1GC' docker.bintray.io/jfrog/artifactory-oss:7.6.2
