#!/bin/bash

function title {
  echo ""
  echo $1
  echo $(echo $1 | sed 's/./=/g')
}

title "Build Gerrit v3.7 image"
docker-compose build

title "Make gerrit-01 primary unhealthy"
ssh -p 29411 admin@localhost gerrit plugin rm healthcheck
sleep 20

title "Kill gerrit-01 primary"
docker-compose kill gerrit-01

title "Upgrade gerrit-01 primary"
docker-compose up gerrit-01-upgrade

title "Start gerrit-01 primary"
docker-compose up -d gerrit-01

title "Wait for gerrit-01 to become healthy again"
while ! curl -s -f http://localhost:8081/config/server/healthcheck\~status; do echo -n '.' && sleep 1; done

title "Make gerrit-02 primary unhealthy"
ssh -p 29412 admin@localhost gerrit plugin rm healthcheck
sleep 20

title "Restart gerrit-02 primary"
docker-compose kill gerrit-02
docker-compose up -d gerrit-02

