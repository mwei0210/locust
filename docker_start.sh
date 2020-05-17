#!/usr/bin/env sh

#if [ -z "${TARGET_URL}" ]; then
#  echo "ERROR: TARGET_URL not configured" >&2
#  exit 1
#fi

LOCUST_MODE="${LOCUST_MODE:=standalone}"
LOCUST_SCRIPT_DIR_PATH="${LOCUST_SCRIPT_DIR_PATH:-/locust}"
_LOCUST_OPTS="-f ${LOCUSTFILE_PATH:-$LOCUST_SCRIPT_DIR_PATH/locustfile.py}"
REQUIREMENT_FILE_NAME="${REQUIREMENT_FILE_NAME:-requirements.txt}"

if [ -f "$file" ]; then
    echo "$file found. Installing dependencies..."
    pip install --user locust -r $LOCUST_SCRIPT_DIR_PATH/$REQUIREMENT_FILE_NAME
else
    echo "$file not found."
fi

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
if [ -n "$RUN_SCRIPT" ]; then
    $RUN_SCRIPT &
fi
exec locust ${LOCUST_OPTS} ${_LOCUST_OPTS}
