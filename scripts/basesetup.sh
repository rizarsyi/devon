#!/bin/bash

echo "copying gnome2 to ~/.gnome2/"
cp -R ../gnome2/* ~/.gnome2/

echo "copying local to ~/.local/"
cp -R ../local/* ~/.local/

echo "copying nanorc to ~/.nanorc"
cp ../nanorc ~/.nanorc

echo "copying bash_aliases to ~/.bash_aliases"
cp ../bash_aliases ~/.bash_aliases

echo "copying bashrc to ~/.bashrc"
cp ../bashrc ~/.bashrc

