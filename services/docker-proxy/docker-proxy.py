#!/usr/bin/python

import json
import os
import os.path
import re
import select
import socket
import struct
import threading
import time
from threading import Thread

docker_admin = "/tmp/docker-proxy.sock"

if os.path.exists(docker_admin):
    os.remove(docker_admin)

server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
server.bind(docker_admin)
server.listen()


# взято отсюда https://www.binarytides.com/receive-full-data-with-the-recv-socket-function-in-python/
def recv_timeout(sock):
    # make socket non blocking
    sock.setblocking(0)
    timeout = 0.3
    # total data partwise in an array
    total_data = []

    begin = time.time()
    while True:
        # if you got some data, then break after timeout
        if total_data and time.time()-begin > timeout:
            break
        elif time.time()-begin > timeout*2:
            break

        try:
            data = sock.recv(4096)
            if len(data) == 0:
                break

            if data:
                total_data.append(data)
                # change the beginning time for measurement
                begin = time.time()
            else:
                # sleep for sometime to indicate a gap
                time.sleep(0.1)
        except:
            pass

    # join all parts to make final string
    return b''.join(total_data)


def recvall(sock):
    BUFF_SIZE = 4096
    data = b''
    while True:
        part = sock.recv(BUFF_SIZE)
        data += part

        if len(part) < BUFF_SIZE:
            break
    return data


you_are_not_allowed = b'HTTP/1.1 404\r\nContent-Type: application/json\r\nContent-Length: 35\r\n\r\n{"message":"You are not allowed."}\n'


# обычный парсер пакета в http формате
def parse_http_packet(buf):
    data = buf.decode("utf-8", "ignore").split("\r\n\r\n")
    headers = data[0].split("\r\n")
    body = ''
    if len(data) == 2:
        body = data[1]

    return (headers, body)


def image_exists(name):
    data = ''
    # fmt: off
    data += 'GET /v1.40/images/json?filters={"reference":{"' + name + '":true}} HTTP/1.1' + '\n'
    data += 'Host: docker' + '\n'
    data += 'User-Agent: Docker-Client/19.03.8 (linux)' + '\n'
    data += '\r\n\r\n'
    # fmt: on

    docker_server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    docker_server.connect("/var/run/docker.sock")
    docker_server.send(data.encode())

    res = recvall(docker_server)
    (headers, body) = parse_http_packet(res)

    json_body = json.loads(body)

    if len(json_body) > 0:
        return True

    return False


def allowed_command(cmd):
    # либо команда не передана
    # либо передана, но минимум 3 параметра и ls в качестве основной команды
    if len(cmd) == 0 or (len(cmd) >= 1 and len(cmd) <= 3 and cmd[0] == "ls"):
        return True
    else:
        return None

# проксируем запросы в сокет докера
# запрещаем конкректные эндпоинты (см. create_endpoints)
#
# данные которые приходят на данный сокет (обычный payload в http формате)
# пример здесь https://docs.docker.com/engine/api/v1.24/


def listenToClient(conn, addr):
    datagram = recvall(conn)

    (headers, body) = parse_http_packet(datagram)

    endpoint = headers[0]

    print("--> (incoming)")
    for h in headers:
        print(h)
    print(body)
    print("----\n")

    # обработчик на выполнении команд
    is_exec = re.search("\/containers\/(.+?)\/exec", endpoint)
    if is_exec:
        print("is exec")
        json_body = json.loads(body)
        cmd = json_body['Cmd'] or []

        if not allowed_command(cmd):
            print('not allowed')
            conn.send(you_are_not_allowed)
            conn.close()
            return

    # обработчик на создание контейнера
    is_container_create = re.search("\/containers\/create", endpoint)
    if is_container_create:
        print('is container create')
        json_body = json.loads(body)
        cmd = json_body['Cmd'] or []
        image = json_body['Image']

        if not allowed_command(cmd):
            print('not allowed')
            conn.send(you_are_not_allowed)
            conn.close()
            return

        if not image_exists(image):
            print('not allowed')
            conn.send(you_are_not_allowed)
            conn.close()
            return

    # обработчик на создание сервиса
    is_service_create = re.search("\/services\/create", endpoint)
    if is_service_create:
        print('is service create')
        json_body = json.loads(body)
        spec = json_body['TaskTemplate']['ContainerSpec']
        # cmd = []
        # if "Args" in spec:
        #     cmd = spec["Args"] or []

        image = spec['Image']

        # print("cmd ", cmd)
        print("image ", image)

        # if not allowed_command(cmd):
        #     print('not allowed')
        #     conn.send(you_are_not_allowed)
        #     conn.close()
        #     return

        if not image_exists(image):
            print('not allowed')
            conn.send(you_are_not_allowed)
            conn.close()
            return

    docker_server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    docker_server.connect("/var/run/docker.sock")
    docker_server.send(datagram)

    datagram_res = recv_timeout(docker_server)
    (headers, body) = parse_http_packet(datagram_res)

    # обработчик на вольюмы (скрываем настройки)
    is_inspect_volume = re.search("\/volumes\/.+?\s", endpoint)
    if is_inspect_volume:
        new_body = json.loads(body)
        new_body['Options'] = None  # скрываем настройки

        new_headers = filter(lambda x: "Content-Length" not in x, headers)

        str_headers = "\r\n".join(new_headers)
        str_body = json.dumps(new_body)

        # создаем новый пакет со скрытыми настройками
        datagram_res = (str_headers + "\r\n\r\n" + str_body).encode('utf8')

    print("<-- (outgoing)")
    for h in headers:
        print(h)
    print()
    print(body)
    print("----\n")

    # при запуске скрипта в контейнере, docker может закрыть сокет раньше
    # игнорируем ошибку если сокет уже закрыт
    try:
        conn.send(datagram_res)
    except:
        pass

    conn.close()


while True:
    conn, addr = server.accept()

    Thread(target=listenToClient, args=(conn, addr)).start()


print("Shutting down...")
server.close()
