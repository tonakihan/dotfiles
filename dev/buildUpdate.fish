#!/usr/bin/env fish
# Сокращения:
# ===========
# Ls - list
# u - user
# F - files 

function main
    cd ..
    printGitStatus

    getConfigHome
    getListFilesOnSystem
    getStatusFiles
    updateFiles
    addFilesToRepo

    printGitStatus
end

function getConfigHome
    if set -q XDG_CONFIG_HOME
        set CONFIG_HOME "$XDG_CONFIG_HOME"
    else
        set CONFIG_HOME "$HOME/.config"
    end
end

function printGitStatus
    echo -e "\tТекущий статус git:"
    git status
    echo
end

# Get a list of files in the dirs
function getListFilesOnSystem
    set -l lsCfgHost (ls "$CONFIG_HOME")
    set -l lsCfgRepo (ls "Shared config")
    for fileWm in (ls "WM")
        set -a lsCfgRepo (ls WM/$fileWm)
    end
end


# Check untracked the config files
# Get different between dirs
# TODO: Добавить поддержку .gitignore
function getStatusFiles
    set -l lsTrackedHost ()
    set -l lsUntrackedHost ()
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
    for file in $lsTrackedHost
        set -l paths (find {WM,Shured\ config} -name $file -printf "%p\"" | string split '"' | head -n -1)
        if test (count $paths) != 1
            echo "FATAL ERROR: Что то пошло не так в updateFiles" &>2
            echo "DBG: paths = $paths" &>2
            echo "DBG: count = $(count $paths)" &>2
            exit 1

            # TODO set вернулся к тому от куда и начал
        end
        cp -rf "$file" "$paths"
    end
end

# Add files to the repo
function addFilesToRepo
    function printUntrackedFiles
        echo -e "\tОтсутствующие файлы/dir в репозитории:"
        for i in (seq (count $lsUntrackedHost))
            echo "[$i] $lsUntrackedHost[$i]"
        end
        echo
    end
    printUntrackedFiles

    set -l prompt 'set_color green; printf "[?] Read"; set_color normal; echo ": "'

    echo -e "\tКакие файлы из списка добавить в Shared config?"
    read -p $prompt -al uLsToSharedCfg
    echo

    echo -e "\tКакие файлы из списка добавить в WM? (Будет применимо к текущему окружению)"
    read -p $prompt -al uLsToWm

    function checkInput
        # Проверка на дубликат (один в оба dir)
        for el in $uLsToSharedCfg
            if contains $el $uLsToWm
                echo "FATAL ERROR: Ввод пользователя. Один файл был назначен в 2 каталога" >&2
                exit 1
            end
        end

        # Откидывание несущ вариантов
        function checkMoreList --argument-names userList
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
        if test $(count $userList) -gt 0
            for el in $userList
                cp -r "$XDG_CONFIG_HOME/$lsUntracked[$el]" "$targetDir"
            end
        end
    end
    addUntrackedFilesToRepo $uLsToSharedCfg "Shared config"
    switch $XDG_SESSION_DESKTOP
        case hyprland
            addUntrackedFilesToRepo $uLWm WM/hyprland
        case i3
            addUntrackedFilesToRepo $uLWm WM/i3wm
        case *
            echo "Не определен текущий WM" >&2
            exit 1
    end
end


main
