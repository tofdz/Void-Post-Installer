#!/bin/bash
## VARIABLES
I3CONF=$HOME/.config/i3				# Dossier .config/i3/
I3FILE=$I3CONF/config				# Fichier .config/i3/config

if [ ! -d $HOME/.fonts ];then
	mkdir $HOME/.fonts
else
echo "Dossier .fonts déjà présent"
fi
if [ ! -d $I3CONF ];then
	mkdir $I3CONF
else
echo "Dossier i3 déjà présent"
fi

# INSTALLATION DES FICHIERS DE CONFIGURATION & WALLPAPERS
sudo vpm i -y i3-gaps i3ipc-glib i3status i3wsr dmenu rofi i3blocks i3blocks-blocklets pasystray font-awesome5 lxappearance feh adwaita-plus compton ImageMagick i3lock-color xautolock 

## PREPARATION DES FICHIERS DE CONFIF ET CLEAN POUR L'INSTALL

# Verification
if [ -f $I3FILE ];then
sudo pycp $I3FILE $I3CONF/config.ori
rm -fv $I3FILE
fi

sudo pycp $WDIR/scripts/blurlock /bin/
sudo pycp $$WDIR/config/i3blocks.conf $WDIR/config/config $I3CONF

sudo chmod +x /bin/blurlock
