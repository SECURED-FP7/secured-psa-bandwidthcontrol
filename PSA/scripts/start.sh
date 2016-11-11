#!/bin/bash
#
# start.sh
#   Created:    19/02/2016
#   Author:     Savvas Charalambides
#
#   Description:
#        Start script for the PSA Bandwidth Control
#-------------------------------------------------------------------------------
# This script is called by the PSA API when the PSA is requested to be started.
#
# Load PSA's current configuration:
#__________________________________
# The psaconf should contain the proper Linux Traffic Control (tc) that
# will configure the PSA's interfaces in order to properly limit
# the downlink and uplink rate to the ones requested by the user.
#
# Thus, in order to properly configure the PSA this script
# executes the psaconf.
#
#
#################################################################
# Configure bandwidth control parameters based on configuration:
#----------------------------------------------------------------
chmod +x /home/psa/pythonScript/psaConfigs/psaconf
source  /home/psa/pythonScript/psaConfigs/psaconf

echo "PSA Started"

exit 1;
