#!/bin/bash

scmBranch=$1
artifactId=$2
version=$3

docker build -t ${DOCKER_REPO_HOST}/${artifactId}:${scmBranch}_${version} .
docker push ${DOCKER_REPO_HOST}/${artifactId}:${scmBranch}_${version}
