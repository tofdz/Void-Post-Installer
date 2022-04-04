#!/bin/bash
if [ -d /etc/X11/xorg.conf.d ];then
	echo -e "Dossier xorg.conf.d présent"
else
	sudo -S mkdir -R /etc/X11/xorg.conf.d/
	echo -e "Dossier crée"
fi
				
if [ -f /etc/X11/xorg.conf.d/00-Keyboard.conf ];then
	echo -e "Fichier 00-Keyboard.conf présent"
else
sudo -S	touch /etc/X11/xorg.conf.d/00-Keyboard.conf
	sudo -S	sh -c "echo 'Section "InputClass"' > /etc/X11/xorg.conf/00-Keyboard.conf"
    sudo -S	sh -c "echo '     Identifier "system-keyboard"' >> /etc/X11/xorg.conf/00-Keyboard.conf"
    sudo -S	sh -c "echo '     MatchisKeyboard "on"' >> /etc/X11/xorg.conf/00-Keyboard.conf"
	sudo -S	sh -c "echo '     Option "XkbLayout" "fr"' >> /etc/X11/xorg.conf/00-Keyboard.conf"
    sudo -S	sh -c "echo '     Option "XkbModel" "pc105"' >> /etc/X11/xorg.conf/00-Keyboard.conf"
	sudo -S	sh -c "echo 'EndSection' >> /etc/X11/xorg.conf/00-Keyboard.conf"
	sudo -S	echo 'Fichier créé'
fi
