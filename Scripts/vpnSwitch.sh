#!/usr/bin/env bash

#FIXME: добавить env и заменить в файлах на нужный интерфейс..
WG_INTERFACE=wg1;

getPassword=$(zenity --password --title "Elevate privileges");

main() {
  # Check interface wg is online
  if [ -n "$(ip link show type wireguard)" ]; then
    echo "$getPassword" | \
    sudo -S wg-quick down $WG_INTERFACE && \
    echo "VPN is down";
  else
    echo "$getPassword" | \
    sudo -S wg-quick up $WG_INTERFACE && \
    echo "VPN is up";
  fi
}

main;
