#!/bin/bash

docker config create registry-proxy-serv registry-proxy-serv.conf
docker service create --name registry-proxy-serv --user root --config src=registry-proxy-serv,target=/etc/nginx/nginx.conf --network default_network nginx
