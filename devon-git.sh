#!/bin/bash

# ---------------------------------------------------------------------------- #
# GIT AWESOMENESS                                                              #
# ---------------------------------------------------------------------------- #

echo "installing git"
sudo apt-add-repository ppa:git-core/ppa
sudo apt-get update
yes | sudo aptitude install git-core git-completion curl

if [ -z `which hub` ]; then
    # install visionmedia's git-extras
    curl https://github.com/visionmedia/git-extras/raw/master/bin/git-update-extras | sudo sh
    # install defunkt's hub
    curl http://chriswanstrath.com/hub/standalone -sLo ~/hub && chmod 755 ~/hub
    sudo mv ~/hub /usr/bin/hub && sudo chown root /usr/bin/hub
    echo alias git=hub >> ~/.bash_aliases
    source ~/.bash_aliases
fi

