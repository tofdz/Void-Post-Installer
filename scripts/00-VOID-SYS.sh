#!/bin/bash
echo "==> 01 Void : System modifications"
# Verification /etc/sysctl.conf

VER1=$(cat /etc/sysctl.conf|grep vm.max_map_count=1048576)
VER2=$(cat /etc/sysctl.conf|grep "abi.vsyscall32 = 0")
VER4=$(cat /etc/security/limits.conf|grep '1048576')
VER5=$(cat /etc/environment|grep -c 'qt5ct')

echo "==> Vérification /etc/sysctl.conf : $VER1"
sudo -S echo "===> 02 /etc/sysctl.conf : vm.max_map_count=1048576"
if [ -e $VER1 ]; then
	sudo -S echo "==!> Modification /etc/sysclt absente : modification en cours"
	sudo -S echo "vm.max_map_count=1048576" >> /etc/sysctl.conf
	VER1A=$(cat /etc/sysctl.conf|grep vm.max_map_count=1048576)
	sudo -S echo "==> Vérification /etc/sysctl.conf : $VER1A"
	else
	sudo -S echo "==> Fichier /etc/sysctl.conf : déjà modifié"
fi

sudo -S echo "===> 03 /etc/sysctl.conf : abi.vsyscall32 = 0"
if [ -e $VER2 ]; then
	sudo -S echo "Modification /etc/sysclt absente : modification en cours"
	sudo -S echo "abi.vsyscall32 = 0" >> /etc/sysctl.conf
	VER2A=$(cat /etc/sysctl.conf|grep "abi.vsyscall32 = 0")
	sudo -S echo "Vérification /etc/sysctl.conf : $VER2A"
	else
	sudo -S echo "Fichier /etc/sysctl.conf : déjà modifié"
fi

# VERIFICATION /etc/security/limits.conf
sudo -S echo "===> 05 /etc/security/limits.conf"
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