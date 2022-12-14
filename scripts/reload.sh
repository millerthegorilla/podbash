#!/bin/bash

if [[ -e ${SCRIPTS_ROOT}/.archive ]]
then
    source ${SCRIPTS_ROOT}/.archive
fi

if [[ -e ${SCRIPTS_ROOT}/.proj ]]
then
    source ${SCRIPTS_ROOT}/.proj
fi

if [[ -z "${DEBUG}" ]]
then
	echo -e "Is the running setup a development setup? : "
	select yn in "Yes" "No"; do
	    case $yn in
	        Yes ) DEBUG="TRUE"; break;;
	        No ) DEBUG="FALSE"; break;;
	    esac
	done
fi

if [[ -z "${DJANGO_CONT_NAME}" ]]
then
	read -p "enter the name of the django container : " DJANGO_CONT_NAME
fi

if [[ -z "${PROJECT_NAME}" ]]
then
	read -p "Enter artisan scripts project name, as in /etc/opt/*PROJECT_NAME*/settings etc [${PROJECT_NAME}] : " project_name
    PROJECT_NAME=${project_name:-${PROJECT_NAME}}
fi

while getopts "gn" OPTION; do
    case $OPTION in
	    g)
			if [[ ${DEBUG} == "TRUE" ]]
			then
				echo "this is a development setup - manage.py should reload automatically on file changes."
			else
				 runuser --login ${USER_NAME} -c "podman exec -e PROJECT_NAME=${PROJECT_NAME} -dit ${DJANGO_CONT_NAME} bash -c \"kill -HUP $(ps -C gunicorn -o %p |grep -v PID |sort | head -n1)\"\""
			fi
			;;
		n)
			if [[ ${DEBUG} == "TRUE" ]]
			then
				echo "this is a development setup - manage.py should reload automatically on file changes."
			else
				 runuser --login ${USER_NAME} -c "podman exec -e PROJECT_NAME=${PROJECT_NAME} -dit ${DJANGO_CONT_NAME} bash -c \"nginx -c /config/nginx/nginx.conf -s reload\""
			fi
	    	exit $?
	    	;;
	    :)                                    # If expected argument omitted:
		    if [[ ${DEBUG} == "TRUE" ]]
			then
				echo "this is a development setup - manage.py should reload automatically on file changes."
			else
			    runuser --login ${USER_NAME} -c "podman exec -e PROJECT_NAME=${PROJECT_NAME} -dit ${DJANGO_CONT_NAME} bash -c \"kill -HUP $(ps -C gunicorn -o %p |grep -v PID |sort | head -n1)\"\""
				runuser --login ${USER_NAME} -c "podman exec -e PROJECT_NAME=${PROJECT_NAME} -dit ${DJANGO_CONT_NAME} bash -c \"nginx -c /config/nginx/nginx.conf -s reload\""
			fi
			exit $?
			;;
	    *)                                    # If unknown (any other) option:
	       exit 1                       # Exit abnormally.
	       ;;
	esac
done