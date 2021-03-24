#!/bin/bash


test -e ./.env || { echo ".env not found" ; exit 1; }

export $(xargs <.env)

container_id=$(docker ps | grep artifactory | awk '{print $1}')

docker exec -it $container_id \
  /bin/sh -c  "curl -XPATCH -u admin:password http://localhost:8040/access/api/v1/users/admin -H \"Content-Type: application/json\" -d '{ \"password\": \"${ARTIFACTORY_PASSWORD}\" }'"