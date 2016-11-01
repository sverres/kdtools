#!/bin/bash
#
# copy  log files to archive folder
#
# run by cron the 1st on evry month
#
# sverre.stikbakke@ntnu.no 01.11.2016
#

cd ./Dropbox 2>/dev/null

LOG_FOLDER='isp-ip-address'
YESTERDAY_YEAR=$(date --date='1 days ago' +%Y)
YESTERDAY_MONTH=$(date --date='1 days ago' +%m)

source ./dropbox.sh

mkdir -p "${LOG_FOLDER}"

cd "${LOG_FOLDER}"

mkdir -p "${YESTERDAY_YEAR}"

echo "abc" >> $(date --date='1 days ago' +%Y-%m-)dill.txt

mv  "${YESTERDAY_YEAR}-${YESTERDAY_MONTH}-"* "${YESTERDAY_YEAR}"
