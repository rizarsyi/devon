#!/bin/bash

# ---------------------------------------------------------------------------- #
# SOME UBUNTU PACKAGES                                                         #
# ---------------------------------------------------------------------------- #

echo "installing terminator"
sudo add-apt-repository ppa:gnome-terminator
sudo apt-get update
yes | sudo aptitude install terminator

