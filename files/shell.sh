#!/bin/bash

CWD=''
ID=$(xdpyinfo | grep focus | cut -f4 -d " ")
PID=$(xprop -id $ID | grep -m 1 PID | cut -d " " -f 3) 

if [ -n "$PID" ] ; then
    TREE=$(pstree -lpA $PID | tail -n 1)
    PID=$(echo $TREE | awk -F'---' '{print $NF}' | sed -re 's/[^0-9]//g')

    if [ -e "/proc/$PID/cwd" ]; then
        CWD=$(readlink "/proc/$PID/cwd")
    fi
fi
if [ -n "$CWD" ]; then
    i3-sensible-terminal -cd $CWD &
else
    i3-sensible-terminal &
fi
