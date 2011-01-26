#!/bin/bash

if [ ! -z `which git` ]; then
    git submodule update
fi

# SCRIPT_DIR
cd `dirname $0`
SRC=../src

#=== PLUGINS ===#
PLUGINS=~/.gnome2/gedit/plugins
if [ ! -d $PLUGINS ]; then
    mkdir -p $PLUGINS
fi
cp -R $SRC/gedit/plugins/* $PLUGINS/
echo "grabbing other plugins from package manager"
yes | sudo aptitude install gedit-plugins

#=== LANGUAGE-SPECS ===#
SPECS=~/.local/share/gtksourceview-2.0/language-specs
if [ ! -d $SPECS ]; then
    mkdir -p $SPECS
fi
cp -R $SRC/gedit/lang-specs/* $SPECS/

#=== SNIPPETS ===#
SNIPPETS=~/.gnome2/gedit/snippets
if [ ! -d $SNIPPETS ]; then
    mkdir -p $SNIPPETS
fi
cp -R $SRC/gedit/snippets/* $SNIPPETS/

#=== STYLES ===#
STYLES=~/.gnome2/gedit/styles
if [ ! -d $STYLES ]; then
    mkdir -p $STYLES
fi
cp -R $SRC/gedit/styles/* $STYLES/

echo "Plugins  => ~/.gnome2/gedit/plugins, /usr/lib/gedit-2/plugins"
echo "Language => ~/.local/share/gtksourceview-2.0/language-specs"
echo "Snippets => ~/.gnome2/gedit/snippets"
echo "Themes   => ~/.gnome2/gedit/styles"

