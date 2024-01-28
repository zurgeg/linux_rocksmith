000-title-000

## Table of contents

1. [Install necessary stuff](#install-necessary-stuff)
1. [Create a clean prefix](#create-a-cean-prefix)
1. [wineasio](#wineasio)
1. [Installing RS_ASIO](#installing-rs_asio)
1. [Set up JACK](#set-up-jack)
1. [Starting the game](#starting-the-game)
1. [A bit of troubleshooting](#a-bit-of-troubleshooting)

# Install necessary stuff

(I recommend `wine-staging` if your distro has it, but usual `wine` works as well.)

000-install-part-000
# the groups should already exist, but just in case
sudo groupadd audio
sudo groupadd realtime
sudo usermod -aG audio $USER`
sudo usermod -aG realtime $USER`
```

Log out and back in. Or reboot, if that doesn't work.

<details><summary> How to check if this worked correctly</summary>

000-install-check-000
>
> For the groups, run `groups`. This will give you a list, which should contain "audio" and "realtime".
</details>

# Create a clean prefix

Delete or rename `$STEAMLIBRARY/steamapps/compatdata/221680`, then start Rocksmith and stop the game once it's running.

The rest will be set up later.

# wineasio

000-install-wineasio-system-000

To make Proton use wineasio, we need to copy these files into the appropriate locations:

```
# !!! WATCH OUT FOR VARIABLES !!!
cp 000-x32unix-000/wineasio32.dll.so "$PROTON/lib/wine/i386-unix/wineasio.dll.so"
cp 000-x64unix-000/wineasio64.dll.so "$PROTON/lib64/wine/x86_64-unix/wineasio.dll.so"
cp 000-x32windows-000/wineasio32.dll "$PROTON/lib/wine/i386-windows/wineasio.dll"
cp 000-x64windows-000/wineasio64.dll "$PROTON/lib64/wine/x86_64-windows/wineasio.dll"
```

In theory, this should also work with Lutris runners (located in `$HOME/.local/share/lutris/runners/wine/`)

To register wineasio (so that it can be used in the prefix), run the `wineasio-register` script that comes in the wineasio zip and set the `WINEPREFIX` to Rocksmiths.

```
env WINEPREFIX=$STEAMLIBRARY/steamapps/compatdata/221680/pfx ./wineasio-register
```

<details><summary> How to check if this worked correctly</summary>

> Download this: [VBAsioTest_1013.zip](https://download.vb-audio.com/Download_MT128/VBAsioTest_1013.zip)
>
> Extract it somewhere and run a command like this (replace the last path with the correct path that you chose):
> ```
> WINEPREFIX=$STEAMLIBRARY/steamapps/compatdata/221680/pfx $PROTON/bin/wine /path/to/VBASIOTest32.exe
> ```
>
</details>

## Installing RS_ASIO

1. [Download](https://github.com/mdias/rs_asio/releases) the newest release, unpack everything to the root of your Rocksmith installation (`$STEAMLIBRARY/steamapps/common/Rocksmith2014/`)
1. Edit RS_ASIO.ini: fill in `wineasio-rsasio` where it says `Driver=`. Do this for every Output and Input section.

## Set up JACK

000-jack-setup-000

# Starting the game

Delete the `Rocksmith.ini` inside your Rocksmith installation. It will auto-generate with the correct values. The only important part is the `LatencyBuffer=`, which has to match the Buffer Periods.

000-steam-running-required-000

If we start the game from the button that says "Play" in Steam, the game can't connect to wineasio (you won't have sound and will get an error message). There are two ways to go about this. You can apply both at the same time, they don't break each other.



<details><summary>1. LD_PRELOAD</summary>

* Advantages: Run from Steam directly
* Disadvantages: higher possibility of crashes, steps you might need to do every game-boot.

Add these launch options to Rocksmith:
```
LD_PRELOAD=/usr/lib32/libjack.so PIPEWIRE_LATENCY=256/48000 %command%
```

You can launch the game from Steam now. For the first few boot-ups, you have to remove window focus from Rocksmith (typically done with Alt+Tab) as soon as the window shows up. If it doesn't crash, continue with instructions.

Rocksmith might not have audio, however, if you don't get a message saying that there's no output device, RS_ASIO and JACK are working fine.

Open qpwgraph or a different JACK patchbay software of your choice. We want to connect microphones to the inputs of Rocksmith and two outputs to our actual output device. Rocksmith will sometimes crash when messing with the patchbay, so this is how you want to go about it:

1. Connect one device to Rocksmith
1. Window focus to Rocksmith
1. Go to step one, until you have connected everything

---

</details>

<details><summary>2. Start script, shortcut in Steam</summary>

* Advantage: Reliable one time setup
* Disadvantages: Another Steam game entry, or having to launch from terminal entirely

### Get the start script

In Steam, right click on Rocksmith and choose "Properties". Set the following launch options:

```
PROTON_LOG=1 PROTON_DUMP_DEBUG_COMMANDS=1 %command%
```

then start the game from Steam again. You will now have a script at `/tmp/proton_$USER/run` that represents the command Steam runs when starting the game. If we run this script, Rocksmith can start via Steam and have sound. (`PIPEWIRE_LATENCY="256/48000" /tmp/proton_$USER/run`)

Let's copy the script to somewhere else and give it a better name. This is an example that I will use in the rest of the guide. You can change the path or the name of the script, if you want to.

```
cp /tmp/proton_$USER/run $STEAMLIBRARY/steamapps/common/rocksmith-launcher.sh
```

!! If you switch Proton versions, regenerate this script !!

We can start the game via this script now: `PIPEWIRE_LATENCY="256/48000" $STEAMLIBRARY/steamapps/common/rocksmith-launcher.sh`

### Making it nice via Steam entry (optional, but recommended)

!! This currently doesn't work for me. Look below for an alternative route. !!

We can't start Rocksmith directly from the Steam Library. But we can use the Steam Library to start the script that starts the game in a way that Steam recognizes.

<details><summary>Fitting meme</summary>

![](https://i.kym-cdn.com/photos/images/original/002/546/187/fb1.jpg)

</details>

Go into your Steam Library and select "Add a game" -> "Add a Non-Steam Game" on the bottom left.

Make sure you can see all files. Select the script we generated just now and add it. This will create a shortcut to the script, which I will refer to as "shortcut" from here on. Right click on the shortcut and select "Properties". Add these launch Options: `PIPEWIRE_LATENCY="256/48000" %command%`

You can now start the game from Steam. Use the shortcut, it will launch the actual game.

---

Launching the script from Steam doesn't work for me right now. You can alternatively add a game in Lutris, which consists of starting this script as explained. Then in Lutris select "Create Steam shortcut".

This works because of how Lutris behaves when games are launched from Steam. All the Steam shortcut does is to notify Lutris to start a game. This is finished when Lutris received the message (= Steam sees it as "stopped"). Lutris then launches the game.

Important Settings:

* Runner: Linux
* Working Directory: The folder where your script is.
* Disable Lutris Runtime: true
* Environment Variables:
	* Name: PIPEWIRE_LATENCY
	* Value: 256/48000

### Beautification (even more optional, but recommended)

Leaving the shortcut just like that is not pretty, so we're going to change that.

You can give the games in your Steam Library a custom look. A good Website for resources is the [SteamGridDB](https://www.steamgriddb.com/).

You can take artwork from [Rocksmith](https://www.steamgriddb.com/game/1841), [Rocksmith 2014](https://www.steamgriddb.com/game/2295), [Rocksmith+](https://www.steamgriddb.com/game/5359161) or anything else you want. I would recommend something that makes the shortcut look different than the game.

**Name and icon:** Go into the shortcut's Properties. Right under the text "Shortcut" you can change the game's icon and name (both show up in the list on the left in desktop mode). I recommend something like "Rocksmith 2014 - Launcher".

**"Hero (banner/background)":** Located above the "Play" button in Steam. Right-click on it and choose "set custom background". You can theoretically set a logo too by right-clicking on the text, but I personally chose not to do that to clearly see which item is which.

**Grid (cover art):** For this it gets a bit harder. Go to `$HOME/.steam/steam/userdata/<number>/config/grid`. Since we added a hero, there should be a file that resembles it, so find it with an image viewer. It's called `<id>_hero.<file-ending>` we need the ID.
copy the cover art into this folder and name it `<id>p.<file-ending>`.

This is how the file structure looks on my system:

![](/img/grid-file.png)

Launch Big Picture Mode now and find the entry in your Library. It should now have artwork.

---

</details>

# A bit of troubleshooting

If some commands don't work, make sure you've set the variables.

## Game crashes

Can happen sometimes when you use a different application, then focus Rocksmith again. Other than that:

* First off, if the game crashes at the start, try two more times. Sometimes it was just random.
* Keep Pavucontrol (or whatever you used) open while starting/playing - I can't really tell why, but it helps a lot
* **Use onboard audio:** I use a seperate sound card (Shows up as "CM106") that creates issues. I don't have to unplug it, but just use the audio built into the mainboard. RealTone Cable works fine btw.
* **Focus away:** If you use pipewire and the game crashes right after the window shows up, you could try taking the focus to another window as quick as possible. It helps sometimes, but isn't reliable
* **Patch bay:** (Meaning: Changes with something like qpwgraph or Catia.) The game doesn't like these changes too much. You might get away with 1-2, but this is a bit luck-based.
* **Disable Big Picture:** I think this was an issue for me at one point. I would do it just to be sure.
* **Start from terminal:** This gives you more info on what's going on. Launch the script from the terminal or
* **Try the old approach:** This is not meant to be used for playing anymore, but it's a reliable way to get the game running: `PIPEWIRE_LATENCY=256/48000 WINEPREFIX=$STEAMLIBRARY/steamapps/compatdata/221680/pfx $PROTON/bin/wine $STEAMLIBRARY/steamapps/common/Rocksmith2014/Rocksmith2014.exe`

## WineASIO

This is a handy debugging tool (that I've also [used in the past](https://github.com/theNizo/linux_rocksmith/issues/22#issuecomment-1276457128)]): https://forum.vb-audio.com/viewtopic.php?t=1204

You can get verbose output of wineasio by using `/usr/bin/pw-jack -v -s 48000 -p 256 %command%`. -v stands for "verbose" and will give you additional information in the terminal.

## CDLC

* Make sure your game is patched for it. Since it's now an .exe, add that to your Steam Library and run it with Proton.
* In the past, we had to set the working directory to the root of the game's folder. This would either be done in the script, in the properties of the shortcut, or in the terminal via `cd`.
