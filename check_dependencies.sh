#!/bin/bash

read -p "WARNING: You're about to download A LOT OF DATA, are you sure? (yN) " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
  echo "n"
  [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi

error()
{
  echo "Error: $*" >&2
  exit 1
}

check_cmd()
{
  if ! which $1 &>/dev/null; then
    error "$1 command not found, you must install it before."
  fi
}

check_cmd wget
check_cmd docker
