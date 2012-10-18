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

printHelp(){
    echo "Install config files from $files to their specified paths from $files"
    echo "(Symbolic links to the files in the repo is the default action"
    echo ""
    echo "Usage: $0 <action> [file1 [file2 ..]]"
    echo "--help        : print this fine help text"
    echo "--copy        : make hard copies of the files"
    echo "--uninstall   : remove files/links"
    echo "--all         : perfom on all"
    echo "--list        : list available config files"
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

for i in $*
do
    case $i in
        --uninstall)
            doUninst=true
        ;;
        --copy)
            doCopy=true
        ;;
        --all)
            doAll=true
        ;;
        --list)
            listFiles
            exit
        ;;
        --help|-h)
            printHelp
            exit
        ;;
        *)
            if [ -f "$files/$i" ]; then
                toInstall="$toInstall $i"
            else
                echo "$i: No such config file."
                exit
            fi
    esac
done

#Check that then options don't contradict
if $doCopy && $doUninst; then
    echo "Contradicting actions, copy and uninstall."
    exit
fi

if $doAll; then
    toInstall=""
    for i in `ls $files`
    do
        toInstall="$toInstall $i"
    done
fi

for i in $toInstall
do
    instPath="`cat $paths/$i.path`"
    instPath="`eval echo $instPath`"

    #Uninstalling if specified
    if $doUninst; then
        msg=`rm -v "$instPath" 2>&1`
        echo "Removing $i: $msg"
        
    #Checking if file already exists
    elif [ -f $instPath  -o -h $instPath ]; then
        echo "$i: $instPath already exists."
        exit

    #Copying
    elif $doCopy; then
        msg=`cp -v "$files/$i" "$instPath"`
        echo "Copying $i: $msg"

    #Linking
    else
	    PWD=`pwd`
        abs="`readlink -fn "$PWD/$files/$i"`"
        msg=`ln -vs "$abs" "$instPath"`
        echo "Linking $i: $msg"
    fi
done


