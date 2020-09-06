#!/bin/bash

serviceName=$1
versionOrBranch=$2

environmentRepo=$3

dockerRepoHost=${DOCKER_REPO_HOST}
githubToken=${GITHUB_TOKEN}

StartService() {
tag=$1

envFileContent=""
if [ "$environmentRepo" == "Custom" ]
then
envFileContent=$(cat /var/jenkins_home/workspace/test/environment/service-env)
else
echo "Environment repository: $environmentRepo"
envFileContent=$(curl -H "Authorization: token ${githubToken}" ${environmentRepo}/${serviceName}/${serviceName} 2> /dev/null)
fi

environment=$(echo "$envFileContent" | sed 's/\r$//' | awk -F " " '{print "--env "$1"="$2}' ORS=' ')
echo "Environment: $environment"

docker service rm ${serviceName}
docker service create --network default_network --replicas 1 --name $serviceName $environment ${dockerRepoHost}/${serviceName}:${tag}
echo "Wait 30 sec"
sleep 30
timeout 120 docker service logs $serviceName
}

VersionScenario() {
version=$1
branch=master
tag=${branch}_$version
echo "Tag: $tag"
StartService $tag
}

BranchScenario() {
branch=$1
#curl - получаем json с тегами; jq - получаем массив тегов, выведенный построчно; sed - удаляем все пробелы, кавычки и запятые
#grep - отфильтровываем теги с указанным названием ветки; awk - выделяем из тегов номера версий;
#sort - сортируем версии по убыванию; head - выбираем верхнюю строку (последнюю версию)
version=$(curl -G registry:5000/v2/${serviceName}/tags/list 2> /dev/null | jq -M ".tags" | sed -E 's/( |\"|,)//g' | grep -E "^${branch}_([0-9]+\.)*[0-9]+$" | awk -F "_" '{print $NF}' | sort -r -n -t "." | head -n 1)
tag=${branch}_$version
echo "Tag: $tag"
StartService $tag
}

ChooseScenario() {
if [ "$versionOrBranch" == "" ]
then
echo "Enter version number or branch name"
exit 1
fi

isItVersion=$(echo $versionOrBranch | grep -E '^([0-9]+\.)*[0-9]+$')

if [ "$isItVersion" != "" ]
then
echo "Version number is entered"
VersionScenario $versionOrBranch
else
echo "Branch name is entered"
BranchScenario $versionOrBranch
fi
}

echo "Start"
echo "Service: $serviceName"
ChooseScenario
echo "Finish"

