#!/bin/bash

echo "[$(date)] Starting container."
COMMAND="apache2 -DFOREGROUND"
source /etc/apache2/envvars
exec ${COMMAND}