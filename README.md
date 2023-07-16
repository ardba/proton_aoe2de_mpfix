# Multiplayer fix for AoE 2: DE
This script checks if ucrtbase.dll is installed for AoE2: DE then installs it if necessary. To run automatically before launching AoE, set your Steam launch options to

```
location/of/script/run.sh ; %command% %steam_location%
```

for example, if you cloned the repo to your $HOME directory,

```
~/proton_aoe2de_mpfix/run.sh ; %command% %steam_location%
```

if %steam_location% is not set, the script will default to /home/$USER/.local/share

## Usage

```
Usage: ./run.sh [OPTIONS]...
Small script containing Multiplayer fix for AOE2 Definitive Edition.

Options:
    -h, --help                    print this text and exit
    -l, --steam-location <PATH>   path to your Steam installation
    -f, --force                   forcefully repatch AOE2DE
```

## Dependencies
- cabextract
- wget
- jq (optional, required to automatically fetch Steam App ID)
