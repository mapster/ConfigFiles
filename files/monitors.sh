#!/bin/bash

office=false
standalone=false

printHelp(){
    echo "Setup monitors using xrandr to predefined modes."
    echo ""
    echo "Usage: $0 <mode>"
    echo ""
    echo "Available modes:"
    printf "%-12s   :   %s\n" "office" "LVDS1 off, VGA1 auto left, HDMI1 auto right"
    printf "%-12s   :   %s\n" "standalone" "LVDS1 off, VGA1 and HDMI1 off"
    printf "%-12s   :   %s\n" "help" "print this fine help text"
    echo ""
}


if [ $# -lt 1 ]; then
    echo "No selections given."
    exit
fi

case $1 in
    office|o*)
        echo "Office mode selected."
        office=true
        ;;
    standalone|s*)
        echo "Standalone mode selected."
        standalone=true
        ;;
    help|h*)
        printHelp
        exit
        ;;
    *)
        echo "Not a valid mode."
        echo "---"
        printHelp
        exit
        ;;
esac

if $office; then
    /usr/bin/xrandr --output VGA1 --auto
    /usr/bin/xrandr --output LVDS1 --off
    /usr/bin/xrandr --output HDMI1 --auto --right-of VGA1
elif $standalone; then
    /usr/bin/xrandr --output VGA1 --off
    /usr/bin/xrandr --output LVDS1 --auto
    /usr/bin/xrandr --output HDMI1 --off
fi
