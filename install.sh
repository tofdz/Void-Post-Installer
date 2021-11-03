#!/bin/bash
# NAME : Void-Post-Installer
# LAUNCHER : install.sh
# Ver  : 0.0.3
# Date : 16/11/2020 maj 02/11/2021

clear
echo -e "####################################"
echo -e "##				       			   ##"
echo -e "##		Void-PostInstall	       ##"
echo -e "##			V 0.0.3	     		   ##"
echo -e "##				       			   ##"
echo -e "####################################"


# On rend les scripts de l'installation executable automatiquement

declare -x WDIR=$(pwd)
echo $WDIR
chmod +x $WDIR/scripts/*
source ~/.config/user-dirs.dirs

function NET(){
echo "Fonction NET()"
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
echo "===> CHECK CLES SSH"
if [ ! -f $SSHDIR$PRIK ] || [ ! -f $SSHDIR$PUBK ];then
        echo "ssh-keygen -t ed25519"
        else
        echo "fichiers deja present"
fi
}
function ELOGIND(){

# Configuration clavier azerty pour
# se connecter à sa session.
echo "===> CONFIGURATION AZERTY AU LOGIN"
cd $WDIR/scripts/
sudo ./03-VOID-Login_AZERTY.sh
cd $WDIR
}
function BASEINSTALL(){

# MISE A JOUR DU SYSTEME (OBLIGATOIRE PREMIERE FOIS POUR DL)
echo "===> BASE INSTALL"
sudo xbps-install -Syuv xbps;sudo xbps-install -Syuv;
# INSTALLATION VPM
sudo xbps-install -Syuv vpm vsv;
sudo vpm i -y void-repo-multilib void-repo-nonfree void-repo-multilib-nonfree
sudo vpm i -y git-all nano zsh curl wget cifs-utils python3-pip octoxbps notepadqq mc htop ytop tmux xarchiver xfburn flatpak unzip smbclient minitube arduino zenmap vlc gimp gparted blender pycp cdrtools socklog socklog-void ytmdl adwaita-qt qt5ct
sudo vpm i -y thunderbird birdtray
sudo ln -s /etc/sv/socklog-unix /var/services;sudo ln -s /etc/sv/nanoklogd /var/services;
cd $WDIR/scripts/
sudo ./02-VOID-Qt5ct.sh
# OPTI SYSTEME Void (On degage les trucs useless ou qui font conflit comme dhcpcd)
sudo vsv disable dhcpcd agetty-hvc0 agetty-hvsi0 agetty-tty2 agetty-tty3 agetty-tty4 agetty-tty5 agetty-tty6;
sudo rm /var/service/dhcpcd /var/service/agetty-hvc0 /var/service/agetty-hvsi0 /var/service/agetty-tty2 /var/service/agetty-tty3 /var/service/agetty-tty4 /var/service/agetty-tty5 /var/service/agetty-tty6;
# INSTALLATION Wallpaper
pycp $WDIR/wallpapers/* $XDG_PICTURES_DIR
# Installation fonts SanFrancisco
echo "===> Fonts SanFrancisco"
cd $HOME
git clone https://github.com/supermarin/YosemiteSanFranciscoFont
if [ ! -d $HOME/.fonts ];then
	mkdir $HOME/.fonts/
	echo "Repertoire .fonts crée !"
fi
sudo pycp $HOME/YosemiteSanFranciscoFont/*.ttf $HOME/.fonts/
fc-cache -fv
echo "Suppression des Fichiers inutile"
rm -rfv $HOME/YosemiteSanFranciscoFont
}

function FLATPAK(){
echo "===> FLATPAK"
# installation via flatpak de Discord & Parsec
echo "Flatpak : Création des repos si non existant"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
echo "Flatpak : Installation Discord & Parsec"
flatpak install Discord Parsec org.freedesktop.Platform.GL.nvidia-470-74
}
function I3INSTALLER(){
# configuration window manager i3
echo echo "===> i3"
cd $WDIR/scripts/
./08-VOID-i3.sh
cd $WDIR
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
function HOSTS(){
# Configuration Reseau (adresse définie)
# Appel un script pour avoir les droits root en écriture sur
# le fichier /etc/hosts
cd $WDIR/scripts/
sudo ./02-VOID-Host_Modifier.sh
cd $WDIR
}

function T420(){

echo "===> T420 addons"
sudo vpm i -y tlp tlp-rdw tp_smapi-dkms tpacpi-bat mesa-dri linux-firmware-intel vulkan-loader mesa-vulkan-intel intel-video-accel libva-intel-driver;
# sudo cp lenovo-mutemic.sh /etc/acpi/&&sudo chmod +x /etc/acpi/lenovo-mutemic.sh;
sudo vsv restart acpid;
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

sudo vpm i -y linux-firmware-broadcom linux-firmware-intel linux-firmware-network intel-ucode mesa-dri mesa-vulkan-intel
sudo vpm i -y tp_smapi-dkms tpacpi-bat

}
function RTX(){
echo "===> nvidia INSTALL"
sudo vpm i -y xfce4-pulseaudio-plugin nvidia
}

function STEAM(){
# Configuration installation Steam
echo "===> STEAM INSTALL"
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
function STEELSERIES(){
echo "===> STEELSERIES INSTALL"
cd $WDIR/scripts/
./07-VOID-rivalcfg.sh
cd $WDIR
}
function VIRTUALBOX(){
echo "===> VIRTUALBOX INSTALL"

cd $WDIR/scripts/
./09-VOID-VirtualBox.sh
cd $WDIR
}

function OHMYZSH(){

# Installation de OhmyZsh!
echo "===> OHMYZSH INSTALL"
sudo vpm i -y zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
exit
}


function MAIN(){

# La fonction principale qui envoie toutes les autres

clear
echo "Bonjour, Post Installation de Voidlinux by TofF en cours !"

NET
SSHKEYTEST
ELOGIND
BASEINSTALL
FLATPAK
I3INSTALLER
NANORC
# Choisir suivant l'installation souhaitée
# T420
# X250
RTX
VIRTUALBOX
STEELSERIES
STEAM
#GOG

#A Declencher en dernier
OHMYZSH

echo "Travail terminé ! Reboot en cours"
}

MAIN
echo "Fin de l'installation - Merci et bonne journée sur VoidLinux"
