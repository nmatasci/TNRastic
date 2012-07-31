#! /bin/env bash
#
# autrestart.sh: bash utility to check the status of the TNRastic service and restart it
# To be used in conjunction with the utility cron 
# Author: Naim Matasci <nmatasci@iplantcollaborative.org>
#
# The contents of this file are subject to the terms listed in the LICENSE file you received with this code.
# Copyright (c) 2012, The Arizona Board of Regents on behalf of
# The University of Arizona
#
###############################################################################

RES=$(curl -s -m 180 localhost/status)
echo $RES
if [ -z "$RES" ]; then
cd /opt/TNRastic/tnrs_handler
./restart.sh
echo $(date) *autorestart* 1>&2
fi
