#!/bin/bash
#
# upload file to Dropbox
#
# sverre.stikbakke@ntnu.no 03.05.2016
#

DROPBOX_URL_API_V2='https://content.dropboxapi.com/2/files/upload'
DROPBOX_TOKEN="your_dropbox_api_token"

dropbox_upload () {
  UPLOAD_FILE="${1}"

  curl -X POST  "${DROPBOX_URL_API_V2}"\
  --header "Authorization: Bearer ${DROPBOX_TOKEN}"\
  --header "Dropbox-API-Arg: {\
    \"path\": \"/${LOG_FOLDER}/${UPLOAD_FILE}\",\
    \"mode\": \"overwrite\",\
    \"autorename\": false,\
    \"mute\": true}"\
  --header "Content-Type: application/octet-stream"\
  --data-binary @"${LOG_FOLDER}/${UPLOAD_FILE}"\
  >"$(basename ${UPLOAD_FILE} .txt).json"\
  2>/dev/null
}

dropbox_move () {
  FROM_PATH="${1}"
  TO_PATH="${2}"

  for logfile in $FROM_PATH; do
    curl -X POST https://api.dropboxapi.com/2/files/move \
      --header "Authorization: Bearer ${DROPBOX_TOKEN}"\
      --header "Content-Type: application/json" \
      --data "{\
        \"from_path\": \"/${logfile}\",\
        \"to_path\": \"/${TO_PATH}\",\
        \"allow_shared_folder\": false,\
        \"autorename\": false}"# \
        # >"$(basename ${FROM_PATH}).json" #\
        # 2>/dev/null
      done
}
