#!/bin/bash

udiskie -aN &
corectrl --minimize-systray &
dunst &

# Для того, чтобы не уходил в спячку экран
xset s off; xset dpms 0 0 0 

# Отключение второго монитора
xrandr --output DisplayPort-1 --off
# На проектор
xrandr --output DisplayPort-2 --same-as HDMI-A-0
