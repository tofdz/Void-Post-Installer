#!/bin/bash
# NAME : Void-Post-Installer
# LAUNCHER : install.sh

TITLE="Void Post Installer"
version="0.2.8"
# Date : 16/11/2020 maj 16/11/2022
# by Tofdz
# assisted by :
#
# DrNeKoSan : crash test !
# Odile     : Les cafés !
# Celine    : Les petits pains !!

WDIR=$(pwd)
chmod +x $WDIR/scripts/*
chmod +x $WDIR/outils/*
source ~/.config/user-dirs.dirs
KEY="12345"
res1=$(mktemp --tmpdir iface1.XXXXXXXX)
res2=$(mktemp --tmpdir iface1.XXXXXXXX)
res3=$(mktemp --tmpdir iface1.XXXXXXXX)
TMP01=$(mktemp --tmpdir iface1.XXXXXXXX)
TMP02=$(mktemp --tmpdir iface1.XXXXXXXX)
TMP03=$(mktemp --tmpdir iface1.XXXXXXXX)
TMP04=$(mktemp --tmpdir iface1.XXXXXXXX)

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
SSHDIR="$HOME/.ssh/"
PRIK="id_ed25519"
echo -e "[ SSH ] ==> CHECK CLES SSH"
if [ $(ls $SSHDIR|grep -c "$PRIK") != 2 ]; then
			# On ouvre une fenetre pour saisir la passphrase
			PASSPHRASE=$(yad --entry --width="800" --height="100" \
							--title="$TITLE $version" --text="Vous n'avez pas généré de clés SSH. Un mot de passe (passphrase) est demandé (sans = connexion auto)" \
							--entry-label="Votre passphrase SSH : " \
							--entry-text="")
			echo $PASSPHRASE
			valret=$?
			case $valret in
				0)
				# On génère la clé avec la passphrase
				echo "Passphrase : $PASSPHRASE"
				if [[ -z "$PASSPHRASE" ]]; then
						ssh-keygen -f $SSHDIR$PRIK -t ed25519 -N ""
				else
				ssh-keygen -f $SSHDIR$PRIK -t ed25519  -P $PASSPHRASE
				fi
				;;
				1)
				echo "EXIT"
				exit
				;;
				255)
				exit
				;;
			esac
	else
			echo -e "[ SSH ] ==> fichiers ssh deja present"
	fi
}
function BASE(){
# MISE A JOUR DU SYSTEME (OBLIGATOIRE PREMIERE FOIS POUR DL)
echo -e "===> BASE INSTALL"
sudo -S xbps-install -Syuv xbps
# INSTALLATION VPM
sudo -S xbps-install -Syuv vpm vsv void-repo-multilib void-repo-nonfree void-repo-multilib-nonfree linux5.15 linux5.15-headers;

# Kernel 
echo -e "===> BASE INSTALL : Kernel : Update"
echo "==> Kernel : Purge"
sudo -S vkpurge rm all
echo "==> Update Grub"
sudo -S update-grub

# DRIVERS CPU/GPU/BLUETOOTH/VIRTIO
echo -e "===> BASE INSTALL : CPU/GPU"

# CPU & GPU INSTALL
$cpuDETECT
$gpuDETECT

# BT & Virt INSTALL
BLUETOOTH
VIRTIONET

# Base Apps
sudo -S vpm i -y dracut-network dracut-uefi dracut-crypt-ssh xorg-server-devel xorg-server-devel-32bit git-all nano inxi zenity picom zsh curl wget python3-pip thunar-archive-plugin catfish testdisk octoxbps cpufrequtils notepadqq mc htop tmux xarchiver unzip p7zip-unrar xfburn pkg-config gparted pycp cdrtools socklog socklog-void adwaita-qt qt5ct xfce4-pulseaudio-plugin gnome-calculator;
sudo -S ln -s /etc/sv/socklog-unix /var/service; sudo -S ln -s /etc/sv/nanoklogd /var/service;

# OPTI SYSTEME Void (On degage les trucs useless ou qui font conflit comme dhcpcd)
sudo -S vsv disable dhcpcd agetty-hvc0 agetty-hvsi0 agetty-tty2 agetty-tty3 agetty-tty4 agetty-tty5 agetty-tty6;
sudo -S rm /var/service/dhcpcd /var/service/agetty-hvc0 /var/service/agetty-hvsi0 /var/service/agetty-tty2 /var/service/agetty-tty3 /var/service/agetty-tty4 /var/service/agetty-tty5 /var/service/agetty-tty6;

#========================================
# AJOUT DE L'AUTO UPDATER & CONFIGURATION
#========================================
sudo -S echo -e "===> BASE INSTALL : AUTO-UPDATER $voiduser"
if [ ! -d /var/service/snooze-daily ]; then
	if [ ! -d /etc/cron.daily ]; then
	sudo -S echo -e "Repertoire cron.daily absent : création en cours..."
	sudo -S mkdir /etc/cron.daily
	else
	sudo -S echo -e "Repertoire Cron.daily présent"
	fi
	sudo -S echo -e "Création service snooze-daily en cours ..."
	sudo -S ln -s /etc/sv/snooze-daily /var/service
else
	sudo -S echo -e "Service snooze-daily déjà présent"
fi
# Copie VOID-UPDATER dans .local/bin
sudo -S pycp $WDIR/outils/VOID-UPDATER.sh $HOME/.local/bin/;
if [ ! -d /etc/cron.hourly ]; then
	sudo -S echo -e "Dossier absent : création"
	sudo -S mkdir /etc/cron.hourly
else
	sudo -S echo -e "Dossier Présent"
fi
if [ ! -f /etc/cron.hourly/updater ]; then
	
	touch updater 
	echo -e '#!/bin/bash' > updater
	echo -e "cd /home/$voiduser/" >> updater
	echo -e 'exec ./VOID-UPDATER.sh' >> updater
	chmod +x /updater
	sudo -S chown root:root updater
	sudo -S mv updater /etc/cron.hourly/
else
	sudo -S echo -e "Fichier deja présent"
fi

# CONFIG PICOM
sudo -S pycp $WDIR/config/picom.conf $HOME/.config/
# INSTALLATION Wallpaper
sudo -S pycp -g $WDIR/wallpapers/* $XDG_PICTURES_DIR

# Installation fonts SanFrancisco
echo -e "===> Fonts SanFrancisco"
cd $HOME
git clone https://github.com/supermarin/YosemiteSanFranciscoFont
if [ ! -d $HOME/.fonts ];then
	sudo mkdir $HOME/.fonts/
	echo -e "Repertoire .fonts crée !"
fi
sudo -S pycp -g $HOME/YosemiteSanFranciscoFont/*.ttf $HOME/.fonts/
sudo -S fc-cache -fv
sudo -S echo -e "Suppression des Fichiers inutile"
rm -rfv $HOME/YosemiteSanFranciscoFont

# Attribue à l'utilisateur le group input (pour les manettes de jeu)
sudo -S usermod -a -G input $USER
echo "$(groups)"

sudo -S echo "===> 04A $HOME/$USER/.local/bin : Verification Dossier présent"
if [ ! -d $HOME/.local/bin ]; then
	mkdir $HOME/.local/bin
	sudo -S echo "Repertoire $HOME/.local/bin crée"
	else
	sudo -S echo "Repertoire $HOME/.local/bin déjà présent"
fi
#==================================
# THUNAR : Ajout fonction recherche
#==================================
echo "<?xml version="1.0" encoding="UTF-8"?>" > $HOME/.config/Thunar/uca.xml
echo "<actions>" >> $HOME/.config/Thunar/uca.xml
echo "<action>" >> $HOME/.config/Thunar/uca.xml
echo "	<icon>utilities-terminal</icon>" >> $HOME/.config/Thunar/uca.xml
echo "	<name>Ouvrir un terminal ici</name>" >> $HOME/.config/Thunar/uca.xml
echo "	<unique-id>1659223755776079-1</unique-id>" >> $HOME/.config/Thunar/uca.xml
echo "	<command>exo-open --working-directory %f --launch TerminalEmulator</command>" >> $HOME/.config/Thunar/uca.xml
echo "	<description>Exemple d’une action personnalisée</description>" >> $HOME/.config/Thunar/uca.xml
echo "	<patterns>*</patterns>" >> $HOME/.config/Thunar/uca.xml
echo "	<startup-notify/>" >> $HOME/.config/Thunar/uca.xml
echo "	<directories/>" >> $HOME/.config/Thunar/uca.xml
echo "</action>" >> $HOME/.config/Thunar/uca.xml
echo "<action>" >> $HOME/.config/Thunar/uca.xml
echo "	<icon>searching</icon>" >> $HOME/.config/Thunar/uca.xml
echo "	<name>Recherche</name>" >> $HOME/.config/Thunar/uca.xml
echo "	<unique-id>1663781577501216-1</unique-id>" >> $HOME/.config/Thunar/uca.xml
echo "	<command>/usr/bin/catfish --path=%f</command>" >> $HOME/.config/Thunar/uca.xml
echo "	<description>Effectuer une recherche</description>" >> $HOME/.config/Thunar/uca.xml
echo "	<patterns>*</patterns>" >> $HOME/.config/Thunar/uca.xml
echo "	<directories/>" >> $HOME/.config/Thunar/uca.xml
echo "	<text-files/>" >> $HOME/.config/Thunar/uca.xml
echo "</action>" >> $HOME/.config/Thunar/uca.xml
echo "</actions>" >> $HOME/.config/Thunar/uca.xml


cd $WDIR/scripts/
./00-VOID-SYS.sh
cd $WDIR
}

# SUPPORT BLUETOOTH & VIRTIONET
function BLUETOOTH(){
echo "==> BLUETOOTH CHECK INSTALL"
if [ $(echo $blueDETECT | grep -c "Present") != 0 ]; then
	echo "==> BLUETOOTH DETECTED"
	sudo -S vpm i -y bluez bluez-qt5 blueman
	sudo -S ln -s /etc/sv/bluetoothd/ /var/service/
	blueDETECT=$(sudo -S lsusb | grep "Bluetooth")
else
	echo "==> BLUETOOTH NOT DETECTED : SKIP PROCESS"
fi
}
function VIRTIONET(){

if [ $(echo $vmDETECT | grep -c "Present") != 0 ]; then
	echo "==> VM detectée : install VIRTIONET"
	echo "==> Virtio-net : Install"
		if [ ! -f /etc/modules-load.d/virtio.conf ];then
			sudo -S touch /etc/modules-load.d/virtio.conf
			sudo -S echo "# load virtio-net" > /etc/modules-load.d/virtio.conf
			sudo -S echo "virtio-net" >> /etc/modules-load.d/virtio.conf
			echo "==> Virtio-net : Fichier crée"
		else
			echo "==> Virtio-net : fichier déjà présent"
		fi
else
	echo "==> VIRTIO NOT DETECTED : SKIP PROCESS"
fi
}
# SUPPORT CPU & GPU
function INTELCPU(){
echo "===> CPU : INTEL INSTALL"
sudo vpm i -y intel-ucode linux-firmware-intel
}
function AMDCPU(){
echo "===> CPU : AMD INSTALL"
sudo vpm i -y linux-firmware-amd
}
function AMDGPU(){

echo "===> AMD INSTALL"
sudo vpm i -y mesa mesa-dri

}
function NVIDIA(){

echo "===> nvidia INSTALL"
sudo vpm i -y mesa mesa-dri mesa-vdpau mesa-vdpau-32bit mesa-opencl nvidia nvidia-libs-32bit nvidia-opencl nvtop
}
function INTELGPU(){
echo -e "==> INTELINSTALL"
sudo vpm i -y mesa mesa-dri mesa-vulkan-intel linux-firmware-broadcom linux-firmware-intel linux-firmware-network intel-ucode
}
# UTILITAIRES SOURIS/CLAVIER CORSAIR & SOURIS STEELSERIES
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
# OPTIMISATION FOR LENOVO LAPTOP
function T420(){

echo "===> T420 addons"
sudo vpm i -y tlp tlp-rdw tp_smapi-dkms tpacpi-bat mesa-dri linux-firmware-intel vulkan-loader mesa-vulkan-intel intel-video-accel libva-intel-driver
sudo chmod +x $HOME/Void-Post-Installer/lenovo/lenovo-mutemusic.sh;sudo pycp $HOME/Void-Post-Installer/lenovo/lenovo-mutemusic.sh /etc/acpi
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
sudo chmod +x $HOME/Void-Post-Installer/lenovo/lenovo-mutemusic.sh;sudo pycp $HOME/Void-Post-Installer/lenovo/lenovo-mutemusic.sh /etc/acpi
sudo vsv restart acpid;
sudo vpm i -y linux-firmware-broadcom linux-firmware-intel linux-firmware-network intel-ucode mesa-dri mesa-vulkan-intel
sudo vpm i -y tp_smapi-dkms tpacpi-bat

}

function FLATPAK(){
echo "===> FLATPAK"
# installation via flatpak de Discord & Parsec
sudo vpm i -y flatpak
echo "Flatpak : Création des repos si non existant"
flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}
function NANORC(){
# Configuration highlighting pour nano (met le code en couleur)
sudo -S echo "===> NANO HIGHLIGHTING"

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
	echo 'PASS=$(yad --entry --hide-text --text="VPI - gufw Launcher")' >> $HOME/.local/bin/gufw-launcher
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

chmod +x $WDIR/outils/*
pycp $WDIR/outils/ZenIso $HOME/.local/bin/

echo '[Desktop Entry]' > $XDG_DESKTOP_DIR/ZenIso.desktop
echo 'Version=1.0' >> $XDG_DESKTOP_DIR/ZenIso.desktop
echo 'Type=Application' >> $XDG_DESKTOP_DIR/ZenIso.desktop
echo 'Name=ZenIso' >> $XDG_DESKTOP_DIR/ZenIso.desktop
echo 'Exec=ZenIso' >> $XDG_DESKTOP_DIR/ZenIso.desktop
echo 'Icon=tools-media-optical-burn-image' >> $XDG_DESKTOP_DIR/ZenIso.desktop
echo 'Terminal=false' >> $XDG_DESKTOP_DIR/ZenIso.desktop
echo 'StartupNotify=false' >> $XDG_DESKTOP_DIR/ZenIso.desktop
echo 'Categories=System;' >> $XDG_DESKTOP_DIR/ZenIso.desktop

}
function I3INSTALLER(){
# configuration window manager i3
echo "===> i3"
cd $WDIR/scripts/
./08-VOID-i3.sh
cd $WDIR
}
function OHMYZSH(){

# Installation de OhmyZsh!
echo "===> OHMYZSH INSTALL"
sudo vpm i -y zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}
function ELOGIND(){

# Configuration clavier azerty pour
# se connecter à sa session.
echo -e "===> CONFIGURATION AZERTY AU LOGIN"
cd $WDIR/scripts/
sudo -S ./03-VOID-Login_AZERTY.sh
cd $WDIR
}

function TEAMVIEWER(){

# Installation TeamViewer
sudo -S echo "===> TeamViewer : Installation"

if [ ! -d $HOME/Applications ]; then
	sudo -S echo "Repertoire Application absent : création"
	mkdir $HOME/Applications
	else
	sudo -S echo "Repertoire Application Présent"
fi
cd $HOME/Applications
wget https://download.teamviewer.com/download/linux/teamviewer_amd64.tar.xz
tar vxf teamviewer_amd64.tar.xz
cd $HOME/Applications/teamviewer
./teamviewer;
pycp $HOME/Applications/teamviewer/teamviewer.desktop $HOME/.local/share/applications

}
function VMWAREWSPLY(){
echo "==> APPS : VMWare Workstation Player 16"
sudo -S vpm i -y libpcsclite pcsclite
sudo -S ln -s /etc/sv/pcscd /var/service
sudo vsv start pcscd
cd $HOME
mkdir VMWareInstall
cd VMWareInstall
wget https://download3.vmware.com/software/player/file/VMware-Player-16.0.0-16894299.x86_64.bundle?HashKey=d0d1117816424e5e5d9d2b1adb78361f&params=%7B%22sourcefilesize%22%3A%22160.60+MB%22%2C%22dlgcode%22%3A%22b1acfc7b4cdc5c976601b26eec4384a2%22%2C%22languagecode%22%3A%22fr%22%2C%22source%22%3A%22DOWNLOADS%22%2C%22downloadtype%22%3A%22manual%22%2C%22downloaduuid%22%3A%22601eda45-6233-4fbb-acbe-68b3f3eb841e%22%2C%22dlgtype%22%3A%22Product+Binaries%22%2C%22productversion%22%3A%2216.0.0%22%2C%22productfamily%22%3A%22VMware+Workstation+Player%22%7D&AuthKey=1648578131_4251ce7b8b701b45089c37195873cde6
chmod +x *
if [ ! -d /etc/init.d/ ];then
sudo mkdir /etc/init.d/
fi
sudo -S ./VMware-Player-16.0.0-16894299.x86_64.bundle
sudo -S sed -i 's/\(Exec=/usr/bin/vmware\).*/\Exec=vmware-launcher-player/' /usr/share/applications/vmware-player.desktop
cd $HOME/.local/bin/
touch vmware-launcher-player
echo "#!/bin/bash" > vmware-launcher-player
echo "sudo /etc/init.d/vmware start && sudo vmware-usbarbitrator" >> vmware-launcher-player
echo "vmplayer" >> vmware-launcher-player
pycp $WDIR/outils/vmware-registration $HOME/.local/bin
chmod +x $HOME/.local/bin/vmware-registration

}
function VMWAREWSPRO(){
echo "==> APPS : VMWare Workstation Pro 16"
sudo -S vpm i -y libpcsclite pcsclite
sudo -S ln -s /etc/sv/pcscd /var/service
sudo vsv start pcscd
cd $HOME
mkdir VMWareInstall
cd VMWareInstall
wget https://download3.vmware.com/software/WKST-1623-LX-New/VMware-Workstation-Full-16.2.3-19376536.x86_64.bundle
chmod +x *
if [ ! -d /etc/init.d/ ];then
sudo mkdir /etc/init.d/
fi
sudo -S ././VMware-Workstation-Full-16.2.3-19376536.x86_64.bundle
# EDITION DES RACCOURCIS DESKTOP
sudo -S sed -i 's/\(Exec=/usr/bin/vmware\).*/\Exec=vmware-launcher/' /usr/share/applications/vmware-workstation.desktop
sudo -S sed -i 's/\(Exec=/usr/bin/vmware\).*/\Exec=vmware-launcher-player/' /usr/share/applications/vmware-player.desktop
# CREATION DES LAUNCHERS DANS $HOME/.local/bin (path)
# Pour VMPlayer
cd $HOME/.local/bin/
touch vmware-launcher vmware-launcher-player
echo "#!/bin/bash" > vmware-launcher-player
echo "sudo /etc/init.d/vmware start && sudo vmware-usbarbitrator" >> vmware-launcher-player
echo "vmplayer" >> vmware-launcher-player
# Pour Workstation
echo "#!/bin/bash" > vmware-launcher
echo "sudo /etc/init.d/vmware start && sudo vmware-usbarbitrator" >> vmware-launcher
echo "vmware" >> vmware-launcher
# Outil d'enregistrement de license
pycp $WDIR/outils/vmware-registration $HOME/.local/bin
chmod +x $HOME/.local/bin/vmware-registration
cd $HOME && sudo -S rm -Rf VMWareInstall
}
function MENUVMWAREWS(){
vmwareSELECT=$(yad --title="VMWare WorkStation installation" \
			--width=400 --height=500 \
			--list --radiolist --separator="" --print-column="2" \
			--column="CHECK" --column="Version" --column="Description"\
			true "VMWAREWSPLY" "Install VMWare WorkStation Player 16"\
			false "VMWAREWSPRO" "Install VMWare WorkStation Pro FULL 16"\
			)
$vmwareSELECT
}
function VIRTUALBOX(){
echo "===> VIRTUALBOX INSTALL"

cd $WDIR/scripts/
./09-VOID-VirtualBox.sh
cd $WDIR
}
function DISCORD(){
sudo -S echo "===> Discord : Installation"
cd $HOME
if [ ! -d $HOME/Applications ];then
	mkdir $HOME/Applications
fi
if [ ! -d $HOME/Discord ];then
# Téléchargement & installation de Discord
	cd $HOME/Applications
	wget -O discord.tar.gz "https://discordapp.com/api/download?platform=linux&format=tar.gz"
	tar xfv discord.tar.gz; rm discord.tar.gz;
# Création raccourci pour le menu systeme
	echo "[Desktop Entry]" > $HOME/.local/share/applications/discord.desktop
	echo "Name=Discord" >> $HOME/.local/share/applications/discord.desktop
	echo "StartupWMClass=discord" >> $HOME/.local/share/applications/discord.desktop
	echo "Comment=All-in-one voice and text chat for gamers that's free, secure, and works on both your desktop and phone." >> $HOME/.local/share/applications/discord.desktop
	echo "GenericName=Internet Messenger" >> $HOME/.local/share/applications/discord.desktop
	echo "Exec=$HOME/Applications/Discord/Discord" >> $HOME/.local/share/applications/discord.desktop
	echo "Icon=discord" >> $HOME/.local/share/applications/discord.desktop
	echo "Type=Application" >> $HOME/.local/share/applications/discord.desktop
	echo "Categories=Network;InstantMessaging;" >> $HOME/.local/share/applications/discord.desktop
	echo "Path=$HOME/Applications/Discord" >> $HOME/.local/share/applications/discord.desktop
	echo "Terminal=false" >> $HOME/.local/share/applications/discord.desktop
	echo "StartupNotify=false" >> $HOME/.local/share/applications/discord.desktop
	else
	sudo -S echo "discord deja installé, supprimmez le dossier Discord pour relancer l'installation"
fi
}
function PICOM(){
echo "Picom : Installation"
# Nettoyage préalable
if [[ $(sudo -S vpm list|grep -c "picom") != 0 ]]; then
		sudo -S echo -e "ignorepkg=picom" > /etc/xbps.d/void.conf
		sudo -S vpm remove -y picom
		sudo -S rm /etc/xbps.d/void.conf
fi
if [[ $(sudo -S vpm list|grep -c "compton") != 0 ]]; then
		sudo -S echo -e "ignorepkg=compton" > /etc/xbps.d/void.conf
		sudo -S echo -e "ignorepkg=compton-conf" >> /etc/xbps.d/void.conf
		sudo -S vpm remove -y compton
		sudo -S rm /etc/xbps.d/void.conf
fi
# Installation Picom-ibhagwan
cd $HOME
git clone https://github.com/void-linux/void-packages
cd void-packages
core=$(cat /proc/cpuinfo | grep processor | wc -l)
echo "XBPS_ALLOW_RESTRICTED=yes" > $HOME/void-packages/etc/conf
echo "XBPS_CCACHE=yes" >> $HOME/void-packages/etc/conf
echo "XBPS_MAKEJOBS=$core" >> $HOME/void-packages/etc/conf
cd void-packages;
./xbps-src binary-bootstrap
git clone https://github.com/ibhagwan/picom-ibhagwan-template
mv picom-ibhagwan-template ./srcpkgs/picom-ibhagwan
./xbps-src pkg picom-ibhagwan
sudo -S xbps-install --repository=hostdir/binpkgs picom-ibhagwan
}
function PARSEC(){
echo "Flatpak : Installation Parsec"
flatpak install --user -y Parsec
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
function PROTONFLAT(){
# Installation ProtonGE pour Steam (steam flatpak version)

echo "==> Install Proton via Flatpak"
flatpak install --user com.valvesoftware.Steam.CompatibilityTool.Proton-GE
}

function AUTOINSTALL(){
echo -e "\033[33,40m==>   AUTOINSTALL\033[0m"
SSHKEYTEST
BASE
GUFW
NANORC
FLATPAK
STEAM
WINE
PROTONFLAT
OHMYZSH
sudo echo "Fin de AUTO-LIGHT"
MENUFIN
}
function CUSTOMINSTALL(){
echo -e "\033[33,40m==>   CUSTOMINSTALL\033[0m"
MENUPARSER
SSHKEYTEST
GUFW
BASE
NANORC
FLATPAK
XBPSLOADER
APPSLOADER
MENUFIN
}

function BANNER(){
ipcrm -M $KEY
softNAME="Void-Post-Installer"

PASS=$(yad --entry --hide-text --title="$TITLE $version" --text="Enter User Password")
echo $PASS|sudo -S clear;

echo -e "####################################"
echo -e "##"
echo -e "##\t\t$softNAME"
echo -e "##\t\tV $version"
echo -e "##"
echo -e "######"
}

function DETECT(){
# DETECTION CPU
cpuDETECT="No Detect"
cputemp=$(cat /proc/cpuinfo)
vmDETECT="No Detect"
if [ $(echo $cputemp | grep -c AMD) != 0 ]; then
		cpuDETECT="AMDCPU"
fi
if [ $(echo $cputemp | grep -c Intel) != 0 ]; then
		cpuDETECT="INTELCPU"
fi
# DETECTION GPU
if [ $(lspci | grep -c VGA) != 0 ]; then
		gputemp=$(lspci | grep VGA)
	if	[ $(echo $gputemp | grep -c  NVIDIA) != 0 ]; then
		gpuDETECT="NVIDIA"
	fi
	if	[ $(echo $gputemp | grep -c AMD) != 0 ]; then
		gpuDETECT="AMDGPU"
	fi
	if	[ $(echo $gputemp | grep -c Intel) != 0 ]; then
		gpuDETECT="INTELGPU"
	fi
fi
# DETECTION VM

if [ $(lspci | grep -c QEMU) != 0 ]; then
	vmDETECT="Present"
fi
# DETECTION BLUETOOTH
blueDETECT="No detect"
if [ $(lsusb | grep -c "Bluetooth") != 0 ]; then
	blueDETECT="Present"
fi


}
function MENUPARSER(){
echo -e "===> START : MENU-PARSER"
# ALIMENTE LES TABLEAU POUR INSTALL DE XBPS ET APPS
cat $res1 > $TMP01
cat $TMP01 | grep XBPS > $TMP02
cat $TMP02 | cut -d "|" -f3 > $TMP03
sed ':a;N;$!ba;s/\n/ /g' $TMP03 > $TMP04
unset customXBPS
while read -r dataXBPS
do
customXBPS+=$dataXBPS
done < $TMP04
cat $res3 | grep APPS > $TMP01
cat $TMP01 | cut -d "|" -f4 > $TMP02
sed 's/.*/& /' $TMP02 > $TMP03
cat $res2 > $TMP01
# BESOIN DE SUPPRIMER LES LIGNES VIDES SUR TMP01
sed '/^$/d' $TMP01 > $TMP02
# ON RAJOUTE LES FIX A LA LISTE DES APPS POUR LA CHARGER DANS LE TABLEAU EN MEME TEMPS
cat $TMP02 >> $TMP03
unset customAPP
while read -r dataAPP
do
customAPP+=("$dataAPP")
done < $TMP03

echo -e "customXBPS : ${customXBPS[@]}"
echo -e "customAPPS : ${customAPP[@]}"
rm $res1 $res2 $res3 $TMP01 $TMP02 $TMP03 $TMP04
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

function MENULANG(){
echo -e "\033[33,40m==>   MENULANG START\033[0m"
BANNER
vpiLANG=$(yad --title="$TITLE $version" --text="Choisissez votre langue :\n\nChoose your language :" \
	--list --width="450" --height="530" --separator="" \
	--column="LANGUAGE :IMG" --column="" --print-column="2" --hide-column="2" \
	$WDIR/icons/FR.png "FR" \
	$WDIR/icons/UK.png "UK" \
	)
valret=$?
echo $vpiLANG
case $valret in 
	0)
	MENU01START
	;;
	1)
	exit
	;;
	255)
	exit
	;;
esac
}
function MENU01START(){
echo -e "\033[33,40m==>   MENU01START\033[0m"
DETECT
source $WDIR/LANG/installer/$vpiLANG
menuCHOIX=$(yad --list --title="$TITLE $version" \
				--text="$vpiLANG\n$menu01START00\n\n==== AUTO DETECT ====\n\nCPU TYPE\t : \t$cpuDETECT\nGPU TYPE\t : \t$gpuDETECT\n\nBluetooth\t : \t$blueDETECT\nVirtio-net\t : \t$vmDETECT" \
				--width="530" --height="220" \
				--center --on-top --icon --icon-size=32 \
				--column="TYPE" --column="Description" --print-column="1" --separator="" \
				"MINIMAL" "$menu01START01" \
				"CUSTOM" "$menu01START02")
valret=$?
case $valret in 
	0)
	if [ $(echo $menuCHOIX|grep -c MINIMAL) != 0 ];then
			# on active le mode minimal (a coder)
			AUTOINSTALL | yad --title='Auto Installation' --window-icon=emblem-downloads --progress
	fi
	if [ $(echo $menuCHOIX|grep -c CUSTOM) != 0 ];then
			# on active le mode custom (a coder)
			MENU02CUSTOM
	fi
	;;
	1)
	exit
	;;
	255)
	exit
	;;
esac
}
function MENU02CUSTOM(){
echo -e "\033[33,40m==>   MENU02CUSTOM\033[0m"
yad --plug="$KEY" --tabnum="1" --form --image="abp.png" --text="\n\nBienvenue dans la post Installation de VoidLinux : \
					\n\nCette Post Installation permettra de finir de configurer correctement votre système \
					\nainsi qu'un paramètrage correct des fichiers de config de base. \
					\nDes modifications vont etre apportés à votre système pour y remedier. \
					\n\nSection XBPS : \
					\n\nListe de paquets installés via l'installateur fourni de base avec void (xbps), \
					\npour une base install bien fournie ! \
					\nUne selection par défaut est déja réalisée (les plus utilisés) \
					\n\nSection Fix : \
					\n\nDes correctifs en fonction des modèles, \
					\nun correctif qui empeche la detection d'un clavier azerty au login \
					\n\nSection APPS : \
					\n\nListe d'applications et leurs configuration pour une utilisation facile \
					\n\n\nINFO : \
					\n\n\nFaites votre selection et validez en cliquant sur le bouton OK \
					\net l'installation se deroulera automatiquement (Veuillez attendre le message de fin svp). \
					\n\nTofdz 2022" &\
yad --plug="$KEY" --tabnum="2" --checklist --list --text="XBPS : Liste des paquets xbps utile" --hide-column="2" \
		--column="CHECK" --column="XBPS" --column="PAQUET" --column="DESCRIPTION" \
		true "XBPS" "cifs-utils" "Outil pour connexion SMB" \
		true "XBPS" "smbclient" "Outil pour connexion SMB (suite)" \
		false "XBPS" "thunderbird" "Client pour les Mails" \
		false "XBPS" "birdtray" "Garder Thunderbird en icone dans la barre des taches" \
		true "XBPS" "gufw" "GUI pour le firewall" \
		false "XBPS" "zenmap" "Testeur de réseau" \
		true "XBPS" "vlc" "lecteur multimedia vlc" \
		false "XBPS" "gimp" "logiciel d'edition d'image" \
		false "XBPS" "blender" "logiciel de conception 3D" \
		false "XBPS" "ytmdl" "telechargez vos playlists youtube" \
		true "XBPS" "filelight" "Affichez les données de vos disques durs !" \
		true "XBPS" "lutris" "Jouez à vos jeu windows favoris préconfiguré pour linux." \
		true "XBPS" "CPU-X" "Affichez les informations CPU" \
		true "XBPS" "xfce4-plugins" "Suite de plugin pour personnaliser votre interface xfce" \
		true "XBPS" "xfce4-screenshooter" "Prendre des captures d'ecran" \
		true "XBPS" "deluge" "Telechargez vos torrent et magnet link" \
		true "XBPS" "caffeine-ng" "Gestion de l'écran de veille (interdire la veille par applications & bien plus)" &>$res1&\
yad --plug="$KEY" --tabnum="3" --form --text="FIX : Tous les correctifs dispo pour VoidLinux" --separator="\n" \
		--field="FIX - Lenovo Thinkpad :CB" "!T420!X250" \
		--field="FIX - AZERTY at login:CB" "!ELOGIND" &>$res2&\
yad --plug="$KEY" --tabnum="4" --checklist --list --text="APPS : Toutes les applications déjà configuré pour vous" --hide-column="3" \
		--column="CHECK" --column=" :IMG" --column="APPS" --column="PAQUET" --column="DESCRIPTION" \
		false "$WDIR/icons/I3wm-color-50.png" "APPS" "VPIAPPS" "Ensemble d'applis assez utile !" \
		false "$WDIR/icons/I3wm-color-50.png" "APPS" "I3INSTALLER" "Installation du gestionnaire de fenetre graphique i3" \
		true "$WDIR/icons/I3wm-color-50.png" "APPS" "PICOM" "Version de picom by ibhagwan" \
		false "$WDIR/icons/Virtualbox-50.png" "APPS" "VIRTUALBOX" "Gestionnaire de machines virtuelles" \
		true "$WDIR/icons/teamviewer_48.png" "APPS" "TEAMVIEWER" "TeamViewer" \
		false "$WDIR/icons/VMWare-Workstation-50.png" "APPS" "MENUVMWAREWS" "VMWARE Workstation Pro / Player 16" \
		false "$WDIR/icons/Parsec-50.png" "APPS" "PARSEC" "Gaming en streaming remote" \
		false "$WDIR/icons/steelseries-light-50.png" "APPS" "STEELSERIES" "Reglages periphériques Steel Series (souris)" \
		false "$WDIR/icons/Corsair-light-50.png" "APPS" "CORSAIR" "Reglages périphériques Corsair (clavier/souris)" \
		false "$WDIR/icons/Gog-light-50.png" "APPS" "GOG" "Installation de Gog Galaxy (Minigalaxy)" \
		true "$WDIR/icons/Wine-50.png" "APPS" "WINE" "Pouvoir installer des applications windows sur voidlinux" \
		true "$WDIR/icons/Steam-color-50.png" "APPS" "STEAM" "Installation de Steam" \
		true "$WDIR/icons/Steam-color-50.png" "APPS" "PROTONFLAT" "Version flatpak de Proton-GE pour steam flatpak" \
		true "$WDIR/icons/Discord-light-50.png" "APPS" "DISCORD" "Célèbre plateforme de chat vocale" \
		true "$WDIR/icons/ohmyzsh-50.png" "APPS" "OHMYZSH" "Shell bien plus avancé que le terminal de base ;) à essayer !" &>$res3&\
yad --notebook --key="$KEY" --title="$TITLE" --image="abp.png" --text="$TITLE" \
		--height="960" --width="780" --separator="|" \
		--tab="Acceuil" --tab="XBPS" --tab="Fix" --tab="APPS" \
		--button="Exit:1" --button="OK:0"
ret=$?
case $ret in
	0)
	echo "Bouton OK"
	CUSTOMINSTALL
	;;
	1)
	pkill yad
	exit
	;;
	255)
	pkill yad
	exit
	;;
esac
}
function MENUFIN(){

echo -e "[ FIN ]==> Installation terminée"

yad --info --title="$TITLE v$version : Installation terminée" \
	--text="Installation terminée !\n\nBonne journée !\n\nTofdz"
valret=$?
case $valret in
	0)
	pkill yad
	exit
	;;
	255)
	exit
	;;
esac
}

MENULANG
