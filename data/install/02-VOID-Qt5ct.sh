#!/bin/bash

# Insertion pour utiliser qt5ct dans le fichier /etc/environment
echo "02-VOID-Qt5ct.sh ===>"
sudo -S echo -e "export QT_QPA_PLATFORMTHEME=qt5ct" | sudo -S tee -a /etc/environment