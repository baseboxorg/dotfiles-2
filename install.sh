#!/bin/bash
#######################################################################
# dotfiles/makesymlinks.sh
# Mark Spain
#
# This script creates symlinks from the home directory to any desired
# dotfiles in ~/dotfiles
#######################################################################

# variables
########################################
dir=$HOME/dotfiles        # dotfiles directory
oldDir=$HOME/dotfiles_old # old dotfiles backup directory
# list of files/folders to symlink in homedir
files="bash_profile bash_load.sh aliases.sh env.sh functions.sh bashrc gitconfig vim zshrc oh-my-zsh private tomcat.sh"

# create dotfiles_old in homedir
########################################
echo "Creating $oldDir for backup of any existing dotfiles in ~"
mkdir -p $oldDir
echo "...done"

# change to the dotfiles directory
########################################
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# install zsh customization files
########################################
install_zsh () {
  if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
    # install submodules
    git submodule update --init --recursive
    # set the default shell to zsh if it isn't currently set to zsh
    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
        chsh -s $(which zsh)
    fi
    # clone zsh-syntax-highlighting from GitHub only if it isn't already present
    #if [[ ! -d $dir/oh-my-zsh/custom/plugins/zsh-syntax-highlighting/ ]]; then
    #    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $dir/oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    #fi
  else
    # get operating system
    OS=$(uname);
    # if the os is Linux, try an apt-get to install zsh and then recurse
    if [[ $OS == Linux ]]; then
        sudo apt-get install zsh
        install_zsh
    # if the os is OS X, tell the user to install zsh
    elif [[ $OS == Darwin ]]; then
        echo "Please install zsh, then re-run this script!"
        exit
    fi
  fi
}

install_zsh

# backup old dotfiles and create symlinks to new ones
########################################
echo "Moving any existing dotfiles from ~ to $oldDir"
for file in $files; do 
    mv $HOME/.$file $HOME/dotfiles_old/
    echo "Creating symlink to $file in home directory"
    ln -s $dir/$file $HOME/.$file
done
echo "...done"

