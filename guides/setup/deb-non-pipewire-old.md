# JACK to ASIO on Debian-based distros

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

When asked about realtime privileges, select yes with the arrow keys and confirm with enter.

```
sudo apt-get install apt-transport-https gpgv
wget https://launchpad.net/~kxstudio-debian/+archive/kxstudio/+files/kxstudio-repos_10.0.3_all.deb
sudo dpkg -i kxstudio-repos_10.0.3_all.deb
sudo apt update
sudo apt install cadence carla wineasio jackd2
# the groups should already exist, but just in case
sudo groupadd audio
suod groupadd realtime
sudo usermod -aG audio $USER`
sudo usermod -aG realtime $USER`
```

Log out and back in.

<details><summary> How to check if this worked correctly</summary>


	For the groups, run `groups`. This will give you a list, which should contain "audio" and "realtime".
</details>

# wineasio

Installing `base-devel` is very useful for using the AUR and compiling in general.

<details>
	<summary>Compile from source</summary>

[Download](https://github.com/wineasio/wineasio/releases) the newest zip and unpack it. Open a terminal inside the newly created folder and run the following commands:

```
# build
rm -rf build32
rm -rf build64
make 32
make 64

# Install on normal wine
sudo cp build32/wineasio.dll /usr/lib/i386-linux-gnu/wine/wineasio.dll
sudo cp build32/wineasio.dll.so /usr/lib/i386-linux-gnu/wine/wineasio.dll.so
sudo cp build64/wineasio.dll /usr/lib/x86_64-linux-gnu/wine/wineasio.dll
sudo cp build64/wineasio.dll.so /usr/lib/x86_64-linux-gnu/wine/wineasio.dll.so
```

</details>

<details>
<summary>Use the AUR</summary>

`yay` is an AUR helper, which I will use as an example. It will install the AUR package for you. You can do this in other ways too, of course

```
yay -S wineasio --noconfirm
```

Notes:

* If it exits with an error, try and remove `--noconfirm`.
* [Tutorial on `yay`](https://youtube.com/watch?v=BbnSoY_yDr8)
</details>

wineasio is now installed on your native wine version.

<details>
	<summary>How to check if it's installed correctly</summary>

	find /usr/lib/ -name "wineasio.dll"
	find /usr/lib/ -name "wineasio.dll.so"
	find /usr/lib32/ -name "wineasio.dll"
	find /usr/lib32/ -name "wineasio.dll.so"

This should output 4 paths (ignore the errors).
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
cp /usr/lib/i386-linux-gnu/wine/wineasio.dll.so "$PROTON/lib/wine/i386-unix/wineasio.dll.so"
cp /usr/lib/x86_64-linux-gnu/wine/wineasio.dll.so "$PROTON/lib64/wine/x86_64-unix/wineasio.dll.so"
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

If we start the game from Steam, the game cant connect to wineasio (you won't have sound and will get an error message). So there's two ways around that:

### Command (No Lutris)

```
# cd is necessary for the Rocksmith.ini and the DLC folder
cd $STEAMLIBRARY/steamapps/common/Rocksmith2014
PIPEWIRE_LATENCY=256/48000 WINEPREFIX=$STEAMLIBRARY/steamapps/compatdata/221680/pfx $PROTON/bin/wine $STEAMLIBRARY/steamapps/common/Rocksmith2014/Rocksmith2014.exe
```

(`PIPEWIRE_LATENCY` is only needed for pipewire, but doesn't do any harm on non-pipewire systems.)

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


