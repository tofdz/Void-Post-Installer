#!/bin/bash

# Insertion pour utiliser qt5ct dans le fichier /etc/environment
echo "02-VOID-Qt5ct.sh ===>"
sudo -S echo "export QT_QPA_PLATFORMTHEME=qt5ct" >> /etc/environment
