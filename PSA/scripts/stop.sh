#!/bin/bash
#
# stop.sh
#   Created:    19/02/2016
#   Author:     Savvas Charalambides
#   
#   Description:
#       This script clears the limits (if any) that were placed on eth0 and eth1.
# 
# This script is called by the PSA API when the PSA is requested to be stopped.
# 

TC=/sbin/tc
$TC qdisc del dev eth0 root
$TC qdisc del dev eth1 root
