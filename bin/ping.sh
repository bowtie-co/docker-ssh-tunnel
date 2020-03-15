#!/bin/bash

set -e

SSH_USER=${SSH_USER:-charlie}
SSH_HOST=${SSH_HOST:-ssh-host}
SSH_PORT=${SSH_PORT:-22}

LOCAL_HOST=${LOCAL_HOST:-0.0.0.0}
LOCAL_PORT=${LOCAL_PORT:-3306}

REMOTE_HOST=${REMOTE_HOST:-remote-host}
REMOTE_PORT=${REMOTE_PORT:-3306}

PING_HOST=$LOCAL_HOST
PING_PORT=$LOCAL_PORT
PING_WAIT=${PING_WAIT:-30}

if [[ "$PING_HOST" == "0.0.0.0" ]]; then
  PING_HOST=localhost
fi

# TODO: Verify / validate variables before attempting?

cmd="nc -zv -w $PING_WAIT $PING_HOST $LOCAL_PORT"

echo "SSH Tunnel Ping: '$cmd'"

out=$($cmd)

echo "res: $? | out: $out"

sleep $PING_WAIT

exec "$0"
