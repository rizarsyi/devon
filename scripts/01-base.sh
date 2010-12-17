#!/bin/bash

echo "copying gnome2 to ~/.gnome2/"
cp -R ../build/gnome2/* ~/.gnome2/

echo "copying local to ~/.local/"
cp -R ../build/local/* ~/.local/

echo "copying nanorc to ~/.nanorc"
cp ../src/nanorc ~/.nanorc

echo "copying bash_aliases to ~/.bash_aliases"
cp ../src/bash_aliases ~/.bash_aliases

echo "copying bashrc to ~/.bashrc"
cp ../src/bashrc ~/.bashrc

