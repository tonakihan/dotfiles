#!/usr/bin/env fish
# Сокращения:
# ===========
# Ls - list
# u - user
# F - files 

function main
    cd ..
    getConfigHome
    getListOfAllConfigurationFiles
    getStatusFiles
    updateFiles
    #addFilesToRepo
end

function getConfigHome
    echo "info: getConfigHome..."
    if set -q XDG_CONFIG_HOME
        set -g CONFIG_HOME "$XDG_CONFIG_HOME"
    else
        set -g CONFIG_HOME "$HOME/.config"
    end
end

# Get a list of files in the dirs
function getListOfAllConfigurationFiles
    set -g lsCfgHost (ls "$CONFIG_HOME")
    set -g lsCfgRepo (ls "Shared config")
    for fileWm in (ls "WM")
        set -a lsCfgRepo (ls WM/$fileWm)
    end
end

# Check untracked the config files
# Get different between dirs
# TODO: Добавить поддержку .gitignore
function getStatusFiles
    set -g lsTrackedHost ()
    set -g lsUntrackedHost ()
    for file in $lsCfgHost
        if not contains $file $lsCfgRepo
            set -a lsUntrackedHost $file
        else
            set -a lsTrackedHost $file
        end
    end
end

# Update files into repo
function updateFiles
    echo "info: updateFiles..."
    for file in $lsTrackedHost
        #Заплатка, что бы работало
        if test $file = "README"*
            continue
        end

        set -l paths (find {WM,Shared\ config} -name $file -printf "%p\"" | string split '"' | head -n -1)
        if test (count $paths) != 1
            echo "FATAL ERROR: Что то пошло не так в updateFiles" >&2
            echo "DBG: paths = $paths" >&2
            echo "DBG: count = $(count $paths)" >&2
            exit 1
        end
        cp -rf "$CONFIG_HOME/$file" "$(dirname "$paths")"
    end
end

# FIXME: если shared пуст, то копируется весь католог
# Add files to the repo
function addFilesToRepo
    echo "info: addFilesToRepo..."
    function printUntrackedFiles
        echo -e "\tОтсутствующие файлы/dir в репозитории:"
        for i in (seq (count $lsUntrackedHost))
            echo "[$i] $lsUntrackedHost[$i]"
        end
        echo
    end
    printUntrackedFiles

    set -f prompt 'set_color green; printf "\t[?] Read"; set_color normal; echo ": "'

    echo -e "Какие файлы из списка добавить в Shared config?"
    read -p $prompt -al uLsToSharedCfg
    echo

    # FIXME: Не работает
    echo -e "Какие файлы из списка добавить в WM? (Будет применимо к текущему окружению)"
    read -p $prompt -al uLsToWm

    function checkInput
        # FIX не работает
        # Проверка на дубликат (один в оба dir)
        for el in $uLsToSharedCfg
            if contains $el $uLsToWm
                echo "FATAL ERROR: Ввод пользователя. Один файл был назначен в 2 каталога" >&2
                exit 1
            end
        end

        # Откидывание несущ вариантов
        function checkMoreList --argument-names userList
            # TODO checks it
            for el in $userList
                if test $el -gt (count $lsUntrackedHost)
                    echo "Введенное число больше существующих вариантов" >&2
                    exit 1
                end
            end
        end
        checkMoreList $uLsToSharedCfg
        checkMoreList $uLsToWm
    end
    checkInput

    # Добавление файлов в репозиторий
    # @param {list} userList - Состоит из чисел. Какие елементы из untrackedFiles нужно скопировать.
    # @param {string} targetDir - В какую папку скопировать файлы из untrackedFiles.
    function addUntrackedFilesToRepo --argument-names userList targetDir
        set userList (echo $userList | string split " ")
        if test $(count $userList) -gt 0
            for el in $userList
                cp -r "$CONFIG_HOME/$lsUntrackedHost[$el]" "$targetDir"
            end
        end
    end

    addUntrackedFilesToRepo "$uLsToSharedCfg" "Shared config"
    switch $XDG_SESSION_DESKTOP
        case hyprland
            echo "info: detected Hyprland"
            addUntrackedFilesToRepo "$uLsToWm" WM/hyprland
        case i3
            echo "info: detected i3wm"
            addUntrackedFilesToRepo "$uLsToWm" WM/i3wm
        case '*'
            echo "ERROR: Не определен текущий WM" >&2
            exit 1
    end
end


main
