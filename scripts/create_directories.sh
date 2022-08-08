#!/bin/bash

source ${PROJECT_SETTINGS}

for dirfile in $(find ${CONTAINER_SCRIPTS_ROOT}/containers -type f -name "directories.sh" | sort)
do
    /bin/bash "${dirfile}"
done