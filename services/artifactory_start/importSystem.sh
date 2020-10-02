#!/bin/bash

curl -X POST -u admin:password -H "Content-type: application/json" -d '{ "importPath" : "/var/opt/jfrog/artifactory/exp/base" }'  http://localhost:8081/artifactory/api/import/system
sleep 15
docker restart artifactory
