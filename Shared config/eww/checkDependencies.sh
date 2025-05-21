#!/usr/bin/env bash

source <(curl -s https://gist.githubusercontent.com/tonakihan/62ce606011c71e1b7c0d972aaef53594/raw/6bfbae4f52e24e2e4800a79f519f6e751c9d4b2d/checkDependencies.sh)

# -- Modules --
# hyprland/workspaces
checkDepend jq socat python3 seq grep stdbuf awk
# hyprland/window-title
# hyprland/indicator/fullscreen
checkDepend jq socat stdbuf grep sed
# vpn-toggle
checkDepend vpnSwitch.sh tr head notify-send ip pkexec cat
# wireplumber
checkDepend wpctl awk pipewire-alsa
# Desk/sysmon
checkDepend vmstat awk free df sed
 

# For all
checkDepend logrotate crontab
searchFonts "Audiowide" "Days One" "SymbolsNerdFont"
