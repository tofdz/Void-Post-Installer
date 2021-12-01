#!/bin/bash
## VARIABLES
CONFDIR=$HOME/.config/					# Dossier .config
I3DIRCONF=$CONFDIR/i3				# Dossier .config/i3/
I3FILE=$I3DIRCONF/config				# Fichier .config/i3/config
ROFIDIRCONF=$CONFDIR/rofi/			# Dossier .config/rofi/
ROFIFILE=$ROFICONFDIR/config.rasi			# Ficher .config/rofi/config

if [ ! -d $HOME/.fonts ];then
	mkdir $HOME/.fonts
else
echo "Dossier .fonts déjà présent"
fi
if [ ! -d $I3DIRCONF ];then
	mkdir $I3DIRCONF
else
echo "Dossier i3 déjà présent"
fi
if [ ! -d $ROFIDIRCONF ];then
	mkdir $ROFIDIRCONF
else
echo "Dossier rofi déjà présent"
fi

# INSTALLATION DES FICHIERS DE CONFIGURATION & WALLPAPERS
sudo vpm i -y i3-gaps i3ipc-glib i3status i3wsr rofi i3blocks i3blocks-blocklets font-awesome5 lxappearance feh adwaita-plus compton compton-conf ImageMagick i3lock-color xautolock 

# Verification
if [ -f $I3FILE ];then
sudo pycp $I3FILE $I3DIRCONF/config.ori
rm -fv $I3FILE
fi

if [ -f $ROFIFILE ];then
sudo pycp $ROFIFILE $ROFIDIRCONF/config.rasi.ori
rm -fv $I3FILE
fi

sudo pycp $WDIR/scripts/blurlock /bin/
sudo pycp $WDIR/config/* $CONFDIR
sudo chmod +x /bin/blurlock
