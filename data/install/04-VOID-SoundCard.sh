#!/bin/bash
# recupere dans lsusb et lspci le peripherique audio (ne respecte pas la casse grace à "-i" )

#VARIABLES
scan[]




function SCAN(){

# recupere la liste des cartes son présente

touch soundcard-list
lsusb | grep -i "audio" > soundcard-list &&lspci | grep -i "audio" > soundcard-list;

amixer -D pulse set Master toggle

amixer -D pulse set Master playback toggle

#commande super interressante !!!!
amixer -D pulse set Master 1+ toggle

#Liste toutes les fonctions dispo par la carte son
amixer -c <card-number>

}