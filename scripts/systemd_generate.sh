#!/bin/bash

source ${SCRIPTS_ROOT}/options
source ${SCRIPTS_ROOT}/.archive
source ${SCRIPTS_ROOT}/.env

cd ${SCRIPTS_ROOT}/systemd/ ## DIRECTORY CHANGE HERE

podman generate systemd --new --name --files ${POD_NAME}

## TEMPLATES
set -a
 django_service=${DJANGO_CONT_NAME}
 django_cont_name=${DJANGO_CONT_NAME}
 project_name=${PROJECT_NAME}
 terminal_cmd=${TERMINAL_CMD}
set +a

if [[ ${DEBUG} == "TRUE" ]]
then
    cat ${SCRIPTS_ROOT}/templates/systemd/manage_start.service | envsubst > ${SCRIPTS_ROOT}/systemd/manage_start.service 
    cat ${SCRIPTS_ROOT}/templates/systemd/qcluster_start.service.dev | envsubst > ${SCRIPTS_ROOT}/systemd/qcluster_start.service 
else
    cat ${SCRIPTS_ROOT}/templates/systemd/qcluster_start.service.prod | envsubst > ${SCRIPTS_ROOT}/systemd/qcluster_start.service 
fi
