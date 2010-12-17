#!/bin/bash

if [ -z `which git` ]; then
    echo "please install git first"
    exit
fi

#git submodule update

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
echo "installing autocomplete"
cp -R $SRC/gedit-plugin-autocomplete/* $PLUGINS
rm $PLUGINS/autocomplete/lib/asp.json

# classbrowser
echo "i need to install exuberant-ctags, gimme a sudo pass"
yes | sudo aptitude install exuberant-ctags
echo "installing classbrowser"
cp -R $SRC/gedit-plugin-classbrowser/* $PLUGINS

# folding
echo "installing classbrowser"
cp -R $SRC/gedit-plugin-folding/* $PLUGINS

# phpcompletion
echo "installing phpcompletion"
cp -R $SRC/gedit-plugin-phpcompletion/plugin/* $PLUGINS

# pylint
echo "installing pylint"
cp -R $SRC/gedit-plugin-pylint/pylint $PLUGINS
cp $SRC/gedit-plugin-pylint/pylint.gedit-plugin $PLUGINS

# quickhighlightmode
echo "installing quickhighlightmode"
cp -R $SRC/gedit-plugin-quickhighlightmode/* $PLUGINS

# smarthome
echo "installing smarthome"
cp -R $SRC/gedit-plugin-smarthome/* $PLUGINS
rm $PLUGINS/README.rst

# snapopen
echo "installing snapopen"
cp -R $SRC/gedit-plugin-snapopen/* $PLUGINS

# zencoding
echo "installing zencoding"
cp -R $SRC/gedit-plugin-zencoding/* $PLUGINS

