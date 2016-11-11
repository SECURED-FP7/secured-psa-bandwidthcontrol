#!/bin/bash
#
SERVICE=tc
if P=$(pgrep $SERVICE)
then
    echo 1
    exit 1
else
    echo 0
    exit 0
    
fi

