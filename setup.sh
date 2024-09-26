#!/usr/bin/env bash

# TODO: Add install scripts
# TODO: Add install icons

# FIX CS2199
if [[ $1 == "--help" ]]; then
    cat << EOF

    Folders:
      ./etc - config files (example) for /etc  [don't install]
      ./icons - later                          [by default save in ~/.local/share/icons]
      ./screenshots - example workspaces       [don't install]
      ./Scripts - my local scripts             [don't install]
      ./"Shared config" - um...                [by default save in ~/.config]
      ./themes - later                         [by default save in ~/.local/share/themes]
      ./WM - environment specific config files [by default save in ~/.config]
        
    If there is an evironment variable \$XDG_CONFIG_HOME then it will be installed not in ~/.config, but in \$XDG_CONFIG_HOME

EOF
    exit 0
fi

installWM() { 
    echo "Installing WM config..."
    if [[ $1 == "" ]]; then
        echo "ERR: installWM(): not found \$1" >&2
        exit 1
    fi
    
    for file in "$PWD/WM/$1/"*; do
        file=$( basename "$file" )
        cp -fr "$PWD/WM/$1/$file" "$XDG_CONFIG_HOME/$file"
    done
}

installShared() { 
    echo "Installing Shared config..."
    for file in "$PWD/Shared config/"*; do
        file=$( basename "$file" )
        cp -fr "$PWD/Shared config/$file" "$XDG_CONFIG_HOME/$file"
    done
}

getConfigDir() {
    if [[ -z "${XDG_CONFIG_HOME}" ]]; then
        if [[ -z "${HOME}" ]]; then
            echo "ERR: getConfigDir(): Not found "\
                "environment variables \$HOME "\
                "or \$XDG_CONFIG_HOME " >&2
            exit 1
        fi
        XDG_CONFIG_HOME="$HOME/.config"
    fi
    echo "Your config dir is \"$XDG_CONFIG_HOME\""
}

saveCrrConfig() {
    echo "Do needed save your current files from ~/.config? By default - yes"
    read -p "Yes or No?: " -r uSaveFiles

    case $uSaveFiles in
        "No" | "N" | "n" | "no" )
            echo "Ok. Skip.";;
        "Yes" | "Y" | "y" | "yes" | * )
            echo "Your $(basename "$XDG_CONFIG_HOME") save as ~/.config_old" &&
            cp -r "$XDG_CONFIG_HOME" "$HOME/.config_old"
            if [ $? -eq 1 ]; then
                echo "ERR: saveCC(): Filed to backup the current config files" >&2
            fi
            ;;
    esac
}

clearConfigDir() {
    if [[ ! -d "${XDG_CONFIG_HOME}" ]]; then
        echo "Not found config dir. Creaiting..."
        mkdir "$XDG_CONFIG_HOME" && \
        echo "Success"
        return
    fi
    
    cat << EOF

    Select method installation:
      [1] Overwrite the entire directory
      [2] Overwrite only conflicting configs
      ---
      [*] by default (2)
    
EOF
    read -p "[?] Select option: " -r uSelectMethodInstall

    case $uSelectMethodInstall in 
        1 )
            rm -R "$XDG_CONFIG_HOME"/*
            ;;
        2 | * )
            # Мб будет нужно: крч можно не заниматься хуйней и использовать cp -f
            #filesNewConf=("$PWD/Shared config/"* "$PWD/WM/$uSelectWM/"*:)
            #echo "DBG: filesNC = $filesNewConf"
            #rm -fr $filesNewConf # хуевая комманда
            ;;
    esac
    sleep 1
}

checkDependencies() {
    notFoundPkg=()
    for pkg in $@; do
        if not which $pkg >> /dev/null 2>&1; then
            notFoundPkg+=($pkg)
        fi
    done
    if [ ${#notFoundPkg[@]} -ne 0 ]; then
        printf "\n\tWRNING: Needed to install next pkg: " 
        printf '%s ' "${notFoundPkg[@]}"
        printf "\n\n"
    fi
}

main() {
    clear
    getConfigDir

    cat << EOF

    Select your window manajer:
      [1] Hyprland
      [2] i3wm
      [3] none (install only "Shared config")
      ---
      [q] exit from installer
      
EOF
    read -p "[?] Select option: " -r uSelectWM 

    case $uSelectWM in
        "q" )
            exit 0;;
        [1-3] )
            saveCrrConfig
            clearConfigDir
            installShared;;
        * )
            echo "ERR: main(): Incorrect input" >&2
            exit 1;;
    esac
    case $uSelectWM in
        1 ) #Hyprland
            checkDependencies Hyprland waybar wofi wlogout hyprpaper grim \
                slurp alacritty hyprlock swayidle brightnessctl hyprpicker \
                wl-copy 
                
            installWM hyprland;;
        2 ) #i3wm
            checkDependencies xclip i3 polybar rofi feh dex xss-lock
            installWM i3wm;;
    esac
}

main

