#!/bin/bash

/usr/bin/redis-server /etc/redis/redis.conf 2>&1 &
/go/bin/gddo-server --crawl_interval 5s --sidebar 2>&1


