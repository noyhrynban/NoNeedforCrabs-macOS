# No Need for Crabs - macOS
A simple crab screen saver for macOS.

[Download Latest](https://github.com/noyhrynban/no-need-for-crabs-macos/releases/latest/download/No.Need.For.Crabs.zip)

The idea came from an episode of *Tenchi Muyo!*, *Hello Baby!*, where Washu starts working on her computer but gets lost in thought and her screen saver starts. Her screen saver is just these two simple little crabs walking across her screen.

I had a couple pillars in mind for how to make this:
 - Look as similar to the original as reasonably possible
 - Run with very few resources (this is only a screen saver afterall)
 - Render using the GPU (best performance and visual quality)

It is written in some very old (by today's standards) OpenGL. Someday, Apple will end support for OpenGL and force everything to run in Metal and I will have to rewite this in Metal (and maybe Swift too).

## Why The Name

The episodes of *Tenchi Universe* are all titled "No Need for ..." Since this screen saver is nothing but a couple crabs, **No Need For Crabs** seemed like a good name.

## Port to webGL

I did a [port to webGL](https://github.com/noyhrynban/NoNeedforCrabs-webGL) so anyone can [enjoy these cute little crabs](https://ryanharper.net/NoNeedforCrabs-webGL/).
