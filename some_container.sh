#!/bin/bash
CONTAINER_NAME="buntu22"
IMAGE="ubuntu:latest"

## ANSI Colors for terminal
GREEN="\033[0;32m"
RED="\033[0;31m"
NO_COLOR="\033[0m"

function ERROR(){ 
  echo -e "\n ${RED} $1 ${NO_COLOR}\n" 
}

function SUCCESS(){ 
  echo -e "\n${GREEN} $1 ${NO_COLOR}\n" 
}
 
function start_container(){
  ## start some container, so we can connect to it
  docker create --name=$CONTAINER_NAME $IMAGE /bin/bash -c "tail /dev/null -f"
  docker start $CONTAINER_NAME

  ## show results
  docker ps
}

function check_network(){
  ## get the container ip 
  # CONTAINER_IP=$(docker inspect $CONTAINER_NAME | jq ".[].NetworkSettings.IPAddress" | tr -d '"')
  CONTAINER_IP=$(docker inspect\
    --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' \
    $CONTAINER_NAME)


  ## check if networking is fine
  ping -c 4 $CONTAINER_IP
}


## if container is not running (otherwise all code below makes no sense)
EXISTS=$(docker ps -q -f name=)

if [ $EXISTS ]; then 
  SUCCESS "Container exists!"
  check_network
else 
  ERROR "Can't find this container"
  start_container
fi

