#!/bin/bash

LOCAL_SETTINGS_FILE=$(source ${CONTAINER_SCRIPTS_ROOT}/setup/setup.sh ${BASH_SOURCE} ${LOCAL_SETTINGS_FILE})

if [[ ${DEBUG} == "TRUE" ]]
then
	exit 0
fi

# SWAG_VOL_NAME
swag_vol_name="cert_vol"
read -p "Swag Volume Name [${swag_vol_name}] : " SWAG_VOL_NAME
SWAG_VOL_NAME=${SWAG_VOL_NAME:-${swag_vol_name}}

echo "SWAG_VOL_NAME=${SWAG_VOL_NAME}" >> ${LOCAL_SETTINGS_FILE}

# CERTBOT_EMAIL
read -p "Email address for letsencrypt certbot : " certbot_email

echo "CERTBOT_EMAIL=${certbot_email}" >> ${LOCAL_SETTINGS_FILE}

# SWAG_HOST_LOG_DIR
swhld = "${USER_DIR}/${PROJECT_NAME}/swag_logs"
read -p "Swag Host log dir (must be different to Host Log Dir) [ ${swhld} ] : " SWAG_HOST_LOG_DIR
SWAG_HOST_LOG_DIR=${SWAG_HOST_LOG_DIR:-${swhld}}

echo "SWAG_HOST_LOG_DIR=${SWAG_HOST_LOG_DIR}" >> ${LOCAL_SETTINGS_FILE}

# EXTRA_DOMAINS
echo -e "\nDo you have a top level domain pointing at your duckdns domain ? : "
select yn in "Yes" "No"; do
    case $yn in
        Yes ) tldomain="TRUE"; break;;
        No ) tldomain="FALSE"; break;;
    esac
done
if [[ ${tldomain} == "TRUE" ]]
then
    read -p "Your top level domain that points at your duckdns domain : " tl_domain
    EXTRA_DOMAINS="${tl_domain}"
else
    EXTRA_DOMAINS="NONE"
fi

echo "EXTRA_DOMAINS=${EXTRA_DOMAINS}" >> ${LOCAL_SETTINGS_FILE}

# SWAG_CONT_NAME

SWAG_CONT_NAME="redis_cont"

echo "SWAG_CONT_NAME=${SWAG_CONT_NAME}" >> ${LOCAL_SETTINGS_FILE}

# SWAG_IMAGE

SWAG_IMAGE=$(get_tag)

echo "SWAG_IMAGE=${SWAG_IMAGE}" >> ${LOCAL_SETTINGS_FILE}

# SWAG_CONT_VOL_STATIC
SWAG_CONT_VOL_STATIC="/opt/static_files/"

echo "SWAG_CONT_VOL_STATIC=${SWAG_CONT_VOL_STATIC}" >> ${LOCAL_SETTINGS_FILE}

# SWAG_CONT_VOL_MEDIA
SWAG_CONT_VOL_MEDIA="/opt/media_files/"

echo "SWAG_CONT_VOL_MEDIA=${SWAG_CONT_VOL_MEDIA}" >> ${LOCAL_SETTINGS_FILE}

# SWAG_CONT_LOG_DIR
SWAG_CONT_LOG_DIR="/config/log/"

echo "SWAG_CONT_LOG_DIR=${SWAG_CONT_LOG_DIR}" >> ${LOCAL_SETTINGS_FILE}