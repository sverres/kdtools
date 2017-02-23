#!/bin/bash
#
# upload file to Dropbox
#
# sverre.stikbakke@ntnu.no 03.05.2016
#

# import ${DROPBOX_TOKEN}
source './dropbox_token'


dropbox_upload () {
  UPLOAD_FILE="${1}"

  curl -X POST  'https://content.dropboxapi.com/2/files/upload' \
  --header "Authorization: Bearer ${DROPBOX_TOKEN}"\
  --header "Dropbox-API-Arg: {\
    \"path\": \"/${LOG_FOLDER}/${UPLOAD_FILE}\",\
    \"mode\": \"overwrite\",\
    \"autorename\": false,\
    \"mute\": true}"\
  --header "Content-Type: application/octet-stream"\
  --data-binary @"${LOG_FOLDER}/${UPLOAD_FILE}"\
  > "$(basename ${UPLOAD_FILE} .txt).json"\
  2> '/dev/null'
}
