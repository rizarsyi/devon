#!/bin/bash

# ---------------------------------------------------------------------------- #
# GIT AWESOMENESS                                                              #
# ---------------------------------------------------------------------------- #

echo "installing git"
sudo apt-add-repository ppa:git-core/ppa
sudo apt-get update
yes | sudo aptitude install git-core git-completion curl

echo "installing visionmedia's git-extras"
curl https://github.com/visionmedia/git-extras/raw/master/bin/git-update-extras | sudo sh

echo "installing defunkt's hub"
curl http://chriswanstrath.com/hub/standalone -sLo ~/hub && chmod 755 ~/hub
sudo mv ~/hub /usr/bin/hub && sudo chown root /usr/bin/hub
if [ ! -z `alias -p | grep hub` ]; then
    `cat alias git=hub >> ~/.bash_aliases`
fi

