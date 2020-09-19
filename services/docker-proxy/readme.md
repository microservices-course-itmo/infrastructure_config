# docker-proxy

простая прокси для docker'а, которая ограничивает права на создание **любых** сервисов/контейнеров/сеток

пример

## запуск

`python docker-proxy.py`

## использование

`export DOCKER_HOST="unix:///tmp/docker-proxy.sock"`

или

`sudo dockerd -H unix:///tmp/docker-proxy.sock`

## пример с использованием docker cli

docker cli формирует на своей стороне запрос с командой и отправляет по сокету заданному в переменной окружении DOCKER_HOST

-

пробуем запуллить image

`docker run -p 6379:6379 --name some-redis -d redis`

получаем ответ

`Error response from daemon: You are not allowed.`

## todo

- ?
