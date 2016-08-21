#!/bin/bash
docker run  -e ADMIN_PASS=123qwe -e VIRTUAL_PORT=9091 -e VIRTUAL_HOST=transmission.mini.25752.com,transmission.inter.25752.com -v /data/volume/downloads/transmission:/opt/transmission/downloads -v /data/volume/downloads/incomplete:/opt/transmission/incomplete -d --name=root --restart=always --privileged transmission
