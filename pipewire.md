(Thanks to [vscsilva](https://github.com/vscsilva) for pointing out that it works now)

# JACK to ASIO, but it's pipewire

It's pretty much the same rundown, so I decided to just point out the differences. I will probably polish this in the future.

## Install necessary stuff

Don't install `jack2`, don't install `cadence` (because it requires `jack2`). Here's what you need, assuming you have `pipewire` and a session manager (probably `wireplumber`) already installed:

`pipewire-alsa pipewire-pulse pipewire-jack qjackctl realtime-privileges pavucontrol`

I've written this in a way that you can just put your package manager's install command in front of it.

## wineasio

Compile from source. [Download](https://github.com/wineasio/wineasio) the newest zip and unpack it. Open a terminal inside the newly created folder and run the following commands:

```
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

# add to Proton version !! watch out for variables !!
cp /usr/lib32/wine/i386-windows/wineasio.dll "$PROTON/lib/wine/i386-windows/wineasio.dll"
cp /usr/lib32/wine/i386-unix/wineasio.dll.so "$PROTON/lib/wine/i386-unix/wineasio.dll.so"
cp /usr/lib/wine/x86_64-windows/wineasio.dll "$PROTON/lib64/wine/x86_64-windows/wineasio.dll"
cp /usr/lib/wine/x86_64-unix/wineasio.dll.so "$PROTON/lib64/wine/x86_64-unix/wineasio.dll.so"

# for Proton versions 6.5 and below
cp /usr/lib32/wine/i386-windows/wineasio.dll "$PROTON/lib/wine/wineasio.dll.so"
cp /usr/lib/wine/x86_64-unix/wineasio.dll.so "$PROTON/lib64/wine/wineasio.dll.so"
```

## Set up JACK

Don't do the step from the other guides with the almost same name.

Open pavucontrol ("PulseAudio Volume Control"), go to "Configuration" and make sure there's exactly one input device and one output device enabled.

All available devices will automatically be tied to Rocksmith, and the game doesn't like you messing around in the patchbay (= it would crash)

## COMMAND

There is an environment variable in there called `PIPEWIRE_LATENCY`. 256 is the Buffer size, you can change it to something you like. I've had good experiences with 256. 48000 refers to the sample rate and is required to be 48000 by Rocksmith

## Starting the game

(You don't always have to do this, but this give me the most reliable experience)

As soon as you see the games window, take the focus away from it, eg. on a different window. Don't focus Rocksmith until the logos start to appear (it's usually the same amount of time). At this point, RS_ASIO is initialized and you can start playing.
