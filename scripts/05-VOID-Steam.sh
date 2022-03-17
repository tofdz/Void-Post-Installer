#!/bin/bash
echo "==> Install Steam"
sudo usermod -a -G input $USER
# Installation de Steam sur VoidLinux.
sudo vpm i -y steam libgcc-32bit libstdc++-32bit libdrm-32bit libglvnd-32bit mono

# Installation de Steam via flatpak (EldenRing EAC actif)
flatpak --user install com.valvesoftware.Steam org.freedesktop.Platform.VulkanLayer.MangoHud
sudo -S echo "vm.max_map_count=1048576" >> etc/sysctl.conf
