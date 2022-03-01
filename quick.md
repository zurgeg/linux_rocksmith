# ALSA (quick and dirty)

## Create a clean wine prefix/compatdata

Go to `$STEAMLIBRARY/steamapps/compatdata` and delete or move `221680`.

Start Rocksmith and stop it again once it's running.

## Modify the prefix

You can either use `protontricks`, or `winetricks`

<details>
<summary>protontricks</summary>

```
protontricks 221680 audio=alsa
protontricks 221680 winecfg
```

</details>

<details>
<summary>winetricks</summary>

```
WINEPREFIX=$STEAMLIBRARY/steamapps/compatdata/221680/pfx winetricks audio=alsa
WINEPREFIX=$STEAMLIBRARY/steamapps/compatdata/221680/pfx winecfg
```

</details>

Once in winecfg, go to the Audio Tab.

* Leave both output devices on default.
* Select the desired input device for both inputs.

Hit "Apply" and "Ok".

## Disbale Input device for Pulse

Open `pavucontrol` ("PulseAudio Volume Control"), go to the configuration tab. Set the input device to "off".

## Disable exclusivity

Go to the root of your Rocksmith installation and open `Rocksmith.ini` with a text editor. Change the following lines:

* `ExclusiveMode=0`
* `Win32UltraLowLatencyMode=0`

## Run the game

Press "Play" in Steam. Have fun.
