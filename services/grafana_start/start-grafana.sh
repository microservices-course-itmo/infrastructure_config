#!/bin/bash

firewall-cmd --zone=trusted --add-port=3000/tcp --permanent
firewall-cmd --reload

docker service create --name grafana \
--network default_network --replicas 1 \
--mount type=bind,source=/etc/docker/shared/grafana,destination=/var/lib/grafana \
-p 3000:3000 grafana/grafana
