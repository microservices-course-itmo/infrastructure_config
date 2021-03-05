#!/bin/bash

docker run --name registry-proxy --user root -v ${PWD}/registry-proxy.conf:/etc/nginx/nginx.conf --network default_network -p 25001:25001 -d nginx;
