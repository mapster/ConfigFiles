#!/bin/bash

#echo "Running polybar launch $(date)" > /home/alexander/poly.log
#polybar --list-monitors >> /home/alexander/poly.log

# Terminate already running bar instances
killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

echo "Discovered: $(polybar --list-monitors)"

monitors=$(polybar --list-monitors | cut -d":" -f1)

if [ $monitors = "DP-2" ] ; then
    echo "Configuring single polybar for Ultrawide monitor"
    PBAR_HEIGHT='35' PBAR_DPI='109' TRAY='left' MONITOR='DP-2' polybar --reload bar1 &
else 
    echo "Configuring for multi-monitor setup"
    for m in $monitors ; do
        tray=
        if [ "$m" = "eDP-1" ]; then
            tray='left'
        fi
        TRAY=$tray MONITOR=$m polybar --reload bar1 &
    done
fi

echo "Bars launched..."
