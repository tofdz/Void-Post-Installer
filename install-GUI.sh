#!/bin/bash
# NAME : Void-Post-Installer
# LAUNCHER : install.sh
version="0.1.5"
# Date : 16/11/2020 maj 04/12/2021
# by Tofdz
# assisted by :
#
# DrNeKoSan : crash test !
# Odile     : Les cafés !
# Celine    : Les petits pains !!
PASS=$(yad --entry --title="Void-Post-Installer v$version" --text="Entrez votre mot de passe :" --hide-text \
			--width=270 --height=150 )
echo $PASS|sudo -S clear
sudo -S xbps-install -Suyv yad
WDIR=$(pwd)
chmod +x $WDIR/scripts/*
source ~/.config/user-dirs.dirs

function NET(){
echo -e "===> NET"
ip[0]=8.8.8.8
i=0
while ((${#ip[*]}!=$i)) ; do
	ping -c1 -q ${ip[$i]};ipR[$i]=${?};
	i=$((i+1));
done
i=0
while ((${#ip[*]}!=$i)) ; do
	if [ ${ipR[$i]} -eq 0 ];then
	echo -e " ${ip[$i]} est ONLINE"
	else
	echo -e " ${ip[$i]} est OFFLINE"
	exit
	fi
	i=$((i+1));
done
}
function SSHKEYTEST(){

# Vérification & Création des clés SSH en ed25519
SSHDIR=/etc/ssh/
PRIK=id_ed25519
PUBK=id_ed15519.pub
echo -e "===> CHECK CLES SSH"
if [ ! -f $SSHDIR$PRIK ] || [ ! -f $SSHDIR$PUBK ];then

		yes 'Y' | ssh-keygen -t ed25519 -N ' '
        else
        echo -e "fichiers deja present"
fi
}
function ELOGIND(){

# Configuration clavier azerty pour
# se connecter à sa session.
echo -e "===> CONFIGURATION AZERTY AU LOGIN"
cd $WDIR/scripts/
sudo -S ./03-VOID-Login_AZERTY.sh
cd $WDIR
}
function BASE(){
# MISE A JOUR DU SYSTEME (OBLIGATOIRE PREMIERE FOIS POUR DL)
echo -e "===> BASE INSTALL"
sudo xbps-install -Syuv xbps;sudo xbps-install -Syuv;
# INSTALLATION VPM
sudo xbps-install -Syuv vpm vsv;
sudo vpm i -y void-repo-multilib void-repo-nonfree void-repo-multilib-nonfree;
sudo vpm i -y git-all nano zsh curl wget python3-pip octoxbps notepadqq mc htop ytop tmux xarchiver unzip p7zip-unrar xfburn gparted pycp cdrtools socklog socklog-void adwaita-qt qt5ct xfce4-pulseaudio-plugin gnome-calculator;

sudo ln -s /etc/sv/socklog-unix /var/services;sudo ln -s /etc/sv/nanoklogd /var/services;
# OPTI SYSTEME Void (On degage les trucs useless ou qui font conflit comme dhcpcd)
sudo vsv disable dhcpcd agetty-hvc0 agetty-hvsi0 agetty-tty2 agetty-tty3 agetty-tty4 agetty-tty5 agetty-tty6;
sudo rm /var/service/dhcpcd /var/service/agetty-hvc0 /var/service/agetty-hvsi0 /var/service/agetty-tty2 /var/service/agetty-tty3 /var/service/agetty-tty4 /var/service/agetty-tty5 /var/service/agetty-tty6;
# INSTALLATION Wallpaper
pycp -g $WDIR/wallpapers/* $XDG_PICTURES_DIR
# Installation fonts SanFrancisco
echo -e "===> Fonts SanFrancisco"
cd $HOME
git clone https://github.com/supermarin/YosemiteSanFranciscoFont
if [ ! -d $HOME/.fonts ];then
	sudo mkdir $HOME/.fonts/
	echo -e "Repertoire .fonts crée !"
fi
sudo pycp -g $HOME/YosemiteSanFranciscoFont/*.ttf $HOME/.fonts/
sudo fc-cache -fv
sudo echo -e "Suppression des Fichiers inutile"
rm -rfv $HOME/YosemiteSanFranciscoFont
# Prendre en compte le $HOME/$USER/.local/bin en compte dans le $PATH
if [ ! -f $HOME/.profile ];then
echo "Création du .profile"
touch $HOME/.profile
echo 'if [ -d "$HOME/.local/bin" ] ; then' > $HOME/.profile
echo 'PATH="$HOME/.local/bin:$PATH"' >> $HOME/.profile
echo "fi" >> $HOME/.profile
echo 'Fichier .profile - Terminé !'
source $HOME/.profile
fi
#sudo echo 'export QT_QPA_PLATFORMTHEME=qt5ct' >> /etc/environment
# Attribue à l'utilisateur le group input (pour les manettes de jeu)
sudo usermod -a -G input $USER
echo "$(groups)"
}
function NANORC(){
# Configuration highlighting pour nano (met le code en couleur)
echo "===> NANO HIGHLIGHTING"

touch $HOME/.nanorc
echo 'include "/usr/share/nano/asm.nanorc"' > $HOME/.nanorc
echo 'include "/usr/share/nano/c.nanorc"' >> $HOME/.nanorc
echo 'include "/usr/share/nano/css.nanorc"' >> $HOME/.nanorc
echo 'include "/usr/share/nano/email.nanorc"' >> $HOME/.nanorc
echo 'include "/usr/share/nano/groff.nanorc"' >> $HOME/.nanorc
echo 'include "/usr/share/nano/java.nanorc"' >> $HOME/.nanorc
echo 'include "/usr/share/nano/lua.nanorc"' >> $HOME/.nanorc
echo 'include "/usr/share/nano/markdown.nanorc"' >> $HOME/.nanorc
echo 'include "/usr/share/nano/nftables.nanorc"' >> $HOME/.nanorc
echo 'include "/usr/share/nano/patch.nanorc"' >> $HOME/.nanorc
echo 'include "/usr/share/nano/po.nanorc"' >> $HOME/.nanorc
echo 'include "/usr/share/nano/tcl.nanorc"' >> $HOME/.nanorc
echo 'include "/usr/share/nano/xml.nanorc"' >> $HOME/.nanorc
echo 'include "/usr/share/nano/autoconf.nanorc"' >> $HOME/.nanorc
echo 'include "/usr/share/nano/changelog.nanorc"' >> $HOME/.nanorc
echo 'include "/usr/share/nano/default.nanorc"' >> $HOME/.nanorc
echo 'include "/usr/share/nano/guile.nanorc"' >> $HOME/.nanorc
echo 'include "/usr/share/nano/javascript.nanorc"' >> $HOME/.nanorc
echo 'include "/usr/share/nano/makefile.nanorc"' >> $HOME/.nanorc
echo 'include "/usr/share/nano/nanohelp.nanorc"' >> $HOME/.nanorc
echo 'include "/usr/share/nano/objc.nanorc"' >> $HOME/.nanorc
echo 'include "/usr/share/nano/perl.nanorc"' >> $HOME/.nanorc
echo 'include "/usr/share/nano/python.nanorc"' >> $HOME/.nanorc
echo 'include "/usr/share/nano/sh.nanorc"' >> $HOME/.nanorc
echo 'include "/usr/share/nano/tex.nanorc"' >> $HOME/.nanorc

}
function GUFW(){
# INTERFACE GRAPHIQUE POUR CONTROLER SON GUFW
# DE MANIERE TRES SIMPLE !!!!
sudo vpm i -y gufw

# CONFIGURATION POUR RENDRE FONCTIONNELLE LE GUI
if [ ! -f $HOME/.local/bin/gufw-launcher ]; then
	touch $HOME/.local/bin/gufw-launcher
	echo '#!/bin/bash' > $HOME/.local/bin/gufw-launcher
	echo 'PASS=$(zenity --password --title="VPI - gufw Launcher")' >> $HOME/.local/bin/gufw-launcher
	echo '$PASS|sudo -S gufw-pkexec clear' >> $HOME/.local/bin/gufw-launcher
	chmod +x $HOME/.local/bin/gufw-launcher

	if [ ! -f $XDG_DEKTOP_DIR/gufw.desktop ]; then
		touch $XDG_DEKTOP_DIR/gufw.desktop
		echo '[Desktop Entry]' > $XDG_DEKTOP_DIR/gufw.desktop
		echo 'Version=1.0' >> $XDG_DEKTOP_DIR/gufw.desktop
		echo 'Type=Application' >> $XDG_DEKTOP_DIR/gufw.desktop
		echo 'Name=gufw' >> $XDG_DEKTOP_DIR/gufw.desktop
		echo 'Comment=Firewall' >> $XDG_DEKTOP_DIR/gufw.desktop
		echo 'Exec=$HOME/.local/bin/gufw-launcher' >> $XDG_DEKTOP_DIR/gufw.desktop
		echo 'Icon=caveau' >> $XDG_DEKTOP_DIR/gufw.desktop
		echo 'Terminal=false' >> $XDG_DEKTOP_DIR/gufw.desktop
		echo 'StartupNotify=false' >> $XDG_DEKTOP_DIR/gufw.desktop
	fi
fi

}
function VPIAPPS(){
echo "MUCHACHOS GRINGOS"
chmod +x $WDIR/outils/*
pycp $WDIR/outils/ZenIso $HOME/.local/bin/

echo '[Desktop Entry]' > $XDG_DEKTOP_DIR/ZenIso.desktop
echo 'Version=1.0' >> $XDG_DEKTOP_DIR/ZenIso.desktop
echo 'Type=Application' >> $XDG_DEKTOP_DIR/ZenIso.desktop
echo 'Name=ZenIso' >> $XDG_DEKTOP_DIR/ZenIso.desktop
echo 'Exec=/home/toff/.local/share/applications/APPS/ZenIso-1.0.3.sh' >> $XDG_DEKTOP_DIR/ZenIso.desktop
echo 'Icon=tools-media-optical-burn-image' >> $XDG_DEKTOP_DIR/ZenIso.desktop
echo 'Terminal=true' >> $XDG_DEKTOP_DIR/ZenIso.desktop
echo 'StartupNotify=false' >> $XDG_DEKTOP_DIR/ZenIso.desktop
echo 'Categories=System;' >> $XDG_DEKTOP_DIR/ZenIso.desktop

}
function INTELGPU(){
echo -e "==> INTELINSTALL"
sudo vpm i -y mesa mesa-dri mesa-vulkan-intel linux-firmware-broadcom linux-firmware-intel linux-firmware-network intel-ucode
}
function AMDGPU(){

echo "===> AMD INSTALL"
sudo vpm i -y mesa mesa-dri

}
function NVIDIA(){

echo "===> nvidia INSTALL"
sudo vpm i -y mesa mesa-dri nvidia nvidia-libs-32bit
FLATNVID
}
function T420(){

echo "===> T420 addons"
sudo vpm i -y tlp tlp-rdw tp_smapi-dkms tpacpi-bat mesa-dri linux-firmware-intel vulkan-loader mesa-vulkan-intel intel-video-accel libva-intel-driver
# sudo cp lenovo-mutemic.sh /etc/acpi/&&sudo chmod +x /etc/acpi/lenovo-mutemic.sh;
sudo chmod +x $HOME/Void-Post-Installer/outils/lenovo-mutemusic.sh;sudo pycp $HOME/Void-Post-Installer/outils/lenovo-mutemusic.sh /etc/acpi
sudo vsv restart acpid
}
function X250(){

echo "===> X250 addons"
if [ -n $(sudo grep 'intel' /etc/default/grub) ];then
	echo "Modification du fichier /etc/default/grub"
	sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=4"/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=4" intel_iommu=igfx_off/' /etc/default/grub
	cat /etc/default/grub
	echo "Mise à jour de Grub"
	sudo update-grub
else
	echo "Fichier déjà modifié"
fi
sudo chmod +x $HOME/Void-Post-Installer/outils/lenovo-mutemusic.sh;sudo pycp $HOME/Void-Post-Installer/outils/lenovo-mutemusic.sh /etc/acpi
sudo vsv restart acpid;
sudo vpm i -y linux-firmware-broadcom linux-firmware-intel linux-firmware-network intel-ucode mesa-dri mesa-vulkan-intel
sudo vpm i -y tp_smapi-dkms tpacpi-bat

}
function I3INSTALLER(){
# configuration window manager i3
echo "===> i3"
cd $WDIR/scripts/
./08-VOID-i3.sh
cd $WDIR
}
function VIRTUALBOX(){
echo "===> VIRTUALBOX INSTALL"

cd $WDIR/scripts/
./09-VOID-VirtualBox.sh
cd $WDIR
}
function FLATPAK(){
echo "===> FLATPAK"
# installation via flatpak de Discord & Parsec
sudo vpm i -y flatpak
echo "Flatpak : Création des repos si non existant"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}
function DISCORD(){
echo "Flatpak : Installation Discord & Parsec"
#flatpak install Discord Parsec org.freedesktop.Platform.GL.nvidia-470-74
flatpak install -y Discord
}
function PARSEC(){
echo "Flatpak : Installation Discord & Parsec"
flatpak install -y Parsec
}
function FLATNVID(){
echo "Flatpak : Installation Discord & Parsec"
flatpak install -y org.freedesktop.Platform.GL.nvidia-470-74
}
function STEELSERIES(){
echo "===> STEELSERIES INSTALL"
cd $WDIR/scripts/
./07-VOID-rivalcfg.sh
cd $WDIR
}
function CORSAIR(){
sudo vpm i -y ckb-next;
sudo ln -s /etc/sv/ckb-next-daemon /var/service;
sudo vsv enable ckb-next-daemon && sudo vsv start ckb-next-daemon;
}
function STEAM(){
echo -e "===> STEAM"
cd $WDIR/scripts/
./05-VOID-Steam.sh
cd $WDIR
}
function GOG(){
echo "===> GOG INSTALL"
cd $WDIR/scripts/
./06-VOID-GOG.sh
cd $WDIR
}
function WINE(){
echo "===> WINE INSTALL"
cd $WDIR/scripts/
./10-VOID-Wine.sh
cd $WDIR
}
function PROTONUP(){
# INSTALLATION DE PROTONUP
pip3 install protonup
REPERTOIRE="$HOME/.local/share/Steam/compatibilitytools.d/"
# Création du repertoire pour Steam
if [ ! -d $REPERTOIRE ];then
sudo mkdir -R $REPERTOIRE
echo 'Protonup - $REPERTOIRE pour steam créé'
fi
# Configuration repertoire steam Proton & install protonGH
echo 'Configuration & Installation ProtonGH pour steam'
protonup -d $REPERTOIRE
protonup -y
}
function OHMYZSH(){

# Installation de OhmyZsh!
echo "===> OHMYZSH INSTALL"
sudo vpm i -y zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
exit
}

function AUTOINSTALL(){

echo -e "==>   AUTOINSTALL"
SSHKEYTEST
ELOGIND
BASE
GUFW
NANORC
CHECKFLATPAK
$gpuDETECT
WINE
PROTONUP
OHMYZSH
sudo echo "Fin de AUTO-LIGHT"
MENUFIN
}
function CUSTOMINSTALL(){

echo -e "==>   CUSTOMINSTALL"
MENUPARSER
SSHKEYTEST
ELOGIND
BASE
CHECKFLATPAK
$gpuDETECT
XBPSLOADER
APPSLOADER
MENUFIN

}

function MENUPARSER(){
echo -e "===> START : MENU-PARSER"
# ALIMENTE LES TABLEAU POUR INSTALL DE XBPS ET APPS
touch TMP01
touch TMP02
touch TMP03
touch TMP04

echo -e "===> MENU PARSER - Fichiers TEMP créé"
echo -e $menuCHECK
echo $menuCHECK > TMP01

sed 's/| /|\n/g' TMP01 > TMP02
cat TMP02 | grep XBPS > TMP03
cat TMP03 | cut -d "|" -f3 > TMP04
sed ':a;N;$!ba;s/\n/ /g' TMP04 > TMP03
unset customXBPS
while read -r dataXBPS
do
customXBPS+=$dataXBPS
done < TMP03

cat TMP02 | grep APPS > TMP01
cat TMP01 | cut -d "|" -f3 > TMP02
sed 's/.*/& /' TMP02 > TMP01

unset customAPP
while read -r dataAPP
do
customAPP+=("$dataAPP")
done < TMP01

echo -e "customXBPS : ${customXBPS[@]}"
echo -e "customAPPS : ${customAPP[@]}"

rm TMP01 TMP02 TMP03 TMP04
}
function CHECKFLATPAK(){
echo -e "===> CHECKFLATPAK"

if [ $(echo $menuCHECK | grep -c DISCORD) ]; then
   echo -e "====> Installation Flatpak pour Discord"
   FLATPAK;
fi

if [ $(echo $menuCHECK | grep -c PARSEC) != 0 ]; then
	echo -e "====> Installation Flatpak pour Parsec"
	FLATPAK
fi

if [ $(echo $gpuDETECT | grep -c NVIDIA) != 0 ]; then
	echo -e "====> Installation Flatpak pour nvidia"
	FLATPAK
	FLATNVID
fi

}
function XBPSLOADER(){
# MOULINETTE XBPSLOADER
echo -e "===XBPSLOADER===> XBPSLOADER :"
sudo vpm i -y ${customXBPS[@]}
}
function APPSLOADER(){
echo -e "==> APPS LOADER START"
compteur=${#customAPP[@]}
echo -e "Compteur = $compteur"
i=0
while (($compteur!=$i));
do
echo -e "==> APPS LOADER BOUCLE WHILE "
${customAPP[$i]};
i=$(($i+1))
done
}

function MENUFIN(){

yad--info --title="Void-Post-Installer v$version : Installation terminée" \
				--text="Installée terminée !\nBonne journée !\nTofdz" 
}
function MAIN(){
DETECT
BANNER

echo -e "GPU : $gpuDETECT"
echo -e "==> MAIN MENU START"
menuCHECK=$(yad --title="Void-Post-Installer" \
			--width=750 --height=940 \
			--image=tools-media-optical-burn-image \
			--text="Bienvenue dans la post installation de VoidLinux" \
			--list --checklist --column=" " --column="TYPE" --column=" Nom " --column="Description : " \
			--separator="|" --hide-column=2 \
			true "XBPS" "cifs-utils" "Description" \
			true "XBPS" "smbclient" "Description" \
			true "XBPS" "thunderbird" "Description" \
			true "XBPS" "birdtray" "Description" \
			true "XBPS" "minitube" "Description" \
			true "XBPS" "arduino" "Description" \
			true "XBPS" "gufw" "Description" \
			true "XBPS" "zenmap" "Description" \
			true "XBPS" "vlc" "Description" \
			true "XBPS" "gimp" "Description" \
			true "XBPS" "blender" "Description" \
			true "XBPS" "ytmdl" "Description" \
			true "XBPS" "filelight" "Description" \
			true "XBPS" "xfce4-plugins" "Description" \
			true "XBPS" "xfce4-screenshooter" "Description" \
			true "XBPS" "xfce4-whiskermenu-plugin" "Description" \
			true "XBPS" "deluge" "Description" \
			true "APPS" "VPIAPPS" "Ensemble d'applis assez utile !" \
			false "APPS" "T420" "Optimisation pour lenovo T420 uniquement" \
			false "APPS" "X250" "Optimisation pour lenovo X250 uniquement" \
			true "APPS" "I3INSTALLER" "Installation du gestionnaire de fenetre graphique i3" \
			true "APPS" "VIRTUALBOX" "Gestionnaire de machines virtuelles" \
			true "APPS" "DISCORD" "Célèbre plateforme de chat vocale" \
			false "APPS" "PARSEC" "Gaming en streaming remote" \
			false "APPS" "STEELSERIES" "Reglages periphériques Steel Series (souris)" \
			false "APPS" "CORSAIR" "Reglages périphériques Corsair (clavier/souris)" \
			true "APPS" "STEAM" "Installation de Steam" \
			true "APPS" "GOG" "Installation de Gog Galaxy (Minigalaxy)" \
			true "APPS" "WINE" "Pouvoir installer des application windows sur voidlinux" \
			true "APPS" "PROTONUP" "Version améliorée de Proton pour steam & wine" \
			true "APPS" "OHMYZSH" "Shell bien plus avancé que le terminal de base ;) à essayer !" \
			--button="Install Minimale:1" --button="Install:0" \
			)
valret=$?
verif=$(echo $menuCHECK | grep -c "TRUE")
case $valret in
	0)
	CUSTOMINSTALL
	;;
	1)
	AUTOINSTALL
	;;
	255)
	;;
esac
echo -e "Retour ??? : $valret"
echo -e "menuCHECK : $menuCHECK"
echo -e menuCHECK
}

function DETECT(){
# DETECTION CPU
cpuDETECT="Default"
cputemp=$(lscpu |grep Proc)
if [ $(echo $cputemp | grep -c AMD) != 0 ]; then
		cpuDETECT="AMD"
fi
if [ $(echo $cputemp | grep -c INTEL) != 0 ]; then
		cpuDETECT="INTEL"
fi
# DETECTION GPU
if [ $(lspci | grep -c VGA) != 0 ]; then
		lspci | grep VGA > gpuTMP01
	if	[ $(cat gpuTMP01 | grep -c NVIDIA) != 0 ]; then
		gpuDETECT="NVIDIA"
	fi
	if	[ $(cat gpuTMP01 | grep -c AMD) != 0 ]; then
		gpuDETECT="AMDGPU"
	fi
	if	[ $(cat gpuTMP01 | grep -c Intel) != 0 ]; then
		gpuDETECT="INTELGPU"
	fi
fi
}
function BANNER(){
softNAME="Void-Post-Installer"
clear
echo -e "####################################"
echo -e "##"
echo -e "##\t\t$softNAME"
echo -e "##\t\tV $version"
echo -e "##"
echo -e "######"
}

MAIN
