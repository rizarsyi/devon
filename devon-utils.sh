#!/bin/bash

# ---------------------------------------------------------------------------- #
# SOME UBUNTU PACKAGES                                                         #
# ---------------------------------------------------------------------------- #

sudo add-apt-repository ppa:gnome-terminator
sudo apt-get update

echo "installing terminator"
yes | sudo aptitude install terminator

