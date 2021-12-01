#!/bin/bash
# VOID-ManageUser.sh
# Gestionnaire d'utilisateurs
# Crée par Tofdz le 30/11/2021
# version 0.0.1
WDIR=$(pwd)								# SOURCE REPERTOIRE DE TRAVAIL ACTUEL 
source $HOME/.config/user-dirs.dirs		# SOURCE LOCAL FILES
										# VARIABLES
LISTUSER=$(mktemp)						# FICHIER TEMPORAIRE

#unset tab2								# tab2		:	tableau de verification presence user apres suppression
unset choix								# Utilisateur à supprimer
unset tabuser							# tabuser	:	tableau listing des utilisateurs
unset UTILISATEUR						# Nom d'utilisateur (en minuscule uniqument)
unset SESSION							# Nom complet de session

function CREATEUSER(){
echo "CREATEUSER"
echo "Utilisateur:Nom Complet $UTILISATEUR:$SESSION" 
sudo useradd -m -s /bin/zsh -G wheel,floppy,audio,video,cdrom,optical,kvm,input,xbuilder -c $SESSION $UTILISATEUR  
sudo passwd $UTILISATEUR

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

}					# CREATION NOUVEL UTILISATEUR + HOME/DIR
function DELETEUSER(){
echo "DELETEUSER"
echo "$choix"

sudo userdel $choix
if [ -d /home/$choix ];then
	sudo rm -rf /home/$choix
	sudo sync
fi
}					# SUPPRIMER LE COMPTE & /HOME/USER
function VERIFICATION(){

#sudo useradd -m -s /bin/zsh -U -G wheel,floppy,audio,video,cdrom,optical,kvm,input,xbuilder -c "$SESSION" $UTILISATEUR
#echo "$PASSWORD" | passwd "$SESSION" --stdin
zenity --question --title "VOID-ManageUser" --width 350 --height 100 --text "Utilisateur $UTILISATEUR créé !\n Mot de passe : $PASSWORD\n\nBonne journée !"

}				# VERIFIER LA SUPPRESSION DE L'UTILISATEUR

function WARNINGCREATION(){
echo "WARNINGCREATION"
echo "Utilisateur : $UTILISATEUR Nom Complet : $SESSION" 

zenity --warning --title="Creation utilisateur" \
	   --width 400 --height 280 \
	   --text="Attention, Vous etes sur le point de créer l'utilisateur $UTILISATEUR ,\n \
	   Ainsi que son home directory : /home/$UTILISATEUR\n \
	   Voulez vous continuez ?" \ 
case $? in
		0)
		CREATEUSER
		;;
		1)
		exit
		;;
		255)
		exit
esac
}
function WARNINGDELETE(){
zenity --question\
				 --title="Suppression utilisateur" \
	   			 --width 400 --height 280 \
				 --text "Vous allez procéder à la suppression définitive de l'utilisateur $choix\n\n \
				 ainsi que de toutes les données contenues dans /home/$choix\n\n \
				 CETTE SUPPRESSION EST DEFINITIVE !\n \
				 Voulez vous continuer ?"

case $? in
		0)
		DELETEUSER
		;;
		1)
		exit
		;;
		255)
		exit
esac



}				# AVERTISSEMENT AVANT SUPPRESSION DEFINITIVE

function MENUCREATION(){

output=$(zenity --forms --title="Creation utilisateur" \
	   --width 400 --height 280 \
	   --text="Ajout nouvel utilisateur :" \
   	   --add-entry="Utilisateur (ex : voiduser)"\
   	   --add-entry="Nom de session affiché (ex : Void User)" \
   	   )
	   
UTILISATEUR=$(echo "$output" | cut -d "|" -f1 )
SESSION=$(echo "$output" | cut -d "|" -f2 )

case $? in
  0)
  WARNINGCREATION
  ;;
  1)
  #REVENIR AU MENU PRINCIPAL
  exit
  ;;
  255)
  #REVENIR AU MENU PRINCIPAL
  exit
esac
}				# MENU CREATION UTILISATEUR + FONCTIONS
function MENUEFFACER(){

# LISTER LES UTILISATEURS
cat /etc/passwd | awk -F: '{print $ 1}' > $LISTUSER
while read -r tablist 
do
tabuser+=("$tablist")
done < $LISTUSER

# MENU LISTE UTILISATEURS
choix=$(zenity --list \
			 --title "VOID-ManageUser" \
			 --text "Choisissez l'utilisateur à supprimer :" \
			 --width 500 --height 600 \
			 --column "Utilisateur :" "${tabuser[@]}" \
			 )
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
choix=$(zenity --list --title "VOID-ManageUSer" \
	   --text "Choix entre :\n\nCREATION\t\tCreation Facile d'un utilisateur\n\nEFFACER\t\tSuppression d'un compte utilisateur \n\t\t\t\t(supprime aussi le /HOME/USER !!!!)\n" \
	   --width 400 --height 280 \
	   --radiolist --column " " --column "Mode" \
	   TRUE CREATION \
	   FALSE EFFACER )

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
function MENUINTRO(){
zenity --question --title "VOID-ManageUser" --width 350 --height 100 --text "Bonjour $USER !\n\nCet utilitaire permet l'administration\ndes comptes utilisateurs\nATTENTION MODIFICATION DEFINITIVE !!!!"
MENUCHOIX
}					# MENU INTRO

MENUINTRO

#function VERIFDELETEUSER(){
# VERIFIER QU'IL N'EST PLUS LA 
#tab2=$(cat /etc/passwd | grep $choix )
#if [ $tab2 != $(/dev/null) ];then
#	zenity --error --title "VOID-ManageUser" \
#			 	   --text "ERREUR SUPPRESSION - COMPTE $choix\nVeuillez contacter votre administrateur" \
#			 	   --width 500 --height 600 \
#else
#	zenity --info --title "VOID-ManageUser" \
#			 	  --text "Suppression du compte effectuée !\n\n Success !" \
#			 	  --width 500 --height 600 \
#fi
#}	# VERIF SUPPRIMER LE COMPTE & /HOME/USER
