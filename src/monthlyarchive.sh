#!/bin/bash
#
# move log files to archive folder
#
# run by cron the 1st of every month
#
# sverre.stikbakke@ntnu.no 11.02.2017
#

cd './Dropbox' 2> '/dev/null'

YESTERDAY_YEAR=$(date --date='15 days ago' +%Y)
YESTERDAY_MONTH=$(date --date='15 days ago' +%m)

move_to_archive () {
  LOG_FOLDER="${1}"

  mkdir -p "${LOG_FOLDER}"
  cd "${LOG_FOLDER}"

  mkdir -p "${YESTERDAY_YEAR}"

  # sample mv command: mv 2017-01-ip-adress-time.txt 2017
  mv "${YESTERDAY_YEAR}"-"${YESTERDAY_MONTH}"-*.txt "${YESTERDAY_YEAR}" \
     2> '/dev/null'

  cd '..'
}

move_to_archive 'isp-ip-address'
move_to_archive 'ping-test'
move_to_archive 'speed-test'

mv *.json 'dropbox-logs' 2> '/dev/null'
