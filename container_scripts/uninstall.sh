#!/bin/bash

# note that the check function in uninstall.sh files is also called
# install_check

if [[ $EUID -ne 0 ]]
then
   echo "This script must be run as root" 
   exit 1
fi

function install_check()
{
  INSTALLED="installed."
    if [[ "550" -ne $(stat -c '%a' ${SCRIPTS_ROOT}/podbash.sh) ]];
    then
      ERROR=": ERR1 podbash.sh"
      INSTALLED="not installed"
    fi
    for line in $(find ${SCRIPTS_ROOT}/scripts -type d);
    do
      if [[ "550" -ne $(stat -c '%a' ${line}) ]];
      then
        ERROR=": ERR2 $line"
        INSTALLED="not installed!";
        break;
      fi
    done
    if [[ $INSTALLED == "installed." ]];
    then
      for line in $(find ${SCRIPTS_ROOT}/scripts -type f)
      do
        if [[ "440" -ne $(stat -c '%a' ${line}) ]];
        then
          ERROR=": ERR3 $line"
          INSTALLED="not installed!"
          break;
        fi
      done
    fi
    if [[ $INSTALLED == "installed." ]];
    then
      for line in $(find ${CONTAINER_SCRIPTS_ROOT} -type f -executable)
      do
        if [[ ${line} ]];
        then
          ERROR=": ERR4 - executable found - $line"
          INSTALLED="not installed!";
          break;
        fi
      done
    fi
    if [[ $INSTALLED == "installed." ]];
    then
      for line in $(find ${SCRIPTS_ROOT}/.git -type d)
      do
        if [[  "550" -ne $(stat -c '%a' ${line}) ]];
        then
          ERROR=": ERR5 $line"
          INSTALLED="not installed!";
          break;
        fi
      done
    fi;
    if [[ $INSTALLED == "installed." ]];
    then
      for line in $(find ${SCRIPTS_ROOT}/.git/objects -type f) 
      do
        if [[ "444" -ne $(stat -c '%a' ${line}) ]];
        then
          ERROR=": ERR6 $line"
          INSTALLED="not installed!";
          break;
        fi
     done
   fi
   if [[ $INSTALLED == "installed." ]];
    then
      for line in $(find ${SCRIPTS_ROOT}/.git -type f | grep -v /objects/ ) 
      do
        if [[ "640" -ne $(stat -c '%a' ${line}) ]];
        then
          ERROR=": ERR7 $line"
          INSTALLED="not installed!";
          break;
        fi
     done
   fi

  echo -e "Scripts are ${INSTALLED} $ERROR";
}

SCRIPT_DIR=$( cd -- "$( dirname -- "${SCRIPTS_ROOT}" )" &> /dev/null && pwd )
OWNER_NAME=$(stat -c "%U" ${SCRIPT_DIR})
find ${SCRIPTS_ROOT} | xargs chown ${OWNER_NAME}:${OWNER_NAME}
find ${SCRIPTS_ROOT} -type d | grep -v "settings_files" | xargs chmod 0775
find ${SCRIPTS_ROOT} -type f | xargs chmod 0660
find ${SCRIPTS_ROOT}/.git -type d | xargs chmod 755
find ${SCRIPTS_ROOT}/.git/objects -type f | xargs chmod 664
find ${SCRIPTS_ROOT}/.git -type f | grep -v /objects/ | xargs chmod 644
chmod 0770 ${SCRIPTS_ROOT}/podbash.sh
chown root:root ${SCRIPTS_ROOT}/settings_files