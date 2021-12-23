#!/bin/bash

# Installation de Steam sur VoidLinux.
sudo vpm i -y steam libstdc++ libdrm libglvnd mono
sudo usermod -a -G input $USER
