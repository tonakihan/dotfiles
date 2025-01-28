#!/usr/bin/env bash

# |--------------------------|
# | Supported only wireguard |
# |--------------------------|

# WARNING: Needed the Polkit and notify-send!
# WARNING: Also add path to .local/bin into .profile
# TODO: Add helps

# FIXME: добавить env в setup и заменить на нужный интерфейс..
setEnv() {
  if [ -z $WG_INTERFACE ]; then
    WG_INTERFACE=wg;
  fi
  # У меня проблемы с передачей сообщения от wg-quick, по этому это здесь
  # FIXME: В waybar опять обрыв канала - файл не получает свой случайный идентификатор
  TEMP_FILE="/tmp/_sh-$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13; echo)"
}

notifySend() {
  local selfNameApp=$(basename "$0")
  notify-send "$selfNameApp" "$(echo $@)"
}

switchVPN() {
  # Check interface wg is online
  if [ -n "$(ip link show type wireguard)" ]; then
    local action="down"
  else
    local action="up"
  fi
  
  pkexec wg-quick $action $WG_INTERFACE &> $TEMP_FILE
  return $?
}

checkError() {
  local status=$1
  local msg=$2
  if [ $status -ne 0 ]; then
    case $msg in
      *"does not exist")
        notifySend "Error: Please add WG_INTERFACE=your_name_wg_conf" \
        "before launch command or modify this script." \
        "Path: \"$0\"";;
      *)
        notifySend "Unknown error: $msg";;
    esac
    exit 1
  fi
}

main() {
  setEnv;
  switchVPN;
  checkError $? "$(cat $TEMP_FILE)";
  rm -f $TEMP_FILE
}
main;
