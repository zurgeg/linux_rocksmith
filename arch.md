# JACK to ASIO on Arch-based distros

## Table of contents

1. [Install necessary stuff](#install-necessary-stuff)
1. [wineasio](#wineasio)
1. [Setting up the game's prefix/compatdata](#setting-up-the-games-prefixcompatdata)
1. [Installing RS_ASIO](#installing-rs_asio)
1. [Set up JACK with Cadence](#set-up-jack-with-cadence)
1. [Starting the game](#starting-the-game)
1. [Command (No Lutris)](#command-no-lutris)
1. [Yes Lutris](#yes-lutris)

## Install necessary stuff

If asked, replace `jack`.

```
sudo pacman -S carla jack2 lib32-jack2 realtime-privileges
# the groups should already exist, but just in case
sudo groupadd audio
suod groupadd realtime
sudo usermod -aG audio $USER`
sudo usermod -aG realtime $USER`
```

Log out and back in

### wineasio

At the time I'm writing this, wineasio just got updated and the AUR packages are out of date, but will work with wine versions until 6.5.

<details>
  <summary>Compile from source</summary>

[Download](https://github.com/wineasio/wineasio) the newest zip and unpack it. Open a terminal inside the newly created folder and run the following commands (stolen from the [README](https://github.com/wineasio/wineasio#readme), adjusted for Arch folder structure):

```
# build
rm -rf build32
rm -rf build64
make 32
make 64

# install on wine
sudo cp build32/wineasio.dll /usr/lib32/wine/i386-windows/wineasio.dll
sudo cp build32/wineasio.dll.so /usr/lib32/wine/i386-unix/wineasio.dll.so
sudo cp build64/wineasio.dll /usr/lib/wine/x86_64-windows/wineasio.dll
sudo cp build64/wineasio.dll.so /usr/lib/wine/x86_64-unix/wineasio.dll.so
```

In theory, this should also work with Lutris runners (located in `$HOME/.local/share/lutris/runners/wine/`)

</details>

<details>
<summary>Use the AUR</summary>

`yay` is an AUR helper, which I will use as an example. It will install the AUR package for you. You can do this other ways too, of course

```
yay -S wineasio
```
</details>

wineasio is now installed on your native wine version. To install it for Proton, run these:

```
# add to Proton version !! watch out for variables !!
cp /usr/lib32/wine/i386-windows/wineasio.dll "$PROTON/lib/wine/i386-windows/wineasio.dll"
cp /usr/lib32/wine/i386-unix/wineasio.dll.so "$PROTON/lib/wine/i386-unix/wineasio.dll.so"
cp /usr/lib/wine/x86_64-windows/wineasio.dll "$PROTON/lib64/wine/x86_64-windows/wineasio.dll"
cp /usr/lib/wine/x86_64-unix/wineasio.dll.so "$PROTON/lib64/wine/x86_64-unix/wineasio.dll.so"

# for Proton versions 6.5 and below
cp /usr/lib32/wine/i386-windows/wineasio.dll "$PROTON/lib/wine/wineasio.dll.so"
cp /usr/lib/wine/x86_64-unix/wineasio.dll.so "$PROTON/lib64/wine/wineasio.dll.so"
```

## Setting up the game's prefix/compatdata

1. Delete or rename `$STEAMLIBRARY/steamapps/compatdata/221680`, then start Rocksmith and stop the game once it's running.
1. `WINEPREFIX=$STEAMLIBRARY/steamapps/compatdata/221680/pfx regsvr32 /usr/lib32/wine/i386-windows/wineasio.dll` (Errors are normal, should end with "regsvr32: Successfully registered DLL [...]")

## Installing RS_ASIO

[Download](https://github.com/mdias/rs_asio/releases) the newest release, unpack everything to the root of your Rocksmith installation (`$STEAMLIBRARY/steamapps/common/Rocksmith2014/`)

Edit RS_ASIO.ini: insert `WineASIO` where it says `Driver=`. Do this for `[Asio.Output]` and `[Asio.Input.0]`. If you don't play multiplayer, you can comment out Input1 and Input2 by putting a `;` in front of the lines.

## Set up JACK with Cadence

1. Open Cadence. If it says on the bottom left that you should log out and back in, and you already did that, restart your machine.
1. Go to `Configure -> Engine`. Make sure that "Realtime" is ticked.
1. Go to "Driver", select ALSA.
 * If you use the same device for input and output, untick "Duplex Mode" and select the device you want to use in the first line. If you use different devices for in- and output, tick "Duplex Mode" and select the devices in the 2nd and 3rd line. Please note that the names are not that intuitive to begin with.
 * Input Channels: <no. of players>; Output Channels: 2
 * Sample Rate: 48000
 * Buffer Size and Buffer Periods: Bigger Buffer Size equals more stability and higher latency. AFAIK you can reduce the Buffer Size, if you add more Periods, but I'm not sure about that. 256/4 (~5ms) works fine for me.
1. Press okay and go to `Tweaks -> WineASIO
 * Tick everything
 * Match No. of in- and -outputs
 * Match Buffer size
1. Press apply
1. You're set up. To start JACK, you can press "Start" under "System"

## Starting the game

Delete the `Rocksmith.ini` inside your Rocksmith installation. It will auto-generate with the correct values. The only important part is the `LatencyBuffer=`, which has to match the Buffer Periods.

Steam and JACK need to be running.

If we start the game from Steam, it will not work. So there's to ways around that:

### Command (No Lutris)

```
# cd is necessary for the Rocksmith.ini and the DLC folder
cd $STEAMLIBRARY/steamapps/common/Rocksmith2014
WINEPREFIX=$STEAMLIBRARY/steamapps/compatdata/221680/pfx $PROTON/bin/wine $STEAMLIBRARY/steamapps/common/Rocksmith2014/Rocksmith2014.exe
```

### Yes Lutris

We need to add Proton as a Lutris runner. This is not officially supported, but otherwise the game can't find Steam.

```
cd ~/.local/share/lutris/runners/wine
ln -s $PROTON Proton-#.##
```

Restart Lutris. Add a game:

* General:
 * Name: Rocksmith® 2014 Edition - Remastered
 * Runner: Wine
 * Release year: 2014
* Game Options
 * Executable: $STEAMLIBRARY/steamapps/common/Rocksmith 2014/Rocksmith2014.exe
 * Working directory: $STEAMLIBRARY/steamapps/common/Rocksmith 2014/
 * Wine prefix: $STEAMLIBRARY/steamapps/compatdata/221680/pfx
* Runner options
 * Wine version: Proton-#.##

Save this and hit "Play."
