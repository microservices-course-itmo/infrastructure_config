#!/bin/bash

jenkinsIp=127.0.0.1
adminPass=${JENKINS_PASSWORD}

cat "list-jobs.txt" | while read line; do 
    args=($line)
    type=${args[0]}
    url=${args[1]}
    pass=${args[2]} 
    if [[ -n "$type" && -n "$url" && -n "$pass" ]]; then
        if [[ "$type" == "api" ]]; then
            echo "Creating api job ${url}"
            echo 'create-api-build-job' | java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090/ -webSocket -auth admin:${adminPass}  build 'create-api-build-job' -p githubRepo=${url} -p password=${pass} && echo "Successful"

        elif [[ "$type" == "deployment" ]]; then
            echo "Creating deployment jobs ${url}"
            echo 'create-deployment-jobs' | java -jar jenkins-cli.jar -s http://${jenkinsIp}:8090/ -webSocket -auth admin:${adminPass}  build 'create-deployment-jobs' -p githubRepo=${url} -p password=${pass} && echo "Successful"
        else
            echo "Unknown parameter ${type}"
        fi
    else
        echo "Wrong line ${line}"
    fi

done