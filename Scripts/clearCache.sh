#!/usr/bin/env bash

# Cleans the system of unnecessary packages for arch base distribution
# Check:
#   - /opt,  
#   - ~/.cache/yay
#   - /var

export numOfPkgToSave=2;

checkRoot () {
    echo "Check root rules";
    if [ `id -u` -eq 0 ]; then
        echo -e "\nE: Please don't run script as root\n";
        exit;
    fi
}

cleanPacman () {
    echo "Clean pacman (/var)"
    if ! which paccache &>/dev/null; then
        sudo pacman -S pacman-contrib
        if [ $? -ne 0 ]; then
            echo -e "\nW: Please install paccache\n";
            retutn;
        fi
    fi
    paccache -rk$numOfPkgToSave
}

cleanYay () {
    echo "Clean yay (~/.cache/yay)";
    # Проверить есть ли дириктория
    if [ ! -d $HOME/.cache/yay ]; then
        return;
    fi
    
    cd $HOME/.cache/yay
    for folder in * ; do
        [ -d $folder ] && cd $folder || continue
        # TODO: Добавить проверку tar
        # Количество имеющихся собранных пакетов
        while true; do
            if [ "$(ls -1 | grep "\.pkg\.tar\.zst" | wc -l)" -gt "$numOfPkgToSave" ]; then
                pkg=$(ls -1 | grep "\.pkg\.tar\.zst" | sed -n 1p)
                rm -f "$pkg";
                echo $pkg;
            else
                break;
            fi
        done
        
        cd $HOME/.cache/yay
    done
}

checkFolderOpt () {
    echo "Check /opt";
    # Проверить пустая ли папка
}

main () {
    echo "Launch cleans of cache";
    echo "Было занято: $(df -m | grep "/$" | awk '{print $3}') Mb"
    checkRoot;
    cleanPacman;
    checkFolderOpt;
    cleanYay;
    echo "Стало: $(df -m | grep "/$" | awk '{print $3}') Mb"
    #TODO: добавить проверку, какие пакеты не отслеживаются pacman
}

main;
