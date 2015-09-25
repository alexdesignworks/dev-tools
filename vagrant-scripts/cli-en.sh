#!/bin/bash
#
# Enable PHP CLI debugging for an app inside vagrant box.
#
# CLI debugging will stay enabled during ssh session. This allows disabling it
# by simply re-ssh'ing into vagrant box.
#
# Usage (from within vagrant box):
# . /home/vagrant/sctipts/cli-en.sh myapp.local

# IDE key as set in PHPStorm's server configuration.
IDEKEY=PHPSTORM
# Host OS' IP address.
REMOTE_HOST=$(netstat -rn | grep "^0.0.0.0 " | cut -d " " -f10)
# Default server name.
SERVER_NAME="application"

# Pass server name as a first parameter as set in PHPStorm's server
# configuration.
if [ -n "$1" ] ; then
  SERVER_NAME=$1
fi

export XDEBUG_CONFIG="idekey=$IDEKEY remote_host=$REMOTE_HOST"
export PHP_IDE_CONFIG="serverName=$SERVER_NAME"

echo XDEBUG_CONFIG=$XDEBUG_CONFIG
echo PHP_IDE_CONFIG=$PHP_IDE_CONFIG
