# JACK to ASIO with pipewire on Debian-based distros

I don't have a debian-based machine to test this. Everything up to starting the game was tested in a VM.

## Table of contents

1. [Install necessary stuff](#install-necessary-stuff)
1. [wineasio](#wineasio)
1. [Setting up the game's prefix/compatdata](#setting-up-the-games-prefixcompatdata)
1. [Installing RS_ASIO](#installing-rs_asio)
1. [Set up JACK](#set-up-jack)
1. [Starting the game](#starting-the-game)
1. [Command (No Lutris)](#command-no-lutris)
1. [Yes Lutris](#yes-lutris)

# Install necessary stuff

(I recommend `wine-staging`, but usual `wine` works as well.)

[missing, sorry]

```
[missing, sorry]
# the groups should already exist, but just in case
sudo groupadd audio
sudo groupadd realtime
sudo usermod -aG audio $USER`
sudo usermod -aG realtime $USER`
```

Log out and back in.

<details><summary> How to check if this worked correctly</summary>


	For the groups, run `groups`. This will give you a list, which should contain "audio" and "realtime".
</details>

# wineasio



To make Proton use wineasio, we need to copy these files into the appropriate locations:

```
# !!! WATCH OUT FOR VARIABLES !!!
cp /usr/lib/i386-linux-gnu/wine/wineasio.dll.so "$PROTON/lib/wine/i386-unix/wineasio.dll.so"
cp /usr/lib/x86_64-linux-gnu/wine/wineasio.dll.so "$PROTON/lib64/wine/x86_64-unix/wineasio.dll.so"
cp /usr/lib/i386-linux-gnu/wine/wineasio.dll "$PROTON/lib/wine/i386-windows/wineasio.dll"
cp /usr/lib/x86_64-linux-gnu/wine/wineasio.dll "$PROTON/lib64/wine/x86_64-windows/wineasio.dll"
```

In theory, this should also work with Lutris runners (located in `$HOME/.local/share/lutris/runners/wine/`)

## Setting up the game's prefix/compatdata

1. Delete or rename `$STEAMLIBRARY/steamapps/compatdata/221680`, then start Rocksmith and stop the game once it's running.
1. `WINEPREFIX=$STEAMLIBRARY/steamapps/compatdata/221680/pfx regsvr32 /usr/lib/i386-linux-gnu/wine/wineasio.dll` (Errors are normal, should end with "regsvr32: Successfully registered DLL [...]")

I don't know a way to check if this is set up correctly. This is one of the first steps I'd redo when I have issues.

## Installing RS_ASIO

[Download](https://github.com/mdias/rs_asio/releases) the newest release, unpack everything to the root of your Rocksmith installation (`$STEAMLIBRARY/steamapps/common/Rocksmith2014/`)

Edit RS_ASIO.ini: fill in `WineASIO` where it says `Driver=`. Do this for `[Asio.Output]` and `[Asio.Input.0]`. If you don't play multiplayer, you can comment out Input1 and Input2 by putting a `;` in front of the lines.

## Set up JACK

What we basically need to do is to select only one output and one input (2 inputs for multiplayer). I like to do this via `pavucontrol`, which works if `pipewire-pulse` is installed.

Open pavucontrol ("PulseAudio Volume Control"), go to "Configuration" and make sure there's exactly one input device and one output device enabled.

All available devices will automatically be tied to Rocksmith, and the game doesn't like you messing around in the patchbay (= it would crash often).

## Starting the game

Delete the `Rocksmith.ini` inside your Rocksmith installation. It will auto-generate with the correct values. The only important part is the `LatencyBuffer=`, which has to match the Buffer Periods.

Steam needs to be running.

If we start the game from the button that says "Play" in Steam, the game cant connect to wineasio (you won't have sound and will get an error message). However, running it from the terminal, or running a script, always made it work.

## Get the start script

In Steam, right click on Rocksmith and choose "Properties". Set the following launch options:

```
PROTON_LOG=1 PROTON_DUMP_DEBUG_COMMANDS=1 %command%
```

then start the game from Steam again. You will now have a script at `/tmp/proton_$USER/run` that represents the command Steam runs when starting the game. If we run this script, Rocksmith can start via Steam and have sound.

Let's copy the script to somewhere else and give it a better name. This is an example that I will use in the rest of the guide. You can change the path or the name of the script, if you want to.

```
cp /tmp/proton_$USER/run $STEAMLIBRARY/steamapps/common/rocksmith-launcher.sh
```

We can start the game via this script now: `PIPEWIRE_LATENCY="256/48000" $STEAMLIBRARY/steamapps/common/rocksmith-launcher.sh`

## Making it nice via Steam entry (optional)

We can't start Rocksmith directly from the Steam Library. But we can use the Steam Library to start the script that starts the game in a way that Steam recognizes.

<details><summary>Fitting meme</summary>

![](https://i.kym-cdn.com/photos/images/original/002/546/187/fb1.jpg)

</details>

Go into your Steam Library and select "Add a game" -> "Add a Non-Steam Game"
Make sure you can see all files. Select the script we generated just now and add it. This will create a shortcut to the script, which I will refer to as "shortcut" from here on.
Right click on the shortcut and select "Properties". Add these launch Options: `PIPEWIRE_LATENCY="256/48000" %command%`

`PIPEWIRE_LATENCY`: Rocksmith needs a sample rate of 48000. 256 refers to the buffer size. This number worked great for me, but you can experiment with others, of course.

You can now start the game from Steam. Use the shortcut, it will launch the actual game.

### Beautification (even more optional, but recommended)

Leaving the shortcut just like that is not pretty, so we're going to change that.

You can give the games in your Steam Library a custom look. A good Website for resources is the [SteamGridDB](https://www.steamgriddb.com/).

You can take artwork from [Rocksmith](https://www.steamgriddb.com/game/1841), [Rocksmith 2014](https://www.steamgriddb.com/game/2295), [Rocksmith+](https://www.steamgriddb.com/game/5359161) or anything else you want. I would recommend something that makes the shortcut look different than the game.

Go into the shortcuts Properties. Right under the text "Shortcut" you can change the game's icon and name (both show up in the list in desktop mode). I recommend something like "Rocksmith 2014 - Launcher".

Above the "Play" button in Steam, there's artwork called the "hero". Right-click on it and choose "set custom background".

For the cover art ("grid"), it gets a bit harder. Go to `$HOME/.steam/steam/userdata/<number>/config/grid`. Since we added a hero, there should be a file that resembles it. It's called `<id>_hero.<file-ending>` we need the ID.
copy the cover art into this folder and name it <id>p.<file-ending>.

This is how it looks on my system:

![](/img/grid-files.png)

Launch Big Picture Mode now and find the entry in your Library. It should now have artwork.

# Small Troubleshooting: The game crashes

## Immediately

When I first tried to set the game up with pipewire, I experienced this.
The solution was the following:

1. Start game
1. As soon as you see the window, take the focus away from it. Focus a different window. Do that as quick as possible. When testing, I needed two tries.
1. If you run it from terminal, wait until logs start to appear.
1. Otherwise, wait a few seconds (10-20), or if you can see the window, wait until the bootup logos show up. Sometimes you will hear sound when unfocussed, sometimes not.
1. Focus the game again

## When messing with Patchbay

Rocksmith doesn't like the patchbay being tampered with very much. It might crash on you if you try something like this.

## When Focussing on the window again

Also, unfocussing and focussing again has the risk of the game crashing too. It won't always crash, but the possibility is high enough to notice.

---

Note to self, adjust this guide for two-player setup as well (which pretty much consists of setting 2 inputs everywhere)
