#!/bin/bash

# these top level install.sh and uninstall.sh can be used to secure the podbash scripts,
# as is the default.
# in every install.sh or uninstall.sh, no matter where it is, place a function called
# install_check and this will be called when the install.sh or uninstall.sh is 
# sourced, and also when podbash commands are run.

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

#find ${SCRIPTS_ROOT} -type d -exec chown root:root {} +
#find ${SCRIPTS_ROOT} -type f -exec chown root:root {} +
find ${SCRIPTS_ROOT} -type d -exec chmod 0550 -- {} +
find ${SCRIPTS_ROOT} -type f -exec chmod 0440 -- {} +
find ${CURRENT_PROJECT_PATH}/container_scripts -type f -name "*$.sh" -exec chmod 0440 -- {} +
#find ${SCRIPTS_ROOT}/container_scripts -type f -name "settings.sh" -exec chmod 0640 -- {} +
find ${CURRENT_PROJECT_PATH}/container_scripts -type d -exec chmod 0770 -- {} +
find ${SCRIPTS_ROOT}/scripts -type f -name "*$.sh" -exec chmod 0440 -- {} +
find ${SCRIPTS_ROOT}/.git -type d -exec chmod 0550 {} +
find ${SCRIPTS_ROOT}/.git/objects -type f -exec chmod 0444 -- {} +
find ${SCRIPTS_ROOT}/.git -type f | grep -v /objects/ | xargs chmod 640
find ${SCRIPTS_ROOT} -type d -exec chown ${SUDO_USER}:${SUDO_USER} -- {} +
find ${SCRIPTS_ROOT} -type f -exec chown ${SUDO_USER}:${SUDO_USER} -- {} +
find ${CURRENT_PROJECT_PATH}/settings_files -type d -exec chown root:root -- {} + \
                                            -exec chmod 0660 -- {} +
find ${CURRENT_PROJECT_PATH}/settings_files -type f -exec chown root:root -- {} + \
                                            -exec chmod 0440 -- {} +
chmod 0550 ${SCRIPTS_ROOT}/podbash.sh
chmod 0550 ${SCRIPTS_ROOT}/scripts