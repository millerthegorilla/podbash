#!/bin/bash

if [[ $EUID -ne 0 ]]
then
   echo "This script must be run as root" 
   exit 1
fi

source ${PROJECT_SETTINGS}

if [[ -n ${POD_NAME} ]]
then
    if [[ $(runuser --login ${USER_NAME} -c "podman pod exists ${POD_NAME}"; echo $?) -eq 0 ]]
    then         
        echo -e "pod ${POD_NAME} exists!  State is $(runuser --login ${USER_NAME} -c "podman pod inspect ${POD_NAME}" | grep -m1 State)"
    else
      echo -e "No project running currently"
    fi
fi