#!/usr/bin/env bash

set -vuex

if [ -n "$(which docker)" ] && [ -z "$(docker images | grep swaggerapi/swagger-editor)" ] ; then
  docker pull swaggerapi/swagger-editor
fi

if [ -n "$(which docker)" ] ; then
  stopped_process=$(docker ps -a | grep swaggerapi/swagger-editor)

  if [ -n "${stopped_process}" ] ; then
    container_id=$(echo ${stopped_process} | awk '{print $1}')
    docker start ${container_id}
  else
    docker run -d -p 18081:8080 swaggerapi/swagger-editor
  fi

fi
