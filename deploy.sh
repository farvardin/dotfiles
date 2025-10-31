#!/usr/bin/env bash

# https://github.com/farvardin/dotfiles
# https://sourceforge.net/p/farvardin-dotfiles/code/ci/default/tree/
# 
# this script won't delete your existing configuration

# 
# sudo add-apt-repository ppa:gottcode/gcppa
# optionel : 
# cadence

DIFF=meld

apt-mini() {
	printf "We will install some basic deb packages on the system. \n\n"
	sleep 2
	sudo apt install xterm meld scite byobu gimp inkscape focuswriter geany micro exuberant-ctags fzf
}

apt-extra() {
	printf "We will install some more deb packages on the system. \n\n"
	sleep 2
	sudo gimp-gmic gmic blender veracrypt gocryptfs hatari gforth freeplane mcomix nextcloud-desktop retroarch syncthing calibre vlc
}

deploy_dotfiles() {

	# current status
	echo -e "\n\n\033[1mCurrent files status:\033[0m"
	for R in .bashrc .ctwmrc .ctags garglk.ini .gvimrc .hgrc .inputrc .profile .SciTEUser.properties SciTEStartup.lua .tmux.conf .vimrc .jedrc .vim .emacs .config/emacs .nanorc .Xresources .Xresources-monochrome .config/gforthrc0 
		do
			ls -alh  ~/$R
		done
	echo -e "\n\n"

	# files
	for R in .bashrc .ctwmrc .ctags garglk.ini .gvimrc .hgrc .inputrc .profile .SciTEUser.properties SciTEStartup.lua .tmux.conf .vimrc .jedrc .emacs .nanorc .Xresources .Xresources-monochrome 
		do
		if [ -f ~/"$R" ]; then
			echo -e "~/$R is already present on your system."
			if cmp -s "$R" ~/"$R"; then
				printf '   The files are the same \n\n'
			else
				printf '\n   The files are different, do you want to compare them? (y/n):\n'
				read -r answer
				if [[ "$answer" == "y" ]] ; then
					$DIFF  "$R" ~/"$R"
				fi
				echo -e "Now this script can backup your $R file to $R.old and link the $R dotfile from this folder to your home so it will become effective. Do you agree? (y/n)"
				read -r answ2
				if [[ "$answ2" == "y" ]] ; then
					mv ~/"$R" ~/"$R".old
					ln -s `pwd`/"$R" ~/
					printf "Done. \n"
				else printf "Nothing was changed. \n"
				fi
			fi
		else
			ln -s `pwd`/$R ~/
			echo -e "\033[1mlinking\033[0m \033[4m$R\033[0m to ~/ ..."
		fi
	done

	# single file in .config

	for R in .config/gforthrc0 
		do
		if [ -f ~/"$R" ]; then
			echo -e "~/$R is already present on your system."
			if cmp -s "$R" ~/"$R"; then
				printf '   The files are the same \n\n'
			else
				printf '\n   The files are different, do you want to compare them? (y/n):\n'
				read -r answer
				if [[ "$answer" == "y" ]] ; then
					$DIFF  "$R" ~/"$R"
					echo -e "Now this script can backup your $R file to $R.old and link the $R dotfile from this folder to your home so it will become effective. Do you agree? (y/n)"
					read -r answ2
					if [[ "$answ2" == "y" ]] ; then
						mv ~/"$R" ~/"$R".old
						ln -s `pwd`/"$R" ~/.config/
						printf "Done. \n"
					else printf "Nothing was changed. \n"
					fi
				fi
			fi
		else
			ln -s `pwd`/$R ~/.config/
			echo -e "\033[1mlinking\033[0m \033[4m$R\033[0m to ~/ ..."
		fi
	done



	# SPECIAL
	# PB with redshit and AppArmor rubbishes
	# files in .config 
	# which don't support symblinks
	for R in .config/redshift.conf
		do
		if [ -f ~/"$R" ]; then
			echo -e "~/$R is already present on your system."
			if cmp -s "$R" ~/"$R"; then
				printf '   The files are the same \n\n'
			else
				printf '\n   The files are different, do you want to compare them? (y/n):\n'
				read -r answer
				if [[ "$answer" == "y" ]] ; then
					$DIFF  "$R" ~/"$R"
					echo -e "Now this script can backup your $R file to $R.old and link the $R dotfile from this folder to your home so it will become effective. Do you agree? (y/n)"
					read -r answ2
					if [[ "$answ2" == "y" ]] ; then
						mv ~/"$R" ~/"$R".old
						cp  `pwd`/"$R" ~/.config/
						printf "Done. \n"
					else printf "Nothing was changed. \n"
					fi
				fi
			fi
		else
			cp  `pwd`/$R ~/.config/
			echo -e "\033[1mCOPYing\033[0m \033[4m$R\033[0m to ~/.config/ ..."
		fi
	done




	# folders
	for R in .vim .scite .dgen 
		do
		if [ -e ~/$R ]; then
			echo -e "~/$R is already present on your system. "
			ls -alh  ~/$R
			printf 'If it is not already linked, do you want to compare the folders? (y/n):\n'
				read -r answer
				if [[ "$answer" == "y" ]] ; then
					$DIFF  "$R" ~/"$R"
					echo -e "Now this script can backup your $R file to $R.old and link the $R dotfile from this folder to your home so it will become effective. Do you agree? (y/n)"
					read -r answ2
					if [[ "$answ2" == "y" ]] ; then
						mv ~/"$R" ~/"$R".old
						ln -s `pwd`/"$R" ~/
						printf "Done. \n"
					else printf "Nothing was changed. \n"
					fi
				fi
		else
			ln -s `pwd`/$R ~/
			echo -e "\033[1mlinking\033[0m \033[4m$R\033[0m to ~/ ..."
		fi
	done

	# special

	# .config

	for R in .config/emacs .config/ghostwriter .config/castor  .config/geany .config/nvim .config/micro
	do
		if [ -e ~/$R ]; then
			echo -e "~/$R is already present on your system."
			echo -e "Now this script can backup your $R file to $R.old and link the $R dotfile from this folder to your home so it will become effective. Do you agree? (y/n)"
					read -r answ3
					if [[ "$answ3" == "y" ]] ; then
						mv ~/"$R" ~/"$R".old
						ln -s `pwd`/"$R" ~/.config/
						printf "Done. \n"
					else printf "Nothing was changed. \n"
					fi
		else
			ln -s `pwd`/$R ~/.config/
			echo -e "\033[1mlinking\033[0m \033[4m$R\033[0m to ~/.config ..."
		fi
	done

	# .config/GottCode ?

	# .config micro

	# .local/share 

	for R in .local/share/GottCode/FocusWriter/Themes
		do
		if [ -e ~/$R ]; then
			echo -e "~/$R is already present on your system."
		else
			ln -s `pwd`/$R ~/.local/share/GottCode/FocusWriter/
			echo -e "\033[1mlinking\033[0m \033[4m$R\033[0m to ~/.local ..."
		fi
	done

	for R in .local/share/cool-retro-term
		do
		if [ -e ~/$R ]; then
			echo -e "~/$R is already present on your system."
		else
			ln -s `pwd`/$R ~/.local/share/
			echo -e "\033[1mlinking\033[0m \033[4m$R\033[0m to ~/.local ..."
		fi
	done

	# we won't copy the whole folder for those projects

	# atom
	for R in .atom/styles.less .atom/config.cson
		do
		if [ -f ~/$R ]; then
			echo -e "~/$R is already present on your system."
		else
			echo -e "Installing .atom links. Don't forget to install also the file-watcher package!"
			mkdir ~/.atom/
			ln -s `pwd`/$R ~/.atom/
			echo -e "\033[1mlinking\033[0m \033[4m$R\033[0m to ~/ ..."
		fi
	done

	# byobu

	for R in .byobu/keybindings.tmux
		do
		if [ -f ~/$R ]; then
			echo -e "~/$R is already present on your system."
		else
			echo -e "Installing byobu links. "
			mkdir ~/.byobu/
			ln -s `pwd`/$R ~/.byobu/
			echo -e "\033[1mlinking\033[0m \033[4m$R\033[0m to ~/ ..."
		fi
	done

	# lagrange: we want only general prefs and fonts, not private keys!
	for R in .config/lagrange/fonts .config/lagrange/prefs.cfg
		do
		if [ -f ~/$R ]; then
			echo -e "~/$R is already present on your system. Backup and/or delete it first manually."
		else
			echo -e "Installing lagrange links. "
			mkdir -p ~/.config/lagrange/
			ln -s `pwd`/$R ~/.config/lagrange/
			echo -e "\033[1mlinking\033[0m \033[4m$R\033[0m to ~/ ..."
		fi
	done

	# windowmaker 
	for R in GNUstep/Library/WindowMaker/Themes/GruvBox.style
		do
		if [ -f ~/$R ]; then
			echo -e "~/$R is already present on your system. Backup and/or delete it first manually."
		else
			echo -e "Installing WindowMaker links. "
			mkdir -p ~/GNUstep/Library/WindowMaker/Themes/
			ln -s `pwd`/$R ~/GNUstep/Library/WindowMaker/Themes/
			echo -e "\033[1mlinking\033[0m \033[4m$R\033[0m to ~/ ..."
		fi
	done

	for R in GNUstep/Defaults/WindowMaker GNUstep/Defaults/WMState
		do
		if [ -f ~/$R ]; then
			echo -e "~/$R is already present on your system. Backup and/or delete it first manually."
		else
			echo -e "Installing WindowMaker links. "
			mkdir -p ~/GNUstep/Defaults/
			ln -s `pwd`/$R ~/GNUstep/Defaults
			echo -e "\033[1mlinking\033[0m \033[4m$R\033[0m to ~/ ..."
		fi
	done

# more
printf "Now this script can install french locale properties for scite in /usr/share/scite/ (using sudo). Do you agree? (y/n)"
				read -r answ4
				if [[ "$answ4" == "y" ]] ; then
					sudo cp .scite/locale.fr.properties /usr/share/scite/
					printf "Done. \n"
				else printf "Nothing was changed. \n"
				fi
				
}


#apt-mini
#apt-extra
deploy_dotfiles
