#!/bin/bash
sudo -S echo "===> ELOGIND AZERTY"
if [ -d /etc/X11/xorg.conf.d ]; then
	sudo -S echo -e "Dossier xorg.conf.d présent"
else
	sudo -S mkdir -p /etc/X11/xorg.conf.d/
	sudo -S echo -e "Dossier crée"
fi
				
if [ -f /etc/X11/xorg.conf.d/00-Keyboard.conf ]; then
	sudo -S echo -e "Fichier 00-Keyboard.conf présent"
	
	# TEST DU FICHIER (A FAIRE)
	
else
	sudo -S touch /etc/X11/xorg.conf.d/00-Keyboard.conf
        sudo -S echo 'Section "InputClass"' | sudo -S tee /etc/X11/xorg.conf.d/00-Keyboard.conf
	sudo -S echo '     Identifier "system-keyboard"' | sudo -S tee -a /etc/X11/xorg.conf.d/00-Keyboard.conf
	sudo -S echo '     MatchisKeyboard "on"' | sudo -S tee -a /etc/X11/xorg.conf.d/00-Keyboard.conf
        sudo -S echo '     Option "XkbLayout" "fr"' | sudo -S tee -a /etc/X11/xorg.conf.d/00-Keyboard.conf
	sudo -S echo '     Option "XkbModel" "pc105"' | sudo -S tee -a /etc/X11/xorg.conf.d/00-Keyboard.conf
        sudo -S echo '     Option "XkbOptions" "caps:shiftlock"' | sudo -S tee -a /etc/X11/xorg.conf.d/00-Keyboard.conf
        sudo -S echo 'EndSection' | sudo -S tee -a /etc/X11/xorg.conf.d/00-Keyboard.conf
fi
