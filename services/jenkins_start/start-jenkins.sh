#!/bin/bash

cd "$(dirname "$0")"

dockerRepoHost=0.0.0.0:25001
dockerHost=proxy-serv:22376
dockerManagerIp=10.11.0.43
githubToken=${GITHUB_TOKEN}

jenkinsIp=127.0.0.1
adminPass=SilverTongue//5-4

#yum install -y wget

#sed -i "s#ARTIFACTORY_PASSWORD#${ARTIFACTORY_PASSWORD}#g" jenkins-home/settings.xml

#mkdir -p /etc/docker/shared/jenkins/home

#firewall-cmd --zone=trusted --add-port=8090/tcp --permanent
#firewall-cmd --reload

# docker build -t ${dockerRepoHost}/jenkins .
# docker push ${dockerRepoHost}/jenkins

docker service create --name jenkins --network=default_network \
	--mount type=bind,source=/etc/docker/shared/jenkins/scripts,destination=/home \
	--mount type=bind,source=/etc/docker/shared/jenkins/home,destination=/var/jenkins_home \
	-e DOCKER_REPO_HOST=${dockerRepoHost} -e DOCKER_HOST=${dockerHost} -e GITHUB_TOKEN=${githubToken} -p 8090:8090 ${dockerRepoHost}/jenkins

# sleep 60
#wget --continue --content-on-error --retry-connrefused --tries=10 --waitretry=120 http://${jenkinsIp}:8090/jnlpJars/jenkins-cli.jar
#cp jenkins-cli.jar jenkins-home/jenkins-cli.jar
#echo 'jenkins.model.Jenkins.instance.securityRealm.createAccount("admin", '\"${adminPass}\"')' | java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090 -auth admin:bdda8f76b6a54c2e956acd864e65b3e6 -noKeyAuth groovy = –

#sleep 10
#cat list-plugins.txt | awk '{print $1}' | while read plugin_name; do echo $plugin_name; java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090 -webSocket -auth admin:${adminPass} install-plugin $plugin_name < /dev/null > /dev/null; done

#echo 'jenkins.model.Jenkins.instance.securityRealm.createAccount("main", '\"${adminPass}\"')' | java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090 -auth admin:${adminPass} -noKeyAuth groovy = –
#cat admin-folder-job.xml | java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090 -webSocket -auth admin:${adminPass} create-job main
#cat create-deployment-jobs.xml | java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090 -webSocket -auth admin:${adminPass} create-job create-deployment-jobs
#cat create-api-build-job.xml | java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090 -webSocket -auth admin:${adminPass} create-job create-api-build-job

#echo "$adminPass" > jenkins-home/adminPass.txt
#cp -r jenkins-home/* /etc/docker/shared/jenkins/scripts
#chmod u+x /etc/docker/shared/jenkins/home/*.sh

# java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090/ -webSocket -auth admin:${adminPass} restart

#sleep 60

#./restore-jobs.sh
