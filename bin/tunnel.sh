#!/bin/bash

set -e

# COLORS! :)
red='\033[0;31m'
cyan='\033[0;36m'
blue='\033[0;34m'
yellow='\033[0;33m'
nocolor='\033[0m'

error() {
  prefix=${2:-"[ERROR] "}
  echo -e "${red}${prefix}${1}${nocolor}"
}

warn() {
  prefix=${2:-"[WARNING] "}
  echo -e "${yellow}${prefix}${1}${nocolor}"
}

debug() {
  if [[ "$VERBOSE" != "" ]]; then
    prefix=${2:-"[DEBUG] "}
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

export SSH_KEY=${SSH_KEY:-id_rsa}
export SSH_PORT=${SSH_PORT:-22}
export BIND_HOST=${BIND_HOST:-0.0.0.0}

REQUIRED_ENV_VARS="
SSH_PATH
SSH_USER
SSH_HOST
SSH_PORT
BIND_HOST
BIND_PORT
REMOTE_HOST
REMOTE_PORT
"

for v in $REQUIRED_ENV_VARS; do
  if missing_env_var "$v"; then
    error "Missing required ENV VAR: '$v'"
  fi
done

cmd="ssh -f -4"

if [[ -f $SSH_PATH/$SSH_KEY ]]; then
  cmd="$cmd -i $SSH_PATH/$SSH_KEY"
fi

if [[ "$SSH_PORT" != "22" ]]; then
  cmd="$cmd -p $SSH_PORT"
fi

cmd="$cmd $SSH_USER@$SSH_HOST -L $BIND_HOST:$BIND_PORT:$REMOTE_HOST:$REMOTE_PORT -N"

debug "SSH Tunnel: '$cmd'"

$($cmd)

warn "$(date)" "[*] "
warn " Tunnel - $BIND_HOST:$BIND_PORT => $REMOTE_HOST:$REMOTE_PORT" "[*] "
warn "Via SSH - $SSH_USER@$SSH_HOST:$SSH_PORT" "[*] "

exec "$@"
