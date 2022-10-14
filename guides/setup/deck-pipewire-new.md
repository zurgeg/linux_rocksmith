# JACK to ASIO on Steam Deck (pipewire)

(Thanks to [BWagener](https://github.com/BWagener) for writing this.)

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

Log out and back in.

<details><summary> How to check if this worked correctly</summary>
For the packages, do `pacman -Q <packages here>`. Should output the names and versions without errors.

	For the groups, run `groups`. This will give you a list, which should contain "audio" and "realtime".
</details>

# wineasio

Installing `base-devel` is very useful for using the AUR and compiling in general.

On SteamOS the following additional packages were required to compile wineasio:

```
sudo pacman -S base-devel glibc linux-headers linux-api-headers libtool binutils lib32-glibc
# note about these two packages: they are in conflict with lib32-pipewire-jack pipewire-jack
# pacman can remove these packages for you and we can reinstall them once wineasio is compiled
sudo pacman -S lib32-jack2 jack2
```

The official source for wineasio is [wineasio/wineasio](https://github.com/wineasio/wineasio), however I could not get it to work with pipewire-jack.

I took the [fixed version from here](https://github.com/TobiasKozel/wineasio) and modified it slightly to get it to compile on the Steam Deck, see [here](https://github.com/BWagener/wineasio/commit/8e24a15801b5980c9245ebf4fe30a722857f7e40) for the modification I made.

```
# retrieve fixed version:
git clone https://github.com/BWagener/wineasio.git
cd wineasio

# build
rm -rf build32
rm -rf build64
make 32
make 64

# Install on normal wine
sudo cp build32/wineasio.dll /usr/lib32/wine/i386-windows/wineasio.dll
sudo cp build32/wineasio.dll.so /usr/lib32/wine/i386-unix/wineasio.dll.so
sudo cp build64/wineasio.dll /usr/lib/wine/x86_64-windows/wineasio.dll
sudo cp build64/wineasio.dll.so /usr/lib/wine/x86_64-unix/wineasio.dll.so
```

<details><summary>Know already what's going on? Here are all commands in one piece without an explanation</summary>

If the commands in this collapsible section don't work for you, try the "longer" variant first before asking for help.

YOU NEED TO HAVE THE $PROTON VARIABLE SET!! (or replaced with the correct path first)

cd into the unpacked directory, then run this.

```
rm -rf build32
rm -rf build64
sudo cp build32/wineasio.dll /usr/lib32/wine/i386-windows/wineasio.dll
sudo cp build32/wineasio.dll.so /usr/lib32/wine/i386-unix/wineasio.dll.so
sudo cp build64/wineasio.dll /usr/lib/wine/x86_64-windows/wineasio.dll
sudo cp build64/wineasio.dll.so /usr/lib/wine/x86_64-unix/wineasio.dll.so
cp build32/wineasio.dll "$PROTON/lib/wine/i386-windows/wineasio.dll"
cp build32/wineasio.dll.so "$PROTON/lib/wine/i386-unix/wineasio.dll.so"
cp build64/wineasio.dll "$PROTON/lib64/wine/x86_64-windows/wineasio.dll"
cp build64/wineasio.dll.so "$PROTON/lib64/wine/x86_64-unix/wineasio.dll.so"
```

And you're done, continue with [Setting up the game's prefix/compatdata](#setting-up-the-games-prefixcompatdata).

</details>

`wineasio` is now installed on your native wine installation.

<details>
	<summary>How to check if it's installed correctly</summary>

	find /usr/lib/ -name "wineasio.dll"
	find /usr/lib/ -name "wineasio.dll.so"
	find /usr/lib32/ -name "wineasio.dll"
	find /usr/lib32/ -name "wineasio.dll.so"

This should output 4 paths (ignore the errors).
</details>

To make Proton use wineasio, we need to copy these files into the appropriate locations:

```
# !!! WATCH OUT FOR VARIABLES !!!
cp /usr/lib32/wine/i386-unix/wineasio.dll.so "$PROTON/lib/wine/i386-unix/wineasio.dll.so"
cp /usr/lib/wine/x86_64-unix/wineasio.dll.so "$PROTON/lib64/wine/x86_64-unix/wineasio.dll.so"
cp /usr/lib32/wine/i386-windows/wineasio.dll "$PROTON/lib/wine/i386-windows/wineasio.dll"
cp /usr/lib/wine/x86_64-windows/wineasio.dll "$PROTON/lib64/wine/x86_64-windows/wineasio.dll"
```

In theory, this should also work with Lutris runners (located in `$HOME/.local/share/lutris/runners/wine/`)

## Setting up the game's prefix/compatdata

1. Delete or rename `$STEAMLIBRARY/steamapps/compatdata/221680`, then start Rocksmith and stop the game once it's running.
1. `WINEPREFIX=$STEAMLIBRARY/steamapps/compatdata/221680/pfx regsvr32 /usr/lib32/wine/i386-windows/wineasio.dll` (Errors are normal, should end with "regsvr32: Successfully registered DLL [...]")

I don't know a way to check if this is set up correctly. This is one of the first steps I'd redo when I have issues.

## Installing RS_ASIO

[Download](https://github.com/mdias/rs_asio/releases) the newest release, unpack everything to the root of your Rocksmith installation (`$STEAMLIBRARY/steamapps/common/Rocksmith2014/`)

Edit RS_ASIO.ini: fill in `WineASIO` where it says `Driver=`. Do this for `[Asio.Output]` and `[Asio.Input.0]`. If you don't play multiplayer, you can comment out Input1 and Input2 by putting a `;` in front of the lines.

## Set up JACK

Open pavucontrol ("PulseAudio Volume Control"), go to "Configuration" and make sure there's exactly one input device and one output device enabled.

All available devices will automatically be tied to Rocksmith, and the game doesn't like you messing around in the patchbay (= it would crash).

## Starting the game

Delete the `Rocksmith.ini` inside your Rocksmith installation. It will auto-generate with the correct values. The only important part is the `LatencyBuffer=`, which has to match the Buffer Periods.

Steam needs to be running.

If we start the game from Steam, the game cant connect to wineasio (you won't have sound and will get an error message). So there's two ways around that:

### Command (No Lutris)

```
# cd is necessary for the Rocksmith.ini and the DLC folder
cd $STEAMLIBRARY/steamapps/common/Rocksmith2014
PIPEWIRE_LATENCY=256/48000 WINEPREFIX=$STEAMLIBRARY/steamapps/compatdata/221680/pfx $PROTON/bin/wine $STEAMLIBRARY/steamapps/common/Rocksmith2014/Rocksmith2014.exe
```

`PIPEWIRE_LATENCY`: Rocksmith needs a sample rate of 48000. 256 refers to the buffer size. This number worked great for me, but you can experiment with others, of course.

(You don't always have to do this, but this give me the most reliable experience) As soon as you see the games window, take the focus away from it, eg. on a different window. Don't focus Rocksmith until the logos start to appear (it's usually the same amount of time). At this point, RS_ASIO is initialized and you can start playing.

### Yes Lutris

Using Proton outside of it's wrapper is discouraged, but if we use normal wine, the game can't find Steam, which is needed for Steam's DRM.

Open Lutris and add a game:

* General:
	* Name: Rocksmith® 2014 Edition - Remastered
	* Runner: Wine
	* Release year: 2014
* Game Options
	* Executable: $STEAMLIBRARY/steamapps/common/Rocksmith 2014/Rocksmith2014.exe
	* Working directory: $STEAMLIBRARY/steamapps/common/Rocksmith 2014/
	* Wine prefix: $STEAMLIBRARY/steamapps/compatdata/221680/pfx
* Runner options
	* Wine version: Custom
	* (Toggle Advanced options to see this) Custom Wine executable: enter path to `dist/bin/wine` or `files/bin/wine` of your desired Proton version
* System options (only needed for pipewire)
	* Environment Variables: PIPEWIRE_LATENCY=256/48000

(People who don't use the Steam version can just choose whatever runner they like.)

Save this and hit "Play."

(You don't always have to do this, but this give me the most reliable experience) As soon as you see the games window, take the focus away from it, eg. on a different window. Don't focus Rocksmith until the logos start to appear (it's usually the same amount of time). At this point, RS_ASIO is initialized and you can start playing.
