#!/bin/bash
# VOID-ManageUser.sh
# Gestionnaire d'utilisateurs
# Crée par Tofdz le 30/11/2021
# version 0.0.1
echo "#===================#"
echo "#  VOID-ManageUser  #"
echo "#===================#"
# MODE ADMIN
# VARIABLES

PASS=$(zenity --password)				# MOT DE PASSE SESSION SUDO AU DEMARRAGE
WDIR=$(pwd)								# SOURCE REPERTOIRE DE TRAVAIL ACTUEL 
source $HOME/.config/user-dirs.dirs		# SOURCE LOCAL FILES
LISTUSER=$(mktemp)						# FICHIER TEMPORAIRE

unset choix								# Utilisateur à supprimer
unset tabuser							# tabuser	:	tableau listing des utilisateurs
unset UTILISATEUR						# Nom d'utilisateur (en minuscule uniqument)
unset SESSION							# Nom complet de session

function CREATEUSER(){
tab[0]=/Bureau
tab[1]=/Documents
tab[2]=/Images
tab[3]=/Modèles
tab[4]=/Musique
tab[5]=/Public
tab[6]=/Téléchargements
tab[7]=/Vidéos
i=0

echo "==> CREATEUSER"
sudo useradd -m -s /bin/zsh -G wheel,floppy,audio,video,cdrom,optical,kvm,input,xbuilder -c $SESSION $UTILISATEUR
echo "$UTILISATEUR:$PASSWORD1" | sudo chpasswd -e
while ((${#tab[*]}!=i)) ; do
	sudo mkdir /home/$UTILISATEUR${tab[$i]}
	echo -e "Création de /home/$UTILISATEUR${tab[$i]}"
	i=$((i+1))
done
MENUCHOIX
}					# CREATION NOUVEL UTILISATEUR + HOME/DIR
function DELETEUSER(){
echo "==> DELETEUSER"
echo "Utilisateur à supprimer : $choix"

sudo userdel $choix
if [ -d /home/$choix ];then
	sudo rm -rf /home/$choix
	sudo sync
fi
MENUCHOIX
}					# SUPPRIMER LE COMPTE & /HOME/USER

function WARNINGCREATION(){
echo "==> WARNINGCREATION"
echo "Utilisateur : $UTILISATEUR Nom Complet : $SESSION" 

zenity --question --title="Création utilisateur" \
	   --width 400 --height 100 \
	   --text="Attention !\nVous etes sur le point de créer l'utilisateur $UTILISATEUR ,\nAinsi que son home directory : /home/$UTILISATEUR\n\nVoulez vous continuer ?"
case $? in
		0)
		CREATEUSER
		;;
		1)
		MENUCREATION
		;;
		255)
		exit
esac
}
function WARNINGDELETE(){
echo "==> WARNINGDELETE"
zenity --question\
				 --title="Suppression utilisateur" \
	   			 --width 400 --height 280 \
				 --text "Vous allez procéder à la suppression définitive de(s) utilisateur(s)\n$choix\n\n \
				 ainsi que de toutes les données contenues dans \n\n \
				 														\
				 CETTE SUPPRESSION EST DEFINITIVE !\n \
				 Voulez vous continuer ?"

case $? in
		0)
		DELETEUSER
		;;
		1)
		MENUEFFACER
		;;
		255)
		exit
esac



}				# AVERTISSEMENT AVANT SUPPRESSION DEFINITIVE

function MENUCREATION(){
echo "==> MENUCREATION"

output=$(zenity --forms --separator="|" --title="Creation utilisateur" \
	   --width 400 --height 160 \
	   --text="Ajout nouvel utilisateur :" \
   	   --add-entry="Utilisateur (ex : voiduser)"\
   	   --add-entry="Nom de session affiché (ex : Void User)" \
	   --add-password="Mot de passe" \
	   --add-password="Confirmation Mot de passe" )
	   
UTILISATEUR=$(echo "$output" | cut -d "|" -f1 )
SESSION=$(echo "$output" | cut -d "|" -f2 )
PASSWORD1=$(echo "$output" | cut -d "|" -f3 )
PASSWORD2=$(echo "$output" | cut -d "|" -f4 )
echo "==> Utilisateur $UTILISATEUR Nom Complet : $SESSION"

case $? in
  0)
  if [ $PASSWORD1 != $PASSWORD2 ];then
  zenity --warning --text="Mot de passe différents, veuillez entrer les memes mots de passe"
  echo "=> PASSWORD1 $PASSWORD1"
  echo "=> PASSWORD2 $PASSWORD2"
  echo "==> ANNULATION CREATION DU COMPTE $SESSION"
  MENUCREATION
  else
  echo "=> PASSWORD1 $PASSWORD1"
  echo "=> PASSWORD2 $PASSWORD2"
  echo "==> MENUCREATION -->WARNING CREATION"
  WARNINGCREATION
  fi
  ;;
  1)
  #REVENIR AU MENU PRINCIPAL
  MENUCHOIX
  ;;
  255)
  #REVENIR AU MENU PRINCIPAL
  exit
esac
}				# MENU CREATION UTILISATEUR + FONCTIONS
function MENUEFFACER(){
echo "==> MENUEFFACER"
unset tabuser

# LISTER LES UTILISATEURS
cat /etc/passwd | awk -F: '{print $ 1}' > $LISTUSER
while read -r tablist 
do
tabuser+=("$tablist")
done < $LISTUSER
echo "==> MENU EFFACER"
echo "Liste des Utilisateurs :"
echo "===="
cat $LISTUSER
echo "===="

# MENU LISTE UTILISATEURS
choix=$(zenity --list\
			 --title "VOID-ManageUser" \
			 --text "Choisissez l'utilisateur à supprimer :" \
			 --width 500 --height 300 \
			 --column "Utilisateur :" "${tabuser[@]}" )
case $? in
   0)
   WARNINGDELETE
   ;;
   1)
   # MENU PRINCIPAL
   MENUCHOIX
   ;;
   255)
   # QUITTER
   exit
esac
	# OUVRIR UN MENU POUR VALIDER LE CHOIX "VOULEZ VOUS VRAIMENT DETRUIRE USER ET /home/USER ?"
}				# MENU EFFACER UTILISATEUR + FONCTIONS	
function MENUCHOIX(){

echo "==> MENU CHOIX"
choix=$(zenity --list --title "VOID-ManageUSer" \
	   --text "Choix entre :\n\nCREATION\t\tCreation Facile d'un utilisateur\n\nEFFACER\t\tSuppression d'un compte utilisateur \n\t\t\t\t(supprime aussi le /HOME/USER !!!!)\n" \
	   --width 400 --height 300 \
	   --column "Mode" --column "Description" \
	   CREATION "Création compte utilisateur" \
	   EFFACER "Suppression compte utilisateur" )

case $? in
  0)
  if [ $choix = "CREATION" ];then
  MENUCREATION
  #VERIFICATION
  fi
  if [ $choix = "EFFACER" ];then
  MENUEFFACER
  fi
  ;;
  1)
  # QUITTER
  exit
  ;;
  255)
  # QUITTER
  exit
esac
}					# MENU DE SELECTION CREATION / EFFACER

echo $PASS|sudo -S echo "==> Start"
zenity --info --title "VOID-ManageUser" --width 350 --height 100 \
		--text "Bonjour $USER !\n\nCet utilitaire permet l'administration\ndes comptes utilisateurs\nATTENTION MODIFICATION DEFINITIVE !!!!"
MENUCHOIX