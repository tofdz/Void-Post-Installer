#!/bin/bash

# Installation de Steam sur VoidLinux.
#Paquets de base


function BASE(){
#Installe le necessaire pour faire fonctionner steam & gamepad
flatpak install app/com.valvesoftware.Steam/x86_64/stable
sudo vpm i -y libgcc-32bit libstdc++-32bit libdrm-32bit libglvnd-32bit mono void-repo-multilib{,-nonfree}

sudo usermod -a -G input $USER 
}

function NVIDIA(){
#Installe les drivers nvidia new gen (RTX compatible)
sudo vpm i -y nvidia-libs-32bit-470.74_1
}

function OPENSOURCE(){
#installe les drivers opensource
sudo vpm i -y mesa-dri-32bit
}

function CONTROLLER(){
sudo vpm i -y sc-controller
}
function MAIN(){

BASE
NVIDIA
#OPENSOURCE
CONTROLLER
}

MAIN
