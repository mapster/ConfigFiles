#!/bin/bash
#
# Attempts to find current directory of the focused shell

if [ $# -ne 2 ]; then
    echo "Requires two arguments; terminal-command and working directory option"
    exit 1
fi

CWD=''
PID=$(swaymsg -t get_tree | jq -r '..|try select(.focused == true)|.pid')

if [ -n "$PID" ] ; then
    TREE=$(pstree -lpA $PID | head -n 1)
    PID=$(echo $TREE | sed -re 's/-[\+-]-/\n/g' | grep -E 'zsh|bash' | tail -n 1 | sed -re 's/[^0-9]//g')

    if [ -e "/proc/$PID/cwd" ]; then
        CWD=$(readlink "/proc/$PID/cwd")
    fi
fi
if [ -n "$CWD" ]; then
    $1 $2 $CWD &
else
    $1 &
fi

echo $CWD
