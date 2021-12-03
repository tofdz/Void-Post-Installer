#!/bin/bash
# VOID-Iso2UsbBootCreator by TofF
# Date : 29/11/2021

WDIR=$(pwd)
source $HOME/.config/user-dirs.dirs

# FICHIERS TEMPORAIRE
cd $XDG_DOWNLOAD_DIR
LIST=$(mktemp)
LIST2=$(mktemp)
LISTUSB=$(mktemp)
LISTUSB2=$(mktemp)

ADDRESS="https://alpha.de.repo.voidlinux.org/live/current/"

function MENUINTRO(){

zenity --question --window-icon=$HOME/Images/test.png --title "VOID-Iso2Usb" --width 350 --height 100 --text "Bonjour $USER !\n\nCet utilitaire va télécharger et installer Voidlinux\n\nATTENTION A CHOISIR LA BONNE PARTITION !!!!"
MENUCHOIX
}
function MENUCHOIX(){

# MENU DE SELECTION ENTRE MODE AUTOMATIQUE & MODE CUSTOM
choix=$(zenity --list --title "VOID-Iso2Usb" \
	   --text "Choix entre :\n\nAuto\t\tInstallation Facile de Void\n\nCustom\t\tChoix de la version a installer\n" \
	   --width 400 --height 300 \
	   --radiolist --column " " --column "Mode" \
	   TRUE AUTO \
	   FALSE CUSTOM	\
	   FALSE USB )
valret=$?
case $valret in
  0)
  if [ $choix = "AUTO" ];then
  MENUAUTO
  fi
  if [ $choix = "CUSTOM" ];then
  MENUCUSTOM
  fi
  if [ $choix = "USB" ];then
  USBSELECT
  fi
  ;;
  1)
  #REVENIR AU MENU PRINCIPAL
  MENUINTRO
  ;;
  255)
  #REVENIR AU MENU PRINCIPAL
esac

}
function MENUAUTO(){
INDEX
grep -E 'void-live-x86_x64|xfce.iso' index.html > $LIST
grep -v live-i686 $LIST > $LIST2
grep -v musl $LIST2 > $LIST
cut -c 10- $LIST > $LIST2
cut -d '"' -f 1 $LIST2 > $LIST
iso=$(cat $LIST)
USBSELECT
ISODL
DDISO
}
function MENUCUSTOM(){
INDEX
TRI
# RECUPERATION DU LISTING ISO VOIDLINUX TELECHARGEABLE
unset listiso
while read -r version
do
listiso+=("$version")
done < $LIST
iso=$(zenity --list \
			 --title "VOID-Iso2Usb" \
			 --text "Version de voidlinux disponible :\nVeuillez choisir la version appropriée" \
			 --width 500 --height 600 \
			 --column "OS" "${listiso[@]}" \
			 )


# TELECHARGEMENT DE L'ISO SELECTIONNE
#wget --progress=bar:force $ADDRESS$iso 2>&1 | zenity --progress --pulsate --title "VOID-Iso2Usb" --text "Téléchargement de l'iso $iso" --auto-close

USBSELECT
ISODL
DDISO
}
function TRI(){


grep -E 'void-' index.html > $LIST
#grep -E 'void-live-x86_64-|-xfce.iso' index.html > LIST

#grep -E '*.iso' index.html > LIST
cut -c 10- $LIST > $LIST2
cut -d '"' -f 1 $LIST2 > $LIST

}
function INDEX(){
# TELECHARGEMENT DE L'INDEX DES VERSIONS DE VOIDLINUX
wget -nv -q $ADDRESS

}
function USBSELECT(){
# RECUPERATION DES PARTITIONS
echo "USBSELECT"
lsblk -n -d -o "NAME","SIZE" > $LISTUSB
unset usblist
while read -r cle
do
usblist+=("$cle")
done < $LISTUSB
usb=$(zenity --list --title "VOID-Iso2Usb" --text "Périphérique disponible :" --width 400 --height 250 --column "NAME" "${usblist[@]}" )
echo $usb > $LISTUSB2 && cut -c-4 $LISTUSB2 > $LISTUSB
cat $LISTUSB
}
function ISODL(){
wget $ADDRESS$iso --progress=bar:force 2>&1 -q | zenity --progress --pulsate --title "VOID-Iso2Usb" --text "Téléchargement de l'iso\n $iso" --auto-close
}
function DDISO(){
# MONTAGE DE L'ISO SUR LA PARTITION SELECTIONNEE
echo "DDISO"
echo $XDG_DOWNLOAD_DIR/$iso
cat $LISTUSB
sudo -S dd bs=4M if=$XDG_DOWNLOAD_DIR/$iso of=/dev/$(cat $LISTUSB) status=progress 2>&1 | zenity --width 400 --height 100 --title "Installation Clé USB VoidLinux" --text "Création clé USB Void en cours\n" --auto-close --progress --pulsate
sudo sync | zenity --info --title "VOID-Iso2Usb" --width 500 --height 100 "Travail terminé" --text "Clé synchro - Go install !!!"
}

MENUINTRO

rm -f LIST*
rm -f index*
rm -f $XDG_DOWNLOAD_DIR/$iso