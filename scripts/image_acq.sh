#!/bin/bash

source ${PROJECT_SETTINGS}

for image_src in $(find ${CONTAINER_SCRIPTS_ROOT}/containers -type f -name "source.sh" | sort)
do
    source ${image_src}
    if [[ -n "${USER_NAME}" ]];   # TODO define a project settings options file that states whether the project is std user or super user account
    then
        if ! runuser ${USER_NAME} -l -c "podman image exists ${TAG}";
        then
	        echo "pulling ${TAG}"
            runuser ${USER_NAME} -l -c "podman pull ${SOURCE}"
        fi
    else
        if ! podman image exists ${TAG};
        then
            echo "pulling ${TAG}"
            podman pull ${SOURCE}
        fi
done
