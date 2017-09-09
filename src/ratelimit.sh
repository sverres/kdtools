#!/bin/bash
#
# test download speed using wget
#
# sverre.stikbakke@ntnu.no 07.09.2017
#

cd './Dropbox' 2> '/dev/null' || \
    { echo "Missing Dropbox folder"; exit 1; }

# import dropbox_upload function
source './dropbox.sh' 2> '/dev/null' || \
    { echo "Missing dropbox.sh"; exit 1; }

LOG_FOLDER='speed-test'
JOB_LOG_FOLDER='dropbox-logs'

DOWNLOAD_URL='http://sverres.net/dsl/'
LARGE_FILE='43mb.iso'
MEDIUM_FILE='9124kb.zip'

DOWNLOAD_FILE="${MEDIUM_FILE}"
RATE_IN_BYTES='500k'

YEAR_MONTH="$(date +%Y-%m)"

LOG_RATELIMIT="${YEAR_MONTH}-ratelimit.txt"

TIME_NOW="$(date +'%a %B %e %T %Z %Y')"


mkdir -p "${LOG_FOLDER}"

echo "--- Ratelimited speedtest running, started at ${TIME_NOW}"

wget \
  --output-file=ratelimit.txt \
  --limit-rate="${RATE_IN_BYTES}" \
  --report-speed=bits \
  "${DOWNLOAD_URL}${DOWNLOAD_FILE}"

grep 'saved' ratelimit.txt >> "${LOG_FOLDER}/${LOG_RATELIMIT}"

rm "${DOWNLOAD_FILE}" 2> '/dev/null'

dropbox_upload "${LOG_FOLDER}" "${LOG_RATELIMIT}"


mkdir -p "${JOB_LOG_FOLDER}"
mv ./*.json  "${JOB_LOG_FOLDER}" 2> '/dev/null'


exit 0
