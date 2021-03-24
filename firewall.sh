


# docker swarm ports 
firewall-cmd --zone=public --add-masquerade --permanent
firewall-cmd --add-port=2376/tcp --permanent
firewall-cmd --add-port=2377/tcp --permanent
firewall-cmd --add-port=7946/tcp --permanent
firewall-cmd --add-port=7946/udp --permanent
firewall-cmd --add-port=4789/udp --permanent

# artifactory ports
firewall-cmd --zone=trusted --add-port=8081/tcp --permanent
firewall-cmd --zone=trusted --add-port=8082/tcp --permanent

# kibana ports
firewall-cmd --zone=trusted --add-port=5601/tcp --permanent

# grafana ports
firewall-cmd --zone=trusted --add-port=3000/tcp --permanent

# jenkins ports
firewall-cmd --zone=trusted --add-port=8080/tcp --permanent

# registry ports
firewall-cmd --zone=trusted --add-port=5000/tcp --permanent

firewall-cmd --reload
