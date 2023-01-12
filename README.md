
# My dotfiles 

Dotfiles are configuration files found on Unix systems.

There are some dotfiles managers but I find it easier to use symbolic links 
(no need to manually synchronise dotfiles with the database)


## Installing 

- To install / use those dotfiles, run this command from a persistent place on your harddrive:

        git clone https://github.com/farvardin/dotfiles.git
        
        or alternatively:
        
        hg clone http://hg.code.sf.net/p/farvardin-dotfiles/code farvardin-dotfiles-code
        (you must have mercurial installed in the later case)

If you have read/write access to this repository (which is very doubtful, but it's just an example), 
the command would be:


        git@github.com:farvardin/dotfiles.git
        
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


## Using yadm

        yadm might be easier to use than the deploy script, but it has some drawbacks.
        
        yadm clone https://github.com/farvardin/dotfiles/


-------------------------------

https://sourceforge.net/p/farvardin-dotfiles/code/ci/default/tree/
