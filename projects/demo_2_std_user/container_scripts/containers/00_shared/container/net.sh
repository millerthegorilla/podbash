#!/bin/bash

source ${PROJECT_SETTINGS}

# if [[ ! $(sysctl net.ipv4.ip_unprivileged_port_start) == "net.ipv4.ip_unprivileged_port_start = 80" ]]
# then
#    echo net.ipv4.ip_unprivileged_port_start=80 >> /etc/sysctl.conf
#    sysctl --system
# fi