#!/bin/bash

docker service create --name postgres --network default_network --replicas 1 --mount type=volume,source=postgres_data,destination=/var/lib/postgresql/data --env POSTGRES_PASSWORD=postgres postgres
