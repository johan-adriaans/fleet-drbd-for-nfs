#!/usr/bin/env bash

# Keep running until etcd connectivity is lost, fail after MAX_FAILURES tries
ETCD_URL="http://127.0.0.1:2379/v2/keys"
MAX_FAILURES=3

echo "Starting cluster connectivity monitor, maximum failures set to $MAX_FAILURES"

COUNT=0
while true; do
  if [ "$(curl --silent --connect-timeout 2 "$ETCD_URL")" ]; then
    if [ $COUNT -ne 0 ]; then
      echo "Successfull connect after $COUNT failures, resetting counter"
    fi
    COUNT=0
  else
    COUNT=$((COUNT + 1))
    echo "Connection to $ETCD_URL failed. Failure $COUNT of $MAX_FAILURES"
  fi

  # Exit with error when connection fails more than
  if [ "$COUNT" -ge "$MAX_FAILURES"  ]; then
    echo Too many failures, exiting.
    exit 1;
  fi

  sleep 2
done
