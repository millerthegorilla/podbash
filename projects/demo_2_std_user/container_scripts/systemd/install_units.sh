#!/bin/bash

source ${PROJECT_SETTINGS}

source ${CONTAINER_SCRIPTS_ROOT}/setup/utils/current_dir.sh

SYSTEMD_UNIT_DIR="${CURRENT_DIR}/unit_files"

if [[ ! -d ${SYSTEMD_UNIT_DIR} ]];
then
    mkdir -p ${SYSTEMD_UNIT_DIR};
fi

pushd ${SYSTEMD_UNIT_DIR}
cp -a * ${HOME}/.config/systemd/user

for f in $(find ${SYSTEMD_UNIT_DIR} -type f -name "*.service")
do
  echo ${f} >> .gitignore
  if [[ -e ${HOME}/.config/systemd/user/${f} ]]
  then
      chcon -u system_u -t systemd_unit_file_t ${HOME}/.config/systemd/user/${f}
      systemctl --user enable ${f}
  fi
done

systemctl --user daemon-reload
popd
