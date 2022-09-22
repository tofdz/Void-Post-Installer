#!/bin/bash
# Installation de Wine pour Voidlinux

sudo -S vpm i -y wine winetricks wine-tools wine-mono wine-gecko wine-32bit libwine-32bit;
# Installation des dépendances pour wine
winetricks allfonts d3dcompiler_47 d3drm d3dx10 d3dx9 d3dx11_43 dxvk vkd3d l3codecx gfw
