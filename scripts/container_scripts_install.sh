#!/bin/bash

for install in $(find ${CONTAINER_SCRIPTS_ROOT} -type f -name "install.sh" | sort)
do
    source ${install}
    if [[ $(type -t install_check) == "function" ]]
    then
      new_install_check=$(type install_check)
    fi
    if [[ $new_install_check != $old_install_check ]];
    then
      install_check
    fi
    if [[ $(type -t install_check) == "function" ]];
    then
      old_install_check=$(type install_check)
    fi
done