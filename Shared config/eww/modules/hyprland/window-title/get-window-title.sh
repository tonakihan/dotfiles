#!/usr/bin/env sh

# Текущее окно определили
hyprctl activewindow -j | jq --raw-output .title

# Теперь слушаем изменения
socat -u UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - |
  stdbuf -o0 grep -E "^activewindow>>" |
  stdbuf -o0 sed -r 's/^activewindow>>[a-zA-Z0-9\._]*,//'
