# Steps I deliberately left out

I'm not the first one to use this setup. I took the information and maintained it. When originally trying to get it to work, I noticed that you can leave some steps out and it still works, without knowing whether they made any difference or not. Just in case you would need them, I have listed them here.

# Add realtime manually

On Arch-based distros, we install a package called `realtime-privileges`, which does this for us. While in my experience it also happens automatically on Debian-based distros, [someone else needed to do this manually](https://www.reddit.com/r/linux_gaming/comments/jmediu/guide_for_setup_rocksmith_2014_steam_no_rs_cable/).

It's explained [here](https://jackaudio.org/faq/linux_rt_config.html) at "1. Editing the configuration file".

# RS_ASIO.ini: BufferSizeMode=host

set this variable to the value listed here.

Worked regardless, didn't notice a difference.

# winecfg: add wineasio

`WINEPREFIX=$STEAMLIBRARY/steamapps/compatdata/221680/pfx winecfg`

Go to Libraries. Type in `wineasio` and click add. Search for it in the list and select "Builtin, then native"

An alternative way to do this is to write this in front of your launch command: `WINEDLLOVERRIDES=wineasio=b,n`
