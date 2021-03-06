#!/bin/bash
#
# current_config.sh
#   Description:
#       This script return the current configuration.
#       (psaConfigs/psaconf)
# 
# This script is called by the PSA API when the PSA's current runtime configuration is requested.
# 
# Return value: 
# Current configuration
#

COMMAND_OUTPUT="$(cat /home/psa/pythonScript/psaConfigs/psaconf)"
printf '%s\n' "${COMMAND_OUTPUT[@]}"
exit 1;

