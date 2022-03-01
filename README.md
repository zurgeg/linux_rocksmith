# Rocksmith 2014 on Linux

These are a few Guides to get [Rocksmith 2014](https://store.steampowered.com/app/221680/Rocksmith_2014_Edition__Remastered/) running on Linux. In case you're interested in gaming on Linux, this is by far the hardest setup for a game I know.

# Disclaimer

I tested it on Manjaro and a Linux Mint VM. Due to the VM factor, you can start the game, but the experience is 1fps or something like that.

I have only tested the Steam version.

**I take no responsibility and will not guarantee for this working.**

# Prerequisites

Don't install or copy Rocksmith from an NTFS drive. It will not start. (I think that's because of permissions, but I'm not sure.)

If you use Proton-GE, install scripts sometimes don't run. Make sure you use normal Proton the first time.

Wine should already be installed, we will need it later.

## Common paths

I will refer to them with variables. You can actually set them as variables via `variablename=value` and just copy-paste the commands, or replace the text. Keep in mind that these are temporary, so only available in the terminal instance where the variable was defined.

#.## has to be replaced by a version number, because I don't know which version you use. So for "Proton #.##", an example replacement would be "Proton 7.0".

* `$HOME`: Already set, don't worry about it. (redirects to `/home/<username>`)
* `$STEAMLIBRARY`: The Steam Library, where Rocksmith is installed in. You can check it by opening Steam, then going to `Steam -> Settings -> Downloads -> Steam Library Folders`. Right above the disk usage indicator, there's a path. that's the one we need.
* `$PROTON`: A specific location inside your Proton installation
 * Normal Proton: `/path/to/steamapps/common/Proton\ #.##/dist`
 * Proton-GE: It's located in the default Steam Library under `compatibilitytools.d/Proton-#.##-GE-#/files`

# Guides

There's a quick way that most people on [ProtonDB](https://www.protondb.com/app/221680) choose, then there's the way of routing the audio through JACK -> wineASIO -> RS_ASIO, which has less delay and sounds better, but also takes longer. I have Guides for Arch-based Distros and Debian-based ones.

* [Quick and easy way](quick.md)
* [Harder way (Arch-based)](arch.md)
* [Harder way (Debian-based)](debian.md)

# Credits

* [preflex](https://gitlab.com/preflex) for showing me how to do it on Arch-based distros.
* [u/JacKeTUs](https://www.reddit.com/user/JacKeTUs) for publishing a [Debian-based Guide](https://old.reddit.com/r/linux_gaming/comments/jmediu/guide_for_setup_rocksmith_2014_steam_no_rs_cable/) on [r/linux_gaming](https://old.reddit.com/r/linux_gaming/)
* Me, for using that information and updating it regularly in the past. My original Guide was posted [here](https://old.reddit.com/r/linux_gaming/comments/jmediu/guide_for_setup_rocksmith_2014_steam_no_rs_cable/gdhg4zx/).
