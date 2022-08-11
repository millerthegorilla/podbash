#!/bin/bash

function make_secret()
{  
    if [[ $(podman secret inspect ${1} &>/dev/null; echo $?) == 0 ]]
    then
        echo -e "podman secret ${1} already exists - reuse ?"
        select yn in "Yes" "No"; do
            case $yn in
                Yes ) REUSE="TRUE"; break;;
                No ) REUSE="FALSE"; break;;
            esac
        done
        if [[ ${REUSE} == "FALSE" ]]
        then
            podman secret rm ${1}
            read -p "Enter variable for ${1} : " token && echo -n "$token" | podman secret create "${1}" - 
        fi
    else
        read -p "Enter variable for ${1} : " token && echo -n "$token" | podman secret create "${1}" -
    fi
}