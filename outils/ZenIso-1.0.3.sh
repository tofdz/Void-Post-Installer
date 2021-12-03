#!/bin/bash
# 	ZenIso
#	Montage d'iso facile sur voidlinux
#	Créé par DrNekosan 
#	le 02/12/21

#	Upgrade by Tofdz
#	le 02/12/21
#	v 1.0

WDIR=$(pwd)
source $HOME/.config/user-dirs.dirs
ISOTEMP=$(mktemp)

#MODE ADMIN
PASS=$(zenity --password)
echo $PASS|sudo -S clear


echo "#============#"
echo "#   ZenIso   #"
echo "#============#"
	
function MONTAGE(){

# MENU SELECTION FICHIER ISO

iso=$(zenity --file-selection --title "ZenIso" \
			--height 500 --width 400 \
			--text "Selectionnez votre ISO" \
	)


case $? in
	0)
	echo "==> Lancement Montage"
	;;
	1)
	exit
	;;
	255)
	exit
esac
compteur=$(echo $iso | grep -o / | wc -l)	
tempdir=$( echo $iso | cut -d "/" -f$compteur )

# VERIFICATION POINT DE MONTAGE
if [ ! -d $HOME/$tempdir ];then
	mkdir $HOME/$tempdir
	echo -e "==> Création $HOME/$tempdir"
fi

# AFFICHAGE VARIABLE POUR DEBUG
echo -e "==> Nom complet du chemin de l'iso:\n" $iso
echo -e "==> Nom du repertoire a creer sur $HOME :\n" $tempdir

# MONTAGE DE L'ISO
sudo mount $iso $HOME/$tempdir -o loop;zenity --info --title "ZenIso" --text "$iso\n\nmonté sur\n\n$HOME/$tempdir" --height 150 --width 450;
MAIN
}

function DEMONTAGE(){

# RECUPERE LA LISTE DES POINTS DE MONTAGE CREE PAR ZENISO
sudo mount -l | grep $HOME | cut -d " " -f3 > $ISOTEMP


echo "==> Lien démontable:"
cat $ISOTEMP

unset liste
while read -r point
do
liste+=(FALSE "$point")
done < $ISOTEMP

# MENU DE SELECTION DES POINTS DE MONTAGE A SUPPRIMER
demontage=$(zenity --list --checklist --separator=" " \
       --title="ZenIso" --text="Choix point de montage\nVous pouvez selectionner plusieurs points en meme temps." \
	   --height=300 --width=700 \
	   --column="SUPPR" --column="Point de montage :" "${liste[@]}" \
	   )

case $? in
   0)
   echo "==> Démontage en cours de $demontage"
   sudo umount $demontage
   echo "==> Suppression en cours de $demontage"
   sudo rmdir $demontage
   sudo rm $ISOTEMP
   MAIN
   ;;
   1)
   MAIN
   ;;
   255)
   exit
esac

}

function MAIN(){

menu=$(zenity --list --radiolist \
	   --title "ZenIso v0.1" --text "Montage ou démontage des fichiers .iso" \
	   --height 150 --width 250 \
	   --column " " --column "Choix" \
	   TRUE MONTAGE \
	   FALSE DEMONTAGE \
	   )
case $? in
	0)
	if [ $menu = "MONTAGE" ];then
	MONTAGE
	fi
	if [ $menu = "DEMONTAGE" ];then
	DEMONTAGE
	fi
	;;
	1)
	exit
	;;
	255)
	exit
esac
}

MAIN