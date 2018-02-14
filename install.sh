#!/bin/bash

# set -x
set -e

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old/$(date +%F_%R)             # old dotfiles backup directory
file_path_abs=$(find $dir/dotfiles -type f)    # list of files/folders to symlink in homedir

# create dotfiles_old in homedir
if [ -d $olddir ]; then
    echo "Creating $olddir for backup."
    mkdir -p $olddir
fi

for file in $file_path_abs; do
    file_path_relative=$(echo $file | sed s#$dir/dotfiles/##)
    file_home=~/$file_path_relative  # file expected in ~
    file_backup="$olddir/$file_path_relative"  # backup file

    # backup files along with its directory in ~ to $olddir
    if [ -e "$file_home" ]; then
        # Create directory before backup if necessary
        if [ ! -e $file_backup ]; then
            mkdir -p $file_backup
            rm -r $file_backup
        fi
        echo "Moving $file_home to $file_backup."
        mv $file_home $file_backup  # we intended to use mv not cp here
    fi

    # creating symlink to $file in home directory
    echo "Creating symlink from $file to $file."
    # Create directory before creating sysmlink if necessary
    if [ ! -e $file_home ]; then
        mkdir -p $file_home
        rm -r $file_home
    fi
    ln -s $file $file_home  # creating symlink to $file in home directory
done
