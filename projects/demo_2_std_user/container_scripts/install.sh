#!/bin/bash

# these top level install.sh and uninstall.sh can be used to secure the podbash scripts,
# as is the default.
# in every install.sh or uninstall.sh, no matter where it is, place a function called
# install_check and this will be called when the install.sh or uninstall.sh is 
# sourced, and also when podbash commands are run.