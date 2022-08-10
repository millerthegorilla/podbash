#!/bin/bash

source ${PROJECT_SETTINGS}
source ${CONTAINER_SCRIPTS_ROOT}/setup/utils/current_dir.sh

if [[ -e ${CURRENT_DIR}/../image/dockerfile/maria.sh ]];
then
   rm -rf ${CURRENT_DIR}/../image/dockerfile/maria.sh
fi

if [[ -n "${DB_VOL}" ]];
then
   if podman volume exists ${DB_VOL};
   then
      podman volume rm ${DB_VOL}
   fi
fi