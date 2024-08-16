#!/bin/bash
#
# -----------------------------------------------
# This sripts allows using some DM and use unique 
# lock screen scripts for every DM.
# -----------------------------------------------
#
# For normal works needed environment variable:
#  $XDG_CONFIG_HOME or $HOME
#  $XDG_CURRENT_DESKTOP
#  $XDG_SESSION_TYPE (if don't have scripts for
#    your session in getPathScriptDM)


arrAppLockscreen=(hyprlock swaylock waylock i3lock)

# -------- *Main settings* --------
function getCmdExecForDM() {
    if [[ "${XDG_CURRENT_DESKTOP}" -eq "Hyprland" ]]; then
        cmdExec="hyprlock"

    # For example:
    #elif [[ $XDG_CURRENT_DESKTOP -eq "Sway" ]]; then
    #    cmdExec=$XDG_CONFIG_HOME/sway/scripts/lockScreen.sh

    else
        echo "WARNING: Not found section for your "\
            "DM in getCmdExecForDM" >&2
        return 
    fi
    echo "Success: Found scripts for DM"
}

function getEnvVar() {
    if [[ -z "${XDG_CONFIG_HOME}" ]]; then
        if [[ -z "${HOME}" ]]; then
            echo "FATAL ERROR: Not found "\
                "environment variables \$HOME "\
                "or \$XDG_CONFIG_HOME" >&2
            exit 1
        fi
        XDG_CONFIG_HOME="$HOME/.config"
    fi
    echo "Success: XDG_CONFIG_HOME=${XDG_CONFIG_HOME}"
}

function runByDefault() {
    if [[ "${XDG_SESSION_TYPE}" -eq "wayland" ]]; then
        if hash swaylock &> /dev/null; then
            swaylock -f 
        elif hash waylock &> /dev/null; then
            waylock

        else
            echo "FATAL ERROR: Not found lock"\
                "sreen application on this computer" >&2
            exit 1
        fi
    elif [[ "${XDG_SESSION_TYPE}" -eq "x11" ]]; then
        if hash i3lock &> /dev/null; then
            i3lock 

        else
            echo "FATAL ERROR: Not found lock"\
                "sreen application on this computer" >&2
            exit 1
        fi
    else
        echo "FATAL ERROR: Not foundyour session manager" >&2
        exit 1
    fi
    echo "Success: Found and runing lock screen"\
        "application"
}

function runLockScreen() { 
    if [[ -n "${cmdExec}" ]]; then
        if "${cmdExec}" &disown; then
            echo "Success: Executed scripts lock screen"
            return
        fi
        echo "ERROR: Can't runing your lockscreen application/script: $cmdExec" >&2
        return 1
    fi

    echo "ERROR: Not found your "\
        "script/app for session lock. Execute by default" >&2
    runByDefault
}

function checkRunningLock() {
    for appLock in $arrAppLockscreen[@] ; do
        if pgrep "$appLock" &> /dev/null; then
            echo "Info: Application lock screen is running"
            exit 0;
        fi
    done
}

function main() {
    checkRunningLock
    getEnvVar
    getCmdExecForDM
    runLockScreen
}

main
exit 0

