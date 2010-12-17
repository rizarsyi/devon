#!/bin/bash

# SCRIPT_DIR
cd `dirname $0`

echo "copying nanorc to ~/.nanorc"
cp ../src/nanorc ~/.nanorc

echo "copying bash_aliases to ~/.bash_aliases"
cp ../src/bash_aliases ~/.bash_aliases

echo "copying bashrc to ~/.bashrc"
cp ../src/bashrc ~/.bashrc

