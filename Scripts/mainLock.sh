#!/bin/bash
#
# -----------------------------------------------
# This sripts allows using some DM and use unique 
# lock screen scripts for every DM.
# -----------------------------------------------
#
# For normal works needed environment variable:
#  $XDG_CURRENT_DESKTOP
#  $XDG_SESSION_TYPE (if don't have scripts for
#    your session in getPathScriptDM)
#
# Also may be needed $XDG_CONFIG_HOME for available
# your configuration files 


arrAppLockscreen=(hyprlock swaylock waylock i3lock)

# -------- *Main settings* --------
function getCmdExecForDM() {
    case $XDG_CURRENT_DESKTOP in

        "Hyprland")
            cmdExec="hyprlock";;

        # For example:
        #"Sway")
        #    cmdExec="$XDG_CONFIG_HOME/sway/scripts/lockScreen.sh";;

        "*")
            echo "WARNING: Not found section for your "\
                "DM in getCmdExecForDM" >&2
            return ;;
    esac 
    echo "Success: Found section for your DM"
}

function runByDefault() {
    local arrCmdExecByDefault=()
    case $XDG_SESSION_TYPE in
        
        "wayland")
            arrCmdExecByDefault=(swaylock hyprlock waylock);;

        "x11")
            arrCmdExecByDefault=(i3lock);;
                  
        "*")
            echo "FATAL ERROR: Not found your session manager" >&2
            exit 1;;
    esac

    if [[ ${#arrCmdExecByDefault[@]} -eq 0 ]]; then
            echo "FATAL ERROR: Not found lock"\
                "screen application on this system" >&2
            exit 1
    fi
    for cmdExecByDefault in "${arrCmdExecByDefault[@]}"
    do
        runCmd $cmdExecByDefault &&
        echo "Success: Found and runing lock screen"\
            "application" && 
        return
    done
}

function runCmd() {
    if ! hash $1 &>/dev/null; then return 1; fi
    echo "Try launch $1"
    $@ & &> /dev/null
    sleep 1
    local pidLockScreen=$!

    if pgrep -f $1 &> /dev/null; then
        echo "Success: Executed cmd"
        return
    fi
        
    if [ $? -eq 0 ] && ! kill -0 $pidLockScreen &> /dev/null; then
        echo "Cmd success ended"
    elif ! kill -0 $pidLockScreen &> /dev/null; then
        echo "ERROR: Cmd not success ended" >&2
    fi
    echo "ERROR: Can't runing your cmd application/script: \"$@\"" >&2
    return 1
}

function runLockScreen() { 
    if [[ -n "$cmdExec" ]]; then
        runCmd $cmdExec &&
        echo "Success: LockScreen executed" &&
        return
    fi

    echo "ERROR: Not found your"\
        "script/application for session lock. Execute by default" >&2
    runByDefault
}

function checkRunningLock() {
    for appLock in $arrAppLockscreen[@] ; do
        if pgrep "$appLock" &> /dev/null; then
            echo "Info: Application lock screen is running ($appLock)"
            exit 0;
        fi
    done
}

function main() {
    checkRunningLock
    getCmdExecForDM
    runLockScreen
}

main
