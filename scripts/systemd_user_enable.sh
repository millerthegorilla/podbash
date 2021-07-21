#!/bin/bash

cd ${SCRIPTS_ROOT}/systemd/
FILES=*
for f in ${FILES}
do
  if [[ -e /etc/systemd/user/${f} ]]
  then
      systemctl --user enable ${f}
  fi
done

cd ${SCRIPTS_ROOT}   ## DIRECTORY CHANGE HERE