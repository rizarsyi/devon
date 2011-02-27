#!/bin/bash

# DEVON_DIR
cd `dirname $0`

# ---------------------------------------------------------------------------- #
# DOTFILES                                                                     #
# ---------------------------------------------------------------------------- #

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

# ---------------------------------------------------------------------------- #
# SOME UBUNTU PACKAGES                                                         #
# ---------------------------------------------------------------------------- #

sudo add-apt-repository ppa:gnome-terminator
sudo apt-add-repository ppa:git-core/ppa
sudo apt-get update

echo "installing terminator"
yes | sudo aptitude install terminator

# ---------------------------------------------------------------------------- #
# GIT AWESOMENESS                                                              #
# ---------------------------------------------------------------------------- #

echo "installing git"
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

# ---------------------------------------------------------------------------- #
# PYTHON AWESOMENESS                                                           #
# ---------------------------------------------------------------------------- #

echo "installing some Python packages"
yes | sudo aptitude install python-setuptools libapache2-mod-wsgi
sudo easy_install -U pip
sudo pip install virtualenv nose should-dsl fabric --upgrade

# ---------------------------------------------------------------------------- #
# LAMP                                                                         #
# ---------------------------------------------------------------------------- #

echo "install Apache"
yes | sudo aptitude install apache2 apache2-mpm-prefork apache2-prefork-dev apache2-utils apache2.2-common

echo "install MySQL"
yes | sudo aptitude install mysql-server-5.1 mysql-client-5.1 libmysqlclient16-dev

echo "install PHP"
yes | sudo aptitude install php5 php5-xdebug php5-suhosin php5-mysql php5-gd libapache2-mod-php5

# ---------------------------------------------------------------------------- #
# GEDIT AWESOMENESS                                                            #
# ---------------------------------------------------------------------------- #

SRC=./gedit

#=== PLUGINS ===#
PLUGINS=~/.gnome2/gedit/plugins
if [ ! -d $PLUGINS ]; then
    mkdir -p $PLUGINS
fi
cp -R $SRC/plugins/* $PLUGINS/
echo "grabbing other plugins from package manager"
yes | sudo aptitude install gedit-plugins

#=== LANGUAGE-SPECS ===#
SPECS=~/.local/share/gtksourceview-2.0/language-specs
if [ ! -d $SPECS ]; then
    mkdir -p $SPECS
fi
cp -R $SRC/lang-specs/* $SPECS/

#=== SNIPPETS ===#
SNIPPETS=~/.gnome2/gedit/snippets
if [ ! -d $SNIPPETS ]; then
    mkdir -p $SNIPPETS
fi
cp -R $SRC/snippets/* $SNIPPETS/

#=== STYLES ===#
STYLES=~/.gnome2/gedit/styles
if [ ! -d $STYLES ]; then
    mkdir -p $STYLES
fi
cp -R $SRC/styles/* $STYLES/

echo "Plugins  => ~/.gnome2/gedit/plugins, /usr/lib/gedit-2/plugins"
echo "Language => ~/.local/share/gtksourceview-2.0/language-specs"
echo "Snippets => ~/.gnome2/gedit/snippets"
echo "Themes   => ~/.gnome2/gedit/styles"

