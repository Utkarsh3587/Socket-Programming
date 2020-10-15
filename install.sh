#!/usr/bin/env bash

# ref https://raspberrypi.stackexchange.com/questions/83659/python-script-does-not-run-when-called-by-service

echo "create a test service ..."
cp crawl.service /lib/systemd/system/
systemctl daemon-reload
systemctl enable crawl.service
sudo systemctl status crawl.service
echo "created the test service"


# to check service logs
# sudo journalctl -f -u crawl
