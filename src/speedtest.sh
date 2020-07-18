#!/bin/bash
#
# test download speed using speedtest
# from https://www.speedtest.net/apps/cli
#
# sverre.stikbakke@ntnu.no 22.10.2016
#

cd './Dropbox' 2> '/dev/null' || \
    { echo "Missing Dropbox folder"; exit 1; }

# import dropbox_upload function
source './dropbox.sh' 2> '/dev/null' || \
    { echo "Missing dropbox.sh"; exit 1; }

LOG_FOLDER='speed-test'
JOB_LOG_FOLDER='dropbox-logs'

YEAR_MONTH="$(date +%Y-%m)"

LOG_TIMES="${YEAR_MONTH}-times.txt"
LOG_SPEEDTEST="${YEAR_MONTH}-speedtest.txt"
LOG_DOWNLOAD="${YEAR_MONTH}-download.txt"
LOG_UPLOAD="${YEAR_MONTH}-upload.txt"

SPEEDTEST_TMP='speedtest.txt'

TIME_NOW="$(date +'%a %B %e %T %Z %Y')"


echo "--- Speedtest running, started at ${TIME_NOW}"
mkdir -p "${LOG_FOLDER}"

if [ -e ./speedtest ]; then
    {
        echo ''
        echo '=================================='
        echo "${TIME_NOW}"
        echo '=================================='
        ./speedtest
    } > "${SPEEDTEST_TMP}"
else
    { echo "Missing speedtest"; exit 1; }
fi

echo "${TIME_NOW}" >> "${LOG_FOLDER}/${LOG_TIMES}"

cat "${SPEEDTEST_TMP}" >> "${LOG_FOLDER}/${LOG_SPEEDTEST}"

grep 'Download' "${SPEEDTEST_TMP}" | awk -F' ' '{print $3}' >> \
     "${LOG_FOLDER}/${LOG_DOWNLOAD}"

grep 'Upload' "${SPEEDTEST_TMP}" | awk -F' ' '{print $3}' >> \
     "${LOG_FOLDER}/${LOG_UPLOAD}"


dropbox_upload "${LOG_FOLDER}" "${LOG_TIMES}"
dropbox_upload "${LOG_FOLDER}" "${LOG_SPEEDTEST}"
dropbox_upload "${LOG_FOLDER}" "${LOG_DOWNLOAD}"
dropbox_upload "${LOG_FOLDER}" "${LOG_UPLOAD}"


mkdir -p "${JOB_LOG_FOLDER}"
mv ./*.json  "${JOB_LOG_FOLDER}" 2> '/dev/null'


exit 0
