#!/bin/bash

cd "$(dirname "$0")"

dockerRepoHost=0.0.0.0:25001
dockerHost=proxy-serv:22376
dockerManagerIp=10.11.0.43
githubToken=${GITHUB_TOKEN}

jenkinsIp=127.0.0.1
adminPass=${JENKINS_PASSWORD}

yum install -y wget

sed -i "s#ARTIFACTORY_PASSWORD#${ARTIFACTORY_PASSWORD}#g" jenkins-home/settings.xml

mkdir -p /etc/docker/shared/jenkins/home

firewall-cmd --zone=trusted --add-port=8090/tcp --permanent
firewall-cmd --reload

docker build -t ${dockerRepoHost}/jenkins .
docker push ${dockerRepoHost}/jenkins

 docker service create --name jenkins --network=default_network \
	 --mount volume-driver=vieux/sshfs,source=jenkins,target=/home,volume-opt=sshcmd=root@${dockerManagerIp}:/etc/docker/shared/jenkins,volume-opt=allow_other,volume-opt=password=${ROOT_PASSWORD} \
	 -e DOCKER_REPO_HOST=${dockerRepoHost} -e DOCKER_HOST=${dockerHost} -e GITHUB_TOKEN=${githubToken} -p 8090:8090 ${dockerRepoHost}/jenkins

# sleep 60
#wget --continue --content-on-error --retry-connrefused --tries=10 --waitretry=120 http://${jenkinsIp}:8090/jnlpJars/jenkins-cli.jar
#cp jenkins-cli.jar jenkins-home/jenkins-cli.jar
#echo 'jenkins.model.Jenkins.instance.securityRealm.createAccount("admin", '\"${adminPass}\"')' | java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090 -auth admin:${tempPass} -noKeyAuth groovy = –

#sleep 10
#cat list-plugins.txt | awk '{print $1}' | while read plugin_name; do echo $plugin_name; java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090 -webSocket -auth admin:${adminPass} install-plugin $plugin_name < /dev/null > /dev/null; done

#echo 'jenkins.model.Jenkins.instance.securityRealm.createAccount("main", '\"${adminPass}\"')' | java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090 -auth admin:${adminPass} -noKeyAuth groovy = –
#cat admin-folder-job.xml | java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090 -webSocket -auth admin:${adminPass} create-job main
#cat create-deployment-jobs.xml | java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090 -webSocket -auth admin:${adminPass} create-job create-deployment-jobs
#cat create-api-build-job.xml | java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090 -webSocket -auth admin:${adminPass} create-job create-api-build-job

#echo "$adminPass" > jenkins-home/adminPass.txt
#cp -r jenkins-home/* /etc/docker/shared/jenkins/home
#chmod u+x /etc/docker/shared/jenkins/home/*.sh

# java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090/ -webSocket -auth admin:${adminPass} restart

#sleep 60

#./restore-jobs.sh
