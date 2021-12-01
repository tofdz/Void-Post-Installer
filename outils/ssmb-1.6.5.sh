#!/bin/bash
# 'ssmbGUI-1.6.sh'VERSION CLEAN
# "versio 0.1.6.6"VERSION FULL DEBUG DES VARIABLES
# "Gestion SMB & Backup"
# By TofF : le 13/11/2020
# Maj : le 16/03/2021
#==============================================
#==============================================


main(){
if [ ! -e ssmbvars.conf ];then
	startvars

	else

		source ssmbvars.conf
		back[0]="$LINK_DESKTOP"
		back[1]="$LINK_DOCUMENTS"
		back[2]="$LINK_PICTURES"
		back[3]="$LINK_DOWNLOAD"
		back[4]="$LINK_MUSIC"
		back[5]="$LINK_VIDEOS"

		if [ ! -e $CRED ];then
			osinstall
		else
			echo " SOFT OK"
			sleep 2
		fi

		if [ ! -e ssmblist.conf ];then
		echo -e " On crÃ©e les fichiers utilisateurs"
		cred
		smblist
		else
		echo -e "environnement crÃ©e"
		fi

	affichage1
	read -p "Appuyez sur entrÃ©e pour continuer :"

fi
}
startvars(){
	#DECLARATION DES VARIABLES DANS UN TABLEAU POUR GENERER
	#LE FICHIER DE CONFIGURATION
	source $HOME/.config/user-dirs.dirs
		
	tab[1]=$XDG_DESKTOP_DIR
	tab[2]=$XDG_DOCUMENTS_DIR
	tab[3]=$XDG_PICTURES_DIR
	tab[4]=$XDG_DOWNLOAD_DIR
	tab[5]=$XDG_MUSIC_DIR
	tab[6]=$XDG_VIDEOS_DIR
	tab[7]=$HOME/Gaming
	echo "CrÃ©ation ssmbvars.conf"
	echo LINK_HOME="$HOME" >  $XDG_DOCUMENTS_DIR/ssmbvars.conf

	# #MOULINETTE POUR GENERER LES RACCOURCIS	/Bureau /Documents etc
	while ((${#tab[*]}!=i)) ; do
	touch TEMPHOM
	touch TEMPDIR
	echo $HOME > TEMPHOM
	echo ${tab[$i]} > TEMPDIR
	compteur=$(cat TEMPHOM | wc --chars)
	LINK=$(cut -c $compteur- TEMPDIR)
	tabE[$i]=$(echo $LINK)
	i=$((i+1))
	done
	echo LINK_DESKTOP="${tabE[0]}" >>  $XDG_DOCUMENTS_DIR/ssmbvars.conf
	echo LINK_DOCUMENTS="${tabE[1]}" >>  $XDG_DOCUMENTS_DIR/ssmbvars.conf
	echo LINK_PICTURES="${tabE[2]}" >>  $XDG_DOCUMENTS_DIR/ssmbvars.conf
	echo LINK_DOWNLOAD="${tabE[3]}" >>  $XDG_DOCUMENTS_DIR/ssmbvars.conf
	echo LINK_MUSIC="${tabE[4]}" >>  $XDG_DOCUMENTS_DIR/ssmbvars.conf
	echo LINK_VIDEOS="${tabE[5]}" >>  $XDG_DOCUMENTS_DIR/ssmbvars.conf
	#echo LINK_HOST="$HOST/$USER" >> $XDG_DOCUMENTS_DIR/ssmbvars.conf
	echo VARS="$XDG_DOCUMENTS_DIR/ssmbvars.conf" >>  $XDG_DOCUMENTS_DIR/ssmbvars.conf
	echo LIST="$XDG_DOCUMENTS_DIR/ssmblist.conf" >>  $XDG_DOCUMENTS_DIR/ssmbvars.conf
	echo CRED="$XDG_DOCUMENTS_DIR/ssmbcred" >>  $XDG_DOCUMENTS_DIR/ssmbvars.conf
	echo ADDRESS="//192.168.20.2" >>  $XDG_DOCUMENTS_DIR/ssmbvars.conf
	echo MP="/mnt/SMB" >>  $XDG_DOCUMENTS_DIR/ssmbvars.conf
	echo BACKUP="/voidshare" >>  $XDG_DOCUMENTS_DIR/ssmbvars.conf
	echo MAGICLINK="$XDG_DESKTOP_DIR" >>  $XDG_DOCUMENTS_DIR/ssmbvars.conf
	echo OWNER=$USER >> $XDG_DOCUMENTS_DIR/ssmbvars.conf
	chmod 600 $XDG_DOCUMENTS_DIR/ssmbvars.conf
	chown $USER:$USER  $XDG_DOCUMENTS_DIR/ssmbvars.conf
	echo -e "ssmbvars.conf crÃ©Ã©"
	echo "Let's Go configurer ssmbvars.conf dans /Documents !!!!"
	echo "Sinon Ã§a ne fonctionnera pas car il n'a pas les infos"
	echo "et oui il faut bosser de temps en temps :P"
	echo "Bisous ! TofF"
	rm TEMPDIR
	rm TEMPHOM
	exit
}
osinstall(){
clear
echo -e "Detection de l'os"
sudo xbps-install -Syu ; sudo xbps-install -Syu dialog cifs-utils smbclient pycp
}
affichage1(){

#==============================================
#		"MENU PRINCIPAL"
#==============================================

	clear
	DIALOG=${DIALOG=dialog}
	fichtemp=`tempfile 2>/dev/null` || fichtemp=/tmp/test$$
	trap "rm -f $fichtemp" 0 1 2 5 15
	$DIALOG --backtitle " SMB-Backup by TofF " \
        	--title "Menu" --clear \
        	--radiolist "Le super Menu de la mort\n
			Bienvenue  !!!	" 20 61 5 \
       "RESET" "Reset du bordel" off\
	"MAGIC" "Montage MagicLink by TofF" off\
         "CONNEXION" "Montage de la connexion" off\
          "BACKUP" "Sauvegarde de votre poste" off\
	   "RESTORE" "Restauration de votre sauvegarde" off\
            "DECONNEXION" "DÃ©montage partage SMB" off\
	     "EXIT" "Au revoir !" ON 2> $fichtemp
valret=$?
choix1=`cat $fichtemp`
case $valret in
  0)

  if [ $choix1 = "MAGIC" ];then
  down
  cred
  smblist
  mp
  magic
  fi

  if [ $choix1 = "CONNEXION" ];then
  net
  down
  cred
  smblist
  mp
  up
  fi

  if [ $choix1 = "BACKUP" ];then
  net
  down
  cred
  mp
  upBACKUP
  copy
  downBACKUP
  fi

  if [ $choix1 = "RESTORE" ];then
  net
  down
  cred
  mp
  upBACKUP
  restore
  downBACKUP
  fi

  if [ $choix1 = "DECONNEXION" ];then
  down
  fi

  if [ $choix1 = "RESET" ];then
  reset
  fi

  if [ $choix1 = "EXIT" ];then
  exit
  clear
  fi
;;
  1)
        #REVENIR AU MENU PRINCIPAL
  echo "Annulation"
;;
  255)
        #REVENIR AU MENU PRINCIPAL
esac
}
net(){

#==============================================
#"CONTROLE SI LE RESEAU EST ACTIF SINON QUITTE"
#))))))))))))))))))))))))))))))))))))))))))))))

tab[0]=google.fr
tab[1]=127.0.0.1
tab[2]=192.168.1.1
tab[3]=192.168.20.1
tab[4]=192.168.20.2
i=0


while ((${#tab[*]}!=$i)) ; do
        ping -c1 -q ${tab[$i]};tabR[$i]=${?};
        i=$((i+1));
done

i=0
while ((${#tab[*]}!=$i)) ; do
        if [ ${tabR[$i]} -eq 0 ];then
                #echo -e " ${tab[$i]} est on"
                tabE[$i]=1
        else
                #echo -e " ${tab[$i]} est off"
                tabE[$i]=0
        fi
        i=$((i+1));
        c=$((c+1));
done
clear

i=0
while ((${#tab[*]}!=$i)) ; do
        if [ ${tabE[$i]} = 1 ];then
                echo -e "${tab[$i]} est ONLINE"
        else
                echo -e "${tab[$i]} est OFFLINE"
        exit
	fi
        i=$((i+1));
done

}
cred(){

#==============================================
#"		GESTION DES CREDENTIALS	"
#==============================================

echo -e "**\e[1;93mVERIFICATION CREDENTIALS\e[0m**";
if [ ! -e $CRED ];then
	source ssmbvars.conf
	echo -e "[ \e[1;35mGO\e[0m ] CREATION FICHIER CREDENTIAL"
	echo -e "\e[1;32mEntrez le nom d'utilisateur\e[0m"
       	read user
	echo -e "\e[1;31mEntrez le mot de passe\e[0m (invisible)"
       	read -s pass
        echo user=$user > $CRED ; echo username=$user > $CRED ; echo password=$pass >> $CRED
	echo -e "[ \e[1;32mOK\e[0m ] FICHIER \e[1;32mcredentials\e[0m CREE ";
       	chmod 600 $CRED ; echo -e "[ \e[1;32mOK\e[0m ] CHMOD 600 FICHIER \e[1;32mcredentials\e[0m"
	chown $OWNER:$OWNER $CRED $LIST
	else
       	echo -e "[ \e[1;32mOK\e[0m ] FICHIER PRESENT"
	fi
}
smblist(){

#==============================================
#"		 VERIFIE ssmblist.conf"
#==============================================
source ssmbvars.conf
echo -e "**\e[1;93m SSMBLIST.CONF CHECK\e[0m**"
#SI LE FICHIER ssmblist.conf est absent alors processus de creation de fichier :
SMB=/
if [ ! -e $LIST ];then
	echo -e "Connection Ã  \e[1;32m$address\e[0m en cours ..."
	smbclient -A $CRED -L $ADDRESS > temp;
	sed -r "s/\t//ig" temp > temp2
	sed '1,3 d' temp2 > temp
	sed '20,30 d' temp > temp2
	cut -c -16 temp2 > temp	#$LIST
	sed 's#^#'$SMB'#' temp > $LIST
	chown $OWNER:$OWNER $LIST;
	rm temp temp2
	echo -e "[ OK ] Fichier ssmblist.conf crÃ©Ã© et temp nettoyÃ©"
else
	echo "Fichier ssmblist deja prÃ©sent"
fi

}
reset(){

#==============================================
#"		 	RESET		"
#==============================================

clear
if [ -e $VARS ];then
rm -f $VARS;echo -e "Fichier ssmbvars effacÃ©"
else
echo -e "ssmbcred absent"
fi
if [ -e $CRED ];then
rm -f $CRED;echo -e "Fichier ssmbcred effacÃ©"
else
echo -e "ssmbcred absent"
fi
if [ -e $LIST ];then
rm -f $LIST;echo -e "Fichier ssmblist.conf effacÃ©"
else
echo -e "ssmblist.conf absent"
fi
echo -e "Relancez le programme SVP"
exit
}
mp(){

#==============================================
#"		 VERIFIE LE $MP"
#==============================================

echo -e "**\e[1;93mVERIFICATION ET MONTAGE SMB\e[0m**"
if [ ! -d $MP ];then
	echo -e "[  \e[1;93mGO\e[0m ] Creation de $MP "
	sudo mkdir $MP
else
	echo -e "$MP DEJA PRESENT "
fi
}
up(){

#======================================================
#"	ACTIVE DESACTIVE LES SHARES SMB sans MAGICLINK"
#======================================================

clear
source $CRED
cat $LIST | while read share ; do
	if [ ! -d $MP$share ] ; then
		echo -e "[ \e[1;35mGO\e[0m ] CREATION REPERTOIRES SMB $share";
		sudo mkdir $MP$share; echo -e "[ \e[1;32mOK\e[0m ] CREATION REPERTOIRES SMB $share";
		echo -e "[ \e[1;35mGO\e[0m ] MONTAGE SHARES RESEAU $share";
		sudo mount -t cifs $ADDRESS$share $MP$share -o credentials=$CRED;
		echo -e "[ \e[1;32mOK\e[0m ] MONTAGE SHARES RESEAU $share";
	else
		echo -e "DEJA MONTE - TERMINE"
	fi
done
}
down(){
clear
cat $LIST | while read share ; do
	if [ -d $MP$share ];then
		echo -e "**\e[1;93mDEMONTAGE MAGICLINK\033[0m**"
		sudo unlink  $MAGICLINK$share
		echo -e "**\e[1;93mDEMONTAGE SHARE SMB\033[0m**"
		sudo umount -f $MP$share&&echo -e "[ OK ] $share dÃ©montÃ©"
		sudo rmdir $MP$share&&echo -e "[ OK ] repertoire $share sur $MP supprimÃ©"
	else
	       	echo "SHARE $share ABSENT"
	fi
done

if [ ! -d $MP ];then
	echo -e "pas de MP"
else
	sudo rmdir  $MP
	echo -e "$MP supprimÃ©"
fi
}
upBACKUP(){

#==============================================
#"	ACTIVE / DESACTIVE LE SHARE BACKUP"
#))))))))))))))))))))))))))))))))))))))))))))))

clear
if [ ! -d $MP$BACKUP ] ; then
	echo -e "[ \e[1;35mGO\e[0m ] CREATION REPERTOIRES SMB $share";
	sudo mkdir $MP$BACKUP; echo -e "[ \e[1;32mOK\e[0m ] CREATION REPERTOIRES SMB $share";
	echo -e "[ \e[1;35mGO\e[0m ] MONTAGE SHARES RESEAU $share";
	sudo mount -t cifs $ADDRESS$BACKUP $MP$BACKUP -o credentials=$CRED;
	echo -e "[ \e[1;32mOK\e[0m ] MONTAGE SHARES RESEAU $share";
	else
	echo -e "DEJA MONTE - TERMINE"
	fi
}
downBACKUP(){
clear
	if [ -d $MP$BACKUP ] ; then
		echo -e "**\e[1;93mDEMONTAGE SHARE BACKUP $BACKUP\033[0m**"
		sudo umount -f $MP$BACKUP
		echo -e "[ OK ] $BACKUP dÃ©montÃ©"
		sudo rmdir $MP$BACKUP
		echo -e "[ OK ] repertoire $BACKUP sur $MP supprimÃ©"
	else
        	echo "SHARE $BACKUP ABSENT"
	fi


	if [ ! -d $MP ] ; then
		echo -e "pas de MP"

	else
		sudo rmdir $MP
		echo -e "$MP supprimÃ©"
	fi
}
magic(){

#==============================================
#"	ACTIVE LES SHARES SMB + MAGICLINK"
#)))))))))))))))))))))))=======================

clear
if [ ! -d $MAGICLINK ];then
	sudo mkdir $MAGICLINK
	echo "CrÃ©ation du Repertoire qui acceuillera les raccourcis"
fi

cat $LIST | while read share ; do
	if [ ! -d $MAGICLINK$share ] ; then
		echo -e "[ \e[1;35mGO\e[0m ] CREATION REPERTOIRES SMB $share";
		sudo mkdir $MP$share; echo -e "[ \e[1;32mOK\e[0m ] CREATION REPERTOIRES SMB $share";
		echo -e "[ \e[1;35mGO\e[0m ] MONTAGE SHARES RESEAU $share";
		sudo mount -t cifs $ADDRESS$share $MP$share -o credentials=$CRED;
		echo -e "[ \e[1;32mOK\e[0m ] MONTAGE SHARES RESEAU $share";
		echo -e "[ \e[1;35mGO\e[0m ] MONTAGE MAGICLINK $share";
		sudo ln -s $MP$share $MAGICLINK$share
		echo -e "[ \e[1;35mGO\e[0m ] MONTAGE MAGICLINK $share";
	else
		echo -e "DEJA MONTE - TERMINE"
	fi

done

}
copy(){

LINK_HOST="$(cat /etc/hostname)/$USER/"
source $CRED
i=1
clear
echo "LANCEMENT DE LA COPIE"

while ((${#back[*]}!=$i)); do
	echo -e "$LINK_HOME${back[$i]} ==>  $MP$BACKUP/$LINK_HOST"
	sudo pycp $LINK_HOME${back[$i]} $MP$BACKUP/$LINK_HOST
	i=$((i+1));
done
echo "BACKUP TerminÃ© !!!"
read -p "Appuyez sur entrÃ©e pour continuer :"

}
restore(){

#==============================================
#	"RESTAURATION DE LA SAUVEGARDE"
#)))))))))))))))))))))))))))))))))))))))))))))))
LINK_HOST="$(cat /etc/hostname)/$USER"
source $CRED
i=1
clear
echo "LANCEMENT DE LA COPIE"
while ((${#back[*]}!=$i)); do

	echo -e "$MP$BACKUP/$LINK_HOST${back[$i]} ===> $LINK_HOME${back[$i]}"
	#cp -r -v $MP$BACKUP${back[$i]} $LINK_HOME
	sudo pycp -g $MP$BACKUP/$LINK_HOST${back[$i]} $LINK_HOME
	i=$((i+1));
done
#	echo -e "$MP$BACKUP$LINK_HOST ===> $LINK_HOME"

#cp -r -v $MP$BACKUP$LINK_HOST $LINK_HOME
#pycp $MP$BACKUP$LINK_HOST $LINK_HOME
read -p "Appuyez sur entrÃ©e pour continuer :"



echo "RESTAURATION TerminÃ©e !"
}

#=======================================================#
# AU DEMARRAGE LA PREMIERE FOIS POUR CREER LES FICHIERS #
# 		NECESSAIRE A LA CONNEXION AU SERVEUR			#
#=======================================================#

main
