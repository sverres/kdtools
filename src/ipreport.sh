#!/bin/bash
#
# log external IP address to files
# - as plain IP address
# - as IP and ISP info - last 24h
# - as url for admin access to router
# 
# sverre.stikbakke@ntnu.no 02.05.2016
#

cd './Dropbox' 2> '/dev/null' || \
    { echo "Missing Dropbox folder"; exit 1; }

# import dropbox_upload function
source './dropbox.sh' 2> '/dev/null' || \
    { echo "Missing dropbox.sh"; exit 1; }

# import ${ADM_PORT}
source './adm_port' 2> '/dev/null' || \
    { echo "Missing adm_port file"; exit 1; }


LOG_FOLDER='isp-ip-address'
JOB_LOG_FOLDER='dropbox-logs'
ADM_URL_FOLDER='adm-url'

LOG_MONTH="$(date +%Y-%m)"

LOG_IP_ADDRESS="${LOG_MONTH}-ip-address.txt"
LOG_IP_ADDRESS_TIME="${LOG_MONTH}-ip-address-time.txt"
LOG_IP_ADDRESS_LAST_24="${LOG_MONTH}-ip-address-last-24.txt"
LOG_ADM_URL="${LOG_MONTH}-adm-url.txt"


echo "--- IP-address files in subfolder ${LOG_FOLDER}"
mkdir -p "${LOG_FOLDER}"

{
  curl -s -S 'myip.dnsomatic.com/login.asp'
  echo
} >> "${LOG_FOLDER}/${LOG_IP_ADDRESS}"

# Output like:
# Mon April 17 23:06:42 WEDT 2017
date +'%a %B %e %T %Z %Y' >> "${LOG_FOLDER}/${LOG_IP_ADDRESS_TIME}"

sleep 15

# Output like:
# 81.191.94.60    AS2116 Broadnet AS      Mon April 17 23:10:43 WEDT 2017
paste <(curl -s http://ipinfo.io/ip) <(curl -s http://ipinfo.io/org) \
  <(date +'%a %B %e %T %Z %Y') >> 'ipinfo.txt'

tail -n 24 < 'ipinfo.txt' > "${LOG_FOLDER}/${LOG_IP_ADDRESS_LAST_24}"

# Delete all but 10 last days ipinfo (no Dropbox upload of this file)
tail -n 240 < 'ipinfo.txt' > tmpfile
cat tmpfile > 'ipinfo.txt'
rm tmpfile


echo "--- Admin login url in subfolder ${ADM_URL_FOLDER}"
mkdir -p "${ADM_URL_FOLDER}"

PROTOCOL='https://'
CURRENT_IP=$(tail -n 1 < "${LOG_FOLDER}/${LOG_IP_ADDRESS}")

# Output like:
# https://46.66.184.43:55555
echo "${PROTOCOL}${CURRENT_IP}:${ADM_PORT}" >> \
  "${ADM_URL_FOLDER}/${LOG_ADM_URL}"


dropbox_upload "${LOG_FOLDER}" "${LOG_IP_ADDRESS}"
dropbox_upload "${LOG_FOLDER}" "${LOG_IP_ADDRESS_TIME}"
dropbox_upload "${LOG_FOLDER}" "${LOG_IP_ADDRESS_LAST_24}"

dropbox_upload "${ADM_URL_FOLDER}" "${LOG_ADM_URL}"


mkdir -p "${JOB_LOG_FOLDER}"
mv ./*.json  "${JOB_LOG_FOLDER}" 2> '/dev/null'


exit 0
