#!/bin/bash
set -e # Fail fast

# Check if jq is installed, then fetch the App ID if it is
if command -v jq &> /dev/null
then
    APPID=$(wget -qO- https://api.steampowered.com/ISteamApps/GetAppList/v2/ | jq '.applist.apps[] | select(.name=="Age of Empires II: Definitive Edition")' | jq ".appid")
else
    APPID=813780 # The most recent App ID when this was written
fi

STEAM_LOCATION="/home/$USER/.steam/steam"

# check if arguments are not empty
if [ ! $# -eq 0 ]; then
    # set STEAM_LOCATION to the provided argument
    STEAM_LOCATION=$1
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
    break
  fi
done;

# Check if the dll already exists and is not a symlink
if [ -f "$SYSTEM32_LOCATION/ucrtbase.dll" ] && [ ! -L "$SYSTEM32_LOCATION/ucrtbase.dll" ]; then
    echo "ucrtbase.dll is already installed"
    exit 0
fi

rm -f $SYSTEM32_LOCATION/ucrtbase.dll # There might be a simlink to the "default" ucrtbase.dll, it needs to be deleted

TEMP_FOLDER=$(mktemp --directory)
cd $TEMP_FOLDER
echo "Fetching vc_redist.x64.exe"
wget https://download.microsoft.com/download/0/6/4/064F84EA-D1DB-4EAA-9A5C-CC2F0FF6A638/vc_redist.x64.exe
cabextract vc_redist.x64.exe --filter a10
cabextract a10 --filter ucrtbase.dll
cp ucrtbase.dll $SYSTEM32_LOCATION
echo "Copied ucrtbase.dll"
rm -f vc_redist.x64.exe a10 ucrtbase.dll
rmdir $TEMP_FOLDER

exit 0
