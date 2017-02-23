#!/bin/bash
#
# test download speed using pyspeedtest.py
# from https://github.com/fopina/pyspeedtest
#
# sverre.stikbakke@ntnu.no 22.10.2016
#

cd './Dropbox' 2> '/dev/null'

LOG_FOLDER='speed-test'

LOG_TIMES="$(date +'%Y-%m-times.txt')"
LOG_SPEEDTEST="$(date +'%Y-%m-speedtest.txt')"
LOG_PING="$(date +'%Y-%m-ping.txt')"
LOG_DOWNLOAD="$(date +'%Y-%m-download.txt')"
LOG_UPLOAD="$(date +'%Y-%m-upload.txt')"


SPEEDTEST_TMP='speedtest.txt'

TIME_NOW="$(date +'%a %B %e %T %Z %Y')"

source ./dropbox.sh

echo "--- Speedtest running, started at ${TIME_NOW}"
mkdir -p "${LOG_FOLDER}"

echo '' > "${SPEEDTEST_TMP}"
echo '==================================' >> "${SPEEDTEST_TMP}"
echo "${TIME_NOW}" >> "${SPEEDTEST_TMP}"
echo '==================================' >> "${SPEEDTEST_TMP}"

./pyspeedtest.py  >> "${SPEEDTEST_TMP}"

echo "${TIME_NOW}" >> "${LOG_FOLDER}/${LOG_TIMES}"
cat "${SPEEDTEST_TMP}" >> "${LOG_FOLDER}/${LOG_SPEEDTEST}"
grep Ping "${SPEEDTEST_TMP}" |awk -F' ' '{print $2 "\t" $3}' >> \
     "${LOG_FOLDER}/${LOG_PING}"
grep Download "${SPEEDTEST_TMP}" |awk -F' ' '{print $3 "\t" $4}' >> \
     "${LOG_FOLDER}/${LOG_DOWNLOAD}"
grep Upload "${SPEEDTEST_TMP}" |awk -F' ' '{print $3 "\t" $4}'>> \
     "${LOG_FOLDER}/${LOG_UPLOAD}"

dropbox_upload "${LOG_TIMES}"
dropbox_upload "${LOG_SPEEDTEST}"
dropbox_upload "${LOG_PING}"
dropbox_upload "${LOG_DOWNLOAD}"
dropbox_upload "${LOG_UPLOAD}"
