#!/bin/bash

# GIT AWESOMENESS
yes | sudo aptitude install python-setuptools python-twisted libapache2-mod-wsgi
sudo easy_install -U pip
sudo pip install virtualenv nose

