#!/bin/bash

#mkdir -p /etc/docker/shared/artifactory

firewall-cmd --zone=trusted --add-port=8081/tcp --permanent
firewall-cmd --zone=trusted --add-port=8082/tcp --permanent

docker service create --name artifactory \
--mount type=bind,source=/etc/docker/shared/artifactory/artifactory,destination=/var/opt/jfrog/artifactory \
--network default_network -p 8081:8081 -p 8082:8082 -e EXTRA_JAVA_OPTIONS='-Xms512m -Xmx1024m -Xss256k -XX:+UseG1GC' \
docker.bintray.io/jfrog/artifactory-oss:7.6.2
