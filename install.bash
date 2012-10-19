#!/bin/bash
echo -en "\e[00m"

#text modifications
GREEN="\e[1;32m"
LGREEN="\e[0;32m"
RED="\e[1;31m"
YEL="\e[0;33m"
CYAN="\e[0;36m"
CLEAN="\e[00m"

paths="`dirname $0`/paths"
files="`dirname $0`/files"
toInstall=""

doUninst=false
doCopy=false
doAll=false
doLink=false

printHelp(){
    echo "Install config files from $files to their specified paths from $files"
    echo "(Symbolic links to the files in the repo is the default action)"
    echo ""
    echo "Usage: $0 <action> [--all|-a] [--force|-f] [file1 [file2 ..]]"
    echo ""
    echo "Available actions:"
    printf "  %-12s    :  %s\n" "copy, c" "make hard copies of the file(s)"
    printf "  %-12s    :  %s\n" "help, h" "print this fine help text"
    printf "  %-12s    :  %s\n" "link, l" "install files as links"
    printf "  %-12s    :  %s\n" "list" "list available config files"
    printf "  %-12s    :  %s\n" "uninstall, u" "remove files/links"
    echo ""
}

listFiles(){
    for i in `ls "$files"`
    do
        state=""
        instPath="`cat $paths/$i.path`"
        instPath="`eval echo $instPath`"
        if [ -h $instPath ]; then
            if [ `readlink -fn "$instPath"` != `readlink -fn "$files/$i"` ]; then
                state="$RED Not installed $CYAN(wrong link)$CLEAN"
            else
                state="$GREEN Installed $CYAN(linked)$CLEAN"
            fi
        elif [ -f $instPath ]; then
            if [ -z "`diff "$instPath" "$files/$i"`" ]; then
                state="$GREEN Installed $YEL(hard-copy)$CLEAN"
            else
                state="$RED Not installed $LGREEN(exists)$CLEAN"
            fi
        else
            state="$RED Not installed$CLEAN"
        fi
        printf "%-30s :   " "$i" 
        echo -e "$state"
    done
}

#if no arguments exute default action
if [ $# -eq 0 ]; then
    listFiles
    exit
fi

#check action
case $1 in
    link|l)
        doLink=true
        ;;
    uninstall|u)
        doUninst=true
        ;;
    copy|c)
        doCopy=true
        ;;
    list)
        listFiles
        exit
        ;;
    help|h)
        printHelp
        exit
        ;;
    *)
        echo "Invalid action: $1"
        echo "-----"
        printHelp
        exit
        ;;
esac
shift

#fetch file arguments to perform on
for i in $*
do
    case $i in
        --all|-a)
            doAll=true
            ;;
        --force|-f)
            doUninst=true
            ;;
        *)
            if [ -f "$files/$i" ]; then
                toInstall="$toInstall $i"
            else
                echo "$i: No such config file."
                exit
            fi
            ;;
    esac
done

# if --all is given then add all files to toInstall
if $doAll; then
    toInstall=""
    for i in `ls $files`
    do
        toInstall="$toInstall $i"
    done
fi

# iterate over files and perform actions
for i in $toInstall
do
    instPath="`cat $paths/$i.path`"
    instPath="`eval echo $instPath`"

    #Uninstalling if specified
    if $doUninst; then
        msg=`rm -v "$instPath" 2>&1`
        echo "Removing $i: $msg"
    fi
        
    #Checking if file already exists

    if [ $doCopy -a -f $instPath ]; then 
        echo "Error - $i: $instPath already exists."
        exit

    #Copying
    elif $doCopy; then
        msg=`cp -v "$files/$i" "$instPath"`
        echo "Copying $i: $msg"

    #Linking
    elif $doLink; then
	    PWD=`pwd`
        abs="`readlink -fn "$PWD/$files/$i"`"
        msg=`ln -vs "$abs" "$instPath"`
        echo "Linking $i: $msg"
    fi
done


