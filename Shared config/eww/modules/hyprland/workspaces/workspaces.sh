#!/usr/bin/env bash

# -- User env difinitions ---------------
#NUMBER_WORKSPACES=8


setEnv() {
  APP_PATH=$(dirname $0)

  #Set a default value
  if test -z $NUMBER_WORKSPACES; then
    NUMBER_WORKSPACES=$(jq 'length' "$APP_PATH/match-name.json")
    #
    if test -v $NUMBER_WORKSPACES
    then NUMBER_WORKSPACES=10
    fi
  fi
}


change-active-workspace() {
  clamp() {
    min=1
    max=$NUMBER_WORKSPACES
    val=$1
    python -c "print(max($min, min($val, $max)))"
  }

  direction=$1
  current=$2

  local target
  if test "$direction" = "down"
  then target=$(clamp $(($current+1)))
  #  
  elif test "$direction" = "up"
  then target=$(clamp $(($current-1)))
  #
  else
    echo "ERROR: Don't understand argument '$direction'" >&2
    exit 1
  fi
  echo "jumping to $target"
  hyprctl dispatch workspace $target
}


get-active-workspace() {
  hyprctl monitors -j | jq '.[] | select(.focused) | .activeWorkspace.id'

  socat -u UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - |
    stdbuf -o0 awk -F '>>|,' -e '/^workspace>>/ {print $2}' -e '/^focusedmon>>/ {print $3}'
}


get-workspaces() {
  spaces() {
    # вернет json only for active workspaces {id: windows}
    workspace_windows=$(hyprctl workspaces -j |
                          jq 'map({
                                    key: .id | tostring,
                                    value: .windows
                              }) |
                              from_entries')
# FIXME: Обработать workspaces вне "зоны"
    seq 1 $NUMBER_WORKSPACES |
      jq \
        --argjson windows "$workspace_windows" \
        --slurpfile names $APP_PATH/match-name.json \
        --slurp -Mc 'map(tostring) |
                     map({
                           id: .,
                           name: ($names[][.]//.),
                           windows: ($windows[.]//0)
                     })'
  }
  spaces

  socat -u UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - |
    stdbuf -o0 grep -E "^(open|close|move)window>>" |
      while read -r line; do
      spaces
    done
}


# -- Main -----------------------
setEnv
$@
