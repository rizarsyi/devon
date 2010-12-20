#!/bin/bash

if [ ! -z `which git` ]; then
    git submodule update
fi

# SCRIPT_DIR
cd `dirname $0`

PLUGINS=~/.gnome2/gedit/plugins
SRC=../src
GMATE_PLUGINS=$SRC/gmate/plugins

if [ ! -d $PLUGINS ]; then
    mkdir -p $PLUGINS
fi

#=== PLUGINS ===#

# align
echo "=> align"
cp -R $GMATE_PLUGINS/align* $PLUGINS

# autocomplete
echo "=> autocomplete"
cp -R $SRC/gedit-plugin-autocomplete/* $PLUGINS

# classbrowser
echo "=> classbrowser"
cp -R $SRC/gedit-plugin-classbrowser/* $PLUGINS

# clientside
echo "=> clientside"
cp -R $SRC/gedit-plugin-clientside/* $PLUGINS

# folding
echo "=> folding"
cp -R $SRC/gedit-plugin-folding/* $PLUGINS

# gemini
echo "=> gemini"
cp -R $GMATE_PLUGINS/gemini* $PLUGINS

# phpcompletion
echo "=> phpcompletion"
cp -R $SRC/gedit-plugin-phpcompletion/plugin/* $PLUGINS

# quickhighlightmode
echo "=> quickhighlightmode"
cp -R $SRC/gedit-plugin-quickhighlightmode/* $PLUGINS
chmod 644 $PLUGINS/quickhighlightmode.gedit-plugin

# smarthome
echo "=> smarthome"
cp -R $SRC/gedit-plugin-smarthome/* $PLUGINS

# smart_indent
echo "=> smart_indent"
cp -R $GMATE_PLUGINS/smart_indent* $PLUGINS

# snapopen
echo "=> snapopen"
cp -R $SRC/gedit-plugin-snapopen/* $PLUGINS

# tabs_extend
echo "=> tabs_extend"
cp -R $SRC/gedit-plugin-tabs_extend/* $PLUGINS

# tabswitch
echo "=> tabswitch"
cp -R $GMATE_PLUGINS/tabswitch* $PLUGINS

# trailsave
echo "=> trailsave"
cp -R $GMATE_PLUGINS/trailsave* $PLUGINS

# zencoding
echo "=> zencoding"
cp -R $SRC/gedit-plugin-zencoding/* $PLUGINS

# cleanup unnecessary files
rm $PLUGINS/*.rst
rm $PLUGINS/*.md
rm -rf $PLUGINS/*.git*
echo "installed to ~/.gnome2/gedit/plugins"

# codecomment, colorpicker, sessionsaver, smartspaces, terminal installed through synaptic
echo "grab other plugins from package manager"
yes | sudo aptitude install gedit-plugins
echo "installed to /usr/lib/gedit-2/plugins"

#=== LANGUAGE-SPECS ===#

SPECS=~/.local/share/gtksourceview-2.0/language-specs

if [ ! -d $SPECS ]; then
    mkdir -p $SPECS
fi

# coffeescript
echo "=> coffeescript"
cp -R $SRC/gedit-lang-coffeescript/coffee_script.lang $SPECS/coffee_script.lang

echo "installed to ~/.local/share/gtksourceview-2.0/language-specs"

