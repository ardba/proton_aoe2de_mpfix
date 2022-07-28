#!/bin/bash
set -e # Fail fast

# check if we got an argument
if [ $# -eq 0 ]; then
# set STEAM_LOCATION to the provided argument
	STEAM_LOCATION="$1"
# else set STEAM_LOCATION to default
else
	STEAM_LOCATION="/home/$USER/.local/share"
fi
SYSTEM32_LOCATION=$STEAM_LOCATION/Steam/steamapps/compatdata/813780/pfx/drive_c/windows/system32
# Check if the dll already exists and is not a symlink
if [ -f "$SYSTEM32_LOCATION/ucrtbase.dll" ] && [ ! -L "$SYSTEM32_LOCATION/ucrtbase.dll" ]; then
    echo "ucrtbase.dll is already installed"
    exit 0
fi

rm -f $SYSTEM32_LOCATION/ucrtbase.dll # There might be a simlink to the "default" ucrtbase.dll, it needs to be deleted

tempFolder=$(mktemp --directory)
cd ${tempFolder}
echo "Fetching vc_redist.x64.exe"
wget https://download.microsoft.com/download/0/6/4/064F84EA-D1DB-4EAA-9A5C-CC2F0FF6A638/vc_redist.x64.exe
cabextract vc_redist.x64.exe --filter a10
cabextract a10 --filter ucrtbase.dll
cp ucrtbase.dll $SYSTEM32_LOCATION
echo "Copied ucrtbase.dll"
rm -f vc_redist.x64.exe a10 ucrtbase.dll
rmdir ${tempFolder}

exit 0
