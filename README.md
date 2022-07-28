# Multiplayer fix for AoE 2: DE
This script checks if ucrtbase.dll is installed for AoE2: DE then installs it if necessary. To run automatically before launching AoE, set your Steam launch options to

```
location/of/script/run.sh ; %command%
```

for example, if you cloned the repo to your $HOME directory,

```
~/proton_aoe2de_mpfix/run.sh ; %command%
```

You can pass an argument to the script to specify the location of steam on your device (default:/home/$USER/.local/share )

## Dependencies
- cabextract
- wget
