#!/bin/bash
set -e # Fail fast

# Arguments
USAGE=0
STEAM_LOCATION="/home/$USER/.steam/steam"
FORCE=0
VCREDIST_LOCATION=""

usage() {
    cat <<- _end_of_usage
	Usage: $0 [OPTIONS]...
	Small script containing Multiplayer fix for AOE2 Definitive Edition.

	Options:
	    -h, --help                    print this text and exit
	    -l, --steam-location <PATH>   path to your Steam installation
	    -f, --force                   forcefully repatch AOE2DE
	_end_of_usage

    exit 0
}

get_args() {
    while [ $# -ne 0 ]
    do
        case "$1" in
        "-h"|"--help")            USAGE=1;;
        "-l"|"--steam-location")  STEAM_LOCATION=$2; shift;;
        "-f"|"--force")           FORCE=1; shift;;
        *)  echo "Unkown argument $1! See --help." 1>&2;;
        esac
        shift
    done
}

patch() {
    # Check if jq is installed, then fetch the App ID if it is
    if command -v jq &> /dev/null
    then
        APPID=$(wget -qO- https://api.steampowered.com/ISteamApps/GetAppList/v2/ | jq '.applist.apps[] | select(.name=="Age of Empires II: Definitive Edition")' | jq ".appid")
    else
        APPID=813780 # The most recent App ID when this was written
    fi

    libraries=$(grep 'path' $STEAM_LOCATION/steamapps/libraryfolders.vdf | sed -re 's/^(\s)+"path"(\s)+"(.*)"$/\3/g')

    echo "Found steam library locations:"
    for library in $libraries; do
        echo " * $library"
    done

    for library in $libraries; do
        SYSTEM32_LOCATION="$library/steamapps/compatdata/$APPID/pfx/drive_c/windows/system32"

        if [ -d "$SYSTEM32_LOCATION" ]; then
            echo "Found app in: $SYSTEM32_LOCATION"
            VCREDIST_LOCATION="$library/steamapps/common/AoE2DE/vc_redist.x64.exe"
            break
        fi
    done;

    # Check if the dll already exists and is not a symlink
    if [ -f "$SYSTEM32_LOCATION/ucrtbase.dll" ] && [ ! -L "$SYSTEM32_LOCATION/ucrtbase.dll" ]; then
        echo "ucrtbase.dll is already installed"
        [ $FORCE -eq 0 ] && exit 0
        echo "Forcing patch anyway..."
    fi
    
    rm -f $SYSTEM32_LOCATION/ucrtbase.dll # There might be a simlink to the "default" ucrtbase.dll, it needs to be deleted

    TEMP_FOLDER=$(mktemp --directory)
    cd $TEMP_FOLDER
    
    # Download vc_redist only if we don't already have it
    if [ -n "$VCREDIST_LOCATION" ] && [ -f "$VCREDIST_LOCATION" ]; then
        cp "$VCREDIST_LOCATION" .
    else
        echo "Fetching vc_redist.x64.exe"
        wget https://download.microsoft.com/download/0/6/4/064F84EA-D1DB-4EAA-9A5C-CC2F0FF6A638/vc_redist.x64.exe
    fi
    cabextract vc_redist.x64.exe --filter a10
    cabextract a10 --filter ucrtbase.dll
    cp ucrtbase.dll $SYSTEM32_LOCATION
    echo "Copied ucrtbase.dll"
    rm -f vc_redist.x64.exe a10 ucrtbase.dll
    rmdir $TEMP_FOLDER
}

get_args "$@"
[ $USAGE -eq 1 ] && usage
patch
