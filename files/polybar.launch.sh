#!/bin/bash

# Terminate already running bar instances
killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

for m in $(polybar --list-monitors | cut -d":" -f1); do
    tray=
    if [ "$m" = "eDP-1" ]; then
        tray='left'
    fi
    TRAY=$tray MONITOR=$m polybar --reload bar1 &
done

echo "Bars launched..."
