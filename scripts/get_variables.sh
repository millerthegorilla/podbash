#!/bin/bash

source ${CONTAINER_SCRIPTS_ROOT}/setup/utils/local_settings.sh

function get_variables()
{
    for container in $(ls -d ${1})
    do
        local_settings_file=$(local_settings ${LOCAL_SETTINGS_FILE} "${container}/variables/questions.sh" | tail -n 1)
        bash ${container}/variables/questions.sh ${local_settings_file}
        cat ${local_settings_file} >> ${PROJECT_SETTINGS}
        unset local_settings_file
    done
}

function get_variables_and_make_project_file()
{

    get_variables "${CONTAINER_SCRIPTS_ROOT}/containers/*"
    get_variables "${CONTAINER_SCRIPTS_ROOT}/pods/*"

    echo -e "Do you want to save your settings as a settings file? : "
    select yn in "Yes" "No";
    do
        case $yn in
            Yes ) SAVE_SETTINGS="TRUE"; break;;
            No ) SAVE_SETTINGS="FALSE"; break;;
        esac
    done    

    if [[ SAVE_SETTINGS == "TRUE" ]]
    then
        cp ${PROJECT_SETTINGS} ${CURRENT_PROJECT_PATH}/settings_files/PROJECT_SETTINGS.${PROJECT_NAME}.$(date +%d-%m-%y_%T)
    fi
}

function make_project_settings()
{
    touch ${PROJECT_SETTINGS}
    if [[ ${PROJECT_TYPE} == "RESTRICTED" ]];
    then
        chown root:root ${PROJECT_SETTINGS}
        chmod 0600 ${PROJECT_SETTINGS}
    fi
}

function check_for_project_settings()
{
    if [[ -f ${PROJECT_SETTINGS} ]]
    then
        if grep -q '[^[:space:]]' ${PROJECT_SETTINGS};
        then
            echo -e "local .PROJECT_SETTINGS exists and is not empty"
            new_file="TRUE"
            for settings_file in $(find ${CURRENT_PROJECT_PATH}/settings_files -maxdepth 1 -type f | grep -v ".git_ignore")
            do
                if diff -q ${PROJECT_SETTINGS} ${settings_file} &>/dev/null;
                then
                    new_file="${settings_file}";
                    break;
                fi
            done
            if [[ "${new_file}" == "TRUE" ]]
            then
                echo -e "Moving it to PROJECT_SETTINGS_OLD"
                mv ${PROJECT_SETTINGS} ${CURRENT_PROJECT_PATH}/settings_files/PROJECT_SETTINGS_OLD.$(date +%d-%m-%y_%T)
            else
                echo -e "File already exists as ${new_file}.  Deleting current settings.\n"
                rm ${PROJECT_SETTINGS}
            fi
            make_project_settings
        fi
    fi
}

check_for_project_settings

echo -e "Enter absolute filepath of project settings or press enter to accept default.\n \
If the default does not exist, then you can enter the variables manually..."

pushd ${CURRENT_PROJECT_PATH}/settings_files &>/dev/null;
read -p ": " -e project_file
popd &>/dev/null
PROJECT_FILE="${CURRENT_PROJECT_PATH}/settings_files/${project_file}"
echo ${PROJECT_FILE}
if [[ -f "${PROJECT_FILE}" ]];
then
    echo "bob"
    project_settings=${PROJECT_FILE}
elif [[ -n ${DEFAULT_PROJECT_FILE} && -f ${DEFAULT_PROJECT_FILE} ]];
then
    project_settings=${DEFAULT_PROJECT_FILE}
else
    get_variables_and_make_project_file
fi

if [[ -n "${project_settings}" && "${project_settings}" != "${CURRENT_PROJECT_PATH}/PROJECT_SETTINGS" ]]
then
    cat ${project_settings} >> ${PROJECT_SETTINGS}
fi
