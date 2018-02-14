#!/bin/bash

# set -x
set -e

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old/$(date +%F_%R)             # old dotfiles backup directory
file_path_abs=$(find $dir/dotfiles -type f)    # list of files/folders to symlink in homedir

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
if [ -d $olddir ]; then
    mkdir -p $olddir
fi


for file in $file_path_abs; do
    file_path_relative=$(echo $file | sed s#$dir/dotfiles/##)
    echo $file_path_relative
    file_home=~/$file_path_relative  # file expected in ~
    echo $file_home
    file_backup="$olddir/$file_path_relative"  # backup file
    echo $file_backup

    # backup files along with its directory in ~ to $olddir
    if [ -e "$file_home" ]; then
        # Create directory before backup if necessary
        if [ ! -e $file_backup ]; then
            mkdir -p $file_backup
            rm -r $file_backup
        fi
        echo "Moving $file_home to $file_backup"
        mv $file_home $file_backup  # we intended to use mv not cp here
    fi

    # creating symlink to $file in home directory
    echo "Creating symlink to $file in home directory."
    # Create directory before creating sysmlink if necessary
    if [ ! -e $file_home ]; then
        mkdir -p $file_home
        rm -r $file_home
    fi
    ln -s $file $file_home  # creating symlink to $file in home directory
done
