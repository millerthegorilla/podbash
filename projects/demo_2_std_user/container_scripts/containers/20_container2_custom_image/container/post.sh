#!/bin/bash

if [[ $EUID -ne 0 ]]
then
   echo "This script must be run as root" 
   exit 1
fi

source ${PROJECT_SETTINGS}
source ${CONTAINER_SCRIPTS_ROOT}/setup/utils/current_dir.sh

echo "init script output = " $?
echo -n "Waiting for mariadb restart..."
until ! podman exec -it ${MARIA_CONT_NAME} bash -c 'ls /tmp/.finished' > /dev/null 2>&1
do
	echo -n "."
done
podman stop ${MARIA_CONT_NAME}
podman start ${MARIA_CONT_NAME}
podman exec -it ${MARIA_CONT_NAME} bash -c 'rm /docker-entrypoint-initdb.d/maria.sh'

if [[ -f ${CURRENT_DIR}/../image/dockerfile/maria.sh ]];
then
    rm ${CURRENT_DIR}/../image/dockerfile/maria.sh
fi