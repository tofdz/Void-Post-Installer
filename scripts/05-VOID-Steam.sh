#!/bin/bash
echo "==> Install Steam"
sudo usermod -a -G input $USER
# Installation de Steam sur VoidLinux.
sudo vpm i -y steam libgcc-32bit libstdc++-32bit libdrm-32bit libglvnd-32bit mono

# Installation de Steam via flatpak (EldenRing EAC actif)
flatpak --user install com.valvesoftware.Steam org.freedesktop.Platform.VulkanLayer.MangoHud

# Verification modification sur sysctl.conf

	VERIF=$(cat /etc/sysctl.conf|grep vm.max_map_count=1048576)
	echo "Vérification /etc/sysctl.con : $VERIF"
	if [ -e $VERIF ];then
	echo "Modification /etc/sysclt absente : modification en cours"
	sudo -S echo "vm.max_map_count=1048576" >> etc/sysctl.conf
	else
	echo "Fichier /etc/sysctl.conf : déjà modifié"
	fi
