#!/bin/bash

cli="$HOME/.local/bin/spotifycli"

printStatus(){
    playstatus=`$cli --playbackstatus`
    status=`$cli --status`

    echo "$playstatus  $status"
}

leftClick(){
    status=`$cli --status 2>&1 > /dev/null`

    if [ "$status" = "Spotify is off" ] ; then
        spotify &
    else
        $cli --playpause
        printStatus
    fi
}

command=$1
if [ -z $command ] ; then
    echo "spotify-status: no command given"
    exit 0
fi

case $command in
    status)
        printStatus
        ;;
    left-click)
        leftClick
        ;;
    *)
        echo "spotify-status: unknown command $command"
        ;;
esac

