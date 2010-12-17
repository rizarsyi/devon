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

# codecomment
echo "=> codecomment"
cp -R $SRC/gedit-plugins/plugins/codecomment/* $PLUGINS
mv $PLUGINS/codecomment.gedit-plugin.desktop.in.in $PLUGINS/codecomment.gedit-plugin

# colorpicker
echo "=> colorpicker"
cp -R $SRC/gedit-plugins/plugins/colorpicker/* $PLUGINS
mv $PLUGINS/colorpicker.gedit-plugin.desktop.in.in $PLUGINS/colorpicker.gedit-plugin

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

# sessionsaver
echo "=> sessionsaver"
cp -R $SRC/gedit-plugins/plugins/sessionsaver $PLUGINS
mv $PLUGINS/sessionsaver/sessionsaver.gedit-plugin.desktop.in.in $PLUGINS/sessionsaver.gedit-plugin
rm $PLUGINS/sessionsaver/*.am

# smartspaces
echo "=> smartspaces"
cp -R $SRC/gedit-plugins/plugins/smartspaces/* $PLUGINS
mv $PLUGINS/smartspaces.gedit-plugin.desktop.in.in $PLUGINS/smartspaces.gedit-plugin

# smarthome
echo "=> smarthome"
cp -R $SRC/gedit-plugin-smarthome/* $PLUGINS

# snapopen
echo "=> snapopen"
cp -R $SRC/gedit-plugin-snapopen/* $PLUGINS
rm $PLUGINS/snapopen/CHANGELOG $PLUGINS/snapopen/INSTALL $PLUGINS/snapopen/README $PLUGINS/snapopen/VERSION

# terminal
echo "=> terminal"
cp -R $SRC/gedit-plugins/plugins/terminal/* $PLUGINS
mv $PLUGINS/terminal.gedit-plugin.desktop.in.in $PLUGINS/terminal.gedit-plugin

# copy the gpdefs.py
cp $SRC/gedit-plugins/plugins/gpdefs.py.in $PLUGINS/gpdefs.py

# zencoding
echo "=> zencoding"
cp -R $SRC/gedit-plugin-zencoding/* $PLUGINS

# cleanup unnecessary files
rm $PLUGINS/*.am
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

