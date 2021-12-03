#!/bin/bash
# NAME : Void-Post-Installer
# LAUNCHER : install.sh
# Ver  : 0.0.4
# Date : 16/11/2020 maj 01/12/2021

PASS=$(zenity --password)
echo $PASS|sudo -S clear

echo -e "####################################"
echo -e "##                                ##"
echo -e "##\tVoid-Post-Installer\t  ##"
echo -e "##\t\tV 0.0.4	 	  ##"
echo -e "##                                ##"
echo -e "####################################"
WDIR=$(pwd)
echo $WDIR
chmod +x $WDIR/scripts/*
source ~/.config/user-dirs.dirs
#===========================#
#			BON				#
#===========================#
NET(){
echo -e "Fonction NET()"
ip[0]=8.8.8.8
ip[1]=192.168.1.1
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

SSHKEYTEST(){

# Vérification & Création des clés SSH en ed25519
SSHDIR=/etc/ssh/
PRIK=id_ed25519
PUBK=id_ed15519.pub
echo -e "===> CHECK CLES SSH"
if [ ! -f $SSHDIR$PRIK ] || [ ! -f $SSHDIR$PUBK ];then
        echo "ssh-keygen -t ed25519"
        else
        echo -e "fichiers deja present"
fi
}
ELOGIND(){

# Configuration clavier azerty pour
# se connecter à sa session.
echo -e "===> CONFIGURATION AZERTY AU LOGIN"
cd $WDIR/scripts/
sudo -S ./03-VOID-Login_AZERTY.sh
cd $WDIR
}
BASE(){
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
pycp $WDIR/wallpapers/* $XDG_PICTURES_DIR
# Installation fonts SanFrancisco
echo -e "===> Fonts SanFrancisco"
cd $HOME
git clone https://github.com/supermarin/YosemiteSanFranciscoFont
if [ ! -d $HOME/.fonts ];then
	sudo mkdir $HOME/.fonts/
	echo -e "Repertoire .fonts crée !"
fi
sudo pycp $HOME/YosemiteSanFranciscoFont/*.ttf $HOME/.fonts/
sudo fc-cache -fv
sudo echo -e "Suppression des Fichiers inutile"
rm -rfv $HOME/YosemiteSanFranciscoFont

#sudo echo 'export QT_QPA_PLATFORMTHEME=qt5ct' >> /etc/environment
# Attribue à l'utilisateur le group input (pour les manettes de jeu)
sudo usermod -a -G input $USER
echo "$(groups)"
}

NANORC(){
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
sudo cp $HOME/.nanorc /root/.nanorc
sudo chown root: /root/.nanorc
}
OHMYZSH(){

# Installation de OhmyZsh!
echo "===> OHMYZSH INSTALL"
sudo vpm i -y zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
exit
}
FIREWALL(){
echo "===> FIREWALL"
cd $WDIR/scripts/
./01-VOID-Firewall.sh
cd $WDIR
}
ADD(){
echo -e "BASEINSTALLADD"
sudo vpm i -y cifs-utils smbclient thunderbird birdtray minitube arduino zenmap vlc gimp blender ytmdl filelight
}

T420(){

echo "===> T420 addons"
sudo vpm i -y tlp tlp-rdw tp_smapi-dkms tpacpi-bat mesa-dri linux-firmware-intel vulkan-loader mesa-vulkan-intel intel-video-accel libva-intel-driver;
# sudo cp lenovo-mutemic.sh /etc/acpi/&&sudo chmod +x /etc/acpi/lenovo-mutemic.sh;
sudo vsv restart acpid;
}
X250(){

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

sudo vpm i -y linux-firmware-broadcom linux-firmware-intel linux-firmware-network intel-ucode mesa-dri mesa-vulkan-intel
sudo vpm i -y tp_smapi-dkms tpacpi-bat

}
I3INSTALLER(){
# configuration window manager i3
echo "===> i3"
cd $WDIR/scripts/
./08-VOID-i3.sh
cd $WDIR
}
VIRTUALBOX(){
echo "===> VIRTUALBOX INSTALL"

cd $WDIR/scripts/
./09-VOID-VirtualBox.sh
cd $WDIR
}
FLATPAK(){
echo "===> FLATPAK"
# installation via flatpak de Discord & Parsec
sudo vpm i -y flatpak 
echo "Flatpak : Création des repos si non existant"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo


echo "Flatpak : Installation Discord & Parsec"
flatpak install Discord Parsec org.freedesktop.Platform.GL.nvidia-470-74



}

# SOURIS & CLAVIER 
STEELSERIES(){
echo "===> STEELSERIES INSTALL"
cd $WDIR/scripts/
./07-VOID-rivalcfg.sh
cd $WDIR
}
CORSAIR(){
sudo vpm i -y ckb-next;
sudo ln -s /etc/sv/ckb-next-daemon /var/service;
sudo vsv enable ckb-next-daemon && sudo vsv start ckb-next-daemon;

}
# APPS GAMING
STEAM(){
echo -e "===> STEAM"
cd $WDIR/scripts/
./05-VOID-Steam
}
GOG(){
echo "===> GOG INSTALL"
cd $WDIR/scripts/
./06-VOID-GOG.sh
cd $WDIR
}
WINE(){
echo "===> WINE INSTALL"
cd $WDIR/scripts/
./10-VOID-Wine.sh
cd $WDIR
}
PROTONUP(){
# INSTALLATION DE PROTONUP
pip3 install protonup
REPERTOIRE="$HOME/.local/share/Steam/compatibilitytools.d/"
# Création du .profile pour prendre en compte le path de protonup
if [ ! -f $HOME/.profile ];then
echo "Création du .profile"
touch $HOME/.profile
echo 'if [ -d "$HOME/.local/bin" ] ; then' > $HOME/.profile
echo 'PATH="$HOME/.local/bin:$PATH"' >> $HOME/.profile
echo "fi" >> $HOME/.profile
echo 'Fichier .profile - Terminé !'
source $HOME/.profile
fi
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

# INSTALLATION GPU
INTEL(){
echo -e "==> INTELINSTALL"
sudo vpm i -y mesa mesa-dri mesa-vulkan-intel linux-firmware-broadcom linux-firmware-intel linux-firmware-network intel-ucode
}
AMD(){

echo "hey"
sudo vpm i -y mesa mesa-dri

}
NVIDIA(){

echo "===> nvidia INSTALL"
sudo vpm i -y mesa mesa-dri nvidia nvidia-libs-32bit

}
DEBROUILLETOI(){

BASE
FIREWALL
sudo vpm i -y $custombase | zenity --progress --auto-close --title "Void-Post-Installer : CUTOM INSTALL+" --text "Installation Automatique en cours ...\nVeuillez patienter s'il vous plait\nMerci de votre patience !"
$GPUCHOIX | zenity --progress --auto-close --title "Void-Post-Installer : GPU INSTALL+" --text "Installation Automatique en cours ...\nVeuillez patienter s'il vous plait\nMerci de votre patience !"
$customapp | zenity --progress --auto-close --title "Void-Post-Installer : CUTOM INSTALL+" --text "Installation Automatique en cours ...\nVeuillez patienter s'il vous plait\nMerci de votre patience !"

}

# MENU CUSTOM
MENUCUSTOMSTART(){

MENUCUSTOMBASE					# BASE INSTALL 
MENUSELECTGPU					# CHOIX GPU ( TEAM ROUGE VERT OU BLEU ?)
MENUCUSTOMAPPS					# CHOIX APPLIS
DEBROUILLETOI					# INSTALLATION CUSTOM
}

MENUCUSTOMBASE(){
echo -e "===> MENUCUSTOMBASE"
unset custombase
custombase=$(zenity --list --checklist --separator=" " --print-column 2 \
					--title="Void-Post-Installer : CUSTOM MODE" \
					--text="Custom install :" \
					--width=500 --height=600 \
					--column=" " --column="id" --column="Description :" \
					FALSE "thunderbird" "Le célèbre client de Messagerie Mail" \
					FALSE "birdtray" "Icone de notifications pour Thunderbird" \
					FALSE "vlc" "Lecteur Multimédia" \
					FALSE "minitube" "Player Youtube sans publicités" \
					FALSE "gimp" "Logiciel de modifications d'images" \
					FALSE "gnome-calculator" "Une calculatrice !!!" \
					FALSE "ytmdl" "Outil permettant de télécharger des playlists youtube" \
					FALSE "filelight" "Pour mieux voir l'espace prix sur vos disques durs" \
					FALSE "zenmap" "Outil de test de sécurité reseau - Pentest" \
					FALSE "arduino" "IDE de devellopement Arduino" \
					FALSE "blender" "Outil de conception 3D" \
					FALSE "cifs-utils" "Outil pour partage reseau microsoft" \
					FALSE "smbclient" "Outil pour partage reseau microsoft" \
					FALSE "neofetch" "Pour afficher le motd sur voidlinux" \
					FALSE "sc-controller" "Steam Controller Driver" \
					)
choix=$?
echo $choix
echo $custombase
case $choix in
  0)
  if [ ! -z $choix ];then
  BACK="MENUCUSTOMBASE" && SUITE="MENUCUSTOMAPPS";MENUSELECTGPU
  else
  zenity --warning "ERREUR" --text "Une erreur est survenue\n = $choix";
  MENUCUSTOMBASE
  fi
  ;;
  1)
  #REVENIR AU MENU PRINCIPAL
  exit
  ;;
  255)
  #REVENIR AU MENU PRINCIPAL
esac
}
MENUSELECTGPU(){
echo -e "===> MENUSELECTGPU"
echo -e "SUITE: $SUITE"
echo -e "RETOUR: $BACK"
unset GPUCHOIX
GPUCHOIX=$(zenity --list --radiolist --title="Void-Post-Installer : GPU" --text="\n\nChoissisez votre Team : Rouge, Vert ou Bleu ?" \
	   --width=500 --height=300 \
	   --column=" " --column="GPU - Marque" \
	   FALSE "AMD" \
	   TRUE "NVIDIA" \
	   FALSE "INTEL" \
	   )
echo $?
echo $GPUCHOIX
case $? in
   0)
   $SUITE
   ;;
   1)
   $BACK
   ;;
   255)
   exit
esac
}	
MENUCUSTOMAPPS(){
echo -e "===> MENUCUSTOMAPPS"

customapp=$(zenity --list --checklist --separator=" && " --print-column=2 \
			  --height=500 --width=700 \
			  --column=" " --column "ID" --column="Description" \
			  FALSE T420 "Optimisation pour lenovo T420 uniquement" \
			  FALSE X250 "Optimisation pour lenovo X250 uniquement" \
			  FALSE I3INSTALLER "Installation du gestionnaire de fenetre graphique i3" \
			  FALSE VIRTUALBOX "Gestionnaire de machines virtuelles" \
			  FALSE FLATPAK "Pour installer des logiciels compatible sur linux comme discord !!!" \
			  FALSE STEELSERIES "Reglages periphériques Steel Series (souris)" \
			  FALSE CORSAIR "Reglages périphériques Corsair (clavier/souris)" \
			  FALSE STEAM "Installation de Steam" \
			  FALSE GOG "Installation de Gog Galaxy (Minigalaxy)" \
			  FALSE WINE "Pouvoir installer des application windows sur voidlinux" \
			  FALSE PROTONUP "Version améliorée de Proton pour steam & wine" \ )
echo $?
echo $customapp
case $? in
   0)
   MENUSELECTGPU
   ;;
   1)
   
   ;;
   255)
   exit
esac
}

# MENU AUTO
MENUAUTOFULL(){

NET
SSHKEYTEST
ELOGIND
BASE
ADD
FIREWALL
NANORC
FLATPAK
I3INSTALLER
MENUSELECTGPU

# T420
# X250

# STEELSERIES
# CORSAIR

STEAM
GOG
WINE
PROTONUP
OHMYZSH
VIRTUALBOX
}
MENUAUTOLIGHT(){
echo -e "==> MENUAUTOLIGHT"
BACK="MENUSELECTGPU"
SUITE="OHMYZSH"

SSHKEYTEST
ELOGIND
BASE
FIREWALL
NANORC
MENUSELECTGPU
WINE
PROTONUP
OHMYZSH
sudo echo "Fin de AUTO-LIGHT"
}

# MENU INTRO
choix=$(zenity --list --title "VOID-ManageUSer" \
	   --text "Choix entre :\n\nAUTO-LIGHT\t\tInstallation minimale\n\nAUTO-FULL\t\t Installation complète\n\nCUSTOM\t\tParamètre d'installation personnalisé\n\t\t\t\t(supprime aussi le /HOME/USER !!!!)\n" \
	   --width 400 --height 350 \
	   --radiolist --column " " --column "Mode" \
	   TRUE AUTO-LIGHT \
	   FALSE AUTO-FULL \
	   FALSE CUSTOM )
case $? in		
  0)
  if [ $choix == "AUTO-LIGHT" ];then
  MENUAUTOLIGHT | zenity --progress --pulsate --auto-close --title "Void-Post-Installer : MODE AUTO-LIGHT" --text "Installation Automatique en cours ...\nVeuillez patienter s'il vous plait\nMerci de votre patience !"
  fi
  if [ $choix == "AUTO-FULL" ];then
  MENUAUTOFULL  | zenity --progress --pulsate --auto-close --title "Void-Post-Installer : MODE AUTO-FULL" --text "Installation Automatique en cours ...\nVeuillez patienter s'il vous plait\nMerci de votre patience !"
  fi
  if [ $choix == "CUSTOM" ];then
  MENUCUSTOMSTART
  fi
  ;;
  1)
  # QUITTER
  exit
  ;;
  255)
  # QUITTER
  exit
  echo $choix
esac
exit
