#!/bin/bash

for install in $(find ${CONTAINER_SCRIPTS_ROOT} -type f -name "install.sh" | sort)
do
    source ${install}
    new_install_check=install_check
    if [[ $new_install_check != $old_install_check ]];
    then
      $new_install_check
    fi
    $old_install_check=install_check
done