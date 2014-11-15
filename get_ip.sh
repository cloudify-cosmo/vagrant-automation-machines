#!/bin/sh

echo `vagrant ssh-config | grep HostName | awk '{print $2}'`