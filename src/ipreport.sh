#!/bin/bash
#
# log external IP address to file
#
# sverre.stikbakke@ntnu.no 02.05.2016
#

cd './Dropbox' 2> '/dev/null'


LOG_FOLDER='isp-ip-address'
LOG_IP_ADDRESS="$(date +%Y-%m-ip-address.txt)"
LOG_IP_ADDRESS_TIME="$(date +%Y-%m-ip-address-time.txt)"

source './dropbox.sh'

echo "--- IP-address files in subfolder ${LOG_FOLDER}"
mkdir -p "${LOG_FOLDER}"


echo "$(curl -s -S myip.dnsomatic.com/login.asp)" >> \
  "${LOG_FOLDER}"/"${LOG_IP_ADDRESS}"
echo "$(date +'%a %B %e %T %Z %Y')" >> \
  "${LOG_FOLDER}"/"${LOG_IP_ADDRESS_TIME}"


dropbox_upload "${LOG_IP_ADDRESS}"
dropbox_upload "${LOG_IP_ADDRESS_TIME}"
