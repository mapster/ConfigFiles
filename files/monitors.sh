#!/bin/bash

MODES_PATH=$HOME/.screenlayout

listModes() {
    echo `/usr/bin/ls $MODES_PATH`
}

describeModes() {
    printf "%-30s    :    %s\n" "<name>" "<description>"
    echo "----------------------------------------------------"
    for m in `listModes` ; do
        all="`$MODES_PATH/$m describe`"
        name=`echo "$all" | cut -d ";" -f 1`
        desc=`echo "$all" | cut -d ";" -f 2`
        printf "%-30s    :    %s\n" "$name" "$desc"
    done
}

printHelp(){
    echo "Setup monitors using xrandr to predefined modes."
    echo ""
    echo "Usage: $0 <mode>"
    echo ""
    echo "Available modes:"
    echo ""
    describeModes
    echo ""
}

changeMode() {
   for m in `listModes` ; do
       all=`$MODES_PATH/$m describe`
       name=`echo "$all" | cut -d ";" -f 1`
       if [ "$name" = "$1" ] ; then
           echo "Switching to $name"
           /bin/sh $MODES_PATH/$m
           exit
       fi
   done
   echo "Error: No such mode $1"
}


if [ $# -lt 1 ]; then
    echo "No selections given."
    exit
fi

case $1 in
    help)
        printHelp
        exit
        ;;
    *)
        changeMode $1
        ;;
esac

nitrogen --restore
