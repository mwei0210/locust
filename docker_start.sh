#!/usr/bin/env sh

LOCUST_SCRIPT_DIR_PATH="${LOCUST_SCRIPT_DIR_PATH:-/locust}"
REQUIREMENT_FILE_PATH="${REQUIREMENT_FILE_PATH:-$LOCUST_SCRIPT_DIR_PATH/requirements.txt}"

if [ -f "$REQUIREMENT_FILE_PATH" ]; then
    echo "$REQUIREMENT_FILE_PATH found. Installing dependencies..."
    pip install --user locust -r $REQUIREMENT_FILE_PATH
else
    echo "$REQUIREMENT_FILE_PATH not found."
fi

if [ -n "$RUN_SCRIPT" ]; then
    echo "running $RUN_SCRIPT..."
    $RUN_SCRIPT &
fi

exec locust
