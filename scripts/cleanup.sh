#!/bin/bash

bash ${SCRIPTS_ROOT}/scripts/clean_save_settings.sh

for pod_cleanup in $(find ${CONTAINER_SCRIPTS_ROOT}/pods/ -type f -name "cleanup.sh" | sort)
do
    bash ${pod_cleanup}
done

for cont_cleanup in $(find ${CONTAINER_SCRIPTS_ROOT} -type f -name "cleanup.sh" -not -path "container_scripts/pods/*" | sort)
do
    bash ${cont_cleanup}
done