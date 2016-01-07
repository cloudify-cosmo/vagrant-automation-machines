#!/usr/bin/env bash

echoerr() { echo "$@" 1>&2; }

# copy the file
SCP_PLUGIN=`vagrant plugin list | grep vagrant-scp | wc -l`

if [ "$SCP_PLUGIN" = "0" ]; then
    echoerr "need vagrant-scp plugin which is missing"
	exit 1
else
    echo "scp plugin already installed"
fi

vagrant scp default:${1} .