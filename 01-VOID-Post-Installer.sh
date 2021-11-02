#!/bin/bash
source ~/.config/user-dirs.dirs
# NAME : VOID_TofF-Installer.sh
# Ver  : 0.0.2
# Date : 16/11/2020 maj 30/10/2021

clear
echo -e "####################################"
echo -e "##				       			   ##"
echo -e "##		Void-PostInstall	       ##"
echo -e "##			V 0.0.2	     		   ##"
echo -e "##				       			   ##"
echo -e "####################################"

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

if [ ! -f $SSHDIR$PRIK ] || [ ! -f $SSHDIR$PUBK ];then
        echo "ssh-keygen -t ed25519"
        else
        echo "fichiers deja present"
fi
}
function ELOGIND(){
# Configuration clavier azerty pour
# se connecter à sa session.
sudo ./03-VOID-Login_AZERTY.sh
}
function BASEINSTALL(){
# MISE A JOUR DU SYSTEME (OBLIGATOIRE PREMIERE FOIS POUR DL)
sudo xbps-install -Syuv xbps;sudo xbps-install -Syuv;
# INSTALLATION VPM
sudo xbps-install -Syuv vpm vsv;
sudo vpm i -y void-repo-multilib void-repo-nonfree void-repo-multilib-nonfree
sudo vpm i -y git-all nano zsh curl wget cifs-utils python3-pip octoxbps notepadqq mc htop ytop tmux xarchiver xfburn flatpak unzip smbclient minitube arduino zenmap vlc gimp gparted blender pycp cdrtools socklog socklog-void ytmdl adwaita-qt qt5ct
sudo ln -s /etc/sv/socklog-unix /var/services;sudo ln -s /etc/sv/nanoklogd /var/services;
sudo ./02-VOID-Qt5ct.sh

# OPTI SYSTEME Void (On degage les trucs useless ou qui font conflit comme dhcpcd)
sudo vsv disable dhcpcd agetty-hvc0 agetty-hvsi0 agetty-tty2 agetty-tty3 agetty-tty4 agetty-tty5 agetty-tty6;
sudo rm /var/service/dhcpcd /var/service/agetty-hvc0 /var/service/agetty-hvsi0 /var/service/agetty-tty2 /var/service/agetty-tty3 /var/service/agetty-tty4 /var/service/agetty-tty5 /var/service/agetty-tty6;
# INSTALLATION Wallpaper
pycp wallpapers/* $XDG_PICTURES_DIR
}

function FLATPAK(){
# flatpak Discord & Parsec
echo "Flatpak : Création des repos si non existant"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
echo "Flatpak : Installation Discord & Parsec"
flatpak install Discord Parsec
}
function I3INSTALLER(){
echo "Installation Paquets pour le gestionnaire i3"
./08-VOID-i3.sh
}
function NANORC(){
# Configuration highlighting pour nano 
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
sudo ./02-VOID-Host_Modifier.sh
}

function T420(){
sudo vpm i -y tlp tlp-rdw tp_smapi-dkms tpacpi-bat mesa-dri linux-firmware-intel vulkan-loader mesa-vulkan-intel intel-video-accel libva-intel-driver;
sudo cp lenovo-mutemic.sh /etc/acpi/&&sudo chmod +x /etc/acpi/lenovo-mutemic.sh;
sudo vsv restart acpid;
}
function X250(){

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
sudo vpm i -y xfce4-pulseaudio-plugin nvidia
}

function STEAM(){
# Configuration installation Steam
./05-VOID-Steam.sh
}
function GOG(){
./06-VOID-GOG.sh
}
function STEELSERIES(){
./07-VOID-rivalcfg.sh
}
function VIRTUALBOX(){
echo "Installation Paquets pour VirtualBox"
./09-VOID-VirtualBox.sh
}

function OHMYZSH(){

# Installation de OhmyZsh!

sudo vpm i -y zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
exit
}

function MAIN(){

# La fonction principale qui envoie toutes les autres

clear
echo "Bonjour, Post Installation de Voidlinux by TofF en cours !"

function CLEAN(){

# Nettoyage avant redemarrage
rm -rfv $HOME/Void-Post-Install
sudo reboot
}

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

#A Declencher en dernier parce que sinon ça fait chier
OHMYZSH

echo "Travail terminé ! Reboot en cours"
}

MAIN
CLEAN

