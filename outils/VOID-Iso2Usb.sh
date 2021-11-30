#!/bin/bash
# VOID-Iso2UsbBootCreator by TofF
# Date : 29/11/2021

WDIR=$(pwd)
source $HOME/.config/user-dirs.dirs

# FICHIERS TEMPORAIRE

LIST=$(mktemp)
LIST2=$(mktemp)
LISTUSB=$(mktemp)
LISTUSB2=$(mktemp)
source $HOME/.config/user-dirs.dirs
cd $XDG_DOWNLOAD_DIR
ADDRESS="https://alpha.de.repo.voidlinux.org/live/current/"

function MENU(){

# RECUPERATION DU LISTING ISO VOIDLINUX TELECHARGEABLE
unset listiso
while read -r version
do
listiso+=("$version")
done < LIST
iso=$(zenity --list --title "VOID-Iso2Usb" --text "Version de voidlinux disponible :" --width 400 --height 600 --column "OS" "${listiso[@]}")

# RECUPERATION DES PARTITIONS
lsblk -n -d -o "NAME","SIZE" > LISTUSB
unset listusb
while read -r cle
do
listusb+=("$cle")
done < LISTUSB
usb=$(zenity --list --title "VOID-Iso2Usb" --text "Périphérique disponible :" --width 400 --height 250 --column "NAME" "${listusb[@]}" )
echo $usb > LISTUSB2 && cut -c-4 LISTUSB2 > LISTUSB

# TELECHARGEMENT DE L'ISO SELECTIONNE
wget --progress=bar:force $ADDRESS$iso 2>&1 | zenity --progress --title "VOID-Iso2Usb" --text "Téléchargement de l'iso $iso" --auto-close --auto-kill

# MONTAGE DE L'ISO SUR LA PARTITION SELECTIONNEE
sudo -S dd bs=4M if=$XDG_DOWNLOAD_DIR/$iso of=/dev/$(cat LISTUSB) status=progress 2>&1 | zenity --progress --width 400 --height 100 --title "Installation Clé USB VoidLinux" --text "Création clé USB Void en cours" --auto-close --auto-kill
sudo sync | zenity --info --title "VOID-Iso2Usb" --width 500 --height 100 "Travail terminé" --text "Clé synchro - Go install !!!"

}

function DOWNLOAD(){
# TELECHARGEMENT DE L'INDEX DES VERSIONS DE VOIDLINUX
wget -nv -q $ADDRESS
grep -E 'void-|.iso' index.html > LIST
cut -c 10- LIST > LIST2
cut -d '"' -f 1 LIST2 > LIST
}


function START(){
zenity --question --title "VOID-Iso2Usb" --width 300 --height 100 --text "Création d'un disque d'installation USB VoidLinux\n Cet utilitaire va télécharger et installer voidlinux\nVoulez vous continuez ?"
DOWNLOAD
MENU

}

START
rm -f LIST*
rm -f index*
rm -f $XDG_DOWNLOAD_DIR/$iso