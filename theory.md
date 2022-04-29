This document is most likely incomplete, because my knowledge is too. Some stuff is probably wrong too.

I will not list what I consider to be general linux knowledge here, just stuff that applies to this exact use case.

## How does this work?

> Audio Device -> JACK -> ASIO (wineASIO) -> RS_ASIO -> Rocksmith2014

Rocksmith usually uses WASAPI for audio input and output.

For pro-audio, which is used for music production, there's an audio system called ASIO on Windows.

Linux has 4 sound servers/systems: ALSA, pulseaudio, pipewire and JACK. JACK is for pro-audio. Pipewire is quite new and aims to be the one standard for all, which is why it has implementations for all of the other ones.

JACK and ASIO are equivalents. Since there's Wine and some people want to do music production on Linux, there's wineasio, which translates between these.

Someone developed RS_ASIO, which you could say is a mod for Rocksmith to work with ASIO devices.

Plugging everything together, we get the chain above.

## What am I actually doing on Linux?

You install JACK and set it up in a certain way. You install wineasio into the standard wine, as well as your runner (Steam Proton, or something else you use). You patch the wine prefix to accept WineASIO and install RS_ASIO to Rocksmith.

Steam Proton has a wrapper, which eg. contains libraries and files that are used instead of system files, to ensure that the games work the same across every platform. Somehow, this destroys functionality with WineASIO, that's why we have to start it without the wrapper. We need to use Proton though, because it can find Steam, which is important because of the Steam DRM.

## Can you set up a prefix to be able to do both?

YES!

The only reason that Rocksmith takes ASIO is because of RS_ASIO. Once you remove that mod (eg. append ".bak" at the end of all the files), you're back to WASAPI and can use the quick and dirty method.

(Come to think of it, you have to select input and output device in winecfg, but I don't think it should make a difference.)
