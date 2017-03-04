#!/bin/bash
#
# move log files on Dropbox to archive folder
#
# run by cron the 1st of every month
#
# sverre.stikbakke@ntnu.no 11.02.2017
#

cd './Dropbox' 2> '/dev/null'

# import ${DROPBOX_TOKEN}
source './dropbox_token' || exit 1


LOG_DROPBOX='dropbox-logs'

YESTERDAY_YEAR="$(date --date='15 days ago' +%Y)"
YESTERDAY_MONTH="$(date --date='15 days ago' +%m)"


dropbox_mkdir () {
  local FOLDER="${1}"
  local NEW_YEAR="${2}"

  NEW_YEAR_PATH="/${FOLDER}/${NEW_YEAR}"

  curl -X POST 'https://api.dropboxapi.com/2/files/create_folder' \
  --header "Authorization: Bearer ${DROPBOX_TOKEN}" \
  --header "Content-Type: application/json" \
  --data "{\
  \"path\": \"${NEW_YEAR_PATH}\", \
  \"autorename\": false}" \
  > "${NEW_YEAR}-${FOLDER}.json" \
  2> '/dev/null'
}


dropbox_move () {
  local FOLDER="${1}"
  local FILENAME="${2}"

  FROM_PATH="/${FOLDER}/${YESTERDAY_YEAR}-${YESTERDAY_MONTH}-${FILENAME}"

  ARCHIVE_YEAR_PATH="/${FOLDER}/${YESTERDAY_YEAR}/"
  ARCHIVE_FILENAME="${YESTERDAY_YEAR}-${YESTERDAY_MONTH}-${FILENAME}"

  TO_PATH="${ARCHIVE_YEAR_PATH}${ARCHIVE_FILENAME}"

  curl -X POST 'https://api.dropboxapi.com/2/files/move' \
  --header "Authorization: Bearer ${DROPBOX_TOKEN}" \
  --header "Content-Type: application/json" \
  --data "{ \
  \"from_path\": \"${FROM_PATH}\", \
  \"to_path\": \"${TO_PATH}\", \
  \"allow_shared_folder\": true, \
  \"autorename\": false}" \
  > "$(basename ${TO_PATH} .txt).json" \
  2> '/dev/null'
}


dropbox_mkdir 'isp-ip-address' "${YESTERDAY_YEAR}"

dropbox_move  'isp-ip-address' 'ip-address.txt'
dropbox_move  'isp-ip-address' 'ip-address-time.txt'


dropbox_mkdir 'adm-url' "${YESTERDAY_YEAR}"

dropbox_move  'adm-url' 'adm-url.txt'


dropbox_mkdir 'speed-test' "${YESTERDAY_YEAR}"

dropbox_move 'speed-test' 'times.txt'
dropbox_move 'speed-test' 'speedtest.txt'
dropbox_move 'speed-test' 'ping.txt'

dropbox_move 'speed-test' 'download.txt'
dropbox_move 'speed-test' 'upload.txt'


dropbox_mkdir 'ping-test' "${YESTERDAY_YEAR}"

dropbox_move 'ping-test' 'wakeup.txt'
dropbox_move 'ping-test' 'baseline.txt'

dropbox_move 'ping-test' 'wakeup-dat.txt'
dropbox_move 'ping-test' 'baseline-dat.txt'

dropbox_move 'ping-test' 'wakeup-loss.txt'
dropbox_move 'ping-test' 'baseline-loss.txt'

dropbox_move 'ping-test' 'wakeup-time.txt'
dropbox_move 'ping-test' 'baseline-time.txt'


mkdir -p "${LOG_DROPBOX}"
mv ./*.json  ${LOG_DROPBOX} 2> '/dev/null'


exit 0
