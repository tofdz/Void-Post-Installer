#!/bin/bash
echo "==> Void : System modifications"
# VER1ication /etc/sysctl.conf

VER1=$(cat /etc/sysctl.conf|grep 'vm.max_map_count=1048576')
VER2=$(cat /etc/sysctl.conf|grep 'abi.vsyscall32 = 0')
VER3=$(cat /etc/profile|grep '/.local/bin')
VER4=$(cat /etc/security/limits.conf|grep '1048576')
VER5=$(cat /etc/environment|grep -c 'qt5ct')


echo "Vérification /etc/sysctl.conf : $VER1"

if [ -e $VER1 ]; then
	echo "Modification /etc/sysclt absente : modification en cours"
	sudo -S sh -c "echo "vm.max_map_count=1048576" >> /etc/sysctl.conf"
	VER1A=$(cat /etc/sysctl.conf|grep vm.max_map_count=1048576)
	echo "Vérification /etc/sysctl.conf : $VER1A"
	else
	echo "Fichier /etc/sysctl.conf : déjà modifié"
fi

if [ -e $VER2 ]; then
	echo "Modification /etc/sysclt absente : modification en cours"
	sudo -S sh -c "echo "abi.vsyscall32 = 0" >> /etc/sysctl.conf"
	VER2A=$(cat /etc/sysctl.conf|grep abi.vsyscall32 = 0)
	echo "Vérification /etc/sysctl.conf : $VER2A"
	else
	echo "Fichier /etc/sysctl.conf : déjà modifié"
fi

# Vérification & création du repertoire .local/bin dans le $HOME
if [ ! -d $HOME/.local/bin ]; then
	mkdir $HOME/.local/bin
	echo "Repertoire $HOME/.local/bin crée"
	else
	echo "Repertoire $HOME/.local/bin déjà présent"
fi

# Prendre en compte le $HOME/$USER/.local/bin en compte dans le $PATH
if [ -e $VER3 ]; then
# if [ -z $(sudo -S cat /etc/profile|grep -c '/.local/bin') ]; then
	echo "==> /etc/profile : Modification en cours ..."
	sudo -S sh -c "echo 'if [ -d "$HOME/.local/bin" ] ; then' >> /etc/profile"
	sudo -S sh -c "echo 'PATH=$HOME/.local/bin:$PATH' >> /etc/profile"
	sudo -S sh -c "echo 'fi' >> /etc/profile"
	sudo -S sh -c "echo 'if [ -d /var/lib/flatpak/exports/share ];then' >> /etc/profile"
	sudo -S sh -c "echo 'PATH=/var/lib/flatpak/exports/share:$PATH' >> /etc/profile"
	sudo -S sh -c "echo 'fi' >> /etc/profile"
	sudo -S sh -c "echo 'if [ -d $HOME/.local/share/flatpak/exports/share ];then'  >> /etc/profile"
	sudo -S sh -c "echo 'PATH=$HOME/.local/share/flatpak/exports/share:$PATH' >> /etc/profile"
	sudo -S sh -c "echo 'fi' >> /etc/profile"
	echo 'Fichier profile - Terminé !'
	sudo -S source /etc/profile
else
	echo -e "==> /etc/profile : Fichier /etc/profile déjà modifié : "
	echo -e "==> /etc/profile : TERMINE"
fi

# VERIFICATION /etc/security/limits.conf
if [ -e $VER4 ]; then
#if [ -z $(cat /etc/security/limits.conf|grep -c '1048576') ]; then
	echo "==> Modification /etc/security/limits.conf"
	sudo -S sh -c "echo "*               hard    nofile          1048576" >> /etc/security/limits.conf"
else
	echo "==> /etc/security/limits.conf déjà modifié"
fi

# Modification /etc/environment
if [ -e $VER5 ]; then
#if [ -z $(sudo -S cat /etc/environment|grep -c 'qt5ct') ]; then
echo "==> Modification /etc/environment QT_QPA_PLATEFORMTHEME=qt5ct"
sudo -S sh -c "echo 'export QT_QPA_PLATFORMTHEME=qt5ct' >> /etc/environment"
else
echo "PASS ==> /etc/environment déjà modifié"
fi