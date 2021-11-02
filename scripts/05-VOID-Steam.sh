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
