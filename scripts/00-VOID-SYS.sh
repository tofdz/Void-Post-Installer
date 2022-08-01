#!/bin/bash
echo "==> Void : System modifications"
# Verification /etc/sysctl.conf

VER1=$(cat /etc/sysctl.conf|grep 'vm.max_map_count=1048576')
VER2=$(cat /etc/sysctl.conf|grep "abi.vsyscall32 = 0")
VER3=$(cat /etc/profile|grep '/.local/bin')
VER4=$(cat /etc/security/limits.conf|grep '1048576')
VER5=$(cat /etc/environment|grep -c 'qt5ct')

echo "==> Vérification /etc/sysctl.conf : $VER1"

if [ -e $VER1 ]; then
	sudo -S echo "==!> Modification /etc/sysclt absente : modification en cours"
	sudo -S echo "vm.max_map_count=1048576" >> /etc/sysctl.conf
	VER1A=$(cat /etc/sysctl.conf|grep vm.max_map_count=1048576)
	sudo -S echo "==> Vérification /etc/sysctl.conf : $VER1A"
	else
	sudo -S echo "==> Fichier /etc/sysctl.conf : déjà modifié"
fi

if [ -e $VER2 ]; then
	sudo -S echo "Modification /etc/sysclt absente : modification en cours"
	sudo -S echo "abi.vsyscall32 = 0" >> /etc/sysctl.conf
	sudo -S echo "Vérification /etc/sysctl.conf : $VER2"
	else
	sudo -S echo "Fichier /etc/sysctl.conf : déjà modifié"
fi

# Vérification & création du repertoire .local/bin dans le $HOME
if [ ! -d $HOME/.local/bin ]; then
	mkdir $HOME/.local/bin
	sudo -S echo "Repertoire $HOME/.local/bin crée"
	else
	sudo -S echo "Repertoire $HOME/.local/bin déjà présent"
fi

# Prendre en compte le $HOME/$USER/.local/bin en compte dans le $PATH
if [ -e $VER3 ]; then
	sudo -S echo "==> /etc/profile : Modification en cours ..."
	sudo -S echo 'if [ -d "$HOME/.local/bin" ] ; then' >> /etc/profile
	sudo -S echo 'PATH=$HOME/.local/bin:$PATH' >> /etc/profile
	sudo -S echo 'fi' >> /etc/profile
	sudo -S echo 'if [ -d /var/lib/flatpak/exports/share ];then' >> /etc/profile
	sudo -S echo 'PATH=/var/lib/flatpak/exports/share:$PATH' >> /etc/profile
	sudo -S echo 'fi' >> /etc/profile
	sudo -S echo 'if [ -d $HOME/.local/share/flatpak/exports/share ];then'  >> /etc/profile
	sudo -S echo 'PATH=$HOME/.local/share/flatpak/exports/share:$PATH' >> /etc/profile
	sudo -S echo 'fi' >> /etc/profile
	sudo -S echo 'Fichier profile - Terminé !'
	sudo -S source /etc/profile
else
	sudo -S echo -e "==> /etc/profile : Fichier /etc/profile déjà modifié : "
	sudo -S echo -e "==> /etc/profile : TERMINE"
fi

# VERIFICATION /etc/security/limits.conf
if [ -e $VER4 ]; then
	echo "==> Modification /etc/security/limits.conf"
	sudo -S echo "@users           -       nice            -20" >> /etc/security/limits.conf
	sudo -S echo "@users           -       nofile          1048576" >> /etc/security/limits.conf
else
	sudo -S echo "==> /etc/security/limits.conf déjà modifié"
fi

# Modification /etc/environment
if [ -e $VER5 ]; then
sudo -S echo "==> Modification /etc/environment QT_QPA_PLATEFORMTHEME=qt5ct"
sudo -S echo 'export QT_QPA_PLATFORMTHEME=qt5ct' >> /etc/environment
else
sudo -S echo "PASS ==> /etc/environment déjà modifié"
fi
