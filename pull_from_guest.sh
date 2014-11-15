#!/bin/bash

## use this script by going to a folder and running ../pull_from_guest.sh /path/to/output

if [ "$1" = "" ];then
    echo "must specify destination folder. pull_from_guest.sh <destination_folder>"
    exit 1
fi


SERVER=`vagrant ssh-config | grep HostName | awk '{print $2}'`
PEM_FILE=`vagrant ssh-config | grep IdentityFile | awk '{print $2}'`
USERNAME=`vagrant ssh-config | grep "User " | awk '{print $2}'`

scp -r -i "$PEM_FILE"  $USERNAME@$SERVER:/vagrant_pull/ "$1"