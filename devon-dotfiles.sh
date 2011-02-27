#!/bin/bash

# ---------------------------------------------------------------------------- #
# DOTFILES                                                                     #
# ---------------------------------------------------------------------------- #

cd `dirname $0`

SRC=./dotfiles

echo "copying nanorc to ~/.nanorc"
cp $SRC/nanorc ~/.nanorc

echo "copying bash_aliases to ~/.bash_aliases"
cp $SRC/bash_aliases ~/.bash_aliases

echo "copying bashrc to ~/.bashrc"
cp $SRC/bashrc ~/.bashrc

echo "copying pythonrc to ~/.pythonrc"
cp $SRC/pythonrc ~/.pythonrc
set PYTHONSTARTUP=~/.pythonrc

