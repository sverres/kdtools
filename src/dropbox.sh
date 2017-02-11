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
