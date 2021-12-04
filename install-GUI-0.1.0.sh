#!/bin/bash
# NAME : Void-Post-Installer
# LAUNCHER : install.sh
version=0.1.0
# Date : 16/11/2020 maj 04/12/2021
# by Tofdz
# assisted by :
#
# DrNeKoSan : crash test !
# Odile     : Les cafés !
# Celine    : Les petits pains !!


cmdspan1='<span color=\"$color">'
cmdspan2='</span>'
rouge="red\"
vert="green\"


PASS=$(zenity --password --title="Void-Post-Installer v$version")
echo $PASS|sudo -S xbps-install -Suyv zenity && clear
echo -e "####################################"
echo -e "##                                ##"
echo -e "##\tVoid-Post-Installer\t  ##"
echo -e "##\t\tV 0.0.9	 	  ##"
echo -e "##                                ##"
echo -e "####################################"

WDIR=$(pwd)
echo $WDIR
chmod +x $WDIR/scripts/*
source ~/.config/user-dirs.dirs
CUSTOMBASE=$(mktemp)
CUSTOMAPP="$HOME/Void-Post-Installer/CUSTOMAPP"
touch $CUSTOMAPP

function NET(){
echo -e "===> NET"
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
function SSHKEYTEST(){

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
sudo cp $HOME/.nanorc /root/.nanorc
sudo chown root: /root/.nanorc
}
function OHMYZSH(){

# Installation de OhmyZsh!
echo "===> OHMYZSH INSTALL"
sudo vpm i -y zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
exit
}
function FIREWALL(){
echo "rien"
}
function VPIAPPS(){

echo -e "===> VPIAPPS"
echo -e "Repertoire actuel : $(pwd)"
source $HOME/.config/user-dirs.dirs	

chmod +x $HOME/Void-Post-Installer/outils/APPS/*
if [ ! -d $HOME/.local/share/applications/PostInstall/Icons/ ] ; then
			echo -e "===> AppsVPI : "
			mkdir $HOME/.local/share/applications/PostInstall
			mkdir $HOME/.local/share/applications/PostInstall/Icons
			mkdir $HOME/.local/share/applications/PostInstall/APPS
			else
			echo -e"/!\/!\ ERREUR /!\/!\ Création répertoire impossible"
			
fi
echo "===> COPIE DES FICHIERS"
pycp $WDIR/outils/APPS/* $HOME/.local/share/applications/PostInstall
pycp $WDIR/outils/ICONS/* $HOME/.local/share/applications/PostInstall/Icons
pycp $WDIR/LAUNCHERS/* $HOME/.local/share/applications
pycp $WDIR/outils/LAUNCHERS/* $XDG_DESKTOP_DIR
}

function ADD(){
echo -e "BASEINSTALLADD"
sudo vpm i -y cifs-utils smbclient thunderbird birdtray minitube arduino zenmap vlc gimp blender ytmdl filelight
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
flatpak install Discord 
}
function PARSEC(){ 
echo "Flatpak : Installation Discord & Parsec"
flatpak install Parsec
}
function FLATNVID(){ 
echo "Flatpak : Installation Discord & Parsec"
flatpak install org.freedesktop.Platform.GL.nvidia-470-74
}

# SOURIS & CLAVIER 
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
# APPS GAMING
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
function INTEL(){
echo -e "==> INTELINSTALL"
sudo vpm i -y mesa mesa-dri mesa-vulkan-intel linux-firmware-broadcom linux-firmware-intel linux-firmware-network intel-ucode
}
function AMD(){

echo "hey"
sudo vpm i -y mesa mesa-dri

}
function NVIDIA(){

echo "===> nvidia INSTALL"
sudo vpm i -y mesa mesa-dri nvidia nvidia-libs-32bit
FLATNVID
}

function MENUFIN(){
zenity --info --title="Void-Post-Installer v$version : Installation terminée" \
				--text="Installée terminée !\nBonne journée !\nTofdz" 
}

function MENUCUSTOMBASE(){
BACK="MENUSELECTGPU"
SUITE="MENUCUSTOMAPPS"
echo -e "===> MENUCUSTOMBASE"

CUSTOMBASE=$(zenity --list --checklist --separator="\n" --print-column 2 \
					--title="Void-Post-Installer : CUSTOM MODE" \
					--text="Custom install :" \
					--width=620 --height=600 \
					--column=" " --column="id" --column="Description :" \
					TRUE "thunderbird" "Le célèbre client de Messagerie Mail" \
					TRUE "birdtray" "Icone de notifications pour Thunderbird" \
					FALSE "vlc" "Lecteur Multimédia" \
					FALSE "minitube" "Player Youtube sans publicités" \
					TRUE "gimp" "Logiciel de modifications d'images" \
					TRUE "gnome-calculator" "Une calculatrice !!!" \
					FALSE "ytmdl" "Outil permettant de télécharger des playlists youtube" \
					TRUE "filelight" "Pour mieux voir l'espace prix sur vos disques durs" \
					TRUE "zenmap" "Outil de test de sécurité reseau - Pentest" \
					FALSE "arduino" "IDE de devellopement Arduino" \
					FALSE "blender" "Outil de conception 3D" \
					TRUE "cifs-utils" "Outil pour partage reseau microsoft" \
					TRUE "smbclient" "Outil pour partage reseau microsoft" \
					FALSE "neofetch" "Pour afficher le motd sur voidlinux" \
					FALSE "sc-controller" "Steam Controller Driver" \
					)

echo $CUSTOMBASE
case $? in
  0)
  if [ ! -z $choix ];then
  MENUSELECTGPU
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
function MENUSELECTGPU(){
echo -e "===> MENUSELECTGPU"
echo -e "SUITE: $SUITE"
echo -e "RETOUR: $BACK"
unset GPUCHOIX
GPUCHOIX=$(zenity --list --radiolist\
				  --title="Void-Post-Installer : GPU" \
				  --text="\n\nChoissisez votre Team : Rouge, Vert ou Bleu ?" \
	   			  --width=500 --height=300 \
	    		  --column=" " --column="GPU - Marque" \
	   			  FALSE "AMD" \
	   			  TRUE "NVIDIA" \
	              FALSE "INTEL" \
	   			  )
echo $?
echo "===> MENUSELECTGPU: GPUCHOIX: $GPUCHOIX"
touch $HOME/Void-Post-Installer/GPUCHOIXTEMP;echo $GPUCHOIX > $HOME/Void-Post-Installer/GPUCHOIXTEMP
cat $HOME/Void-Post-Installer/GPUCHOIXTEMP

case $? in
   0)
   echo -e "==> GPU choix : $GPUCHOIX"
   $SUITE
   ;;
   1)
   $BACK
   ;;
   255)
   exit
esac
}	
function MENUCUSTOMAPPS(){
echo -e "===> MENUCUSTOMAPPS"
unset choix
choix=$(zenity --list --checklist --separator=" " --print-column=2 \
			  --height=500 --width=700 \
			  --column=" " --column="ID" --column="Description" \
			  TRUE VPIAPPS "Ensemble d'applis assez utile !" \
			  FALSE T420 "Optimisation pour lenovo T420 uniquement" \
			  FALSE X250 "Optimisation pour lenovo X250 uniquement" \
			  TRUE I3INSTALLER "Installation du gestionnaire de fenetre graphique i3" \
			  TRUE VIRTUALBOX "Gestionnaire de machines virtuelles" \
			  TRUE DISCORD "Célèbre plateforme de chat vocale" \
			  FALSE PARSEC "Gaming en streaming remote" \
			  FALSE STEELSERIES "Reglages periphériques Steel Series (souris)" \
			  FALSE CORSAIR "Reglages périphériques Corsair (clavier/souris)" \
			  TRUE STEAM "Installation de Steam" \
			  TRUE GOG "Installation de Gog Galaxy (Minigalaxy)" \
			  TRUE WINE "Pouvoir installer des application windows sur voidlinux" \
			  TRUE PROTONUP "Version améliorée de Proton pour steam & wine" \
			  TRUE OHMYZSH "Shell bien plus avancé que le terminal de base ;) à essayer !" \
			   )

# PREPARATION POUR L'INSTALL DE FLATPAK		


echo $choix > $HOME/Void-Post-Installer/CUSTOMAPP
echo -e "valeur $?"
echo -e "liste de CUSTOMAPP $CUSTOMAPPLIST"
case $? in
   0)
   if [ $(($(grep -c DISCORD $HOME/Void-Post-Installer/CUSTOMAPP)+$(grep -c PARSEC $HOME/Void-Post-Installer/CUSTOMAPP))) != 0 ] || [ $(grep -c NVIDIA $HOME/Void-Post-Installer/GPUCHOIXTEMP) != 0 ]; then
   echo -e "===> FLATPAK BASE-INSTALL"
   #FLATPAK
   fi
   DEBROUILLETOI
   ;;
   1)
   exit
   ;;
   255)
   exit
esac
}
function DEBROUILLETOI(){

echo -e "===CUSTOM-QUEUE===> BASE :";
BASE
sudo vpm i -y $CUSTOMBASE
echo -e "==> GPUCHOIX: $GPUCHOIX choix: $choix" 
if [ $(($(grep -c DISCORD $HOME/Void-Post-Installer/CUSTOMAPP)+$(grep -c PARSEC $HOME/Void-Post-Installer/CUSTOMAPP))) != 0 ]||[ $(grep -c NVIDIA $HOME/Void-Post-Installer/GPUCHOIXTEMP) != 0 ]; then
				echo -e "===> FLATPAK BASE-INSTALL"
				FLATPAK
fi
$GPUCHOIX;
# PARTIE MOULINETTE POUR CUSTOMAPP
# ET AUTANT DIRE QUE C'EST LA MERDE ...
touch $HOME/CUSTOMTEMP
echo -e "NEKONEKONEKO"
# MOULINETTE UTILITE INSTALLATION FLATPAK

# truc chiant
echo -e "===> MOULINETTE POUR LANCER LES FONCTIONS\nLES UNES APRES LES AUTRES AVEC UNE LISTE DYNAMIQUE"
cat $HOME/Void-Post-Installer/CUSTOMAPP
sed 's/ /\n/g' $HOME/Void-Post-Installer/CUSTOMAPP > $HOME/CUSTOMTEMP
cat $HOME/CUSTOMTEMP
while read -r paquets
do
custombaselist+=("$paquets")
done < $HOME/CUSTOMTEMP
echo -e ${#custombaselist[@]}
i=0 
compteur=$((${#custombaselist[@]}))
while (($compteur!=$i)); do
echo -e "==$i==> CUSTOMBASE INSTALLATION : ${custombaselist[$i]}"
${custombaselist[$i]}
i=$((i+1));
done

sudo rm $HOME/CUSTOMTEMP $HOME/Void-Post-Installer/CUSTOMAPP;
MENUFIN
}
# MENU AUTO
MENUAUTOFULL(){
echo -e "==FULL==> NET";NET
echo -e "==FULL==> SSHKEYTEST";SSHKEYTEST
echo -e "==FULL==> ELOGIND";ELOGIND
echo -e "==FULL==> BASE";BASE
echo -e "==FULL==> VPIAPPS";VPIAPPS
echo -e "==FULL==> ADD";ADD
#echo -e "==FULL==> FIREWALL";FIREWALL
echo -e "==FULL==> NANORC";NANORC
#echo -e "==FULL==> FLATPAK";FLATPAK
echo -e "==FULL==> I3INSTALLER";I3INSTALLER
echo -e "==FULL==> MENUSELECTGPU";MENUSELECTGPU
#echo -e "==FULL==> T420"; T420
#echo -e "==FULL==> X250"; X250
#echo -e "==FULL==> STEELSERIES"; STEELSERIES
#echo -e "==FULL==> CORSAIR"; CORSAIR
echo -e "==FULL==> STEAM";STEAM
echo -e "==FULL==> GOG";GOG
echo -e "==FULL==> WINE";WINE
echo -e "==FULL==> PROTONUP";PROTONUP
echo -e "==FULL==> OHMYZSH";OHMYZSH
echo -e "==FULL==> VIRTUALBOX";VIRTUALBOX
MENUFIN
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
MENUFIN
}

# MENU INTRO
MAIN(){
choix=$(zenity --list --radiolist --print-column 2 --title="Void-Post-Installer v$version" \
	           --column=" " --column="Mode" --column="Description" \
	   		   --text="\n\nChoississez votre mode d'installation" \
	   		   --width=1020 --height=240 \
	    	   FALSE AUTO-LIGHT "Installation minimale : Une configuration de void correcte, parfaite pour tester void en Machine virtuelle (NO GAMING)" \
	           TRUE AUTO-FULL "Installation complète : Une configuration de void pour ne plus revenir a windows. (GAMING INSIDE BRO)" \
	   		   FALSE CUSTOM "Custom Mode : Paramètres d'installation personnalisé pour choisir ses paquets"\
			   )
case $? in		
  0)
  if [ $choix == "AUTO-LIGHT" ];then
  echo -e "==MENU-AUTO-LIGHT==> "
  MENUAUTOLIGHT
  fi
  if [ $choix == "AUTO-FULL" ];then
  echo -e "==MENU-AUTO-FULL==> "
  MENUAUTOFULL
  fi
  if [ $choix == "CUSTOM" ];then 
  echo -e "==MENU-CUSTOM==> "
  MENUCUSTOMBASE
  fi
  ;;
  1)
  # QUITTER
  exit
  ;;
  255)
  # QUITTER
  exit
esac

}
MAIN
