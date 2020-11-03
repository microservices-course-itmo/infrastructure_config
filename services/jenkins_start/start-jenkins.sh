#!/bin/bash

cd "$(dirname "$0")"

dockerRepoHost=${DOCKER_REPO_HOST}
githubToken=${GITHUB_TOKEN}

jenkinsIp=127.0.0.1
adminPass=${JENKINS_PASSWORD}

sed -i "s#ARTIFACTORY_PASSWORD#${ARTIFACTORY_PASSWORD}#g" jenkins-home/settings.xml

mkdir /mounts/jenkins/home
chown -R 1030 /mounts/jenkins/

firewall-cmd --zone=trusted --add-port=8090/tcp --permanent
firewall-cmd --reload

imageExist=$(docker image inspect jenkins | grep "Error: No such image")
if [ "$imageExist" != "" ]
then
docker build -t jenkins .
fi

docker start jenkins > /dev/null
sleep 60
wget --continue --content-on-error --retry-connrefused --tries=10 --waitretry=120 http://${jenkinsIp}:8090/jnlpJars/jenkins-cli.jar
cp jenkins-cli.jar jenkins-home/jenkins-cli.jar

sleep 10

#echo 'jenkins.model.Jenkins.instance.securityRealm.createAccount("main", '\"${adminPass}\"')' | java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090 -auth admin:${adminPass} -noKeyAuth groovy = –
#cat admin-folder-job.xml | java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090 -webSocket -auth admin:${adminPass} create-job main
cat create-deployment-jobs.xml | java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090 -webSocket -auth admin:${adminPass} create-job create-deployment-jobs
cat create-api-build-job.xml | java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090 -webSocket -auth admin:${adminPass} create-job create-api-build-job

echo "$adminPass" > jenkins-home/adminPass.txt
cp -r jenkins-home/* /mounts/jenkins/home
chmod u+x /mounts/jenkins/home/*.sh

java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090/ -webSocket -auth admin:${adminPass} restart
