#!/usr/bin/env bash
if ! pgrep waybar; then
    echo "---Launch---" | tee -a /tmp/waybar.log; 
    waybar -l debug | tee -a /tmp/waybar.log &disown
fi

function runBin {
    if ! pgrep $0; then
        $@ &disown
        echo "$@"
    fi
}


runBin hyprpaper
runBin corectrl --minimize-systray
