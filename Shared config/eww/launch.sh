#!/usr/bin/env bash

setEnv() {
  # Требуется для работы с indclude modules
  export EWW_CONFIG_ROOT=$(realpath $(dirname $0))
}

checkEww() {
  if not which eww &>/dev/null; then
    echo "Not found eww in env PATH." &>2;
    exit 1;
  fi
}

killEww() {
  killall eww &>/dev/null

  while pgrep eww &>/dev/null; do
    sleep 1
  done
}

launchEwwWindow() {
  for window in $@; do
    echo "open $window"

    if (echo $window | grep '/' &>/dev/null)
    then
      dir=$(echo $window | sed 's/\/\w*//')
      window=$(echo $window | sed 's/^\w*\///')
    else dir=$window
    fi

    export EWW_CONFIG_HOME="$EWW_CONFIG_ROOT/window/$dir"
    eww --config="$EWW_CONFIG_HOME" open $window
  done;
}


main() {
  checkEww;
  setEnv;
  killEww;

  launchEwwWindow bar desk/left desk/right
}
main;
