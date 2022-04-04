#!/bin/bash
echo "==> Install Steam"
# Installation de Steam sur VoidLinux.
sudo vpm i -y libgcc-32bit libstdc++-32bit libdrm-32bit libglvnd-32bit

# Installation de Steam via flatpak (EldenRing EAC actif)
flatpak install --user com.valvesoftware.Steam org.freedesktop.Platform.VulkanLayer.MangoHud

# Verification modification sur sysctl.conf

	VERIF=$(cat /etc/sysctl.conf|grep vm.max_map_count=1048576)
	echo "Vérification /etc/sysctl.conf : $VERIF"
	if [ -e $VERIF ];then
	echo "Modification /etc/sysclt absente : modification en cours"
	sudo -S sh -c "echo "vm.max_map_count=1048576" >> /etc/sysctl.conf"
	VERIF=$(cat /etc/sysctl.conf|grep vm.max_map_count=1048576)
	echo "Vérification /etc/sysctl.conf : $VERIF"
	else
	echo "Fichier /etc/sysctl.conf : déjà modifié"
	fi
