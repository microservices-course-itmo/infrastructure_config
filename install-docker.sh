#!/bin/bash

yum check-update

curl -fsSL https://get.docker.com/ | sh

curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

usermod -aG docker $USER

systemctl restart docker
