#!/bin/bash
set -e

rm -f /tmp/screen.png
scrot /tmp/screen.png
convert /tmp/screen.png -scale 5% -scale 2000% /tmp/screen.png
[[ -f ~/.i3/lock-icon.png ]] && convert /tmp/screen.png ~/.i3/lock-icon.png -gravity center -composite -matte /tmp/screen.png
i3lock -i /tmp/screen.png
