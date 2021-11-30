#!/bin/bash
# VOID-ManageUser.sh
# Gestionnaire d'utilisateurs
# Crée par Tofdz le 30/11/2021
# version 0.0.1
WDIR=$(pwd)
source $HOME/.config/user-dirs.dirs
# VARIABLES
LISTUSER=$(mktemp)
# unset tab2					# tab2		:	tableau de verification presence user apres suppression
unset tabuser					# tabuser	:	tableau listing des utilisateurs

#=======================

# MENU CREATION UTILISATEUR + FONCTIONS
function MENUCREATION(){

output=$(zenity --forms --title="Creation utilisateur" \
	   --width 400 --height 280 \
	   --text="Ajout nouvel utilisateur :" \
   	   --add-entry="Utilisateur (ex : voiduser)"\
   	   --add-entry="Nom de session affiché (ex : Void User)" \
   	   --add-password="Mot de passe" \
   	   --add-password="Confirmer Mot de passe" )
	   
IDUSER=$(echo "$output" | cut -d "|" -f1 )
UTILISATEUR=$(echo "$output" | cut -d "|" -f2 )
PASSWORD1=$(echo "$output" | cut -d "|" -f3 )
PASSWORD2=$(echo "$output" | cut -d "|" -f4 )
}
function VERIFICATION(){

if [ $PASSWORD1 != $PASSWORD2 ];then
# SI LE MOT DE PASSE EST DIFFERENT ON COLORE LA CASE PASSWORD2 EN ROUGE
zenity --error --title "VOID-ManageUser" --width 350 --height 100 --text "Mot de passe différent, veuillez retaper votre mot de passe!"
PASSWORD1=$(/dev/null)
PASSWORD2=$(/dev/null)
echo "1:" $PASSWORD1 "2:" $PASSWORD2 
MENUCREATION
else

echo "Utilisateur" $IDUSER  
echo "Nom de session" $UTILISATEUR
echo "Mot de passe" $PASSWORD1

#sudo useradd -m -s /bin/zsh -U -G wheel,floppy,audio,video,cdrom,optical,kvm,input,xbuilder -c "$IDUSER" $UTILISATEUR
#echo "$PASSWORD" | passwd "$IDUSER" --stdin
zenity --question --title "VOID-ManageUser" --width 350 --height 100 --text "Utilisateur $UTILISATEUR créé !\n Mot de passe : $PASSWORD\n\nBonne journée !"
fi
}

# MENU EFFACER UTILISATEUR + FONCTIONS
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
			 
# SUPPRIMER LE COMPTE
sudo userdel ${tab[$choix]}
if [ -d /home/${tab[$choix]} ];then
	sudo rm -rf /home/${tab[$choix]}
	sudo sync
fi

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
}
# MENU INTRO

function MENUINTRO(){
zenity --question --title "VOID-ManageUser" --width 350 --height 100 --text "Bonjour $USER !\n\nCet utilitaire permet l'administration\ndes comptes utilisateurs\nATTENTION MODIFICATION DEFINITIVE !!!!"
MENUCHOIX
}

# MENU DE SELECTION CREATION / EFFACER
function MENUCHOIX(){
choix=$(zenity --list --title "VOID-ManageUSer" \
	   --text "Choix entre :\n\nCREATION\t\tCreation Facile d'un utilisateur\n\nEFFACER\t\tSuppression d'un compte utilisateur \n\t\t\t\t(supprime aussi le /HOME/USER !!!!)\n" \
	   --width 400 --height 280 \
	   --radiolist --column " " --column "Mode" \
	   TRUE CREATION \
	   FALSE EFFACER )
valret=$?
case $valret in
  0)
  if [ $choix = "CREATION" ];then
  MENUCREATION
  VERIFICATION
  fi
  if [ $choix = "EFFACER" ];then
  MENUEFFACER
  fi
  ;;
  1)
  #REVENIR AU MENU PRINCIPAL
  MENUINTRO
  ;;
  255)
  #REVENIR AU MENU PRINCIPAL
  exit
esac
}

MENUINTRO
