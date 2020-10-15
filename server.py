#!/usr/bin/env python3

import socket
import subprocess

from time import sleep

HOST = '127.0.0.1'  # Standard loopback interface address (localhost)
# PORT = 65432        # Port to listen on (non-privileged ports are > 1023)
PORT = 10117


def close_process(p):
    p.stdin.close()
    p.stdout.close()

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.bind((HOST, PORT))
    s.listen()
    conn, addr = s.accept()
    with conn:
        
        # cmd = "./code-q1.sh https://www.neurobit.io sleep"
        
        while True:
            try:
                print('Connected by', addr)
                data = conn.recv(1024)
                # print("Client Says: ", data)
                
                params = data.decode()
                cmd = "./code-q1.sh {} {}".format(params.split("&")[0], params.split("&")[-1])

                # cmd = "./code-q1.sh https://www.neurobit.io sleep"
                p = subprocess.Popen(cmd , shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

                while p.poll() == None:
                    print("Waiting for the results to crawl")
                    sleep(1)
                
                # data = p.stdout.peek()
                # print("data", data)

                # conn.sendall(data)
                conn.sendall(p.stdout.peek())
                # close_process(p)
                if not data: break

            except socket.error:
                print("Error Occured.")
                break

conn.close()
