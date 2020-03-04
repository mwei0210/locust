#!/usr/bin/env sh

#if [ -z "${TARGET_URL}" ]; then
#  echo "ERROR: TARGET_URL not configured" >&2
#  exit 1
#fi

LOCUST_MODE="${LOCUST_MODE:=standalone}"
_LOCUST_OPTS="-f ${LOCUSTFILE_PATH:-/locust/locustfile.py}"

if [ "${LOCUST_MODE}" = "MASTER" ]; then
    _LOCUST_OPTS="${_LOCUST_OPTS} --master"
elif [ "${LOCUST_MODE}" = "SLAVE" ]; then
    if [ -z "${LOCUST_MASTER_HOST}" ]; then
        echo "ERROR: MASTER_HOST is empty. Slave mode requires a master" >&2
        exit 1
    fi

    _LOCUST_OPTS="${_LOCUST_OPTS} --slave --master-host=${LOCUST_MASTER_HOST} --master-port=${LOCUST_MASTER_PORT:-5557}"
fi

echo "Starting Locust in ${LOCUST_MODE} mode..."
echo "$ locust ${LOCUST_OPTS} ${_LOCUST_OPTS}"
cd /locust
ls -al
exec locust ${LOCUST_OPTS} ${_LOCUST_OPTS}
