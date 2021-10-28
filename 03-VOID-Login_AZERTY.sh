#!/bin/bash



if [ -d /etc/X11/xorg.conf.d ];then
	echo "Dossier xorg.conf.d présent"
else
	mkdir /etc/X11/xorg.conf.d/
	echo "Dossier crée"
fi
				
if [ -f /etc/X11/xorg.conf.d/00-Keyboard.conf ];then
	echo "Fichier 00-Keyboard.conf présent"
else
	echo 'Section "InputClass"' > /etc/X11/xorg.conf/00-Keyboard.conf
    echo '     Identifier "system-keyboard"' >> /etc/X11/xorg.conf/00-Keyboard.conf
    echo '     MatchisKeyboard "on"' >> /etc/X11/xorg.conf/00-Keyboard.conf
	echo '     Option "XkbLayout" "fr"' >> /etc/X11/xorg.conf/00-Keyboard.conf
    echo '     Option "XkbModel" "pc105"' >> /etc/X11/xorg.conf/00-Keyboard.conf
	echo 'EndSection' >> /etc/X11/xorg.conf/00-Keyboard.conf
	echo 'Fichier créé'
fi
				
echo "travail terminé"

#sudo rm /etc/X11/xorg.conf.d/00-Keyboard.conf
#sudo rmdir /etc/X11/xorg.conf.d/