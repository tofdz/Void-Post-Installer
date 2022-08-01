#!/bin/bash
echo "==> Install Steam"
# Installation de Steam sur VoidLinux.
sudo vpm i -y libgcc-32bit libstdc++-32bit libdrm-32bit libglvnd-32bit

# Installation de Steam via flatpak (EldenRing EAC actif)
flatpak install --user com.valvesoftware.Steam org.freedesktop.Platform.VulkanLayer.MangoHud
