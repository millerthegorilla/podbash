#!/bin/bash

source ${SCRIPTS_ROOT}/.proj

podman image exists python:latest
if [[ ! $? -eq 0 ]]
then
	podman pull docker.io/library/python:latest &
fi
podman image exists elasticsearch:7.11.2
if [[ ! $? -eq 0 ]]
then
	podman pull docker.io/library/elasticsearch:7.11.2 &
fi
podman image exists mariadb:10.5
if [[ ! $? -eq 0 ]]
then
        podman pull docker.io/library/mariadb:10.5 &
fi
podman image exists redis:6.2.2-buster
if [[ ! $? -eq 0 ]]
then
        podman pull docker.io/library/redis:6.2.2-buster &
fi
podman image exists docker-clamav:latest
if [[ ! $? -eq 0 ]]
then
        podman pull docker.io/mkodockx/docker-clamav:latest &
fi
podman image exists duckdns:latest
if [[ ! $? -eq 0 ]]
then
        podman pull docker.io/linuxserver/duckdns:latest &
fi
podman image exists swag:1.14.0
if [[ ! $? -eq 0 ]]
then
    podman pull docker.io/linuxserver/swag:version-1.14.0 &
fi

wait

if [[ ${DEBUG} == "TRUE" ]]
then
    podman image exists "python:${PROJECT_NAME}_debug"
    if [[ ! $? -eq 0 ]]
    then
        podman build --build-arg=PROJECT_NAME=${PROJECT_NAME} --tag="python:${PROJECT_NAME}_debug" -f='dockerfiles/dockerfile_django_dev'
    fi
else
    podman image exists "python:${PROJECT_NAME}_prod"
    if [[ ! $? -eq 0 ]]
    then
        echo $(whoami)
        cp -ar ${CODE_PATH}/media/ ${SCRIPTS_ROOT}/dockerfiles/django/
        podman build --build-arg=PROJECT_NAME=${PROJECT_NAME} --tag="python:${PROJECT_NAME}_prod" -f='dockerfiles/dockerfile_django_prod'
    fi
fi

function build_swag()
{
   rm ${SCRIPTS_ROOT}/.images
   podman build --tag='swag:artisan' -f='dockerfiles/dockerfile_swag_prod'
   echo -e "[swag]" > ${SCRIPTS_ROOT}/.images
   echo -e "TL_DOMAIN=${EXTRA_DOMAINS}" >> ${SCRIPTS_ROOT}/.images
   echo -e "DUCK_DOMAIN=${DUCKDNS_SUBDOMAIN}" >> ${SCRIPTS_ROOT}/.images 
}

if [[ ${DEBUG} == "FALSE" ]]
then
    podman image exists swag:artisan
    if [[ ! $? -eq 0 ]]
    then
        if [[ -e ${SCRIPTS_ROOT}/.images ]]
        then
            source ${SCRIPTS_ROOT}/.images
            if [[ ${TL_DOMAIN} != ${EXTRA_DOMAINS} || ${DUCK_DOMAIN} != ${DUCKDNS_SUBDOMAIN} ]]
            then
                build_swag
            fi
        else
            build_swag
        fi
    fi
fi