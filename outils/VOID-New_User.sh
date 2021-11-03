#!/bin/bash

#=========================
#=========================
function CREAUSER(){
echo "===================================="
echo "# Création d'un nouvel utilisateur #"
echo "#                                  #"
echo "#       ENTREZ UN NOM              #"
echo "# (minuscules uniquement !!!)      #"
echo "# AUCUN ESPACE NI CARAC SPECIAL    #"
echo "===================================="

echo "Entrez le nom de session"
# Lire le nom
read UTILISATEUR
echo "Entrez le ID user"
# Lire
read IDUSER
echo "$"
sudo useradd -m -s /bin/zsh -U -G wheel,floppy,audio,video,cdrom,optical,kvm,input,xbuilder -c "$IDUSER" $UTILISATEUR
echo "$UTISATEUR - Création MOT DE PASSE"
sudo passwd $UTILISATEUR
}

#=========================
#=========================
function CREAHOMEDIR(){
echo "Entrez le mot de passe utilisateur"

tab[0]=/Bureau
tab[1]=/Documents
tab[2]=/Images
tab[3]=/Modèles
tab[4]=/Musique
tab[5]=/Public
tab[6]=/Téléchargements
tab[7]=/Vidéos

i=0

while ((${#tab[*]}!=i)) ; do
	sudo mkdir /home/$UTILISATEUR${tab[$i]}
	echo -e "Création de /home/$UTILISATEUR${tab[$i]}"
	i=$((i+1))
done
}

#=========================
#=========================
function CONFIGDIR(){
if [ -d $HOME/.config ];then
	if [ ! -d /home/$UTILISATEUR/.config ];then
	echo "Création /home/$UTILISATEUR/.config"
	sudo mkdir /home/$UTILISATEUR/.config
	fi
	#sudo pycp $HOME/.config/* /home/$UTILISATEUR/.config/
	sudo pycp $HOME/.config/i3 $HOME/.config/gtk-3.0 $HOME/.config/qt5ct /home/$UTILISATEUR/.config/
fi
}

#=========================
#=========================
function CHMOD(){
sudo chown -R $UTILISATEUR:$UTILISATEUR /home/$UTILISATEUR
}


function MAIN(){
CREAUSER
CREAHOMEDIR
CONFIGDIR
CHMOD
}

MAIN
