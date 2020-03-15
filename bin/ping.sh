#!/bin/bash

set -e

# COLORS! :)
red='\033[0;31m'
cyan='\033[0;36m'
blue='\033[0;34m'
yellow='\033[0;33m'
nocolor='\033[0m'

error() {
  prefix="[ERROR] "
  echo -e "${red}${prefix}${1}${nocolor}"
}

warn() {
  prefix="[WARNING] "
  echo -e "${yellow}${prefix}${1}${nocolor}"
}

debug() {
  if [[ "$VERBOSE" != "" ]]; then
    prefix="[DEBUG] "
    echo -e "${cyan}${prefix}${1}${nocolor}"
  fi
}

has_env_var() {
  env | grep "$1" > /dev/null 2>&1
  return $?
}

missing_env_var() {
  if has_env_var $1; then
    return 1
  else
    return 0
  fi
}

load_env_file() {
  if [[ ! -f $1 ]]; then
    warn "Missing ENV file: $1"
  else
    ENV_VARS=$(cat $1)

    export $(echo $ENV_VARS | xargs)
  fi
}

if [[ -f ".env" ]]; then
  load_env_file ".env"
fi

if [[ "$APP_ENV" != "" ]]; then
  load_env_file ".env.$APP_ENV"
fi

SSH_PORT=${SSH_PORT:-22}
LOCAL_HOST=${LOCAL_HOST:-0.0.0.0}
PING_HOST=$LOCAL_HOST
PING_PORT=$LOCAL_PORT
PING_WAIT=${PING_WAIT:-30}

REQUIRED_ENV_VARS="
SSH_USER
SSH_HOST
LOCAL_HOST
LOCAL_PORT
REMOTE_HOST
REMOTE_PORT
"

for v in $REQUIRED_ENV_VARS; do
  if missing_env_var "$v"; then
    error "Missing required ENV VAR: '$v'"
  fi
done

if [[ "$PING_HOST" == "0.0.0.0" ]]; then
  PING_HOST=localhost
fi

cmd="nc -zv -w $PING_WAIT $PING_HOST $PING_PORT"

debug "SSH Tunnel Ping: '$cmd'"

out=$($cmd)

if [[ "$?" != "0" ]]; then
  error "Failed to ping tunnel - $PING_HOST:$PING_PORT"
  exit 1
fi

sleep $PING_WAIT

exec "$0"
