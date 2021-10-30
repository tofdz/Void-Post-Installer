#!/bin/bash
I3CONF=$HOME/.config/i3/
I3BCONF=$HOME/.config/i3/i3blocks.conf

if [ ! -d $HOME/.fonts ];then
	mkdir $HOME/.fonts
else
echo "Dossier .fonts déjà présent"
fi

# TELECHARGEMENT DES PAQUETS POUR i3
echo "Installation Paquets pour le gestionnaire i3"
sudo vpm i -y i3 i3ipc-glib i3status i3wsr i3-gaps dmenu rofi iblocks i3blocks-blocklets pasystray font-awesome5-5.15.4_1 lxappearance

# PREPARATION DES FICHIERS DE CONFIF ET CLEAN POUR L'INSTALL
pycp $I3CONF/config $I3CONF/config.ori
rm -fv $I3CONF/config

# INSTALLATION DES FICHIERS DE CONFIGURATION
pycp config/config $I3CONF
pycp config/i3blocks.conf $I3CONF

#Installer la police qui va bien
#OUUUUUUUUUPPPP OUUUUUUUUUUP THAAAAAAAT'S DAAAAAAAAA SOUUUUUUUUUN OF DAAAAAAAAAA POOOOOOOOOLICE !
cd $HOME
git clone https://github.com/supermarin/YosemiteSanFranciscoFont
pycp YosemiteSanFranciscoFont/'Text Face (Alternate)/'*.ttf $HOME/.fonts/
fc-cache -fv
echo "Suppression des Fichiers inutile"
rm -rfv YosemiteSanFranciscoFont
