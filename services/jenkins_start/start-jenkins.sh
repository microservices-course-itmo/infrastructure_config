#!/bin/bash

jenkinsIp=127.0.0.1


mkdir /mounts/jenkins/home
chown -R 1030 /mounts/jenkins/

sudo firewall-cmd --zone=trusted --add-port=8090/tcp --permanent


docker build -t jenkins .

initPassword=$(docker run --name jenkins --network=j-a-net --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /mounts/jenkins/home:/home -e DOCKER_REPO_HOST=${DOCKER_REPO_HOST} -p 8090:8090 jenkins 2>&1 | grep -m1 -A2 "Please use the following password to proceed to installation:" | (tail -n 1 && docker stop jenkins > /dev/null))
echo "Password: $initPassword"

docker start jenkins > /dev/null
sleep 60
wget --continue --content-on-error --retry-connrefused --tries=10 --waitretry=120 http://${jenkinsIp}:8090/jnlpJars/jenkins-cli.jar
echo 'jenkins.model.Jenkins.instance.securityRealm.createAccount("admin", "admin")' | java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090 -auth admin:${initPassword} -noKeyAuth groovy = –

sleep 10
cat list-plugins.txt | awk '{print $1}' | while read plugin_name; do echo $plugin_name; java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090 -webSocket -auth admin:admin install-plugin $plugin_name < /dev/null > /dev/null; done

cat service-app.xml | java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090 -webSocket -auth admin:admin create-job service-app
cat run-service.xml | java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090 -webSocket -auth admin:admin create-job run-service

cp -r jenkins-home/* /mounts/jenkins/home
chmod u+x /mounts/jenkins/home/*.sh

java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090/ -webSocket -auth admin:admin restart
