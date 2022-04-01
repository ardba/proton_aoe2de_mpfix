#!/bin/bash
set -e # Fail fast

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

folder="/tmp/fix-aoe"
mkdir -p $folder && cd "$_"
echo "Fetching vc_redist.x64.exe"
wget https://download.microsoft.com/download/0/6/4/064F84EA-D1DB-4EAA-9A5C-CC2F0FF6A638/vc_redist.x64.exe
cabextract vc_redist.x64.exe
cabextract a10
cp ucrtbase.dll  /home/$SUDO_USER/.local/share/Steam/steamapps/compatdata/1493710/pfx/drive_c/windows/system32/ # This changes sometimes, depending on proton version?
echo "Copied dll"
rm -rf $folder
