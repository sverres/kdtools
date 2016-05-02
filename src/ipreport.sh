#!/bin/bash
#
# log external IP address to file
#
# sverre.stikbakke@ntnu.no 02.05.2016
#

cd ./Dropbox 2>/dev/null


LOG_FOLDER='isp-ip-address'
LOG_IP_ADDRESS="$(date +${LOG_FOLDER}/%Y-%m-ip-address.txt)"
LOG_IP_ADDRESS_TIME="$(date +${LOG_FOLDER}/%Y-%m-ip-address-time.txt)"


echo "--- IP-address files in subfolder ${LOG_FOLDER}"
mkdir -p "${LOG_FOLDER}"


echo "$(curl -s -S myip.dnsomatic.com)" >>  "${LOG_IP_ADDRESS}"
echo "$(date +'%a %B %e %T %Z %Y')" >> "${LOG_IP_ADDRESS_TIME}"
