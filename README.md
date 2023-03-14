# Rocksmith 2014 on Linux

These are a few Guides to get [Rocksmith 2014](https://store.steampowered.com/app/221680/Rocksmith_2014_Edition__Remastered/) running on Linux. In case you haven't tried gaming on Linux yet, other than not working, it won't get harder than this by far for other games.

# Disclaimer

This is the bare minimum to get it to work. I don't know if certain changes recommended by other people have a performance impact.

I tested it on Manjaro, Arch and a Linux Mint VM. Due to the VM factor, I was actually able to start the game, but the experience is 1fps or something like that.

I have only tested the Steam version.

**I take no responsibility and will not guarantee for this working.**

# Prerequisites

Don't install or copy Rocksmith from/to an NTFS drive. It will not start. (I think that's because of permissions, but I'm not sure.)

If you use Proton-GE, install scripts sometimes don't run. Make sure you use normal Proton the first time.

We will need wine, which is installed in the first step.

## Common paths

I will refer to them with variables. You can actually set them as variables via `variablename=value` and just copy-paste the commands, or replace the text. Keep in mind that these are temporary, so only available in the terminal instance where the variable was defined.

#.## has to be replaced by a version number, because I don't know which version you use. So for "Proton #.##", an example replacement would be "Proton 7.0".

* `$HOME`: Already set, don't worry about it. (redirects to `/home/<username>`)
* `$STEAMLIBRARY`: The Steam Library, where Rocksmith is installed in. You can check it by opening Steam, then going to `Steam -> Settings -> Downloads -> Steam Library Folders`. Right above the disk usage indicator, there's a path. that's the one we need.
* `$PROTON`: A specific location inside your Proton installation
 * Normal Proton: `/path/to/steamapps/common/Proton\ #.##/dist`
 * Proton-GE: It's located in the default Steam Library under `compatibilitytools.d/Proton-#.##-GE-#/files`

# Guides

There are two ways to do this. The one most people on [ProtonDB](https://www.protondb.com/app/221680) use is quicker, but results in high delay and distorted sound. It routes the sound through ALSA. This can be found in "Other Guides".

Then there's the way of routing the audio through JACK -> wineASIO -> RS_ASIO, which has less delay and sounds better, but also takes longer to set up. I have Guides for Arch-based Distros and Debian-based ones. These can be found in the tables below.

**Recent Proton versions:**

|| pipewire | non-pipewire |
|---|---|---|
| Arch | [Guide](guides/setup/arch-pipewire-new.md) | [Guide](guides/setup/arch-non-pipewire-new.md) |
| Debian | [Not finished](guides/setup/deb-pipewire-new.md) | [Guide](guides/setup/deb-non-pipewire-new.md) |
| Steam Deck | [Guide](guides/setup/deck-pipewire-new.md) | N/A |

**Proton versions 6.5 and below:**

|| pipewire | non-pipewire |
|---|---|---|
| Arch | [Guide](guides/setup/arch-pipewire-old.md) | [Guide](guides/setup/arch-non-pipewire-old.md) |
| Debian | [Not finished](guides/setup/deb-pipewire-old.md) | [Guide](guides/setup/deb-non-pipewire-old.md) |
| Steam Deck | [Guide](guides/setup/deck-pipewire-old.md) | N/A |

**Other Guides:**

* [ALSA - Quick and dirty](guides/quick.md)
* [Steps I cut out](guides/unused.md)
* [OBS guide for these setups](guides/obs.md)
* [Why all of this works](guides/theory.md)

## Scripts

Because someone asked, I have written scripts that do everything for you.

For native Steam: `wget https://raw.githubusercontent.com/theNizo/linux_rocksmith/main/scripts/native-steam.sh && ./native-steam.sh && rm native-steam.sh`

For other Rocksmith installations: `wget https://raw.githubusercontent.com/theNizo/linux_rocksmith/main/scripts/other.sh && ./other.sh && rm other.sh`

# Credits

* [preflex](https://gitlab.com/preflex) for showing me how to do it on Arch-based distros.
* [u/JacKeTUs](https://www.reddit.com/user/JacKeTUs) for publishing a [Debian-based Guide](https://old.reddit.com/r/linux_gaming/comments/jmediu/guide_for_setup_rocksmith_2014_steam_no_rs_cable/) on [r/linux_gaming](https://old.reddit.com/r/linux_gaming/)
* [the_Nizo](https://github.com/theNizo), for using that information and updating it regularly in the past. My original Guide was posted [here](https://old.reddit.com/r/linux_gaming/comments/jmediu/guide_for_setup_rocksmith_2014_steam_no_rs_cable/gdhg4zx/).
* [BWagener](https://github.com/BWagener) for writing the Steam Deck Guide.
* [Siarkowy](https://github.com/Siarkowy) for replacing the "JustInCaseWeNeedIt" workaround and the shortcut in Steam.

Thank you all for the work ^^
