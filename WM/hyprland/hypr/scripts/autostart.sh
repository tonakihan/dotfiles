#!/usr/bin/env bash

function runBin {
    if not pidof $1 &> /dev/null; then
        $@ &
        echo "Running: $@"
    else
        killall -9 $1
        sleep 1
        runBin $@
    fi
}

function runBinWithLog {
    echo "---Launch---" | tee -a "/tmp/$1.log"
    runBin $@ | tee -a "/tmp/$1.log" &
}

runBin hyprpaper
runBinWithLog waybar
#runBin swayidle -C $HOME/.config/hypr/swayidle.conf
sleep 2 && runBin corectrl --minimize-systray
