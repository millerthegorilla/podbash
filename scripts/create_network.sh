#!/bin/bash

source ${PROJECT_SETTINGS}

for netfile in $(find ${CONTAINER_SCRIPTS_ROOT}/containers -type f -name "net.sh" | sort)
do
    /bin/bash "${netfile}"
done