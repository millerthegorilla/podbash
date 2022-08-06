#!/bin/bash

if [[ $EUID -ne 0 ]]
then
   echo "This script must be run as root" 
   exit 1
fi

L_S_FILE=${1}

source ${CONTAINER_SCRIPTS_ROOT}/containers/00_shared/variables/settings.sh

pod_name=${PROJECT_NAME}_pod
read -p "Pod name [${pod_name}] : " POD_NAME
POD_NAME=${POD_NAME:-${pod_name}}

echo "POD_NAME=${POD_NAME}" >> ${L_S_FILE}

# PORT1_DESCRIPTION
PORT1_DESCRIPTION=0.0.0.0:443:443

echo "PORT1_DESCRIPTION=${PORT1_DESCRIPTION}" >> ${L_S_FILE}

# PORT2_DESCRIPTION
PORT2_DESCRIPTION=0.0.0.0:80:80

echo "PORT2_DESCRIPTION=${PORT2_DESCRIPTION}" >> ${L_S_FILE}