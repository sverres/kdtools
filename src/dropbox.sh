#!/bin/bash
#
# upload file to folder on Dropbox
# using Dropbox API v2
#
# sverre.stikbakke@ntnu.no 03.05.2016
#

# import ${DROPBOX_TOKEN}
source './dropbox_token'  || \
    { echo "Missing dropbox_token file"; exit 1; }


dropbox_upload () {
  local FOLDER="${1}"
  local FILE="${2}"

  local JOB_LOG="$(basename ${FILE} .txt).json"

  curl -X POST  'https://content.dropboxapi.com/2/files/upload' \
  --header "Authorization: Bearer ${DROPBOX_TOKEN}" \
  --header "Dropbox-API-Arg: { \
    \"path\": \"/${FOLDER}/${FILE}\", \
    \"mode\": \"overwrite\", \
    \"autorename\": false, \
    \"mute\": true}" \
  --header "Content-Type: application/octet-stream" \
  --data-binary @"${FOLDER}/${FILE}" \
  > "${JOB_LOG}" \
  2> '/dev/null'
}
