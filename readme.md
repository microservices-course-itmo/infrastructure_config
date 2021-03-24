# перед запуском

1. Поменять пароли в сервисах в `.env` файлах, такие сервисы помечены '@@@'

```
.
├── artifactory @@@
│   ├── docker-compose.yml
│   └── .env (ARTIFACTORY_PASSWORD)
├── elk @@@
│   ├── docker-compose.yml
│   ├── elasticsearch
│   │   └── elasticsearch.yml
│   ├── .env (ELASTIC_PASSWORD)
│   ├── kibana
│   │   └── kibana.yml
│   └── logstash
│       ├── logstash.conf
│       └── logstash.yml
├── kafka
│   ├── docker-compose.yml
│   └── .env
├── mongo @@@
│   ├── docker-compose.yml
│   └── .env (MONGO_INITDB_ROOT_PASWORD)
├── monitoring
│   ├── docker-compose.yml
│   ├── .env
│   └── prometheus.yml
├── proxy
│   ├── docker-compose.yml
│   ├── docker-load-balancer.conf
│   ├── .env-reverse-docker
│   └── registry-reverse-proxy.conf
└── registry
    ├── docker-compose.yml
    └── .env
```

# запуск

```bash
./firewall.sh
./install-docker.sh
# ./start-docker.sh
./start-swarm.sh
./services_new/artifactory/set-password.sh
```
