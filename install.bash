#!/bin/bash

paths="`dirname $0`/paths"
files="`dirname $0`/files"
toInstall=""
doUninst=false
doCopy=false

printHelp(){
    echo "Install config files from $files to their specified paths from $files"
    echo "(Symbolic links to the files in the repo is the default action"
    echo ""
    echo "Usage: $0 <action> [file1 [file2 ..]]"
    echo "--help        : print this fine help text"
    echo "--copy        : make hard copies of the files"
    echo "--uninstall   : remove files/links"
    echo "--list        : list available config files"
    echo ""
}

listFiles(){
    echo `ls $files`
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
        msg=`ln -vs "$files/$i" "$instPath"`
        echo "Linking $i: $msg"
    fi
done


