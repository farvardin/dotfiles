
# My dotfiles 

Dotfiles are configuration files found on Unix systems.

There are some dotfiles managers but I find it easier to use symbolic links 
(no need to manually synchronise dotfiles with the database)


## Installing 

- To install / use those dotfiles, run this command from a persistent place on your harddrive:

        git clone https://github.com/farvardin/dotfiles.git
        
        or alternatively:
        
        hg clone http://hg.code.sf.net/p/farvardin-dotfiles/code farvardin-dotfiles-code
        (you must have mercurial installed in the later case, the sf.net repo is not updated often)

If you have read/write access to this repository (which is very doubtful, but it's just an example), 
the command would be:


        git clone git@github.com:farvardin/dotfiles.git
        
        or 
        
        hg clone ssh://farvardin@hg.code.sf.net/p/farvardin-dotfiles/code farvardin-dotfiles-code


- rename the folder to a more friendly name, for instance:

        mv farvardin-dotfiles-code dotfiles

- run "deploy.sh" 

It will create symbolic links if the corresponding files are not present 
(you can make a backup of your own configurations to be sure it won't erase anything 
but it shouldn't be necessary). 

You can also make a diff to compare what it could add to your settings (the default diff tools
in the script is meld, you can change it if you prefer).

To add a new dotfile, just edit the deploy.sh script.


## Updating 

- enter the copy of the repository on your hardrive, for instance:

        cd ~/.dotfiles/
        
- type:
        git pull
        
        or 
        
        hg pull
        hg update



## Other tools:

- Stow: https://www.jakewiesler.com/blog/managing-dotfiles
- Nix: https://alexpearce.me/2021/07/managing-dotfiles-with-nix/
- chezmoi: https://www.chezmoi.io/
- homemade: https://www.freecodecamp.org/news/build-your-own-dotfiles-manager-from-scratch/
- Yet Another Dotfiles Manager: https://yadm.io/


### Using yadm

        yadm might be easier to use than the deploy script, but it has some drawbacks.
        
        yadm clone https://github.com/farvardin/dotfiles/


## Tips 


### Writerdecks

Nano and micro can be great tools for writerdecks (devices / laptops dedicated to write prosa). I've tried to configure both tools to have similar behaviors.
See also: https://github.com/sspaeti/dotfiles/tree/master/nvim/.config/nvim-wp

#### nano 

meta = esc (most of the time)

- ctrl+g : show help
- ctrl+l : goto line
- ctrl+f : find (search)
- esc+n : hide line numbers
- esc+z : hide title bar
- esc+x : show status bar
- ctrl+space : next word
- F10 : next tab
- F11 : next search
- ctrl+s : save current file
- ctrl+o : save as a new file
- meta+m : disable mouse support


https://www.nano-editor.org/dist/latest/cheatsheet.html


#### micro

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





 


-------------------------------

https://sourceforge.net/p/farvardin-dotfiles/code/ci/default/tree/
