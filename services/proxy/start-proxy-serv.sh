#!/bin/bash

docker config create proxy-serv proxy-serv.conf
docker service create --name proxy-serv --user root --config src=proxy-serv,target=/etc/nginx/nginx.conf --network default_network nginx


