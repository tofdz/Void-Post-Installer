#!/bin/bash

# Installation de Steam sur VoidLinux.
sudo vpm i -y steam libgcc-32bit libstdc++-32bit libdrm-32bit libglvnd-32bit mono
sudo usermod -a -G input $USER
