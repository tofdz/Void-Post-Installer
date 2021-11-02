#!/bin/bash
I3CONF=$HOME/.config/i3/
I3BCONF=$HOME/.config/i3/i3blocks.conf

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

# PREPARATION DES FICHIERS DE CONFIF ET CLEAN POUR L'INSTALL
if [ -f $I3CONF/config ];then
sudo pycp $I3CONF/config $I3CONF/config.ori
rm -fv $I3CONF/config
else
# INSTALLATION DES FICHIERS DE CONFIGURATION & WALLPAPERS
sudo pycp $HOME/Void-Post-Installer/config/config $I3CONF
sudo pycp $HOME/Void-Post-Installer/config/i3blocks.conf $I3CONF
sudo pycp $HOME/Void-Post-Installer/wallpapers/* $HOME/Images/
fi
#Installer la police qui va bien
#OUUUUUUUUUPPPP OUUUUUUUUUUP THAAAAAAAT'S DAAAAAAAAA SOUUUUUUUUUN OF DAAAAAAAAAA POOOOOOOOOLICE !
cd $HOME
git clone https://github.com/supermarin/YosemiteSanFranciscoFont
sudo pycp $HOME/YosemiteSanFranciscoFont/*.ttf $HOME/.fonts/
fc-cache -fv
echo "Suppression des Fichiers inutile"
rm -rfv YosemiteSanFranciscoFont
sudo vpm i -y i3-gaps i3ipc-glib i3status i3wsr dmenu rofi i3blocks i3blocks-blocklets pasystray font-awesome5 lxappearance feh adwaita-plus compton ImageMagick i3lock-color 
