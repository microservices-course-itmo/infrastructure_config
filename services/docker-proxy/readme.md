# docker-proxy

простая прокси для docker'а, которая ограничивает права на создание **любых** сервисов/контейнеров/сеток

## запуск

`python docker-proxy.py`

## использование

`export DOCKER_HOST="unix:///tmp/docker-admin.sock"`

или

`sudo dockerd -H unix:///tmp/docker-admin.sock`

## пример с использованием docker cli

пробуем запуллить image

`docker run -p 6379:6379 --name some-redis -d redis`

получаем ответ

`Error response from daemon: You are not allowed.`

## todo

- ?
