# Friday Night Funkin' Niz engine
wenamechainsama

## Credits

- **Original dev team**
- [ninjamuffin99](https://twitter.com/ninja_muffin99) - Original programmer
- [PhantomArcade3K](https://twitter.com/phantomarcade3k) and [Evilsk8r](https://twitter.com/evilsk8r) - Art
- [Kawaisprite](https://twitter.com/kawaisprite) - Musician

- **Engine team**
- [Niz ako JesusDev](uwu)


### Installing the Required Programs

1. [Install Haxe 4.1.5](https://haxe.org/download/) - install haxe 

2. [Install HaxeFlixel](https://haxeflixel.com/documentation/install-haxeflixel/) - install haxeflixel

Other installations you'd need are the additional libraries, a fully updated list will be in `Project.xml` in the project root. Currently, these are all of the things you need to install:

```
haxelib install flixel
haxelib install flixel-addons
haxelib install flixel-ui
haxelib install hscript
```

You'll also need to install a couple things that involve Gits. To do this, you need to do a few things first.
1. Download [git-scm](https://git-scm.com/downloads). Works for Windows, Mac, and Linux, just select your build.
2. Follow instructions to install the application properly.
3. aaand install this: 
```
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-r
haxelib git flixel-addons https://github.com/HaxeFlixel/flixel-addons
```
and you should be good to go there.

To run it from your desktop (Windows, Mac, Linux) it can be a bit more involved. For Linux, you only need to open a terminal in the project directory and run `lime test linux -debug` and then run the executable file in export/release/linux/bin. For Windows, you need to install Visual Studio Community 2019. While installing VSC, don't click on any of the options to install workloads. Instead, go to the individual components tab and choose the following:
* MSVC v142 - VS 2019 C++ x64/x86 build tools
* Windows SDK (10.0.17763.0)


Once that is done you can open up a command line in the project's directory and run `lime test windows -debug`. Once that command finishes (it takes forever even on a higher end PC), you can run FNF from the .exe file under export\release\windows\bin
As for Mac, 'lime test mac -debug' should work, if not the internet surely has a guide on how to compile Haxe stuff for Mac.