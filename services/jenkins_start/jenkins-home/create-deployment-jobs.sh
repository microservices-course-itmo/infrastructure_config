#!/bin/bash

jenkinsIp=127.0.0.1
adminPass=admin

user=$1
password=$2
githubRepos=$3
branches=$4
serviceNames=$5

cd "$(dirname "$0")"

echo 'jenkins.model.Jenkins.instance.securityRealm.createAccount('\"${user}\", \"${password}\"')' | java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090 -auth admin:${adminPass} -noKeyAuth groovy = –
cat new-user-pattern.xml | sed "s#USER#${user}#g" | java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090 -webSocket -auth admin:${adminPass} create-job ${user}

githubReposXml=$(echo "$githubRepos" | sed 's/\.git//g' | awk -F "," '{ for(i = 1; i <= NF; i++) { printf("%s ", "<hudson.plugins.git.UserRemoteConfig><url>"$i"</url></hudson.plugins.git.UserRemoteConfig>"); } }')
branchesXml=$(echo "$branches" | awk -F "," '{ for(i = 1; i <= NF; i++) { printf("%s ", "<hudson.plugins.git.BranchSpec><name>*/"$i"</name></hudson.plugins.git.BranchSpec>"); } }') 
serviceNamesXml=$(echo "$serviceNames" | awk -F "," '{ for(i = 1; i <= NF; i++) { printf("%s ", "<string>"$i"</string>"); } }')

echo "$githubReposXml"
echo "$branchesXml"
echo "$serviceNamesXml"

cat build-service-pattern.xml | sed "s#GITHUB_REPOS#${githubReposXml}#g" | sed "s#BRANCHES#${branchesXml}#g" | java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090 -webSocket -auth admin:${adminPass} create-job ${user}/build-service
cat run-service-pattern.xml | sed "s#SERVICE_NAMES#${serviceNamesXml}#g" | java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090 -webSocket -auth admin:${adminPass} create-job ${user}/run-service

