#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo ${DIR}
mkdir -p /mounts/artifactory
chown -R 1030 /mounts/
yum install curl at
systemctl start atd
cp -r ${DIR}/base /mounts/artifactory/exp/
firewall-cmd --zone=trusted --add-port=8081/tcp --permanent
firewall-cmd --zone=trusted --add-port=8082/tcp --permanent

docker run -d --name artifactory --network=j-a-net --restart=always -v /mounts/artifactory:/var/opt/jfrog/artifactory -p 8081:8081 -p 8082:8082 -e EXTRA_JAVA_OPTIONS='-Xms512m -Xmx1024m -Xss256k -XX:+UseG1GC' docker.bintray.io/jfrog/artifactory-oss:7.6.2
echo "${DIR}/importSystem.sh" | at now +5 min