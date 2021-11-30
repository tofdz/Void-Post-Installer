#!/bin/bash
# VOID-Iso2UsbBootCreator by TofF
# Date : 29/11/2021
WDIR=$(pwd)
source $HOME/.config/user-dirs.dirs

# FICHIERS TEMPORAIRE
#touch $WDIR/.LIST
#touch $WDIR/.LISTUSB
#touch $WDIR/.LISTUSB2
LIST=$(mktemp)
LIST2=$(mktemp)
LISTUSB=$(mktemp)
LISTUSB2=$(mktemp)
source $HOME/.config/user-dirs.dirs
cd $XDG_DOWNLOAD_DIR
ADDRESS="https://alpha.de.repo.voidlinux.org/live/current/"

function MENU(){

unset listiso
while read -r version
do
listiso+=("$version")
done < LIST
iso=$(zenity --list --title "VOID-Iso2Usb" --text "Version de voidlinux disponible :" --width 400 --height 600 --column "OS" "${listiso[@]}")

#lsblk -d | cut -c-4 > .LISTUSB
lsblk -n -d -o "NAME","SIZE" > LISTUSB

unset listusb
while read -r cle
do
listusb+=("$cle")
done < LISTUSB
usb=$(zenity --list --title "VOID-Iso2Usb" --text "Périphérique disponible :" --width 400 --height 250 --column "NAME" "${listusb[@]}" )
echo $usb > LISTUSB2 && cut -c-4 LISTUSB2 > LISTUSB

# TELECHARGEMENT DE L'ISO SELECTIONNE
wget $ADDRESS$iso -q --progress=bar:force:noscroll | zenity --progress --title "VOID-Iso2Usb" --text "Téléchargement de l'iso $iso" --auto-close
# MONTAGE DE L'ISO SUR LA PARTITION SELECTIONNEE
sudo -S dd bs=4M if=$XDG_DOWNLOAD_DIR/$iso of=/dev/$(cat LISTUSB) status=progress | zenity --progress --width 400 --height 100 --title "Installation Clé USB VoidLinux" --text "Création clé USB Void en cours" --auto-close
sudo sync | zenity --info --title "VOID-Iso2Usb" --width 500 --height 100 "Travail terminé" --text "Clé synchro - Go install !!!"
}

function DOWNLOAD(){

wget -nv --show-progress $ADDRESS
grep -E 'void-|.iso' index.html > LIST
cut -c 10- LIST > LIST2
cut -d '"' -f 1 LIST2 > LIST
}


function START(){
zenity --question --title "VOID-Iso2Usb" --width 300 --height 100 --text "Création d'un disque d'installation USB VoidLinux"
DOWNLOAD
MENU

}

START
rm -f LIST*
rm -f index*
rm -f $XDG_DOWNLOAD_DIR/$iso