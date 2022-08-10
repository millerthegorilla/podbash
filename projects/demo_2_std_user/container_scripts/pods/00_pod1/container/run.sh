#!/bin/bash

source ${PROJECT_SETTINGS}

if [[ "${DEBUG}" == "TRUE" ]]
then
   podman pod create --name ${POD_NAME} -p 0.0.0.0:8000:8000
else
   podman pod create --name ${POD_NAME} -p ${PORT1_DESCRIPTION} -p ${PORT2_DESCRIPTION} # --dns-search=${POD_NAME} --dns-opt=timeout:30 --dns-opt=attempts:5
fi