# JACK to ASIO on Steam Deck (pipewire)

(Thanks to [BWagener](https://github.com/BWagener) for writing this.)

(I (Nizo) don't own a Steam deck, but am the only maintainer currently. I therefore rely on reports of other people and try to keep this up to date as best as possible.)

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

Note: Install qpwgraph through Discover (Discover comes preinstalled on Steam Deck)

```
# disable readonly mode
sudo steamos-readonly disable

sudo pacman-key --init
sudo pacman-key --populate archlinux

sudo pacman -S realtime-privileges wine-staging
# These packages are already on SteamOS so I did not install them:
# pipewire-alsa pipewire-pulse pipewire-jack lib32-pipewire-jack pavucontrol
# the groups should already exist, but just in case
sudo groupadd audio
sudo groupadd realtime
sudo usermod -aG audio $USER`
sudo usermod -aG realtime $USER`
```

Log out and back in. Or reboot, if that doesn't work.

<details><summary> How to check if this worked correctly</summary>

> For the packages, do `pacman -Q package-name`. (You can do multiple at once) Should output the names and versions without errors.
>
> For the groups, run `groups`. This will give you a list, which should contain "audio" and "realtime".
</details>

# Create a clean prefix

Delete or rename `$STEAMLIBRARY/steamapps/compatdata/221680`, then start Rocksmith and stop the game once it's running.

The rest will be set up later.

# wineasio

Installing `base-devel` is very useful for using the AUR and compiling in general.

On SteamOS the following additional packages were required to compile wineasio:

```
sudo pacman -S base-devel glibc linux-headers linux-api-headers libtool binutils lib32-glibc
# note about these two packages: they are in conflict with lib32-pipewire-jack pipewire-jack
# pacman can remove these packages for you and we can reinstall them once wineasio is compiled
sudo pacman -S lib32-jack2 jack2
```

<details><summary>Know already what's going on? Here are all commands in one piece without an explanation</summary>

> If the commands in this collapsible section don't work for you, try the "longer" variant first before asking for help.
>
> YOU NEED TO HAVE THE $PROTON AND $STEAMLIBRARY VARIABLE SET!! (or replaced with the correct path first)
>
> cd into the unpacked directory, then run this.
>
> ```
> rm -rf build32
> rm -rf build64
> make 32
> make 64
> sudo cp build32/wineasio32.dll /usr/lib32/wine/i386-windows/wineasio32.dll
> sudo cp build32/wineasio32.dll.so /usr/lib32/wine/i386-unix/wineasio32.dll.so
> sudo cp build64/wineasio64.dll /usr/lib/wine/x86_64-windows/wineasio64.dll
> sudo cp build64/wineasio64.dll.so /usr/lib/wine/x86_64-unix/wineasio64.dll.so
> cp build32/wineasio32.dll "$PROTON/lib/wine/i386-windows/wineasio32.dll"
> cp build32/wineasio32.dll.so "$PROTON/lib/wine/i386-unix/wineasio32.dll.so"
> cp build64/wineasio64.dll "$PROTON/lib64/wine/x86_64-windows/wineasio64.dll"
> cp build64/wineasio64.dll.so "$PROTON/lib64/wine/x86_64-unix/wineasio64.dll.so"
> env WINEPREFIX=$STEAMLIBRARY/steamapps/compatdata/221680/pfx ./wineasio-register
> ```
>
> And you're done, continue with [Installing RS_ASIO](#installing-rs_asio).
>
</details>

The official source for wineasio is [wineasio/wineasio](https://github.com/wineasio/wineasio). If the official one doesn't work, clone the fixed version from here: https://github.com/BWagener/wineasio.git

[Download](https://github.com/wineasio/wineasio/releases) the newest zip and unpack it. Open a terminal inside the newly created folder and run the following commands:

<details><summary>[How to] Clone instead of downloading:</summary>

> (No support for this way, as release package is easier to replicate.)
>
> ```
> git clone --recursive https://github.com/wineasio/wineasio.git
> cd wineasio
> ```
>

</details>



```
# build
rm -rf build32
rm -rf build64
make 32
make 64

# Install on normal wine
sudo cp build32/wineasio32.dll /usr/lib32/wine/i386-windows/wineasio32.dll
sudo cp build32/wineasio32.dll.so /usr/lib32/wine/i386-unix/wineasio32.dll.so
sudo cp build64/wineasio64.dll /usr/lib/wine/x86_64-windows/wineasio64.dll
sudo cp build64/wineasio64.dll.so /usr/lib/wine/x86_64-unix/wineasio64.dll.so
```



`wineasio` is now installed on your system.

<details><summary>How to check if it's installed correctly</summary>

> 	find /usr/lib32/ -name "wineasio*"
> 	find /usr/lib/ -name "wineasio*"
>
> This should output 4 paths (ignore the errors).
>
</details>

To make Proton use wineasio, we need to copy these files into the appropriate locations:

```
# !!! WATCH OUT FOR VARIABLES !!!
cp /usr/lib32/wine/i386-unix/wineasio32.dll.so "$PROTON/lib/wine/i386-unix/wineasio32.dll.so"
cp /usr/lib/wine/x86_64-unix/wineasio64.dll.so "$PROTON/lib64/wine/x86_64-unix/wineasio64.dll.so"
cp /usr/lib32/wine/i386-windows/wineasio32.dll "$PROTON/lib/wine/i386-windows/wineasio32.dll"
cp /usr/lib/wine/x86_64-windows/wineasio64.dll "$PROTON/lib64/wine/x86_64-windows/wineasio64.dll"
```

In theory, this should also work with Lutris runners (located in `$HOME/.local/share/lutris/runners/wine/`)

To register wineasio (so that it can be used in the prefix), run the `wineasio-register` script and set the `WINEPREFIX` to Rocksmiths.

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

[Download](https://github.com/mdias/rs_asio/releases) the newest release, unpack everything to the root of your Rocksmith installation (`$STEAMLIBRARY/steamapps/common/Rocksmith2014/`)

Edit RS_ASIO.ini: fill in `wineasio-rsasio` where it says `Driver=`. Do this for every Output and Input section.

## Set up JACK

What we basically need to do is to select only one output and one input (2 inputs for multiplayer). I like to do this via `pavucontrol`, which works if `pipewire-pulse` is installed.

Open pavucontrol ("PulseAudio Volume Control"), go to "Configuration" and make sure there's exactly one input device and one output device enabled.

All available devices will automatically be tied to Rocksmith, and the game doesn't like you messing around in the patchbay (= it would crash often).

# Starting the game

Delete the `Rocksmith.ini` inside your Rocksmith installation. It will auto-generate with the correct values. The only important part is the `LatencyBuffer=`, which has to match the Buffer Periods.

Steam needs to be running.

If we start the game from the button that says "Play" in Steam, the game can't connect to wineasio (you won't have sound and will get an error message). There are two ways to go about this. You can apply both at the same time, they don't break each other.



<details><summary>1. LD_PRELOAD</summary>

* Advantages: Run from Steam directly
* Disadvantages: higher possibility of crashes, steps you might need to do every game-boot.

Add these launch options to Rocksmith:
```
LD_PRELOAD=/usr/lib32/libjack.so PIPEWIRE_LATENCY=256/48000 %command%
```

You can launch the game from Steam now. For the first few boot-ups, you have to remove window focus from Rocksmith (typically done with Alt+Tab) as soon as the window shows up. If it doesn't crash, continue.

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

We can start the game via this script now: `PIPEWIRE_LATENCY="256/48000" $STEAMLIBRARY/steamapps/common/rocksmith-launcher.sh`

### Making it nice via Steam entry (optional, but recommended)

We can't start Rocksmith directly from the Steam Library. But we can use the Steam Library to start the script that starts the game in a way that Steam recognizes.

---

<details><summary>Fitting meme</summary>

![](https://i.kym-cdn.com/photos/images/original/002/546/187/fb1.jpg)

</details>

Go into your Steam Library and select "Add a game" -> "Add a Non-Steam Game" on the bottom left.

> With the redesign of the Steam UI, adding non-Steam games is currently not possible because of a bug. You can still add entries via the old gui, which you can open with this command: `steam -vgui

Make sure you can see all files. Select the script we generated just now and add it. This will create a shortcut to the script, which I will refer to as "shortcut" from here on. Right click on the shortcut and select "Properties". Add these launch Options: `PIPEWIRE_LATENCY="256/48000" %command%`

You can now start the game from Steam. Use the shortcut, it will launch the actual game.

### Beautification (even more optional, but recommended)

Leaving the shortcut just like that is not pretty, so we're going to change that.

You can give the games in your Steam Library a custom look. A good Website for resources is the [SteamGridDB](https://www.steamgriddb.com/).

You can take artwork from [Rocksmith](https://www.steamgriddb.com/game/1841), [Rocksmith 2014](https://www.steamgriddb.com/game/2295), [Rocksmith+](https://www.steamgriddb.com/game/5359161) or anything else you want. I would recommend something that makes the shortcut look different than the game.

**Name and icon:** Go into the shortcut's Properties. Right under the text "Shortcut" you can change the game's icon and name (both show up in the list on the left in desktop mode). I recommend something like "Rocksmith 2014 - Launcher".

**"Hero (banner/background)":** Located above the "Play" button in Steam. Right-click on it and choose "set custom background". You can theoretically set a logo too by right-clicking on the text, but I personally chose not to do that to clearly see which item is which.

**Grid (cover art):** For this it gets a bit harder. Go to `$HOME/.steam/steam/userdata/<number>/config/grid`. Since we added a hero, there should be a file that resembles it. It's called `<id>_hero.<file-ending>` we need the ID.
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
