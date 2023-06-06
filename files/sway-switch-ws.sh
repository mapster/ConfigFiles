#!/bin/bash
IS_NUMBER='^[0-9]+$'

add=0
case $1 in
    next)
        add=1
        ;;
    prev)
        add=-1
        ;;
esac


current_ws="$(swaymsg -t get_workspaces | jq '.. | try select(.focused == true) | .num')"


if [[ $current_ws =~ $IS_NUMBER ]] ; then
    next_ws="$((current_ws + add))"

    if [ $next_ws -gt 10 ] ; then
        swaymsg workspace 1
    elif [ $next_ws -lt 1 ] ; then
        swaymsg workspace 10
    else
        swaymsg workspace $next_ws
    fi
fi
