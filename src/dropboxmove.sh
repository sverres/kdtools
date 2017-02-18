#!/bin/bash
#
# copy log files to archive folder
#
# run by cron the 1st of every month
#
# sverre.stikbakke@ntnu.no 11.02.2016
#

cd "./Dropbox" 2> '/dev/null'


# import ${DROPBOX_TOKEN}
source "./dropbox_token"

YESTERDAY_YEAR="$(date --date='15 days ago' +%Y)"
YESTERDAY_MONTH="$(date --date='1 days ago' +%m)"


dropbox_mkdir () {
  FOLDER="${1}"
  NEW_YEAR="${2}"

  NEW_YEAR_PATH="/${FOLDER}/${NEW_YEAR}"

  curl -X POST 'https://api.dropboxapi.com/2/files/create_folder' \
  --header "Authorization: Bearer ${DROPBOX_TOKEN}" \
  --header "Content-Type: application/json" \
  --data "{\
  \"path\": \"${NEW_YEAR_PATH}\",\
  \"autorename\": false}"\
  > "${FOLDER}/${NEW_YEAR}.json"\
  2> '/dev/null'
}


dropbox_move () {
  FOLDER="${1}"
  FILENAME="${2}"

  FROM_PATH="/${FOLDER}/${YESTERDAY_YEAR}-${YESTERDAY_MONTH}-${FILENAME}"
  TO_PATH="/${FOLDER}/${YESTERDAY_YEAR}/${YESTERDAY_YEAR}-${YESTERDAY_MONTH}-${FILENAME}"

  curl -X POST 'https://api.dropboxapi.com/2/files/move' \
  --header "Authorization: Bearer ${DROPBOX_TOKEN}"\
  --header "Content-Type: application/json" \
  --data "{\
  \"from_path\": \"${FROM_PATH}\",\
  \"to_path\": \"${TO_PATH}\",\
  \"allow_shared_folder\": true,\
  \"autorename\": true}"\
  > "$(basename ${TO_PATH} .txt).json"\
  2> '/dev/null'
}


dropbox_mkdir "isp-ip-address" "$YESTERDAY_YEAR"

dropbox_move  "isp-ip-address" "ip-address.txt"
dropbox_move  "isp-ip-address" "ip-address-time.txt"

dropbox_mkdir "speed-test" "$YESTERDAY_YEAR"

dropbox_move "speed-test" "times.txt"
dropbox_move "speed-test" "speedtest.txt"
dropbox_move "speed-test" "ping.txt"

dropbox_move "speed-test" "download.txt"
dropbox_move "speed-test" "upload.txt"

dropbox_mkdir "ping-test" "$YESTERDAY_YEAR"

dropbox_move "ping-test" "uio-wakeup.txt"
dropbox_move "ping-test" "uio-baseline.txt"

dropbox_move "ping-test" "uio-wakeup-dat.txt"
dropbox_move "ping-test" "uio-baseline-dat.txt"

dropbox_move "ping-test" "uio-wakeup-loss.txt"
dropbox_move "ping-test" "uio-baseline-loss.txt"

dropbox_move "ping-test" "uio-wakeup-time.txt"
dropbox_move "ping-test" "uio-baseline-time.txt"


mv *.json 'dropbox-logs' 2> '/dev/null'
