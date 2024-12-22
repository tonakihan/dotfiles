#!/usr/bin/env bash

sleep 1
killall -e xdg-desktop-portal-hyprland
killall -e xdg-desktop-portal-wlr
killall xdg-desktop-portal

if [[ -d "/usr/libexec" ]]; then
  libPath="libexec"
else
  libPath="lib"
fi
/usr/$libPath/xdg-desktop-portal-hyprland & 
sleep 2
/usr/$libPath/xdg-desktop-portal &
