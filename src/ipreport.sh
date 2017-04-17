#!/bin/bash
#
# log external IP address to file
#
# sverre.stikbakke@ntnu.no 02.05.2016
#

cd './Dropbox' 2> '/dev/null'

# import dropbox_upload function
source './dropbox.sh' || exit 1

# import ${ADM_PORT}
source './adm_port' || exit 1


LOG_FOLDER='isp-ip-address'
LOG_DROPBOX='dropbox-logs'
ADM_URL_FOLDER='adm-url'


LOG_IP_ADDRESS="$(date +%Y-%m-ip-address.txt)"
LOG_IP_ADDRESS_TIME="$(date +%Y-%m-ip-address-time.txt)"
LOG_IP_ADDRESS_LAST_24="$(date +%Y-%m-ip-address-last-24.txt)"
LOG_ADM_URL="$(date +%Y-%m-adm-url.txt)"


echo "--- IP-address files in subfolder ${LOG_FOLDER}"
mkdir -p "${LOG_FOLDER}"

{
  curl -s -S 'myip.dnsomatic.com/login.asp'
  echo
} >> "${LOG_FOLDER}/${LOG_IP_ADDRESS}"

date +'%a %B %e %T %Z %Y' >> "${LOG_FOLDER}/${LOG_IP_ADDRESS_TIME}"

sleep 15

paste <(curl -s http://ipinfo.io/ip) <(curl -s http://ipinfo.io/org) \
  <(date +'%a %B %e %T %Z %Y') >> 'ipinfo.txt'

tail -n 24 < 'ipinfo.txt' > "${LOG_FOLDER}/${LOG_IP_ADDRESS_LAST_24}"

# Delete all but 10 last days ipinfos
tail -n 240 < 'ipinfo.txt' > tmpfile
cat tmpfile > 'ipinfo.txt'
rm tmpfile


echo "--- Admin login url in subfolder ${ADM_URL_FOLDER}"
mkdir -p "${ADM_URL_FOLDER}"

PROTOCOL='https://'
CURRENT_IP=$(tail -n 1 < "${LOG_FOLDER}/${LOG_IP_ADDRESS}")

echo "${PROTOCOL}${CURRENT_IP}:${ADM_PORT}" >> \
  "${ADM_URL_FOLDER}/${LOG_ADM_URL}"


dropbox_upload "${LOG_FOLDER}" "${LOG_IP_ADDRESS}"
dropbox_upload "${LOG_FOLDER}" "${LOG_IP_ADDRESS_TIME}"
dropbox_upload "${LOG_FOLDER}" "${LOG_IP_ADDRESS_LAST_24}"

dropbox_upload "${ADM_URL_FOLDER}" "${LOG_ADM_URL}"


mkdir -p "${LOG_DROPBOX}"
mv ./*.json  "${LOG_DROPBOX}" 2> '/dev/null'


exit 0
