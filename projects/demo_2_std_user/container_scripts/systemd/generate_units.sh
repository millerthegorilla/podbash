#!/bin/bash

source ${PROJECT_SETTINGS}

source ${CONTAINER_SCRIPTS_ROOT}/setup/utils/current_dir.sh

SYSTEMD_UNIT_DIR="${CURRENT_DIR}/unit_files"

# POD MUST BE RUNNING WITH ALL CONTAINERS RUNNING INSIDE
pushd ${SYSTEMD_UNIT_DIR} &>/dev/null;
podman generate systemd --new --name --files ${POD_NAME}

# copy gitignore into empty dir
cp ${CURRENT_DIR}/templates/systemd_git_ignore ${SYSTEMD_UNIT_DIR}/.gitignore
chmod -R 0644 ${SYSTEMD_UNIT_DIR}/*