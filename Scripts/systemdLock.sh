#!/bin/bash

export XDG_RUNTIME_DIR=/run/user/$(id -u)
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=Hyprland
export WAYLAND_DISPLAY=wayland-1

/home/mark/.script/mainLock.sh
