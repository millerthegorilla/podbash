#!/bin/bash

source ${PROJECT_SETTINGS}

source ${CONTAINER_SCRIPTS_ROOT}/setup/utils/current_dir.sh

SYSTEMD_UNIT_DIR="${CURRENT_DIR}/unit_files"

if [[ ! -d ${SYSTEMD_UNIT_DIR} ]];
then
    mkdir -p ${SYSTEMD_UNIT_DIR};
fi

for f in $(find ${SYSTEMD_UNIT_DIR} -type f -name "*.service")
do
  cp ${f} ${HOME}/.config/systemd/user/$(basename ${f})
  echo ${f} >> .gitignore
  chcon -u unconfined_u -t systemd_unit_file_t ${HOME}/.config/systemd/user/$(basename ${f})
  systemctl --user enable $(basename ${f})
done

systemctl --user daemon-reload