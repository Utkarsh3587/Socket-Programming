#!/usr/bin/env python3

import socket

HOST = '127.0.0.1'  # The server's hostname or IP address
PORT = 10117        # The port used by the server

url = input("URL: ")
search = input("Search term: ")

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.connect((HOST, PORT))
    # s.sendall(b'Hello, world')
    s.sendall(("{}&{}").format(url, search).encode())
    data = s.recv(4096)

print('Received Data \n', data.decode())