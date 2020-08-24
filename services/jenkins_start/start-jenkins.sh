#!/bin/bash

dockerRepoHost=10.11.0.43:5000

jenkinsIp=127.0.0.1
adminPass=admin

cd "$(dirname "$0")"

mkdir /mounts/jenkins/home
chown -R 1030 /mounts/jenkins/

firewall-cmd --zone=trusted --add-port=8090/tcp --permanent
firewall-cmd --reload


#docker build -t jenkins .

initPassword=$(docker run --name jenkins --network=j-a-net --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /mounts/jenkins/home:/home -e DOCKER_REPO_HOST=${dockerRepoHost} -p 8090:8090 jenkins 2>&1 | grep -m1 -A2 "Please use the following password to proceed to installation:" | (tail -n 1 && docker stop jenkins > /dev/null))
echo "Password: $initPassword"

docker start jenkins > /dev/null
sleep 60
wget --continue --content-on-error --retry-connrefused --tries=10 --waitretry=120 http://${jenkinsIp}:8090/jnlpJars/jenkins-cli.jar
cp jenkins-cli.jar jenkins-home/jenkins-cli.jar
echo 'jenkins.model.Jenkins.instance.securityRealm.createAccount("admin", '\"${adminPass}\"')' | java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090 -auth admin:${initPassword} -noKeyAuth groovy = –

sleep 10
cat list-plugins.txt | awk '{print $1}' | while read plugin_name; do echo $plugin_name; java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090 -webSocket -auth admin:${adminPass} install-plugin $plugin_name < /dev/null > /dev/null; done

cat create-deployment-jobs.xml | java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090 -webSocket -auth admin:${adminPass} create-job create-deployment-jobs

cp -r jenkins-home/* /mounts/jenkins/home
chmod u+x /mounts/jenkins/home/*.sh

java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090/ -webSocket -auth admin:${adminPass} restart
