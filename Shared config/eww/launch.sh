#!/usr/bin/env bash

# Попробывать заставить подключаться к одному server

setEnv() {
  # Требуется для работы с indclude modules
  EWW_MAIN_CONFIG_DIR=$(realpath $(dirname $0))
  export EWW_MODULES_DIR="$EWW_MAIN_CONFIG_DIR/modules"
}

checkDeepend() {
  # eww
  if not which eww &>/dev/null; then
    echo "Not found eww in env PATH." &>2;
    exit 1;
  fi
}

launchEwwDaemon() {
  while pgrep eww &>/dev/null; do
    killall eww &>/dev/null
    sleep 1
  done
  eww daemon;
  sleep 1;
}

launchEwwWindow() {
  for window in $@; do
    echo "open $window"
    eww close --config="$EWW_MAIN_CONFIG_DIR/window/$window" $window
    eww --logs --config="$EWW_MAIN_CONFIG_DIR/window/$window" open $window
  done;
}

main() {
  checkDeepend;
  setEnv;
  launchEwwDaemon; # Оно не принимает скрипты не убивая
  launchEwwWindow bar
}

main;
