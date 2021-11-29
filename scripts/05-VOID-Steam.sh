#!/bin/bash

# Installation de Steam sur VoidLinux.
#Paquets de base

function BASE(){
#Installe le necessaire pour faire fonctionner steam & gamepad

sudo vpm i -y steam libgcc-32bit libstdc++-32bit libdrm-32bit libglvnd-32bit mono
sudo usermod -a -G input $USER
}

function NVIDIA(){
#Installe les drivers nvidia new gen (RTX compatible)
sudo vpm i -y nvidia-libs-32bit
}

function OPENSOURCE(){
#installe les drivers opensource
sudo vpm i -y mesa-dri-32bit
}
function PROTONUP(){
# INSTALLATION DE PROTONUP
pip3 install protonup

# Création du .profile pour prendre en compte le path de protonup
if [ ! -f $HOME/.profile ];then
echo "Création du .profile"
touch $HOME/.profile
echo 'if [ -d "$HOME/.local/bin" ] ; then' > $HOME/.profile
echo 'PATH="$HOME/.local/bin:$PATH"' >> $HOME/.profile
echo "fi" >> $HOME/.profile
echo "Fichier .profile - Terminé !"
source $HOME/.profile

# Création du repertoire pour Steam
if [ ! -d ~/.local/share/Steam/compatibilitytools.d ];then
sudo mkdir -R ~/.local/share/compatibitytools.d/
echo "Protonup - Repertoire pour steam créé"
fi
# Configuration repertoire steam Proton & install protonGH
echo "Configuration & Installation ProtonGH pour steam"
protonup -d "~/.local/share/Steam/compatibilitytools.d/" && protonup -y
}

function CONTROLLER(){
sudo vpm i -y sc-controller
}

function MAIN(){
BASE
NVIDIA
#OPENSOURCE
PROTONUP
CONTROLLER
}

MAIN
