#!/bin/bash

# ---------------------------------------------------------------------------- #
# PYTHON AWESOMENESS                                                           #
# ---------------------------------------------------------------------------- #

echo "installing some Python packages"
yes | sudo aptitude install python-setuptools libapache2-mod-wsgi
sudo easy_install -U pip
sudo pip install virtualenv nose should-dsl fabric --upgrade

