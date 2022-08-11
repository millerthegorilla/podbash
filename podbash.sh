#!/bin/bash

PARAMS=""

set -a
SCRIPTS_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

if [[ -e ${SCRIPTS_ROOT}/options ]]
then
  source ${SCRIPTS_ROOT}/options
fi
set +a

if [[ -s ${PROJECT_SETTINGS} ]];
then
    source ${PROJECT_SETTINGS}
fi

if [[ ! -d ${CURRENT_PROJECT_PATH}/settings_files ]];
then
    mkdir -p ${CURRENT_PROJECT_PATH}/settings_files/env_files;
    chmod 0775 ${CURRENT_PROJECT_PATH}/settings_files ${CURRENT_PROJECT_PATH}/settings_files/env_files;
fi

function local_install_check()
{
  for install in $(find ${CONTAINER_SCRIPTS_ROOT} -type f -name "install.sh")
  do
    source ${install}
    if [[ $(type -t install_check) == "function" ]]
    then
      new_install_check=$(type install_check)
    fi
    if [[ $new_install_check != $old_install_check ]];
    then
      install_check
    else
      function install_check() { test=""; }
    fi
    if [[ $(type -t install_check) == "function" ]];
    then
      old_install_check=$(type install_check)
    fi
  done
}

if [[ "$1" != "install" && "$1" != "uninstall" ]]; then
    local_install_check;
fi

if ! [[ -s ${PROJECT_SETTINGS} ]];
then
  echo -e "**!! PROJECT_SETTINGS is EMPTY !!**"
fi

while (( "$#" )); do
  case "$1" in
    install)
      bash ${SCRIPTS_ROOT}/scripts/container_scripts_install.sh -r
      exit $?
      ;;
    uninstall)
      bash ${SCRIPTS_ROOT}/scripts/container_scripts_uninstall.sh -r
      exit $?
      ;;
    create)
      labels=()
      iarray=()
      alllabels=('variables' 'templates' 'directories' 'network' 'pull' 'build' 'settings' 'pods' 'containers' 'systemd')
      parray=( "${@:2}" )
      if [[ ${#parray} -gt 0 ]]
      then
          if [[ ${parray[0]^^} == 'ALL' ]]
          then
              labels=( ${alllabels[@]} )
          else
              # labels=${parray[@]:1}
              declare -A vars
              vars['variables']=0
              vars['templates']=1
              vars['directories']=2
              vars['network']=3
              vars['pull']=4
              vars['build']=5
              vars['settings']=6
              vars['pods']=7
              vars['containers']=8
              vars['systemd']=9
              i=0
              for j in "${parray[@]}"
              do
                  iarray[$i]=${vars[$j]}
                  i=$i+1
              done
              IFS=$'\n' sorted=($(sort <<<"${iarray[*]}"))
              unset IFS
              i=0
              for j in "${sorted[@]}"
              do
                 labels[i]="${alllabels[$j]}"
                 i=$i+1
              done
          fi
      else
          labels=( ${alllabels[@]} )
      fi
      if [[ ${#labels[@]} -eq 0 ]]
      then
        labels=( ${parray[@]} )
      fi
      for i in "${labels[@]}"
      do
          case "${i^^}" in
            'VARIABLES')
                echo -e "\nOkay, lets find out more about you...\n"
                bash ${SCRIPTS_ROOT}/scripts/get_variables.sh
                if [[ $? -ne 0 ]]
                then
                  exit $?
                fi
            ;;
            'TEMPLATES')
                echo -e "\nOkay, lets find out more about you...\n"
                bash ${SCRIPTS_ROOT}/scripts/templates.sh
                if [[ $? -ne 0 ]]
                then
                  exit $?
                fi
            ;;
            'DIRECTORIES')
                echo -e "\nNow I will create necessary directtories.\n"
                bash ${SCRIPTS_ROOT}/scripts/create_directories.sh
                if [[ $? -ne 0 ]]
                then
                  exit $?
                fi
            ;;
            'NETWORK')
                echo -e "\nNow for general network settings.\n"
                bash ${SCRIPTS_ROOT}/scripts/create_network.sh
                if [[ $? -ne 0 ]]
                then
                  exit $?
                fi
            ;;
            'PULL')
                echo -e "\nI will now download container images, if they are not already present.\n"
                bash ${SCRIPTS_ROOT}/scripts/image_acq.sh
                wait $!
                if [[ $? -ne 0 ]]
                then
                  exit $?
                fi
            ;;
            'BUILD')
                echo -e "\nI will now build any custom container images, if they are not already present.\n"
                bash ${SCRIPTS_ROOT}/scripts/image_build.sh
                if [[ $? -ne 0 ]]
                then
                  exit $?
                fi
            ;;
            'SETTINGS')
                echo -e "\n please choose the settings file you want to use.\n"
                bash ${SCRIPTS_ROOT}/scripts/settings.sh
            ;;
            'PODS')
                echo -e "\n I will create the pods.\n"
                bash ${SCRIPTS_ROOT}/scripts/create_pods.sh
            ;;
            'CONTAINERS')
                echo -e "\n and now I will create the containers...\n"
                bash ${SCRIPTS_ROOT}/scripts/create_containers.sh
            ;;
            'SYSTEMD')
                echo -e "\n fancy some systemd?...\n"
                echo -e "Generate and install systemd --user unit files? : "
                select yn in "Yes" "No"; do
                    case $yn in
                        Yes ) SYSD="TRUE"; break;;
                        No ) SYSD="FALSE"; break;;
                    esac
                done
                if [[ ${SYSD} == "TRUE" ]]
                then
                    bash ${SCRIPTS_ROOT}/scripts/systemd.sh
                fi
            ;;
            *)
                echo -e "Error: unknown option passed to create : ${i^^}"
                exit 1
            ;;
          esac
      done
      exit $? 
      ;;
    clean)
      bash ${SCRIPTS_ROOT}/scripts/cleanup.sh
      exit $?
      ;;
    clean_save_settings)
      bash ${SCRIPTS_ROOT}/scripts/clean_save_settings.sh
      exit $?
      ;; 
    custom)
      command=${2}
      shift 2;      
      bash $(find ${CONTAINER_SCRIPTS_ROOT}/containers -name "${command}.sh") $@
      exit $?
      ;;   
    status)
      shift;
      if [[ ${1} == "restricted" ]];
      then
          scripts_install_check
      fi
      if [[ -s "${PROJECT_SETTINGS}" ]]
      then
          echo -e "PROJECT_SETTINGS file exists and is not empty!"
      else
          echo -e "PROJECT_SETTINGS file is empty!"
      fi
      if [[ -f "${CURRENT_PROJECT_PATH}/status.sh" ]];
      then
          bash "${CURRENT_PROJECT_PATH}/status.sh";
      fi
      exit $?
      ;;
    interact)
      if [[ -z ${USER_NAME} ]]
      then
          read -p "Enter username : " USER_NAME
      fi
      runuser --login ${USER_NAME} -P -c "XDG_RUNTIME_DIR=\"/run/user/$(id -u ${USER_NAME})\" DBUS_SESSION_BUS_ADDRESS=\"unix:path=${XDG_RUNTIME_DIR}/bus\" cd; ${2}"
      exit $?
      ;;
    update)
      if [[ -z ${USER_NAME} ]]
      then
          read -p "Enter username : " USER_NAME
      fi
      su ${USER_NAME} -c "cd; podman ps --format=\"{{.Names}}\" | grep -oP '^((?!infra).)*$' | while read name; do podman exec -u root ${name} bash -c \"apt-get update; apt-get upgrade -y\"; done"
      exit $?
      ;;
    refresh)
      if [[ -z ${USER_NAME} ]]
      then
          read -p "Enter username : " USER_NAME
      fi
      if [[ -z ${POD_NAME} ]]
      then
          read -p "Enter username : " POD_NAME
      fi
      su ${USER_NAME} -c "cd; podman pod stop ${POD_NAME}; podman image prune --all -f"
      ${SCRIPTS_ROOT}/scripts/image_acq.sh
      ${SCRIPTS_ROOT}/scripts/image_build.sh
      systemctl reboot
      ;;
    help|-h|-?|--help)
      echo -e "$ ./podbash.sh command   - where command is one of clean,
create [ variables, templates, directories, network, pull, build, settings, pods, containers, systemd ],
install, refresh, status, settings, update or help.

clean - cleans the project, deleting the containers and pod, and deleting 
        settings files etc.

create - on its own creates a new project, running through the various stages
    which are:
       variables   - gets variables from user
       templates   - calls into container/pod directories templates.sh to
                     use envsubst to complete template files in appropriate
                     template directory
       directories - calls into directories.sh in container directories to
                     make any directories and set permissions etc
       network     - calls net.sh in containers/pods directories to set network
                     settings for containers
       pull        - pulls the podman images that are mentioned in source.sh in
                     each container directory
       build       - builds any custom containers that are defined
       settings    - calls choose_settings.sh to choose the appropriate settings file
                     and copy or envsubst them to the appropriate place
       pods        - creates pods 
       containers  - creates the containers from the container scripts, pre,run,post
                     in that order (default - see ${SCRIPTS_ROOT}/options)
       systemd     - creates and installs the systemd units
    
    Use any combination of the stage names after the create verb to perform
    those stages.

install - when you first clone the repository, you can set the appropriate 
          permissions using this verb.

interact - commands following the interact verb will be run inside the podman
           pod using systemd context.  You are often better to run 
           'podman pod exec -it container_name bash' in the user account.

postgit - in case you reinstall django_artisan filebase completes and copies
          manage.py and wsgi.py and copies them to the appropriate places and
          sets the file and directory permissions inside the container correctly

refresh - deletes all images, downloads them and rebuilds the custom images.

status - reports the current status of the project.

settings - replaces the settings file with one you choose from the 
           dev/production directory.

tests_on - changes database permissions sufficient to allow tests to be run

update - runs apt-get update in all the containers.  Note that when you create a
         project you can specify that the containers are updated where possible,
         which will be done automatically by podman.

help - this text."
      exit 0
      ;;
    *) # unsupported flags
      echo "Error: Unsupported action $1" >&2
      exit 1
      ;;
  esac
done # set positional arguments in their proper place

#eval set -- "$PARAMS"

echo "I need a command!!"
exit 1
