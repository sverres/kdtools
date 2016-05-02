#!/bin/bash
#
# test ping response time
#
# sverre.stikbakke@ntnu.no 02.05.2016
#

cd ./Dropbox 2>/dev/null

PINGURL='myhost.com'

LOG_UIO_WAKEUP="$(date +%Y-%m-uio-wakeup.txt)"
LOG_UIO_BASELINE="$(date +%Y-%m-uio-baseline.txt)"

DAT_UIO_WAKEUP="$(date +%Y-%m-uio-wakeup-dat.txt)"
DAT_UIO_BASELINE="$(date +%Y-%m-uio-baseline-dat.txt)"

DAT_UIO_WAKEUP_LOSS="$(date +%Y-%m-uio-wakeup-loss.txt)"
DAT_UIO_BASELINE_LOSS="$(date +%Y-%m-uio-baseline-loss.txt)"

DAT_UIO_WAKEUP_TIME="$(date +%Y-%m-uio-wakeup-time.txt)"
DAT_UIO_BASELINE_TIME="$(date +%Y-%m-uio-baseline-time.txt)"

TIME_NOW="$(date +'%a %B %e %T %Z %Y')"

echo "--- Pingtest running, started at ${TIME_NOW}"

which ping |grep system32 > /dev/null
if [ ${?} -eq 0 ]  # grep return code: match = 0, not found = 1
then
  # echo windows
  PINGVERSION=32
  PINGOPTION='-n'
else
  # echo linux
  PINGVERSION=1
  PINGOPTION='-c'
fi

ping "${PINGOPTION}" 3 "${PINGURL}" > uio_wakeup.txt
echo "$(date +'%a %B %e %T %Z %Y')" > uio_wakeup_time.txt
sleep 2
ping "${PINGOPTION}" 20 "${PINGURL}" > uio_baseline.txt
echo "$(date +'%a %B %e %T %Z %Y')" > uio_baseline_time.txt


echo '==============================' >> "${LOG_UIO_WAKEUP}"
cat uio_wakeup_time.txt >> "${LOG_UIO_WAKEUP}"
echo '==============================' >> "${LOG_UIO_WAKEUP}"
cat uio_wakeup.txt >> "${LOG_UIO_WAKEUP}"


echo '==============================' >> "${LOG_UIO_BASELINE}"
cat uio_baseline_time.txt >> "${LOG_UIO_BASELINE}"
echo '==============================' >> "${LOG_UIO_BASELINE}"
cat uio_baseline.txt >> "${LOG_UIO_BASELINE}"


if [ ${PINGVERSION} -eq 32 ]
then
  # from Windows ping output
  grep Average uio_wakeup.txt >> "${DAT_UIO_WAKEUP}"
  grep Average uio_baseline.txt >> "${DAT_UIO_BASELINE}"
else
  # from Linux ping output
  grep rtt uio_wakeup.txt |cut -c 23-99|cut -d / -f 1-4|cut -d m -f 1|\
    tr / " " >> "${DAT_UIO_WAKEUP}"
  grep rtt uio_baseline.txt |cut -c 23-99|cut -d / -f 1-4|cut -d m -f 1|\
    tr / " " >> "${DAT_UIO_BASELINE}"
fi


grep loss uio_wakeup.txt  >> "${DAT_UIO_WAKEUP_LOSS}"
grep loss uio_baseline.txt  >> "${DAT_UIO_BASELINE_LOSS}"


cat uio_wakeup_time.txt >> "${DAT_UIO_WAKEUP_TIME}"
cat uio_baseline_time.txt >> "${DAT_UIO_BASELINE_TIME}"
