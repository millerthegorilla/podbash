#!/bin/bash

source ${PROJECT_SETTINGS}

podman pod exists ${POD_NAME}
retval=$?

if [[ ! $retval -eq 0 ]]
then
	echo no such pod!
else
    echo -e "\nshutting down and removing the pod..."
	podman pod stop ${POD_NAME}
	podman pod rm ${POD_NAME}
fi

# prune any miscellaneous images that may have been left over during builds.
podman image prune -f

podman pod exists ${POD_NAME}
if [[ $? != 0 ]]
then
    echo -e "Finished Cleaning.\n"
else
    echo -e "Finished Cleaning but **pod still exists**"
fi 