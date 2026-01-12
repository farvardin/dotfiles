# Writerdecks

Writerdecks are devices dedicated to the art of writing. It can be special 
hardware, but an old laptop might be easier and cheaper.

## Hardware

### Install Debian / Devuan

You might not need to install a full desktop environment, so it will boot 
straight to the console / TTY. 

### Additional tweaking of the hardware and the OS

You can install a light window manager (like openbox or windowmaker) and 
start it, if needed, with the ``startx`` command from the console. You can adjust brightness with blight

- apt-install wmaker openbox blight

It's possible to temporary change the font size in TTY with:

- setfont Uni3-Terminus32x16

A definite change can be made by adjusting ``/etc/default/console-setup`` :

```
CODESET="Uni3"
FONTFACE="Terminus"
FONTSIZE="32x16"
``` 

If you save your work using a git forge (like gitlab or github), you might need to save your ssh key.

Use

eval `ssh-agent -s`
eval `ssh-add ~/.ssh/id_rsa`

to prevent typing your key every time.


## Software

Nano and micro can be great tools for writerdecks. 
I've tried to configure both tools to have similar behaviors (see the dotfiles).
See also: https://github.com/sspaeti/dotfiles/tree/master/nvim/.config/nvim-wp

### nano 

meta = esc (most of the time)

- ctrl+g : show help
- ctrl+l : goto line
- ctrl+f : find (search)
- esc+n : hide line numbers
- esc+z : hide title bar
- esc+x : show status bar
- ctrl+space : next word
- F10 : next tab (you can open multiple files from the command line)
- F11 : next search
- ctrl+s : save current file
- ctrl+o : save as a new file
- meta+m : disable mouse support


https://www.nano-editor.org/dist/latest/cheatsheet.html


### micro

install fzf and exuberant-ctags

- ctrl+n : hide ruler (line numbers)
- ctrl+l : goto line
- ctrl+e : command prompt
 - help defaultkeys : show default key bindings.
 - vsplit / hsplit : split window in vertical / horizontal
- ctrl+w : switch to next window split
- ctrl+space : next word
- ctrl+r : previous word
- F10 : next tab
- F11 : launch fzf to select a section
- ctrl+o : open a file


https://github.com/zyedidia/micro/blob/master/runtime/help/keybindings.md


## Other tools / devices / links

### Links


- Linux OS:

https://devuan.org/
https://debian.org/

- Some more ressources:

https://www.writerdeck.org/
https://www.reddit.com/r/writerDeck/
https://www.reddit.com/r/cyberDeck/

https://en.wikipedia.org/wiki/Cambridge_Z88
https://en.wikipedia.org/wiki/Atari_Portfolio
https://en.wikipedia.org/wiki/Amstrad_NC100
https://en.wikipedia.org/wiki/Palmtop_PC

https://www.typeframe.net/


### ESP32 lilygo TTGO 

If you save your work from a DOS session, to convert to French encoding:
``dos2unix -863 MYTEXT.TXT``


