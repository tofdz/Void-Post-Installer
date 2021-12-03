#!/bin/bash
## VARIABLES
CONFIGDIR="$HOME/Void-Post-Installer"
				# Dossier .config
I3FILE="$HOME/.config/i3/config"
I3DIRCONF="$HOME/.config/i3"				# Dossier .config/i3/
ROFIFILE="$HOME/.config/rofi/config.rasi"			# Ficher .config/rofi/config


echo -e "===> 08-VOID-i3.sh"
# VERIF REPERTOIRE FONTS
if [ ! -d $HOME/.fonts ];then
	mkdir $HOME/.fonts
else
echo -e "/!\ Dossier .fonts déjà présent"
fi
# VERIF REPERTOIRE I3
if [ ! -d $I3DIRCONF ];then
	mkdir $I3DIRCONF
else
echo -e "/!\ Dossier i3 déjà présent"
fi
# VERIF REPERTOIRE ROFI
if [ ! -d $ROFIDIRCONF ];then
	mkdir $ROFIDIRCONF
else
echo -e "/!\ Dossier rofi déjà présent"
fi

# INSTALLATION DES FICHIERS DE CONFIGURATION & WALLPAPERS

if [ ! -f $I3FILE ];then
sudo pycp $CONFIGDIR/config/* $HOME/.config 
else
echo "==> i3 config files déjà présent - skip"
fi
# Verification
sudo vpm i -y i3-gaps i3ipc-glib i3status i3wsr rofi i3blocks i3blocks-blocklets pasystray font-awesome5 lxappearance feh adwaita-plus compton compton-conf ImageMagick i3lock-color xautolock 

sudo pycp $CONFIGDIR/scripts/blurlock /bin/
sudo chmod +x /bin/blurlock