#!/usr/bin/env bash
echo "---" | tee -a /tmp/waybar.log; 
waybar | tee -a /tmp/waybar.log &disown

hyprpaper &disown
corectrl --minimize-systray &disown
