#!/bin/bash

set -e

SSH_USER=${SSH_USER:-charlie}
SSH_HOST=${SSH_HOST:-ssh-host}
SSH_PORT=${SSH_PORT:-22}

LOCAL_HOST=${LOCAL_HOST:-0.0.0.0}
LOCAL_PORT=${LOCAL_PORT:-3306}

REMOTE_HOST=${REMOTE_HOST:-remote-host}
REMOTE_PORT=${REMOTE_PORT:-3306}
REMOTE_WAIT=${REMOTE_WAIT:-10}

# TODO: Verify / validate variables before attempting?

cmd="ssh -f -4 $SSH_USER@$SSH_HOST -L $LOCAL_HOST:$LOCAL_PORT:$REMOTE_HOST:$REMOTE_PORT -N"

echo "SSH Tunnel: '$cmd'"

$($cmd)

exec "$@"
