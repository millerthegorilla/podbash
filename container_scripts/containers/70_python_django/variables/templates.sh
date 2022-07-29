#!/bin/bash

source ${PROJECT_SETTINGS}

if [[ ${DEBUG} == "TRUE" ]]
then
	cat ${CURRENT_DIR}/templates/dockerfile/dockerfile_dev | envsubst '$DOCKERFILE_APP_NAMES' > ${CURRENT_DIR}/../image/dockerfiles/dockerfile_dev
else
	set -a
	    NUM_OF_WORKERS=$(($(nproc --all) * 2 + 1))
	set +a
	cat ${CURRENT_DIR}/templates/gunicorn/gunicorn.conf.py | envsubst > ${SCRIPTS_ROOT}/settings/gunicorn.conf.py
    cat ${CURRENT_DIR}/templates/gunicorn/init | envsubst > ${SCRIPTS_ROOT}/dockerfiles/django/init
fi

cat ${CURRENT_DIR}/templates/env/settings_env | envsubst > ${SCRIPTS_ROOT}/settings/settings_env

cat ${CURRENT_DIR}/templates/django/manage.py | envsubst > ${CODE_PATH}/manage.py
chown ${USER_NAME}:${USER_NAME} ${CODE_PATH}/manage.py

cat ${CURRENT_DIR}/templates/django/wsgi.py | envsubst > ${CODE_PATH}/${django_project_name}/wsgi.py
chown ${USER_NAME}:${USER_NAME} ${CODE_PATH}/${django_project_name}/wsgi.py