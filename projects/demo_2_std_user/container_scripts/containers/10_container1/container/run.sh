#!/bin/bash

if [[ $EUID -ne 0 ]]
then
   echo "This script must be run as root" 
   exit 1
fi

source ${PROJECT_SETTINGS}

podman run -dit --pod ${POD_NAME} ${AUTO_UPDATES} -e CLAMAV_NO_CLAMD=true -e CLAMAV_NO_FRESHCLAMD=true -v clam_vol:/var/lib/clamav --name ${CLAM_CONT_NAME} ${CLAM_IMAGE}