#!/bin/bash

source ${PROJECT_SETTINGS}

if [[ -n ${POD_NAME} ]]
then
    if podman pod exists ${POD_NAME};
    then         
        echo -e "pod ${POD_NAME} exists!  State is $(podman pod inspect ${POD_NAME} | grep -m1 State)"
        exit 0
    else
      echo -e "No project running currently"
      exit 1
    fi
fi