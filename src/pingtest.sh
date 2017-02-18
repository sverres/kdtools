#!/bin/bash
#
# test ping response time
#
# sverre.stikbakke@ntnu.no 02.05.2016
#

cd "./Dropbox" 2> '/dev/null'


# import ${PINGURL}
source "./pingurl"

LOG_FOLDER='ping-test'

LOG_WAKEUP="$(date +%Y-%m-wakeup.txt)"
LOG_BASELINE="$(date +%Y-%m-baseline.txt)"

DAT_WAKEUP="$(date +%Y-%m-wakeup-dat.txt)"
DAT_BASELINE="$(date +%Y-%m-baseline-dat.txt)"

DAT_WAKEUP_LOSS="$(date +%Y-%m-wakeup-loss.txt)"
DAT_BASELINE_LOSS="$(date +%Y-%m-baseline-loss.txt)"

DAT_WAKEUP_TIME="$(date +%Y-%m-wakeup-time.txt)"
DAT_BASELINE_TIME="$(date +%Y-%m-baseline-time.txt)"

TIME_NOW="$(date +'%a %B %e %T %Z %Y')"

source "./dropbox.sh"

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

echo "--- Pingtest running, started at ${TIME_NOW}"
mkdir -p "${LOG_FOLDER}"

ping "${PINGOPTION}" 3 "${PINGURL}" > 'wakeup.txt'
echo "$(date +'%a %B %e %T %Z %Y')" > 'wakeup_time.txt'
sleep 2
ping "${PINGOPTION}" 20 "${PINGURL}" > 'baseline.txt'
echo "$(date +'%a %B %e %T %Z %Y')" > 'baseline_time.txt'


echo '=================================' >> \
  "${LOG_FOLDER}/${LOG_WAKEUP}"
cat 'wakeup_time.txt' >> \
  "${LOG_FOLDER}/${LOG_WAKEUP}"
echo '=================================' >> \
  "${LOG_FOLDER}/${LOG_WAKEUP}"
cat 'wakeup.txt' >> \
  "${LOG_FOLDER}/${LOG_WAKEUP}"


  echo '=================================' >> \
    "${LOG_FOLDER}/${LOG_BASELINE}"
  cat 'baseline_time.txt' >> \
    "${LOG_FOLDER}/${LOG_BASELINE}"
  echo '=================================' >> \
    "${LOG_FOLDER}/${LOG_BASELINE}"
  cat 'baseline.txt' >> \
    "${LOG_FOLDER}/${LOG_BASELINE}"


if [ ${PINGVERSION} -eq 32 ]
then
  # from Windows ping output
  grep 'Average' 'wakeup.txt' >> "${LOG_FOLDER}/${DAT_WAKEUP}"
  grep 'Average' 'baseline.txt' >> "${LOG_FOLDER}/${DAT_BASELINE}"
else
  # from Linux ping output
  grep rtt 'wakeup.txt' |\
    cut -c 23-99|cut -d / -f 1-4|cut -d m -f 1|tr / " " >> \
    "${LOG_FOLDER}/${DAT_WAKEUP}"
  grep 'rtt' 'baseline.txt' |\
    cut -c 23-99|cut -d / -f 1-4|cut -d m -f 1|tr / " " >> \
    "${LOG_FOLDER}/${DAT_BASELINE}"
fi


grep 'loss' 'wakeup.txt'  >> "${LOG_FOLDER}/${DAT_WAKEUP_LOSS}"
grep 'loss' 'baseline.txt'  >> "${LOG_FOLDER}/${DAT_BASELINE_LOSS}"


cat 'wakeup_time.txt' >> "${LOG_FOLDER}/${DAT_WAKEUP_TIME}"
cat 'baseline_time.txt' >> "${LOG_FOLDER}/${DAT_BASELINE_TIME}"

dropbox_upload "${LOG_WAKEUP}"
dropbox_upload "${LOG_BASELINE}"

dropbox_upload "${DAT_WAKEUP}"
dropbox_upload "${DAT_BASELINE}"

dropbox_upload "${DAT_WAKEUP_LOSS}"
dropbox_upload "${DAT_BASELINE_LOSS}"

dropbox_upload "${DAT_WAKEUP_TIME}"
dropbox_upload "${DAT_BASELINE_TIME}"
