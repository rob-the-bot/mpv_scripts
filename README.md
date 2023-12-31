﻿# mpv scripts

Scripts for MPV used in feeding assay annotation.
It gets the current frame and the position of the mouse (relative to the frame size of the video), and copy this information to the clipboard.

## Usage

1. Downlaod `mpv` from [this link](https://mpv.io/installation/)
2. Place all files from this repo in `~/.config/mpv/`
2. Open any video using `mpv`. Press `shift` + `o`, you should see `current frame number` / `total frame number`
3. The `annotation.lua` script gets the current frame and the position of the mouse (relative to the frame size of the video), and copy this information to the clipboard
   + Press `g` (lower case) to get the current frame (starts from 0)
   + Press `c` (lower case) to get the position of the mouse

## Note

Currently all major operating systems are supported, however only vanilla `mpv` player is support. For example, `IINA` on MacOS doesn't work due to [the key-binding issue with lua scripts](https://github.com/iina/iina/issues/2140).
