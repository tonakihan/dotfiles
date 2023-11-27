#!/usr/bin/env bash

if [[ $1 == "--help" ]]; then
    clear
    cat << EOF
        Folder:
          ./etc - config files (example) for /etc  [don't install]
          ./icons - later                          [by default save in ~/.local/share/icons]
          ./screenshots - later                    [don't install]
          ./Scripts - useful scripts for WM        [don't install]
          ./Shared\ config -                       [by default save in ~/.config]
          ./themes - later                         [by default save in ~/.local/share/themes]
          ./WM - environment specific config files [by default save in ~/.config]
        
        If there is an evironment variable \$XDG_CONFIG_HOME then it will be installed not in ~/.config, but in \$XDG_CONFIG_HOME
EOF
    exit 0
fi

if [[ $@ == *"--link"* ]]; then 
    $setForCP = "-frs"
else
    $setForCP = "-fr"
fi

installWM() { 
    if [[ $1 == "" ]]; then
        echo "ERR instWM(): not found \$1"
        exit 1
    fi
    
    cp $setForCP ./WM/$1/* $XDG_CONFIG_HOME
}

installShared() { 
    cp $setForCP ./Shared\ config/* $XDF_CONFIG_HOME
}

getConfigDir() {
    if [[ -z "${XDG_CONFIG_HOME}" ]]; then
        if [[ -z "${HOME}" ]]; then
            echo "ERR getConfigDir(): Not found"\
                "environment variables \$HOME"\
                "or \$XDG_CONFIG_HOME" >&2
            exit 1
        fi
        XDG_CONFIG_HOME=$HOME/.config
    fi
    echo "Your config dir is ${XDG_CONFIG_HOME}"
}

saveOldConfig() {
    echo "Your $XDG_CONFIG_HOME save as ~/.config_old"
    cp -ri $XDG_CONFIG_HOME ~/.config_old
}

main() {
    clear
    getConfigDir
    echo ""

    cat << EOF
    Select your window manajer:
      [1] Hyprland
      [2] i3wm
      [3] none (install only Shared config)
      ---
      [q] exit from install

EOF
    read -p "[?] Select option : " -r setWM 

    case $setWM in
        "q" )
            exit 0;;
        [1-3] )
            saveOldConfig
            installShared;;
        * )
            echo "ERR main(): Incorrect input"
            exit 1;;
    esac
    case $setWM in
        1 ) #Hyprland
            installWM hyprland;;
        2 ) #i3wm
            installWM i3wm;;
    esac
}

main

