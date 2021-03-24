#!/bin/bash

docker swarm init

# Сеть для docker swarm
docker network create -d overlay --attachable default_network