#!/bin/bash
voiduser=$(echo $USER)
VER1=$(cat /etc/sysctl.conf|grep vm.max_map_count=1048576)
VER2=$(cat /etc/sysctl.conf|grep "abi.vsyscall32 = 0")
VER4=$(cat /etc/security/limits.conf|grep '1048576')
VER5=$(cat /etc/environment|grep -c 'qt5ct')
sudo -s <<eof
echo -e "==> 00 Void : System modifications"

# CLEANINSTALL
echo -e "==> CLEANER"

#CLEANER
echo "===> BASE CLEANING - PLEASE WAIT !"
touch /etc/xbps.d/Base_Install.conf
echo "ignorepkg=linux-firmware-amd" >> /etc/xbps.d/Base_Install.conf
echo "ignorepkg=linux-firmware-intel" >> /etc/xbps.d/Base_Install.conf
echo "ignorepkg=linux-firmware-nvidia" >> /etc/xbps.d/Base_Install.conf
echo "ignorepkg=xf86-video-amdgpu" >> /etc/xbps.d/Base_Install.conf
echo "ignorepkg=xf86-video-ati" >> /etc/xbps.d/Base_Install.conf
echo "ignorepkg=xf86-video-dummy" >> /etc/xbps.d/Base_Install.conf
echo "ignorepkg=xf86-video-fbdev" >> /etc/xbps.d/Base_Install.conf
echo "ignorepkg=xf86-video-intel" >> /etc/xbps.d/Base_Install.conf
echo "ignorepkg=xf86-video-nouveau" >> /etc/xbps.d/Base_Install.conf
echo "ignorepkg=xf86-video-vesa" >> /etc/xbps.d/Base_Install.conf
echo "ignorepkg=xf86-video-vmware" >> /etc/xbps.d/Base_Install.conf

vpm remove -y linux-firmware-amd linux-firmware-intel linux-firmware-nvidia xf86-video-amdgpu xf86-video-ati xf86-video-dummy xf86-video-fbdev xf86-video-intel xf86-video-nouveau xf86-video-vesa xf86-video-vmware 
echo "==> Suppression Base_Install.conf"
rm /etc/xbps.d/Base_Install.conf

# Verification /etc/sysctl.conf
echo "==> Vérification /etc/sysctl.conf : $VER1"
echo "===> 02 /etc/sysctl.conf : vm.max_map_count=1048576"
if [ -e $VER1 ]; then
	echo "==!> Modification /etc/sysclt absente : modification en cours"
	echo "vm.max_map_count=1048576" >> /etc/sysctl.conf
	echo "==> Vérification /etc/sysctl.conf : $VER1"
	else
	echo "==> Fichier /etc/sysctl.conf : déjà modifié"
fi
sudo -S echo "===> 03 /etc/sysctl.conf : abi.vsyscall32 = 0"
if [ -e $VER2 ]; then
	sudo -S echo "Modification /etc/sysclt absente : modification en cours"
	echo "abi.vsyscall32 = 0" >> /etc/sysctl.conf
	sudo -S echo "Vérification /etc/sysctl.conf : $VER2"
	else
	sudo -S echo "Fichier /etc/sysctl.conf : déjà modifié"
fi

# Verification limits.conf
sudo -S echo "===> 04 /etc/security/limits.conf pour $voiduser"
if [ -e $VER4 ]; then
	sudo -S echo "==> Modification /etc/security/limits.conf"
	echo "$voiduser           -       nice            -20" >> /etc/security/limits.conf
	echo "$voiduser           -       nofile          1048576" >> /etc/security/limits.conf
else
	sudo -S echo "==> /etc/security/limits.conf déjà modifié"
fi

# Modification /etc/environment
if [ -e $VER5 ]; then
sudo -S echo "==> Modification /etc/environment QT_QPA_PLATEFORMTHEME=qt5ct"
echo 'export QT_QPA_PLATFORMTHEME=qt5ct' >> /etc/environment
else
sudo -S echo "PASS ==> /etc/environment déjà modifié"
fi

#==============================
# PATH : $HOME/$USER/.local/bin
#==============================
echo "===> $HOME/.local/bin : Modification fichiers"
if [ -e $(cat /etc/profile|grep "/.local/bin") ]; then
	sudo -S echo "==> /etc/profile : Modification en cours ..."
	echo 'if [ -d "$HOME/.local/bin" ]; then' >> /etc/profile
	echo 'PATH=$HOME/.local/bin:$PATH' >> /etc/profile
	echo 'fi' >> /etc/profile
	echo 'if [ -d /var/lib/flatpak/exports/share ]; then' >> /etc/profile
	echo 'PATH=/var/lib/flatpak/exports/share:$PATH' >> /etc/profile
	echo 'fi' >> /etc/profile
	echo 'if [ -d $HOME/.local/share/flatpak/exports/share ]; then'  >> /etc/profile
	echo 'PATH=$HOME/.local/share/flatpak/exports/share:$PATH' >> /etc/profile
	echo 'fi' >> /etc/profile
	sudo -S echo 'Fichier profile - Terminé !'
else
	echo -e "==> /etc/profile : Fichier /etc/profile déjà modifié : "
	echo -e "==> /etc/profile : TERMINE"
fi

eof
