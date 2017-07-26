#!/bin/bash
#
# test ping response time
#
# sverre.stikbakke@ntnu.no 02.05.2016
#

cd './Dropbox' 2> '/dev/null' || \
    { echo "Missing Dropbox folder"; exit 1; }

# import ${PINGURL}
source './pingurl' || \
    { echo "Missing pingurl file"; exit 1 ;}

# import dropbox_upload function
source './dropbox.sh' || \
    { echo "Missing dropbox.sh"; exit 1; }


LOG_FOLDER='ping-test'
LOG_DROPBOX='dropbox-logs'

# Output like:
# Mon April 17 23:40:42 WEDT 2017
DATESTRING='%a %B %e %T %Z %Y'

LOG_MONTH="$(date +%Y-%m)"

LOG_WAKEUP="${LOG_MONTH}-wakeup.txt"
LOG_BASELINE="${LOG_MONTH}-baseline.txt"

DAT_WAKEUP="${LOG_MONTH}-wakeup-dat.txt"
DAT_BASELINE="${LOG_MONTH}-baseline-dat.txt"

DAT_WAKEUP_LOSS="${LOG_MONTH}-wakeup-loss.txt"
DAT_BASELINE_LOSS="${LOG_MONTH}-baseline-loss.txt"

DAT_WAKEUP_TIME="${LOG_MONTH}-wakeup-time.txt"
DAT_BASELINE_TIME="${LOG_MONTH}-baseline-time.txt"

TIME_NOW="$(date +'%a %B %e %T %Z %Y')"

if which ping | grep 'system32' > /dev/null
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
date +"${DATESTRING}" > 'wakeup_time.txt'
sleep 5
ping "${PINGOPTION}" 20 "${PINGURL}" > 'baseline.txt'
date +"${DATESTRING}" > 'baseline_time.txt'


{
  echo '================================='
  cat 'wakeup_time.txt'
  echo '================================='
  cat 'wakeup.txt'
} >> "${LOG_FOLDER}/${LOG_WAKEUP}"

{
  echo '================================='
  cat 'baseline_time.txt'
  echo '================================='
  cat 'baseline.txt'
} >> "${LOG_FOLDER}/${LOG_BASELINE}"


if [ ${PINGVERSION} -eq 32 ]
then
  # from Windows ping output
  grep 'Average' 'wakeup.txt' >> "${LOG_FOLDER}/${DAT_WAKEUP}"
  grep 'Average' 'baseline.txt' >> "${LOG_FOLDER}/${DAT_BASELINE}"
else
  # from Linux ping output
  grep rtt 'wakeup.txt' | \
    cut -c 23-99 | cut -d / -f 1-4 | cut -d m -f 1 | tr / " " >> \
    "${LOG_FOLDER}/${DAT_WAKEUP}"
  grep 'rtt' 'baseline.txt' | \
    cut -c 23-99 | cut -d / -f 1-4 | cut -d m -f 1 | tr / " " >> \
    "${LOG_FOLDER}/${DAT_BASELINE}"
fi


grep 'loss' 'wakeup.txt'  >> "${LOG_FOLDER}/${DAT_WAKEUP_LOSS}"
grep 'loss' 'baseline.txt'  >> "${LOG_FOLDER}/${DAT_BASELINE_LOSS}"

cat 'wakeup_time.txt' >> "${LOG_FOLDER}/${DAT_WAKEUP_TIME}"
cat 'baseline_time.txt' >> "${LOG_FOLDER}/${DAT_BASELINE_TIME}"


dropbox_upload "${LOG_FOLDER}" "${LOG_WAKEUP}"
dropbox_upload "${LOG_FOLDER}" "${LOG_BASELINE}"

dropbox_upload "${LOG_FOLDER}" "${DAT_WAKEUP}"
dropbox_upload "${LOG_FOLDER}" "${DAT_BASELINE}"

dropbox_upload "${LOG_FOLDER}" "${DAT_WAKEUP_LOSS}"
dropbox_upload "${LOG_FOLDER}" "${DAT_BASELINE_LOSS}"

dropbox_upload "${LOG_FOLDER}" "${DAT_WAKEUP_TIME}"
dropbox_upload "${LOG_FOLDER}" "${DAT_BASELINE_TIME}"


mkdir -p "${LOG_DROPBOX}"
mv ./*.json  ${LOG_DROPBOX} 2> '/dev/null'


exit 0
