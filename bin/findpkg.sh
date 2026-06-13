#!/bin/bash

##  Выведет все пакеты сироты

pkgNotInstall=''

echo "Установленные вручную сироты:"
for pkg in $(pacman -Qdt | awk '{print $1}') 
do 
    # Ищу пакет сирот среди установленных вручную
    if pacman -Qqen | grep $pkg &>/dev/null; then
        echo "$pkg";
    else
        temp="${pkgNotInstall} ${pkg}"
        pkgNotInstall=$temp
    fi
done

echo "Из воздуха"
echo $pkgNotInstall 
