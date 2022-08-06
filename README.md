# Podbash

A script to organise the creation of podman container and pod scripts.

### license
As poor as these scripts are, and keeping in mind I accept no responsibility for any errors or headaches they may create, they are released, under an MIT license.  Use them at your own peril!

### quickstart

The scripts are designed to be installed in a super user account and to refer to a user account.  So you will need a sudo account and a non-sudo user, for maximum security.

Download, clone etc this project into your sudo users account, and then run ```podbash install```, this sets the permissions of the podbash scripts to the most restrictive possible.  If you want to git pull or change the scripts, then you can run ```podbash uninstall``` before you do so.
To create the containers and pods etc, run ```podbash create```.
To remove the containers and pods etc, run ```podbash clean```.

### demo

There are two example containers in this project that should help illustrate the process.  I have a project called artisan_scripts at https://github.com/millerthegorilla/artisan_scripts, that configures a bunch of containers inside a pod, that then mount code from a django project (https://github.com/millerthegorilla/django_artisan) inside a container running python, that can automatically provision a duckdns https django site.

### containers and pods

The scripts are used to provision a pod containing n containers.   You can theoretically, within resource limits, create as many containers as you like, and even create more than one pod if you wish.  The podbash script will run the containers based on the configuration it finds in the directory structure below the container_scripts directory.

That directory structure is as follows:

container_scripts&nbsp;>&nbsp;containers&nbsp;>&nbsp;containername&nbsp;>&nbsp;container&nbsp;>&nbsp;cleanup.sh
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;directories.sh
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;net.sh
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;pre.sh
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;run.sh
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;post.sh
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;>&nbsp;image&nbsp;>&nbsp;dockerfile&nbsp;>&nbsp;dockerfile
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;>&nbsp;custom.sh
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;>&nbsp;source.sh
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;>&nbsp;custom&nbsp;>&nbsp;your_custom_script.sh
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;...
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;>&nbsp;variables&nbsp;>&nbsp;templates&nbsp;>&nbsp;template_file.sh
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;...
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;>&nbsp;questions.sh
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;>&nbsp;templates.sh
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;>&nbsp;install.sh
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;uninstall.sh

pods&nbsp;>&nbsp;podname&nbsp;>&nbsp;container&nbsp;>&nbsp;cleanup.sh
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;>&nbsp;pre.sh
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;>&nbsp;run.sh
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;>&nbsp;post.sh
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;>&nbsp;variables&nbsp;>&nbsp;questions.sh
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;>&nbsp;install.sh
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;>&nbsp;uninstall.sh

settings&nbsp;>&nbsp;development&nbsp;>&nbsp;settings_for_development.sh
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;...
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;>&nbsp;production&nbsp;>&nbsp;settings_for_production.sh
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;...

setup&nbsp;>&nbsp;setup.sh
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;>&nbsp;utils&nbsp;>&nbsp;utility_files.sh&nbsp;&nbsp;(to&nbsp;be&nbsp;sourced&nbsp;into&nbsp;container&nbsp;scripts)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;...

... = more than one file
* if you want to create and run containers in a specific order then prefix the container names with numbers.

### requirements

In development mode I run the scripts inside a virt-manager vm, and so I spawn a graphical terminal to display the running django process in.
In any case, the machine, either for debug or production, needs to have an up to date bash shell, as I have not written the scripts to be particularly portable (see TODO below )

### options

There is a file in the root directory called 'options'.  I am using Gnome 3, so the TERMINAL_CMD is set to 'gnome-terminal --'.   If you are using xterm, then you will want to edit the file and change TERMINAL_CMD to 'xterm -e' etc etc.
The TERMINAL_CMD is used to spawn a terminal in the case of using a development install.  In this case when you start your machine, or more likely VM, then as soon as you login a terminal will spawn running the manage.py runserver command.  When you ctrl-C to kill the runserver command, the terminal will shutdown.  If you have systemd unit files installed, then you can simply run 'systemctl --user start manage_start.service' to spawn a new terminal running the dev server.

```CONTAINER_SCRIPTS_ROOT="${SCRIPTS_ROOT}/container_scripts"``` 
container scripts root is a convenient path to the scripts that have the information about the containers, pods, systemd etc.

```DEFAULT_PROJECT_FILE=```  this is a path to a file that contains the default project settings.

```PROJECT_SETTINGS="${SCRIPTS_ROOT}/.PROJECT_SETTINGS"``` the environment variable PROJECT_SETTINGS refers to the project settings file throughout the code, and the default is to locate a file in the scripts root called '.PROJECT_SETTINGS'.  If you set a DEFAULT_PROJECT_FILE or select a file from the settings_files directory, or if you manually enter the variables, the settings in each case get copied to the location of PROJECT_SETTINGS in the options file.

RUN_FILES='pre,run,post' - a comma delimited list of the files called in creating the container, in order.  If you want more granularity of control, then make more entries in here.  The comma delimited list is converted to an array, and the names 'pre', 'run', post', etc are used to refer to commands that you define as pre.sh run.sh or post.sh.

LOCAL_SETTINGS_FILE="./settings.sh" - as you answer questions when defining the project variables, each container's question's answers are stored in the LOCAL_SETTINGS_FILE, which defaults to a file called settings.sh, that is in the same directory as the questions.

### podbash commands

All podbash commands must be run as root, ie sudo or similar.

* ```./podbash.sh clean```

If at any point the scripts fail or you break out of them, you can run the script cleanup.sh to remove the containers and to reset the script environment to the beginning.

To clean up completely, run the ```./podbash.sh clean```, answer yes to code removal, and to image removal, and to log removal.

* ```./podbash.sh create```

* ```./podbash.sh create [ variables, templates, directories, network, pull, build, settings, pods, containers, systemd ]```

Creates the containers.  You can use the verb 'create' alone, in which case it will call the stages above in order, or you can pass a set of parameters to the create verb, referring to the different stages.  You might only want to build custom images, in which case you would run ```podbash.sh create images``` or perhaps the script exited at the pull image stage and you want to finish the process in which case you would run ```./podbash.sh create pull build settings pods containers systemd``` 

* ```./podbash.sh install```

This verb installs the artisan scripts, making certain that the directories and files are set to their most restrictive permissions.  All artisan_run commands require the commands to be run as root, ie sudo.  So, when you first clone this repository, immediately run ```sudo ./podbash.sh install```

* ```./podbash.sh uninstall```

This does the opposite of the install command, and puts files and directories back to the permissions that they had on the remote git repo.  So, when you want to git pull, you need to run this command first, or git will complain about unreachable files etc...

* ```./podbash.sh custom your_custom_script```

You can create a directory named 'custom' inside the container directory and then place scripts that can be run.  The command to pass to podbash is custom script_name (without the .sh).  Any parameters that follow ```podbash.sh custom script_name```  are passed to the script.  I use this in my django project to run ```python manage.py verb``` inside the appropriate container, for example.

* ```./podbash.sh refresh```

This command deletes and remakes the containers from the images.  It is an alias for `./podbash.sh create images`.  When the images have been rebuilt the host machine is restarted.

* ```./podbash.sh status```

This prints some details about the running project, if it is running, the username etc

* ```./podbash.sh update```

This command attempts to run a package update in all of the containers.  When you run the `podbash.sh create` command, you can select to update the containers the systemd way, which will check for an updated container in the registry, and pull it and restart the container if one exists.
https://www.redhat.com/sysadmin/podman-auto-updates-rollbacks

### systemd

When the systemd units have been created and installed, be aware that the podman container systemd units are created with the --new flag.  This completely breaks down and rebuilds the containers as clean, whenever the systemd unit shuts down/the host machine restarts etc.  If you want files/database/etc to persist then you will need to mount volumes in your run.sh command.

### Podman

You will want to read about podman generally, http://docs.podman.io/en/latest/index.html, 
but to list the containers, on your host machine or VM type in a terminal that is in the $USERNAME account:
```
podman ps
```
You can then see the list of active containers, and establish the name of the container you wish to exec into.
```
podman exec -it maria_cont bash
```
for example, to inspect the database (ie run mysql -uroot -p$PASSWORD).   http://docs.podman.io/en/latest/markdown/podman-exec.1.html

### TODO

the scripts need to be made more secure, to prevent command injection etc.
the scripts need to be made more portable.

### disclaimer...

These scripts are provided as is, with no support, and the author accepts nil responsibility for any damage or otherwise that using these scripts may cause.  They are alpha, permanently, so proceed with care.  The scripts have only been tested on machines running Fedora CoreOs, ie Silverblue and Fedora IOT.

I have tested them on a newly installed system, in my case a raspberry pi running Fedora IOT.

## Have fun!