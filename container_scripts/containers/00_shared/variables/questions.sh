#!/bin/bash

if [[ $EUID -ne 0 ]]
then
   echo "This script must be run as root" 
   exit 1
fi

L_S_FILE=${1}

# PROJECT_NAME
echo -e "#************************** PROJECT_NAME **************************"
isValidVarName() {
    echo "$1" | grep -q '^[_[:alpha:]][_[:alpha:][:digit:]]*$' && return || return 1
}

until isValidVarName "${PROJECT_NAME}"
do
   read -p 'Artisan scripts project name - this is used as a directory name, so must be conformant to bash requirements : ' PROJECT_NAME
   if ! isValidVarName "${PROJECT_NAME}"
   then
       echo -e "That is not a valid variable name.  Your project name must conform to bash directory name standards"
   fi
done

echo "PROJECT_NAME=${PROJECT_NAME}" >> ${L_S_FILE}

# USER_NAME
USER_NAME=${RANDOM}
until id ${USER_NAME} >/dev/null 2>&1;
do
    read -p "Standard/service user account name ['artisan_sysd'] : " USER_NAME
    USER_NAME=${USER_NAME:-"artisan_sysd"}
done
# if [[ $(id ${USER_NAME} > /dev/null 2>&1; echo $?) -ne 0 ]]
# then
#     echo -e "Error, account with username ${USER_NAME} does not exist!"
#     exit 1
# fi

echo "USER_NAME=${USER_NAME}" >> ${L_S_FILE} 

# USER_DIR
pushd / &> /dev/null
read -p "Absolute path to User home dir [ /home/${USER_NAME} ] : " -e USER_DIR
USER_DIR=${USER_DIR:-/home/${USER_NAME}}
popd &> /dev/null

echo "USER_DIR=${USER_DIR}" >> ${L_S_FILE}

# CODE_PATH
pushd / &> /dev/null
until [[ -d "${CODE_PATH}" && ! -L "${CODE_PATH}" ]] 
do
    read -p 'Absolute path to code (the folder where manage.py resides) : ' -e CODE_PATH
    if [[ ! -d "${CODE_PATH}" ]]
    then
       echo -e "That path doesn't exist!"
    fi
    if [[ -L "${CODE_PATH}" ]]
    then
        echo -e "Code path must not be a symbolic link"
    fi
    if [[ ! -d "${CODE_PATH}/media" ]]
    then
        echo -e "There is no media dir in that location. Are you sure?  I will progress anyway.  If it is incorrect, simply stop the script and restart."
    fi
done
popd &> /dev/null

echo "CODE_PATH=${CODE_PATH}" >> ${L_S_FILE}

# DJANGO_PROJECT_NAME
PN=$(basename $(dirname $(find ${CODE_PATH} -name "asgi.py")))
read -p "Enter the name of the django project ie the folder in which wsgi.py resides [${PN}] : " DJANGO_PROJECT_NAME
DJANGO_PROJECT_NAME=${DJANGO_PROJECT_NAME:-${PN}}

echo "DJANGO_PROJECT_NAME=${DJANGO_PROJECT_NAME}" >>  ${L_S_FILE}

# DEBUG
if [[ -z "${DEBUG}" ]]
then
    echo -e "\nIs this development ie debug? : "
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) DEBUG="TRUE"; break;;
            No ) DEBUG="FALSE"; break;;
        esac
    done
fi

echo "DEBUG=${DEBUG}" >> ${L_S_FILE}

# AUTO_UPDATES
## add a container label to container run that auto-updates the container every ...
echo -e "\nEnable container updates where possible ? : "
select yn in "Yes" "No"; do
    case $yn in
        Yes ) AUTO_UPDATES="--label 'io.containers.autoupdate=registry'"; break;;
        No ) AUTO_UPDATES=""; break;;
    esac
done

echo "AUTO_UPDATES=\"${AUTO_UPDATES}\"" >> ${L_S_FILE}