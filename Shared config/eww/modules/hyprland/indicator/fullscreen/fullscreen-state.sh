#!/usr/bin/env sh

# Получить состояние текущего окна
getStateWindow() {
  hyprctl activewindow -j | jq '.fullscreen//0'
}
getStateWindow

socat -u UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - |
  stdbuf -o0 grep -E "^(fullscreen|workspace|closewindow)>>" |
  stdbuf -o0 sed -r 's/^fullscreen>>//' |
  while read -r line
  do
    if ! (echo $line | grep -E "^[0-9]+$"); then
      getStateWindow
    fi
  done
