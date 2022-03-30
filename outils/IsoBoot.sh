#!/bin/bash
# VOID-Iso2UsbBootCreator by TofF
# Date : 29/11/2021
WDIR=$(pwd)
source $HOME/.config/user-dirs.dirs
TITLE="IsoBoot"
version="0.9.0"

PASS=$(yad --entry --hide-text --title="$TITLE $version" --text="Entrez le mot de passe")
echo $PASS|sudo -S echo -e "==START=="
# FICHIERS TEMPORAIRE
cd $XDG_DOWNLOAD_DIR
touch LIST
touch LIST2
ADDRESS="https://alpha.de.repo.voidlinux.org/live/current/"

function MENU(){
unset iso
# MENU DE SELECTION ENTRE MODE AUTOMATIQUE & MODE CUSTOM
choix=$(yad --list --title="$TITLE $version" \
	   --text="Texte simple" \
	   --separator="" \
	   --width=320 --height=600 \
	   --column=" :IMG" --column="Mode" \
	   $HOME/Images/LOGOS/void.png "AUTO" \
	   $HOME/Images/LOGOS/FSVOID.png "SELECTVOID" \
	   $HOME/Images/LOGOS/HDD.png "CUSTOM" \
	   )
valret=$?
echo -e "valeur menu : $?"
echo -e "valeur choix : $choix"
case $valret in
  0)
  if [ $choix = "AUTO" ];then
  echo -e "MENU==>MENUAUTO"
  MENUAUTO
  CLEAN
  fi
  if [ $choix = "SELECTVOID" ];then
  echo -e "MENU==>MENUSELECTVOID"
  MENUSELECTVOID
  CLEAN
  fi
  if [ $choix = "CUSTOM" ];then
  echo -e "MENU==>MENUCUSTOM"
  USBSELECT
  CLEAN
  fi
  ;;
  1)
  #REVENIR AU MENU PRINCIPAL
  MENUINTRO
  CLEAN
  ;;
  255)
  CLEAN
  #REVENIR AU MENU PRINCIPAL
esac
CLEAN
}
function MENUAUTOVOID(){
wget -nv -q $ADDRESS
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
function MENUSELECTVOID(){
echo -e "==> MENUCUSTOM"
INDEX

# RECUPERATION DU LISTING ISO VOIDLINUX TELECHARGEABLE
unset listiso
while read -r version
do
listiso+=("$version")
done < LIST

iso=$(yad --list --title="$TITLE $version" \
			 --separator="" \
			 --text="Version de voidlinux disponible :\nVeuillez choisir la version appropriée" \
			 --width 500 --height 600 \
			 --column "OS" "${listiso[@]}" \
			 )
case $? in
	0)
	USBSELECT
	ISODL
	DDISO
	;;
	255)
	CLEAN
	exit
	;;
esac
CLEAN
}
function MENUSELECTISO(){
# RECUPERATION DES PARTITIONS
VOIDLIST
USBSELECT
isoselect=$(yad --file)
DDISO
}
function INDEX(){
# TELECHARGEMENT DE L'INDEX DES VERSIONS DE VOIDLINUX
wget -nv -q $ADDRESS
grep -E 'void-' index.html > LIST
#grep -E 'void-live-x86_64-|-xfce.iso' index.html > LIST
#grep -E '*.iso' index.html > LIST
cut -c 10- LIST > LIST2
cut -d '"' -f 1 LIST2 > LIST
rm index.html
}
function USBSELECT(){

# RECUPERATION DE LA LISTE DES PERIPHERIQUES USB & HDD
unset usblist
echo "USBSELECT"
lsblk -n -d -o "SIZE" > TMP1
lsblk -n -d -o "PATH" > TMP2
lsblk -n -d -o "NAME" > TMP3
lsblk -n -d -o "VENDOR" > TMP4
lsblk -n -d -o "MODEL" > TMP5
# TMP1
while read -r data1
do
usblist1+=("$data1")
done < TMP1
# TMP2
while read -r data2
do
usblist2+=("$data2")
done < TMP2
# TMP3
while read -r data3
do
usblist3+=("$data3")
done < TMP3
while read -r data4
do
usblist4+=("$data4")
done < TMP4
while read -r data5
do
usblist5+=("$data5")
done < TMP5


usb=$(yad --list --title "VOID-Iso2Usb" --text "Périphérique disponible :" --width 400 --height 250 --column="SIZE" --column="PATH" --column="NAME" --column="VENDOR" --column="MODEL" "$(cat TMP1)" "$(cat TMP2)" "$(cat TMP3)" "$(cat TMP4)" "$(cat TMP4)")
case $? in
255)
CLEAN
exit
;;
esac
}
function ISODL(){
wget $ADDRESS$iso --progress=bar:force 
}
function DDISO(){
# MONTAGE DE L'ISO SUR LA PARTITION SELECTIONNEE
echo "DDISO"

if [ $iso != " " ]; then
cat LISTUSB
sudo -S dd bs=4M if=$XDG_DOWNLOAD_DIR/$iso of=/dev/$(cat LISTUSB) status=progress
sudo sync
rm $XDG_DOWNLOAD_DIR/$iso
else
sudo -S dd bs=4M if=$isoselect of=/dev/$(cat LISTUSB) status=progress
yad --info --title="$TITLE" --width 500 --height 100 --text "Clé synchro - Go install !!!"
fi

}
function CLEAN(){ 
echo -e "===> CLEAN "
#rm LIST* 
#rm TMP1
rm index.html

}
function VOIDLIST(){
INDEX
unset listiso
while read -r version
do
listiso+=("$version")
done < LIST

}

MENU