#!/bin/bash

# Зваершение текущих экземпляров polybar
killall -q polybar
# Ожидание полного завершения работы процессов
while pgrep -u $UID -x polybar >/dev/null; 
    do sleep 1; 
done

echo "---" | tee -a /tmp/polybar_1.log
# Запуск polybar с конфигом ~/.config/polybar/config
polybar Bar1 2>&1 | tee -a /tmp/polybar_1.log 

echo "Polybar загрузился..."

