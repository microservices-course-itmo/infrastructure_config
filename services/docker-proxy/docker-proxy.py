#!/usr/bin/python

import json
import os
import os.path
import socket
import threading
from threading import Thread

docker_admin = "/tmp/docker-proxy.sock"

if os.path.exists(docker_admin):
    os.remove(docker_admin)

server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
server.bind(docker_admin)
server.listen()


# items = open('allowed-images.txt', 'r')
# allowed_images = set([item.strip() for item in items.readlines()])


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


create_endpoints = [
    "/services/create",
    "/containers/create",
    "/images/create",
    "/networks/create",
    "/volumes/create"
]


def listenToClient(conn, addr):
    datagram = recvall(conn)

    data = datagram.decode("utf-8").split("\r\n\r\n")
    headers = data[0].split("\r\n")
    body = data[1]

    # print(headers)
    # print("----")
    # print(body)

    endpoint = headers[0]

    # print(endpoint)

    if any(item in endpoint for item in create_endpoints):
        conn.send(you_are_not_allowed)
        conn.close()
        return

    docker_server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    docker_server.connect("/var/run/docker.sock")
    docker_server.send(datagram)
    datagram_res = recvall(docker_server)

    # print(datagram_res)

    conn.send(datagram_res)
    conn.close()


while True:
    conn, addr = server.accept()

    Thread(target=listenToClient, args=(conn, addr)).start()


print("Shutting down...")
server.close()
