#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

if [[ -z "${SCRIPTS_ROOT}" ]]
then
    echo "Error!  SCRIPTS_ROOT must be defined"
    exit 1
fi

cd ${SCRIPTS_ROOT}/systemd

FILES=*
for f in ${FILES}
do
  if [[ -e /etc/systemd/user/${f} ]]
  then
  	  su ${USER_NAME} -c "XDG_RUNTIME_DIR=\"/run/user/$(id -u ${USER_NAME})\" DBUS_SESSION_BUS_ADDRESS=\"unix:path=${XDG_RUNTIME_DIR}/bus\" systemctl --user disable ${f}"
  	  if [[ ! $? -eq 0 ]]
  	  then
  	  	  echo -e "\nFailed whilst disabling systemd units."
  	  	  exit 1
  	  fi
      rm -rf /etc/systemd/user/${f}
  fi
done

cd ${SCRIPTS_ROOT}
