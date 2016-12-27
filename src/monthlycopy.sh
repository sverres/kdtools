#!/bin/bash
#
# copy log files to archive folder
#
# run by cron the 1st of every month
#
# sverre.stikbakke@ntnu.no 27.12.2016
#

cd ./Dropbox 2>/dev/null

LOG_FOLDERS='isp-ip-address ping-test speed-test'
YESTERDAY_YEAR=$(date --date='1 days ago' +%Y)
YESTERDAY_MONTH=$(date --date='28 days ago' +%m)

source ./dropbox.sh

move_to_archive () {
    LOG_FOLDER="${1}"

    mkdir -p "${LOG_FOLDER}"

    cd "${LOG_FOLDER}"

    mkdir -p "${YESTERDAY_YEAR}"

    echo "abc" >> $(date --date='28 days ago' +%Y-%m-)dill.txt

    # sample command: mv 2016-10-ip-adress-time-txt 2016
    mv  "${YESTERDAY_YEAR}-${YESTERDAY_MONTH}-"* "${YESTERDAY_YEAR}"

    cd ..
}

for FOLDER in $LOG_FOLDERS; do
    move_to_archive "${FOLDER}"
done
