#!/bin/bash
#
# test ping response time
#
# sverre.stikbakke@ntnu.no 02.05.2016
#

cd './Dropbox' 2> '/dev/null' || \
    { echo "Missing Dropbox folder"; exit 1; }

# import ${PINGURL}
source './pingurl' 2> '/dev/null' || \
    { echo "Missing pingurl file"; exit 1 ; }

# import dropbox_upload function
source './dropbox.sh' 2> '/dev/null' || \
    { echo "Missing dropbox.sh"; exit 1; }


LOG_FOLDER='ping-test'
JOB_LOG_FOLDER='dropbox-logs'

# Output like:
# Mon April 17 23:40:42 WEDT 2017
DATESTRING='%a %B %e %T %Z %Y'

YEAR_MONTH="$(date +%Y-%m)"

LOG_WAKEUP="${YEAR_MONTH}-wakeup.txt"
LOG_BASELINE="${YEAR_MONTH}-baseline.txt"

DAT_WAKEUP="${YEAR_MONTH}-wakeup-dat.txt"
DAT_BASELINE="${YEAR_MONTH}-baseline-dat.txt"

DAT_WAKEUP_LOSS="${YEAR_MONTH}-wakeup-loss.txt"
DAT_BASELINE_LOSS="${YEAR_MONTH}-baseline-loss.txt"

DAT_WAKEUP_TIME="${YEAR_MONTH}-wakeup-time.txt"
DAT_BASELINE_TIME="${YEAR_MONTH}-baseline-time.txt"

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


if [ ${PINGVERSION} -eq 32 ]; then
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


mkdir -p "${JOB_LOG_FOLDER}"
mv ./*.json  ${JOB_LOG_FOLDER} 2> '/dev/null'


exit 0
