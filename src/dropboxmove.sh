#!/bin/bash
#
# move log files on Dropbox to archive folder
#
# run by cron the 1st of every month
# (or within first 14 days of each new month)
#
# sverre.stikbakke@ntnu.no 11.02.2017
#

cd './Dropbox' 2> '/dev/null' || \
    { echo "Missing Dropbox folder"; exit 1; }

# import ${DROPBOX_TOKEN}
source './dropbox_token' 2> '/dev/null' || \
    { echo "Missing dropbox_token file"; exit 1; }

JOB_LOG_FOLDER='dropbox-logs'

YESTERDAY_YEAR="$(date --date='15 days ago' +%Y)"
YESTERDAY_MONTH="$(date --date='15 days ago' +%m)"


dropbox_mkdir () {
  local FOLDER="${1}"
  local YEAR="${2}"
  
  local ARCHIVE_PATH="/${FOLDER}/${YEAR}"
  local JOB_LOG="${YEAR}-${FOLDER}.json"

  curl -X POST 'https://api.dropboxapi.com/2/files/create_folder' \
  --header "Authorization: Bearer ${DROPBOX_TOKEN}" \
  --header "Content-Type: application/json" \
  --data "{\
  \"path\": \"${ARCHIVE_PATH}\", \
  \"autorename\": false}" \
  > "${JOB_LOG}" \
  2> '/dev/null'
}


dropbox_move () {
  local FOLDER="${1}"
  local FILENAME="${2}"  # truncated - without date part

  local FROM_PATH="/${FOLDER}/${YESTERDAY_YEAR}-${YESTERDAY_MONTH}-${FILENAME}"

  local ARCHIVE_YEAR_PATH="/${FOLDER}/${YESTERDAY_YEAR}/"
  local ARCHIVE_FILENAME="${YESTERDAY_YEAR}-${YESTERDAY_MONTH}-${FILENAME}"

  local TO_PATH="${ARCHIVE_YEAR_PATH}${ARCHIVE_FILENAME}"

  local JOB_LOG="$(basename ${TO_PATH} .txt).json"

  curl -X POST 'https://api.dropboxapi.com/2/files/move' \
  --header "Authorization: Bearer ${DROPBOX_TOKEN}" \
  --header "Content-Type: application/json" \
  --data "{ \
  \"from_path\": \"${FROM_PATH}\", \
  \"to_path\": \"${TO_PATH}\", \
  \"allow_shared_folder\": true, \
  \"autorename\": false}" \
  > "${JOB_LOG}" \
  2> '/dev/null'
}


dropbox_mkdir 'isp-ip-address' "${YESTERDAY_YEAR}"

dropbox_move  'isp-ip-address' 'ip-address.txt'
dropbox_move  'isp-ip-address' 'ip-address-time.txt'
dropbox_move  'isp-ip-address' 'ip-address-last-24.txt'


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


mkdir -p "${JOB_LOG_FOLDER}"
mv ./*.json  ${JOB_LOG_FOLDER} 2> '/dev/null'


exit 0
