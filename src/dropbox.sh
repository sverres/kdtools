#!/bin/bash
#
# upload file to Dropbox
#
# sverre.stikbakke@ntnu.no 03.05.2016
#

DROPBOX_URL='https://content.dropboxapi.com/1/files_put/auto'
DROPBOX_TOKEN="your_dropbox_api_token"

dropbox_upload () {
  UPLOAD_FILE="${1}"

  curl -X PUT\
  "${DROPBOX_URL}/${LOG_FOLDER}/${UPLOAD_FILE}"\
  --data-binary @"${LOG_FOLDER}/${UPLOAD_FILE}"\
  -H 'Content-Type: text/plain'\
  -H "Authorization: Bearer ${DROPBOX_TOKEN}"\
  >"$(basename ${UPLOAD_FILE} .txt).json"\
  2>/dev/null
}
