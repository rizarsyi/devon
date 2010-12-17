#!/bin/bash

if [ -z `which git` ]; then
    echo "please install git first"
    exit
fi

git submodule update

# SCRIPT_DIR
cd `dirname $0`

PLUGINS=../build/gnome2/gedit/plugins
SRC=../src

if [ ! -d $PLUGINS ]; then
    mkdir -p $PLUGINS
fi

#========================================================================
# PLUGINS
#========================================================================

# autocomplete
echo "=> autocomplete"
cp -R $SRC/gedit-plugin-autocomplete/* $PLUGINS
rm $PLUGINS/autocomplete/lib/asp.json

# classbrowser
echo "=> classbrowser"
cp -R $SRC/gedit-plugin-classbrowser/* $PLUGINS

# folding
echo "=> folding"
cp -R $SRC/gedit-plugin-folding/* $PLUGINS

# phpcompletion
echo "=> phpcompletion"
cp -R $SRC/gedit-plugin-phpcompletion/plugin/* $PLUGINS

# pylint
echo "=> pylint"
cp -R $SRC/gedit-plugin-pylint/pylint $PLUGINS
cp $SRC/gedit-plugin-pylint/pylint.gedit-plugin $PLUGINS

# quickhighlightmode
echo "=> quickhighlightmode"
cp -R $SRC/gedit-plugin-quickhighlightmode/* $PLUGINS
chmod 644 $PLUGINS/quickhighlightmode.gedit-plugin

# smarthome
echo "=> smarthome"
cp -R $SRC/gedit-plugin-smarthome/* $PLUGINS

# snapopen
echo "=> snapopen"
cp -R $SRC/gedit-plugin-snapopen/* $PLUGINS
rm $PLUGINS/snapopen/CHANGELOG $PLUGINS/snapopen/INSTALL $PLUGINS/snapopen/README $PLUGINS/snapopen/VERSION

# zencoding
echo "=> zencoding"
cp -R $SRC/gedit-plugin-zencoding/* $PLUGINS

# cleanup unnecessary files
rm $PLUGINS/*.rst
rm $PLUGINS/*.md
rm -rf $PLUGINS/*.git*

# lets copy those files to ~/.gnome2/gedit/plugins
GEDIT_PLUGINS=~/.gnome2/gedit/plugins
if [ ! -d $GEDIT_PLUGINS ]; then
    mkdir $GEDIT_PLUGINS
fi

echo "installed to ~/.gnome2/gedit/plugins"
cp -R $PLUGINS/* $GEDIT_PLUGINS
rm -rf ../build/gnome2

# codecomment, colorpicker, sessionsaver, smartspaces, terminal installed through synaptic
echo "grab other plugins from package manager"
yes | sudo aptitude install gedit-plugins
