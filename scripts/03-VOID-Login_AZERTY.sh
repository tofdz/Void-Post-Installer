#!/bin/bash
FILPATH="/etc/X11/xorg.conf.d/00-Keyboard.conf"
DIRPATH="/etc/X11/xorg.conf.d"
echo "03-VOID-Login_AZERTY ===>"
if [ -d $DIRPATH ];then
	echo "Dossier xorg.conf.d présent"
else
	mkdir $DIRPATH
	echo "Dossier crée"
fi
				
if [ -f $FILPATH ];then
	echo "Fichier 00-Keyboard.conf présent"
else
	echo 'Section "InputClass"' > $FILPATH
	echo '     Identifier "system-keyboard"' >> $FILPATH
    	echo '     MatchisKeyboard "on"' >> $FILPATH
	echo '     Option "XkbLayout" "fr"' >> $FILPATH
    	echo '     Option "XkbModel" "pc105"' >> $FILPATH
	echo 'EndSection' >> $FILPATH
	echo 'Fichier créé'
fi
