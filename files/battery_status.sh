#!/bin/bash

export DISPLAY=:0.0
export XAUTHORITY=$HOME/.Xauthority

BATTERY_SYS_PATH="/sys/class/power_supply"
HALF_THRESHOLD=0.5
LOW_THRESHOLD=0.12
CRIT_THRESHOLD=0.07
BATTERY="$BATTERY_SYS_PATH/$1"

printHelp(){
    echo "Notify about battery status."
    echo ""
    echo "Usage: $0 <battery> <level>"
    echo ""
    echo "<battery> is any batteries in $BATTERY_SYS_PATH and is expected to have energy_now and energy_full."
    echo "<level> is either half, low or critical"
    echo ""
    echo "Recommended crontab:"
    echo "*/60 * * * * $HOME/.bin/battery_status BAT0 half"
    echo "*/5 * * * * $HOME/.bin/battery_status BAT0 low"
    echo "*/1 * * * * $HOME/.bin/battery_status BAT0 critical"
}

if [ $# -lt 2 ] ; then
    echo "Too few arguments."
    echo "-------"
    printHelp
    exit 1
fi

if [ ! -d $BATTERY ] ; then
    echo "Battery not found: $BATTERY"
    echo "------"
    printHelp
    exit 1
fi

if [ ! -f $BATTERY/energy_now -o ! -f $BATTERY/energy_full ] ; then
    echo "energy_now or energy_full files not found in: $BATTERY"
    echo "------"
    printHelp
    exit 1
fi

if [[ ! "$2" =~ ^half|low|critical$ ]] ; then
    echo "<level> must be half, low or critical: $2"
    echo "------"
    printHelp
    exit 1
fi

if [[ "$(cat $BATTERY/status)" == "Charging" ]] ; then
    echo "Battery is charging, won't notify."
    exit 0
fi

level="$2"

now=`cat $BATTERY/energy_now`
full=`cat $BATTERY/energy_full`
remaining=`echo "$now/$full" | bc -l`

upper_threshold=$HALF_THRESHOLD
lower_threshold=$LOW_THRESHOLD
urgency="low"

if [ $level = "low" ] ; then
    upper_threshold=$LOW_THRESHOLD
    lower_threshold=$CRIT_THRESHOLD
    urgency="normal"
elif [ $level = "critical" ] ; then
    upper_threshold=$CRIT_THRESHOLD
    lower_threshold=0
    urgency="critical"
fi

is_in_level=`echo "$remaining < $upper_threshold && $remaining >= $lower_threshold" | bc -l`

if [ "$is_in_level" = '1' ] ; then
    percent=`echo "scale=0; ($remaining * 100)/1" | bc -l`
    text="Battery is at $level capacity: $percent%"
    notify-send -u $urgency "$text"
fi


