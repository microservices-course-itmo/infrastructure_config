#!/bin/bash

cd "$(dirname "$0")"

jenkinsIp=127.0.0.1
adminPass=$(cat adminPass.txt)

githubRepo=$1
password=$2

userAndRepoName=$(echo "$githubRepo" | awk -F "/" '{print $4"/"$5}' | sed -E "s/.git$//g")

git ls-remote --heads $githubRepo | awk -F "/" '{print $3}' | while read branch;
do
curl https://raw.githubusercontent.com/${userAndRepoName}/${branch}/pom.xml 2>  /dev/null | sed -E 's/xmlns=".*"//g' > pom.xml
apiName=$(xmllint --xpath "//project/artifactId/text()" pom.xml 2> /dev/null)
rm pom.xml
if [ "$apiName" != "" ]
then
echo "$apiName" > apiName.tmp
break
fi
done

serviceName=$(cat apiName.tmp | sed -E "s/-api$//g")
rm apiName.tmp
echo "$serviceName"

echo 'jenkins.model.Jenkins.instance.securityRealm.createAccount('\"${serviceName}\", \"${password}\"')' | java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090 -auth admin:${adminPass} -noKeyAuth groovy = –
cat new-user-pattern.xml | sed "s#USER#${serviceName}#g" | java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090 -webSocket -auth admin:${adminPass} create-job ${serviceName}

githubRepoXml='<hudson.plugins.git.UserRemoteConfig><url>https://github.com/'${userAndRepoName}'</url></hudson.plugins.git.UserRemoteConfig>'
branchesXml='<hudson.plugins.git.BranchSpec><name>*/*</name></hudson.plugins.git.BranchSpec>'

echo "$githubRepoXml"
echo "$branchesXml"

cat build-service-pattern.xml | sed "s#GITHUB_REPO#${githubRepoXml}#g" | sed "s#BRANCHES#${branchesXml}#g" | java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090 -webSocket -auth admin:${adminPass} create-job ${serviceName}/build-api

