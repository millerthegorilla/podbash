#!/bin/bash

source ${PROJECT_SETTINGS}

IFS=',' read -r -a run_files <<< "${RUN_FILES}"

for container in $(ls -d ${CONTAINER_SCRIPTS_ROOT}/containers/*)
do
    for run_file in "${run_files[@]}"
    do
        if [[ -f "${container}/container/${run_file}.sh" ]]
        then
            bash "${container}/container/${run_file}.sh"
        fi
    done
done
