#!/bin/bash

source ${PROJECT_SETTINGS}
source ${CONTAINER_SCRIPTS_ROOT}/setup/utils/current_dir.sh
source ${CONTAINER_SCRIPTS_ROOT}/setup/utils/get_tag.sh

custom_tag=$(get_tag "${CURRENT_DIR}")

EXISTING_IMAGE_VARS="${CURRENT_DIR}/existing_image_vars"

function build_maria()
{
   if [[ -e ${EXISTING_IMAGE_VARS} ]]
   then
      rm ${EXISTING_IMAGE_VARS}
   fi
   podman build --tag="${custom_tag}" -f="${CURRENT_DIR}/dockerfile/dockerfile"
   echo -e "DBNAME=${DB_NAME}" > ${EXISTING_IMAGE_VARS}
   echo -e "DBUSER=${DB_USER}" >> ${EXISTING_IMAGE_VARS} 
   echo -e "DBHOST=${DB_HOST}" >> ${EXISTING_IMAGE_VARS} 
}

podman image exists ${custom_tag}

if [[ $? -eq 0 ]]
then
    if [[ -e ${EXISTING_IMAGE_VARS} ]]
    then
        source ${EXISTING_IMAGE_VARS}
        if [[ ${DBNAME} != ${DB_NAME} || ${DBUSER} != ${DB_USER} || ${DBHOST} != ${DB_HOST} ]]
        then
            build_maria
        fi
        # maria image doesn't need to be built
    else
        build_maria
    fi
else
    build_maria
fi