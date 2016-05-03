#!/bin/bash
#
# test download speed using wget
#
# sverre.stikbakke@ntnu.no 02.05.2016
#

cd ./Dropbox 2>/dev/null

DOWNLOAD_URL='http://myhost.com'
DOWNLOAD_FILE='my10MBfile.zip'
LOG_FOLDER='speed-test'

LOG_TIMES="$(date +'%Y-%m-times.txt')"
LOG_SPEEDTEST="$(date +'%Y-%m-speedtest.txt')"
LOG_DOWNLOAD="$(date +'%Y-%m-download.txt')"

SPEEDTEST_TMP='speedtest.txt'

TIME_NOW="$(date +'%a %B %e %T %Z %Y')"

source ./dropbox.sh

echo "--- Speedtest running, started at ${TIME_NOW}"
mkdir -p "${LOG_FOLDER}"

echo '' > "${SPEEDTEST_TMP}"
echo '==============================' >> "${SPEEDTEST_TMP}"
echo "${TIME_NOW}" >> "${SPEEDTEST_TMP}"
echo '==============================' >> "${SPEEDTEST_TMP}"

wget  -a "${SPEEDTEST_TMP}" "${DOWNLOAD_URL}/${DOWNLOAD_FILE}"
rm "${DOWNLOAD_FILE}"

echo "${TIME_NOW}" >> "${LOG_FOLDER}/${LOG_TIMES}"
cat "${SPEEDTEST_TMP}" >> "${LOG_FOLDER}/${LOG_SPEEDTEST}"
grep saved "${SPEEDTEST_TMP}" >> "${LOG_FOLDER}/${LOG_DOWNLOAD}"

dropbox_upload "${LOG_TIMES}"
dropbox_upload "${LOG_SPEEDTEST}"
dropbox_upload "${LOG_DOWNLOAD}"
