#!/bin/bash
# NAME : Void-Post-Installer
# Date : 16/11/2020 maj 26/10/2023
# by Tofdz
# assisted by :
# DrNeKoSan : crash test !
# Odile     : Les cafés !
# Celine    : Les petits pains !!

TITLE="Void Post Installer"
version="0.3.5"
voiduser=$USER
WDIR=$(pwd)
scripts="$WDIR/data/install"
outils="$WDIR/data/outils"
config="$WDIR/data/config"
icons="$WDIR/data/icons"
dirapp="$HOME/.local/bin"
shareapp="$HOME/.local/share/applications"
chmod +x $scripts/*
chmod +x $outils/*
source ~/.config/user-dirs.dirs
KEY="12345"
res1=$(mktemp --tmpdir iface1.XXXXXXXX)
res2=$(mktemp --tmpdir iface1.XXXXXXXX)
res3=$(mktemp --tmpdir iface1.XXXXXXXX)
TMP01=$(mktemp --tmpdir iface1.XXXXXXXX)
TMP02=$(mktemp --tmpdir iface1.XXXXXXXX)
TMP03=$(mktemp --tmpdir iface1.XXXXXXXX)
TMP04=$(mktemp --tmpdir iface1.XXXXXXXX)

# Menu Color

colROUGE='\e[1;31m'
colVERT='\e[1;32m'
colJAUNE='\e[1;33m'
colBLEU='\e[1;34m'
colDEFAULT='\e[0;37m'

function NET(){
sudo -S echo -e "$colJAUNE\n[NET] == Test connexion internet ==\n$colDEFAULT"
ip[0]=8.8.8.8
ip[1]=1.1.1.1
i=0
while ((${#ip[*]}!=$i)) ; do
	ping -c1 -q ${ip[$i]};ipR[$i]=${?};
	i=$((i+1));
done
i=0
while ((${#ip[*]}!=$i)) ; do
	if [ ${ipR[$i]} -eq 0 ];then
	sudo -S echo -e "$colVERT[NET] ${ip[$i]} est ONLINE $colDEFAULT"
	else
	sudo -S echo -e "$colROUGE[NET] ${ip[$i]} est OFFLINE : Pas d'accès internet, veuillez vous connecter $colFEDAULT"
	exit
	fi
	i=$((i+1));
done
sudo -S echo -e "$colVERT\n[NET] == Connexion internet success ==\n$colDEFAULT"
}

function BASE(){
# MISE A JOUR DU SYSTEME (OBLIGATOIRE PREMIERE FOIS POUR DL)
sudo -S echo -e "$colJAUNE\n[BASE] == BASE INSTALL ==\n$colDEFAULT"
sudo -S xbps-install -Syuv xbps; sudo -S xbps-install -Suyv;
# INSTALLATION VPM
sudo -S xbps-install -Syuv vpm vsv void-repo-multilib void-repo-nonfree void-repo-multilib-nonfree;
# CLEANALL
SYS
# DRIVERS CPU/GPU/BLUETOOTH/VIRTIO
sudo -S echo -e "$colJAUNE\n[BASE] == BASE INSTALL : CPU/GPU ==\n$colDEFAULT"

# CPU & GPU INSTALL
$cpuDETECT
$gpuDETECT

# BT & Virt INSTALL
BLUETOOTH
VIRTIONET

# Kernel 
sudo -S echo -e "$colJAUNE\n[BASE] == BASE INSTALL : Kernel ==\n$colDEFAULT"
sudo -S echo -e "$colJAUNE\n[BASE] == Kernel : Purge ==\n$colDEFAULT"
sudo -S vkpurge rm all
sudo -S echo -e "$colJAUNE\n[BASE] == Update Grub ==\n$colDEFAULT"
sudo -S update-grub

# OPTI SYSTEME Void (On degage les trucs useless ou qui font conflit comme dhcpcd)
sudo -S vsv disable dhcpcd agetty-hvc0 agetty-hvsi0 agetty-tty2 agetty-tty3 agetty-tty4 agetty-tty5 agetty-tty6;
sudo -S rm /var/service/dhcpcd /var/service/agetty-hvc0 /var/service/agetty-hvsi0 /var/service/agetty-tty2 /var/service/agetty-tty3 /var/service/agetty-tty4 /var/service/agetty-tty5 /var/service/agetty-tty6;

# Base Apps
sudo -S echo -e "$colJAUNE\n[BASE] == Firmware & co ==\n $colDEFAULT"
sudo -S xbps-install -y linux-lts linux-lts-headers linux-firmware linux-firmware-broadcom linux-firmware-network dracut-network 
sudo -S echo -e "$colJAUNE\n[BASE] == Minimum Apps ==\n $colDEFAULT"
sudo -S xbps-install -y nano notepadqq mc htop tmux gparted cdrtools socklog socklog-void zenity curl wget python3-pip inxi pycp;
sudo -S echo -e "$colJAUNE\n[BASE] == Xfce addons ==\n $colDEFAULT"
sudo -S xbps-install -y xorg-server-devel snooze thunar-archive-plugin catfish octoxbps pkg-config adwaita-qt qt5ct xfce4-pulseaudio-plugin gnome-calculator gnome-disk-utility;
sudo -S echo -e "$colJAUNE\n[BASE] == Apps with utility ==\n $colDEFAULT"
sudo -S xbps-install -y testdisk cpufrequtils xarchiver unzip p7zip xfburn;

# LOG : Mise en place service
sudo -S echo -e "$colJAUNE\n[BASE] == Démarrage service log ==\n $colDEFAULT"
sudo -S ln -s /etc/sv/socklog-unix /var/service; sudo -S ln -s /etc/sv/nanoklogd /var/service;
if [ -d "/var/service/socklog-unix" ]; then
	sudo -S echo -e "$colVERT[BASE] == Service log démarré ==\n$colDEFAULT"
	else
	sudo -S echo -e "$colROUGE[BASE] == Service log absent - Erreur ==\n$colDEFAULT"
fi

#========================================
# AJOUT DE L'AUTO UPDATER & CONFIGURATION
#========================================
sudo -S echo -e "$colJAUNE\n[BASE] == AUTO-UPDATER $voiduser ==\n$colDEFAULT"
if [ ! -d /var/service/snooze-daily ]; then
	if [ ! -d /etc/cron.daily ]; then
	sudo -S echo -e "$colJAUNE\n[BASE] == Repertoire cron.daily absent : création en cours... ==\n $colDEFAULT"
	sudo -S mkdir /etc/cron.daily;
		if [ -d "/etc/cron.daily" ]; 
		then
		sudo -S echo -e "$colVERT\n[BASE] == Repertoire cron.daily présent ==\n $colDEFAULT"
		else
		sudo -S echo -e "$colROUGE\n[BASE] == Repertoire cron.daily absent : Erreur ==\n $colDEFAULT"
		fi
	else
	sudo -S echo -e "$colVERT\n[BASE] == Repertoire Cron.daily présent ==\n $colDEFAULT"
	fi
	sudo -S echo -e "$colJAUNE\n[BASE] == Activation Service snooze-daily en cours ... ==\n $colDEFAULT"
	sudo -S ln -s /etc/sv/snooze-daily /var/service
		if [ -d "/var/service/snooze-daily" ]; then
		sudo -S echo -e "$colVERT\n[BASE] == Service snooze-daily présent ==\n $colDEFAULT"
		else
		sudo -S echo -e "$colROUGE\n[BASE] == Service snooze-daily absent : Erreur ==\n $colDEFAULT"
		fi
else
	sudo -S echo -e "$colVERT\n[BASE] == Service snooze-daily déjà présent ==\n $colDEFAULT"
fi
# Copie VOID-UPDATER dans .local/bin
if [ ! -d "$dirapp" ]; then
	mkdir $dirapp
	if [ -d "$dirapp" ]; then
	sudo -S echo -e "$colVERT\n[BASE] == Répertoire $dirapp créé ==\n $colDEFAULT"
	else
	sudo -S echo -e "$colROUGE\n[BASE] == Répertoire $dirapp absent - Erreur ==\n $colDEFAULT"
	fi
fi
sudo -S echo -e "$colJAUNE\n[BASE] == VPI-UPDATER installation ==\n $colDEFAULT"
pycp $outils/VPI-UPDATER $dirapp;
if [ -f "$dirapp/VPI-UPDATER" ]; then
	sudo -S echo -e "$colVERT\n[BASE] == VPI-UPDATER installé ==\n $colDEFAULT"
else
	sudo -S echo -e "$colROUGE\n[BASE] == VPI-UPDATER absent - Erreur ==\n $colDEFAULT"
fi
if [ ! -d /etc/cron.hourly ]; then
	sudo -S echo -e "Dossier absent : création"
	sudo -S mkdir /etc/cron.hourly
else
	sudo -S echo -e "Dossier Présent"
fi
if [ ! -f /etc/cron.hourly/updater ]; then
	
	sudo -S touch updater 
	echo -e '#!/bin/bash' | sudo -S tee /etc/cron.hourly/updater
	echo -e "cd $dirapp" | sudo -S tee -a /etc/cron.hourly/updater
	echo -e 'exec ./VPI-UPDATER' | sudo -S tee -a /etc/cron.hourly/updater
	sudo -S chmod +x /etc/cron.hourly/updater
	sudo -S chown root:root /etc/cron.hourly/updater
	sudo -S ln -s /etc/sv/snooze-hourly /var/service
else
	sudo -S echo -e "Fichier deja présent"
fi


# Attribue à l'utilisateur le group input (pour les manettes de jeu)
sudo -S echo -e "## Ajout de $voiduser au groupe Input"
sudo -S usermod -a -G input $voiduser
sudo -S echo -e "==> Liste des groupes :\n$(groups)"

# Création dossier .local/bin si absent (en cas de fresh install)
sudo -S echo "===> 04A $dirapp : Verification Dossier présent"
if [ ! -d $dirapp ]; then
	mkdir $dirapp
	sudo -S echo "Repertoire $dirapp crée"
	else
	sudo -S echo "Repertoire $dirapp déjà présent"
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
cd $WDIR
}

function THEME(){
sudo -S echo -e "$colJAUNE\n[THEME] == Installation Theme VPI ==\n$colDEFAULT"
# Patch pour désactiver sauvegarde session
if [ -d "$HOME/.cache/sessions/" ]; then
	rm -rfv $HOME/.cache/sessions/
	chmod -w $HOME/.cache/sessions/
fi
# Installation Theme Qogir
cd $HOME
sudo -S echo -e "$colJAUNE\n[THEME] == Installation Qogir ==\n$colDEFAULT"
git clone https://github.com/vinceliuice/Qogir-theme; cd Qogir-theme; sh -c "$(exec ./install.sh)";
rm -rfv Qogir-theme

# INSTALLATION Wallpaper
sudo -S echo -e "$colJAUNE\n[THEME] == Installation Wallpaper ==\n$colDEFAULT"
sudo -S pycp -g $WDIR/data/wallpapers/* /usr/share/backgrounds/xfce/

# Installation fonts SanFrancisco
sudo -S echo -e "$colJAUNE\n[THEME] == Installation font SanFrancisco ==\n$colDEFAULT"
cd $HOME
git clone https://github.com/supermarin/YosemiteSanFranciscoFont
if [ ! -d $HOME/.fonts ];then
	sudo mkdir $HOME/.fonts/
	sudo -S echo -e "Repertoire .fonts crée !"
fi
sudo -S pycp -g $HOME/YosemiteSanFranciscoFont/*.ttf $HOME/.fonts/
sudo -S fc-cache -fv
sudo -S echo -e "Suppression des Fichiers inutile"
rm -rfv $HOME/YosemiteSanFranciscoFont
sudo -S echo -e "$colJAUNE\n[THEME] == Backup xfce4-panel.xml ==\n$colDEFAULT"
rm -rf $HOME/.cache/sessions/; chmod -w $HOME/.cache/sessions/;
# Backup ancien theme dans $HOME/.config/xfce4-BAK
if [ ! -d "$XDG_DOCUMENTS_DIR/xfce4-BAK" ]; then
sudo -S echo -e "$colJAUNE\n[THEME] == Backup xfce4 dans $XDG_DOCUMENTS_DIR/xfce4-BAK/ ==\n$colDEFAULT"
mkdir $XDG_DOCUMENTS_DIR/xfce4-BAK
pycp $HOME/.config/xfce4/* $XDG_DOCUMENTS_DIR/xfce4-BAK
pycp -g $HOME/.config/xfce4/panel/* $XDG_DOCUMENTS_DIR/xfce4-BAK
fi
# Préparation pour dotFiles pour XFCE4
sudo -S echo -e "$colJAUNE\n[THEME] == Préparation xfce4 ==\n$colDEFAULT"
killall xfce4-panel;
rm -rfv $HOME/.config/xfce4/panel/*;
rm -rfv $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml;
# Installation dotFiles pour XFCE4
sudo -S echo -e "$colJAUNE\n[THEME] == Installation dotfiles xfce4 ==\n$colDEFAULT"
pycp -f $config/xfce4/* $HOME/.config/xfce4/

}
function SYS(){
VER1=$(cat /etc/sysctl.conf|grep vm.max_map_count=1048576)
VER2=$(cat /etc/sysctl.conf|grep "abi.vsyscall32 = 0")
VER4=$(cat /etc/security/limits.conf|grep '1048576')
VER5=$(cat /etc/environment|grep -c 'qt5ct')
sudo -S echo -e "==> 00 Void : System modifications"

#CLEANER
sudo -S echo "===> BASE CLEANING - PLEASE WAIT !"

echo "ignorepkg=linux-firmware-amd" | sudo -S tee /etc/xbps.d/Base_Install.conf
echo "ignorepkg=linux-firmware-intel" | sudo -S tee -a /etc/xbps.d/Base_Install.conf
echo "ignorepkg=linux-firmware-nvidia" | sudo -S tee -a /etc/xbps.d/Base_Install.conf
echo "ignorepkg=xf86-video-amdgpu" | sudo -S tee -a /etc/xbps.d/Base_Install.conf
echo "ignorepkg=xf86-video-ati" | sudo -S tee -a /etc/xbps.d/Base_Install.conf
echo "ignorepkg=xf86-video-dummy" | sudo -S tee -a /etc/xbps.d/Base_Install.conf
echo "ignorepkg=xf86-video-fbdev" | sudo -S tee -a /etc/xbps.d/Base_Install.conf
echo "ignorepkg=xf86-video-intel" | sudo -S tee -a /etc/xbps.d/Base_Install.conf
echo "ignorepkg=xf86-video-nouveau" | sudo -S tee -a /etc/xbps.d/Base_Install.conf
echo "ignorepkg=xf86-video-vesa" | sudo -S tee -a /etc/xbps.d/Base_Install.conf
echo "ignorepkg=xf86-video-vmware" | sudo -S tee -a /etc/xbps.d/Base_Install.conf
cd /etc/xbps.d/
sudo -S chown root:root Base_Install.conf;
sudo -S vpm remove -y linux-firmware-amd linux-firmware-intel linux-firmware-nvidia xf86-video-amdgpu xf86-video-ati xf86-video-dummy xf86-video-fbdev xf86-video-intel xf86-video-nouveau xf86-video-vesa xf86-video-vmware 
sudo -S echo -e "$colJAUNE\n[BASE] == Suppression Base_Install.conf ==\n$colDEFAULT"
sudo -S rm Base_Install.conf
sudo -S echo -e "$colJAUNE\n[BASE] == NETTOYAGE PAQUETS & CACHE ==\n$colDEFAULT"
sudo -S xbps-remove -v -o --yes; sudo -S xbps-remove -v -O --yes;
# Verification /etc/sysctl.conf
sudo -S echo -e "==> Vérification /etc/sysctl.conf : $VER1"
if [ -e $VER1 ]; then
	echo "==!> Modification /etc/sysclt absente : modification en cours"
	echo "vm.max_map_count=1048576" | sudo -S tee -a /etc/sysctl.conf
	echo "==> Vérification /etc/sysctl.conf : $VER1"
	else
	echo "==> Fichier /etc/sysctl.conf : déjà modifié"
fi

sudo -S echo "===> 03 /etc/sysctl.conf : abi.vsyscall32 = 0"
if [ -e $VER2 ]; then
	sudo -S echo "Modification /etc/sysclt absente : modification en cours"
	echo "abi.vsyscall32 = 0" | sudo -S tee -a /etc/sysctl.conf
	sudo -S echo "Vérification /etc/sysctl.conf : $VER2"
	else
	sudo -S echo "Fichier /etc/sysctl.conf : déjà modifié"
fi

# Verification limits.conf
sudo -S echo "===> 04 /etc/security/limits.conf pour $voiduser"
if [ -e $VER4 ]; then
	sudo -S echo "==> Modification /etc/security/limits.conf"
	echo "$voiduser           -       nice            -20" | sudo -S tee -a /etc/security/limits.conf
	echo "$voiduser           -       nofile          1048576" | sudo -S tee -a /etc/security/limits.conf
else
	sudo -S echo "==> /etc/security/limits.conf déjà modifié"
fi

# Modification /etc/environment
if [ -e $VER5 ]; then
sudo -S echo "==> Modification /etc/environment QT_QPA_PLATEFORMTHEME=qt5ct"
echo 'export QT_QPA_PLATFORMTHEME=qt5ct' | sudo -S tee -a /etc/environment
else
sudo -S echo "PASS ==> /etc/environment déjà modifié"
fi

#==============================
# PATH : $HOME/$USER/.local/bin
#==============================
echo "===> $HOME/.local/bin : Modification fichiers"
if [ -e $(cat /etc/profile|grep "/.local/bin") ]; then
	sudo -S echo "==> /etc/profile : Modification en cours ..."
	echo 'if [ -d "$HOME/.local/bin" ]; then' | sudo -S tee -a /etc/profile
	echo 'PATH=$HOME/.local/bin:$PATH' | sudo -S tee -a /etc/profile
	echo 'fi' | sudo -S tee -a /etc/profile
	echo 'if [ -d /var/lib/flatpak/exports/share ]; then' | sudo -S tee -a /etc/profile
	echo 'PATH=/var/lib/flatpak/exports/share:$PATH' | sudo -S tee -a /etc/profile
	echo 'fi' | sudo -S tee -a /etc/profile
	echo 'if [ -d $HOME/.local/share/flatpak/exports/share ]; then' | sudo -S tee -a /etc/profile
	echo 'PATH=$HOME/.local/share/flatpak/exports/share:$PATH' | sudo -S tee -a /etc/profile
	echo 'fi' | sudo -S tee -a /etc/profile
	sudo -S echo -e "Fichier profile - Terminé !"
else
	sudo -S echo -e "==> /etc/profile : Fichier /etc/profile déjà modifié : "
	sudo -S echo -e "==> /etc/profile : TERMINE"
fi
}
function SSHKEYTEST(){
SSHDIR="$HOME/.ssh/"
PRIK="id_ed25519"
sudo -S echo -e "$colJAUNE\n[SSH] == START ==\n$colDEFAULT"
sudo -S echo -e "$colJAUNE\n[SSH] == CHECK CLES SSH ==\n$colDEFAULT"
if [ $(ls $SSHDIR|grep -c "$PRIK") != 2 ]; then
			# On ouvre une fenetre pour saisir la passphrase
			PASSPHRASE=$(yad --entry --width="800" --height="100" \
							--title="$TITLE $version" --text="Vous n'avez pas généré de clés SSH. Un mot de passe (passphrase) est demandé (sans = connexion auto)" \
							--entry-label="Votre passphrase SSH : " \
							--entry-text="")
			valret=$?
			case $valret in
				0)
				# On génère la clé avec la passphrase
				if [[ -z "$PASSPHRASE" ]]; then
					ssh-keygen -f $SSHDIR$PRIK -t ed25519 -N ""
					ssh-add id_ed25519
				else
					ssh-keygen -f $SSHDIR$PRIK -t ed25519  -P $PASSPHRASE
					ssh-add id_ed25519
				fi
				;;
				1)
				sudo -S echo -e "$colROUGE\n[SSH] == EXIT ==\n$colDEFAULT"
				exit
				;;
				252)
				exit
				;;
			esac
	else
			sudo -S echo -e "$colVERT\n[SSH] == Fichiers ssh déjà présent ==\n$colDEFAULT"
	fi
### Installation des clés dans la configuration
## Config SSH

# BACKUP CONFIG FILE
sudo -S echo -e "$colJAUNE\n[SSHD] == Modification /etc/ssh/sshd_config ==\n$colDEFAULT"
if [ ! -f /etc/ssh/sshd_config.sav ]; then
	sudo -S echo -e "$colJAUNE\n[SSHD] == Backup en cours vers /etc/ssh/sshd_config.sav ==\n$colDEFAULT"
	sudo -S pycp /etc/ssh/sshd_config /etc/ssh/sshd_config.sav
	if [ -f /etc/ssh/sshd_config.sav ]; then
		sudo -S echo -e "$colVERT\n[SSHD] == Backup OK ==\n$colDEFAULT"
	else
		sudo -S echo -e "$colROUGE\n[SSHD] !! Backup échoué : erreur !!\n$colDEFAULT"
	fi
else
	sudo -S echo -e "$colVERT\n[SSHD] == sshd déjà backup ==\n$colDEFAULT"
fi
# CONFIG SSHD_CONFIG
if [ $(grep -c "HostKey $SSHDIR$PRIK" /etc/ssh/sshd_config) = 0 ]; then
	ligne=$(grep -n "#HostKey /etc/ssh/ssh_host_ed25519_key" /etc/ssh/sshd_config|cut -d: -f1)
	lignecorr=$(($ligne+1))
	sudo -S sed "$ligne a\\
HostKey $SSHDIR$PRIK" /etc/ssh/sshd_config > $WDIR/sshd_config
sudo -S rm /etc/ssh/sshd_config;
sudo -S echo -e "$colVERT\n[SSHD] == Remplacement du fichier sshd d'origine par celui modifié ==\n$colDEFAULT"
sudo -S cp $WDIR/sshd_config /etc/ssh/
	if [ -f /etc/ssh/sshd_config ]; then
		sudo -S echo -e "$colVERT\n[SSHD] == Fichier bien remplacé ==\n$colDEFAULT"
	else
		sudo -S echo -e "$colROUGE\n[SSHD] Fichier absent : erreur ==\n$colDEFAULT"
	fi
else
sudo -S echo -e "$colJAUNE[SSHD] == Fichier sshd_config déjà patché ==\n$colDEFAULT"
fi
}

# SUPPORT BLUETOOTH & VIRTIONET
function BLUETOOTH(){
sudo -S echo -e "==> BLUETOOTH CHECK INSTALL"
if [ $(echo $blueDETECT | grep -c "Present") != 0 ]; then
	sudo -S echo -e "==> BLUETOOTH DETECTED"
	sudo -S xbps-install -y bluez bluez-qt5 blueman
	sudo -S ln -s /etc/sv/bluetoothd/ /var/service/
	blueDETECT=$(sudo -S lsusb | grep "Bluetooth")
else
	sudo -S echo -e "==> BLUETOOTH NOT DETECTED : SKIP PROCESS"
fi
}
function VIRTIONET(){

if [ $(echo $vmDETECT | grep -c "Present") != 0 ]; then
	sudo -S echo -e "==> VM detectée : install VIRTIONET"
	sudo -S echo -e "==> Virtio-net : Install"
		if [ ! -f /etc/modules-load.d/virtio.conf ];then
			sudo -S touch /etc/modules-load.d/virtio.conf
			sudo -S echo "# load virtio-net" | sudo -S tee /etc/modules-load.d/virtio.conf
			sudo -S echo "virtio-net" | sudo -S tee -a /etc/modules-load.d/virtio.conf
			sudo -S echo -e "==> Virtio-net : Fichier crée"
		else
			sudo -S echo -e "==> Virtio-net : fichier déjà présent"
		fi
else
	sudo -S echo -e "==> VIRTIO NOT DETECTED : SKIP PROCESS"
fi
}
# SUPPORT CPU & GPU
function INTELCPU(){
sudo -S echo -e "===> CPU : INTEL INSTALL"
sudo -S xbps-install -y intel-ucode linux-firmware-intel

}
function INTELGPU(){
echo -e "==> INTELINSTALL"
sudo -S xbps-install -y mesa mesa-dri mesa-vulkan-intel linux-firmware-intel intel-ucode

}
function AMDCPU(){
echo "===> CPU : AMD INSTALL"
sudo -S xbps-install -y linux-firmware-amd
}
function AMDGPU(){

echo "===> AMD INSTALL"
sudo -S xbps-install -y linux-firmware-amd mesa mesa-dri

}
function NVIDIA(){

sudo -S echo -e "===> nvidia INSTALL"
sudo -S xbps-install -y nvidia nvidia-opencl nvidia-firmware linux-firmware-nvidia nvtop;
sudo -S xbps-install -y mesa mesa-dri mesa-opencl mesa-vaapi mesa-vdpau;
sudo -S xbps-install -y Vulkan-Header Vulkan-ValidationLayers vulkan-loader;
# Fichier de configuration pour la gestion des ventilateurs
if [ ! -d "/etc/X11/xorg.conf.d" ]; then
	sudo -S echo -e "$colROUGE[SHIFTLOCK] == REPERTOIRE xorg.conf.d absent ==\n$colDEFAULT"
	sudo -S mkdir /etc/X11/xorg.conf.d
fi	
sudo -S touch /etc/X11/xorg.conf.d/11-nvidia.conf
echo 'Section "OutputClass"' | sudo -S tee /etc/X11/xorg.conf.d/11-nvidia.conf
echo '     Identifier "nvidia"' | sudo -S tee -a /etc/X11/xorg.conf.d/11-nvidia.conf
echo '     MatchDriver "nvidia-drm"' | sudo -S tee -a /etc/X11/xorg.conf.d/11-nvidia.conf
echo '     Driver "nvidia"' | sudo -S tee -a /etc/X11/xorg.conf.d/11-nvidia.conf
echo '     Option "Coolbits" "4"' | sudo -S tee -a /etc/X11/xorg.conf.d/11-nvidia.conf
echo 'EndSection' | sudo -S tee -a /etc/X11/xorg.conf.d/11-nvidia.conf

sudo -S echo -e "==> Installation GreenWithEnvy"
flatpak install --user com.leinardi.gwe
sudo -S echo -e "==> GWE : Création raccourci pour le démarrage auto"
echo '[Desktop Entry]'|tee $HOME/.config/autostart/GreenWithEnvy.desktop
echo 'Encoding=UTF-8'|tee -a $HOME/.config/autostart/GreenWithEnvy.desktop
echo 'Version=0.9.4'|tee -a $HOME/.config/autostart/GreenWithEnvy.desktop
echo 'Type=Application'|tee -a $HOME/.config/autostart/GreenWithEnvy.desktop
echo 'Name=GreenWithEnvy'|tee -a $HOME/.config/autostart/GreenWithEnvy.desktop
echo 'Comment=Afterburner Like'|tee -a $HOME/.config/autostart/GreenWithEnvy.desktop
echo 'Exec=flatpak run com.leinardi.gwe --hide-window'|tee -a $HOME/.config/autostart/GreenWithEnvy.desktop
echo 'OnlyShowIn=XFCE;'|tee -a $HOME/.config/autostart/GreenWithEnvy.desktop
echo 'RunHook=0'|tee -a $HOME/.config/autostart/GreenWithEnvy.desktop
echo 'StartupNotify=false'|tee -a $HOME/.config/autostart/GreenWithEnvy.desktop
echo 'Terminal=false'|tee -a $HOME/.config/autostart/GreenWithEnvy.desktop
echo 'Hidden=false'|tee -a $HOME/.config/autostart/GreenWithEnvy.desktop

}

# UTILITAIRES SOURIS/CLAVIER CORSAIR & SOURIS STEELSERIES
function STEELSERIES(){
sudo -S echo -e "[MOUSE] SteelSeries Driver"
cd $HOME
git clone https://github.com/flozz/rivalcfg.git
cd rivalcfg
pip3 install .
sudo -S rivalcfg --update-udev
sudo -S rivalcfg -p 125
}
function CORSAIR(){
sudo -S echo -e "[DEVICE] Corsair Driver"
sudo -S xbps-install -y ckb-next;
sudo -S ln -s /etc/sv/ckb-next-daemon /var/service;
}
# OPTIMISATION FOR LENOVO LAPTOP
function T420(){

echo "===> T420 addons"
sudo -S xbps-install -y tlp tlp-rdw tp_smapi-dkms tpacpi-bat mesa-dri linux-firmware-intel vulkan-loader mesa-vulkan-intel intel-video-accel libva-intel-driver
sudo -S chmod +x $HOME/Void-Post-Installer/lenovo/lenovo-mutemusic.sh
sudo -S pycp $HOME/Void-Post-Installer/lenovo/lenovo-mutemusic.sh /etc/acpi
sudo -S vsv restart acpid
}
function T470(){

# Support TouchScreen
if [ $(lsusb|grep -c "Touch") != 0]; then
	sudo -S echo -e "T470 : TouchScreen detecté : installation"
	sudo -S xbps-install -y xinput xinput_calibrator
	if [ ! -f $shareapp/VPI-TouchScreen_Calibration ]; then
		echo '#!/bin/bash' > $dirapp/VPI-TouchScreen_Calibration
		echo 'PASS=$(yad --entry --image=window-maximize --title="TouchScreen Calibration" --hide-text --text="TouchScreen Calibration\n\nEnter user password :\n")' >> $dirapp/VPI-TouchScreen_Calibration
		echo 'echo -e $PASS|sudo -S xinput_calibration' >> $dirapp/VPI-TouchScreen_Calibration
	else
		echo 'VPI-TouchScreen_Calibration présent'
	fi
	if [ ! -f $shareapp/VPI-TouchScreen_Calibration.desktop ]; then
		echo '[Desktop Entry]' > $shareapp/VPI-TouchScreen_Calibration.desktop
		echo 'Version=1.0' >> $shareapp/VPI-TouchScreen_Calibration.desktop
		echo 'Type=Application' >> $shareapp/VPI-TouchScreen_Calibration.desktop
		echo 'Name=VPI-TouchScreen_Calibration' >> $shareapp/VPI-TouchScreen_Calibration.desktop
		echo 'Exec=VPI-TouchScreen_Calibration' >> $shareapp/VPI-TouchScreen_Calibration.desktop
		echo 'Icon=window-maximize' >> $shareapp/VPI-TouchScreen_Calibration.desktop
		echo 'Terminal=false' >> $shareapp/VPI-TouchScreen_Calibration.desktop
		echo 'StartupNotify=false' >> $shareapp/VPI-TouchScreen_Calibration.desktop
		echo 'Categories=X-VPI;' >> $shareapp/VPI-TouchScreen_Calibration.desktop
	else
		echo 'VPI-TouchScreen_Calibration.desktop présent'
	fi
	
	if [ $(grep -c "MOZ_USE_XINPUT2" /etc/security/pam_env.conf) = 0]; then
	echo "MOZ_USE_XINPUT2 DEFAULT=1"|sudo -S tee -a /etc/security/pam_env.conf
	sudo -S echo -e "[T470][TOUCH]Fichier /etc/security/pam_env.conf modifié avec succès"
	else
	sudo -S echo -e "[T470][TOUCH]Fichier /etc/security/pam_env.conf deja modifié"
	fi
else
	sudo -S echo -e "T470 : TouchScreen non detecté"
fi

sudo -S xbps-install -y acpid tlp tpacpi-bat
if [ ! -d /var/service/acpid ]; then
	sudo -S ln -s /etc/sv/acpid /var/service
	sudo -S echo -e "[OK] Service ACPID activé"
else
	sudo -S echo -e "[OK] Service ACPID deja actif"
fi
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
sudo xbps-install -y linux-firmware-broadcom linux-firmware-intel linux-firmware-network intel-ucode mesa-dri mesa-vulkan-intel
sudo xbps-install -y tp_smapi-dkms tpacpi-bat

}
# CORRECTION BUG CLAVIER AZERTY AU LOGIN
function ELOGIND(){

# Configuration clavier azerty pour
# se connecter à sa session.
sudo -S echo -e "===> ELOGIND AZERTY"
if [ -d /etc/X11/xorg.conf.d ]; then
	sudo -S echo -e "Dossier xorg.conf.d présent"
else
	sudo -S mkdir -p /etc/X11/xorg.conf.d/
	sudo -S echo -e "Dossier crée"
fi
				
if [ -f /etc/X11/xorg.conf.d/00-Keyboard.conf ]; then
	sudo -S echo -e "Fichier 00-Keyboard.conf présent"
	
	# TEST DU FICHIER (A FAIRE)
	
else
	sudo -S touch /etc/X11/xorg.conf.d/00-Keyboard.conf
	sudo -S echo 'Section "InputClass' > /etc/X11/xorg.conf.d/00-Keyboard.conf
    	sudo -S echo '     Identifier "system-keyboard"' >> /etc/X11/xorg.conf.d/00-Keyboard.conf
    	sudo -S echo '     MatchisKeyboard "on"' >> /etc/X11/xorg.conf.d/00-Keyboard.conf
	sudo -S echo '     Option "XkbLayout" "fr"' >> /etc/X11/xorg.conf.d/00-Keyboard.conf
    	sudo -S echo '     Option "XkbModel" "pc105"' >> /etc/X11/xorg.conf.d/00-Keyboard.conf
	sudo -S	echo 'EndSection' >> /etc/X11/xorg.conf.d/00-Keyboard.conf
fi
}
# CORRECTION COMPORTEMENT TOUCHE VERR MAJ & SHIFT
function SHIFTLOCK(){
# Fonction verr. maj + shift
lang=$(echo $(echo $(locale|grep "LC_MESSAGE")|cut -d '"' -f2)|cut -d "_" -f1)
if [ ! -d "/etc/X11/xorg.conf.d" ]; then
	sudo -S echo -e "$colROUGE\n[SHIFTLOCK] == REPERTOIRE xorg.conf.d absent ==\n$colDEFAULT"
	sudo -S mkdir /etc/X11/xorg.conf.d
	sudo -S echo -e "$colVERT\n[SHIFTLOCK] == Répertoire xorg.conf.d crée ==\n$colDEFAULT"
fi	
sudo -S touch /etc/X11/xorg.conf.d/00-Keyboard.conf
echo 'Section "InputClass"' | sudo -S tee /etc/X11/xorg.conf.d/00-Keyboard.conf
echo '     Identifier "system-keyboard"' | sudo -S tee -a /etc/X11/xorg.conf.d/00-Keyboard.conf
echo '     MatchisKeyboard "on"' | sudo -S tee -a /etc/X11/xorg.conf.d/00-Keyboard.conf
echo '     Option "XkbLayout" "'"$lang"'"' | sudo -S tee -a /etc/X11/xorg.conf.d/00-Keyboard.conf
echo '     Option "XkbModel" "pc105"' | sudo -S tee -a /etc/X11/xorg.conf.d/00-Keyboard.conf
echo '     Option "XkbOptions" "caps:shiftlock"' | sudo -S tee -a /etc/X11/xorg.conf.d/00-Keyboard.conf
echo 'EndSection' | sudo -S tee -a /etc/X11/xorg.conf.d/00-Keyboard.conf
}

function FLATPAK(){
sudo -S echo -e "===> FLATPAK"
# installation de flatpak
sudo -S xbps-install -y flatpak
sudo -S echo -e "Flatpak : Création des repos si non existant"
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
echo 'set linenumbers' >> $HOME/.nanorc
}
function GUFW(){
sudo -S echo -e "$colJAUNE\n[GUFW] == Démarrage installation ==\n$colDEFAULT"
sudo -S xbps-install -y ufw gufw
sudo -S ln -s /etc/sv/ufw /var/service
sudo -S echo -e "$colJAUNE\n[GUFW] == Config files ==\n$colDEFAULT"
#VPIXFCE
if [ ! -f $dirapp/VPI-Firewall ]; then
	echo '#!/bin/bash' > $dirapp/VPI-Firewall
	echo 'PASS=$(yad --entry --image=security-low --title="GUFW Firewall" --hide-text --text="Firewall Launcher\n\nEnter user password :\n")' >> $dirapp/VPI-Firewall
	echo 'echo $PASS|sudo -S gufw-pkexec' >> $dirapp/VPI-Firewall
	chmod +x $dirapp/VPI-Firewall
else
	echo "Fichier VPI-Firewall présent"
fi
if [ ! -d "$shareapp" ]; then
	mkdir $shareapp
fi
if [ ! -f $shareapp/VPI-Firewall.desktop ]; then
# VPI-Firewall
	echo '[Desktop Entry]' > $shareapp/VPI-Firewall.desktop
	echo 'Version=1.0' >> $shareapp/VPI-Firewall.desktop
	echo 'Type=Application' >> $shareapp/VPI-Firewall.desktop
	echo 'Name=VPI-Firewall' >> $shareapp/VPI-Firewall.desktop
	echo 'Exec=VPI-Firewall' >> $shareapp/VPI-Firewall.desktop
	echo 'Icon=security-low' >> $shareapp/VPI-Firewall.desktop
	echo 'Terminal=false' >> $shareapp/VPI-Firewall.desktop
	echo 'StartupNotify=false' >> $shareapp/VPI-Firewall.desktop
	echo 'Categories=X-VPI;' >> $shareapp/VPI-Firewall.desktop
else
	echo "Fichier VPI-Firewall.desktop présent"
fi
sudo -S ufw enable
# Pour activer des regles dans ufw directement à l'installation
# sudo ufw allow from 192.168.1.0/24  to any port 22 # Autoriser les ports 22 du sous réseaux 192.168.1.X
}
function VPIXFCE(){

unset ligne
unset ligne2
dirmenu="$HOME/.config/menus"
file="xfce-applications.menu"
sudo -S echo -e "[VPIXFCE] ==> Verification Backup fichier $file"
if [ ! -d "$dirmenu" ]; then
	mkdir $dirmenu
	sudo -S echo -e "$colVERT\n[VPIXFCE] == Création Répertoire $dirmenu ==\n$colDEFAULT"
fi

if [ -f $dirmenu/$file.bak ]; then
	sudo -S echo -e "[VPIXFCE] ==> Fichier $file.bak présent"
	else
	sudo -S echo -e "[VPIXFCE] ==> Création backup $file"
	pycp $dirmenu/$file $dirmenu/$file.bak
	sudo -S echo -e "[VPIXFCE] ==> Backup $file créé"
fi
# RECUPERE LE NUMERO DE LIGNE A MODIFIER :

sudo -S echo -e "[VPIXFCE] ==> Edition fichier $file"
if [ $(grep -c "X-VPI" $dirmenu/$file) = 0 ]; then

	sudo -S echo -e "[VPIXFCE] ==> Fichier $file non modifié : modification en cours"
	ligne=$(grep -n "Name>Other" $dirmenu/$file|cut -d: -f1)
	lignecorr=$(($ligne-2))
	sed "$lignecorr a\\
	<Menu>\\
		<Name>VPI</Name>\\
		<Directory>VPI.directory</Directory>\\
		<Include>\\
			<Category>X-VPI</Category>\\
		</Include>\\
	</Menu>" $dirmenu/$file > $dirmenu/xfce-test
	
ligne2=$(grep -n "Menuname>Other" $dirmenu/xfce-test|cut -d: -f1)
sudo -S sed "$ligne2 a\\
		<Menuname>VPI</Menuname>" $dirmenu/xfce-test > $dirmenu/$file
	rm $dirmenu/xfce-test
	sudo -S echo -e "[VPIXFCE] ==> $file modifié"
else
	sudo -S echo "[VPIXFCE] Fichier $file déjà modifié"
fi
if [ ! -d "$HOME/.local/share/desktop-directories"]; then
	sudo -S echo -e "$colROUGE\n[VPI-APPS] == MENU VPI-APPS : Répertoire .local/share/desktop-directories absent ==\n$colDEFAULT"
	mkdir $HOME/.local/share/desktop-directories;
	sudo -S echo -e "$colVERT\n[VPI-APPS] == MENU VPI-APPS : Répertoire .local/share/desktop-directories créé ==\n$colDEFAULT"
fi

if [ ! -f "$HOME/.local/share/desktop-directories/VPI.directory" ]; then
	sudo -S echo -e "[VPIXFCE] ==> Création VPI.directory"
	echo 'Fichier VPI.directory absent : création'
	echo '[Desktop Entry]' > $HOME/.local/share/desktop-directories/VPI.directory
	echo 'Version=1.1' >> $HOME/.local/share/VPI.directory
	echo 'Type=Directory' >> $HOME/.local/share/VPI.directory
	echo 'Name=VPI' >> $HOME/.local/share/VPI.directory
	echo 'Comment=Application Void Post Installer by TofF.' >> $HOME/.local/share/VPI.directory
	echo 'Icon=xfce-system-settings-symbolic' >> $HOME/.local/share/VPI.directory
	sudo -S echo -e "[VPIXFCE] ==> Fichier VPI.directory créé"
else
	sudo -S echo -e "[VPIXFCE] ==> Fichier VPI.directory présent"
fi


}
function VPIAPPS(){
sudo -S echo -e "==> Installation VPI-Apps"
sudo -S pycp $outils/VPI-* $dirapp
# VERIFICATION PRESENCE & MODIF FICHIER MENU
VPIXFCE
if [ ! -d "$shareapp" ]; then
	sudo -S echo -e "$colROUGE[VPIAPPS] == REPERTOIRE $shareapp absent ==\n$colDEFAULT"
	mkdir $shareapp
fi	
#VPI-Backup-Restore
if [ ! -f $shareapp/VPI-Backup-Restore.desktop ]; then
	echo '[Desktop Entry]' > $shareapp/VPI-Backup-Restore.desktop
	echo 'Version=1.0' >> $shareapp/VPI-Backup-Restore.desktop
	echo 'Type=Application' >> $shareapp/VPI-Backup-Restore.desktop
	echo 'Name=VPI-Backup-Restore' >> $shareapp/VPI-Backup-Restore.desktop
	echo 'Exec=VPI-Backup-Restore' >> $shareapp/VPI-Backup-Restore.desktop
	echo 'Icon=document-save-as' >> $shareapp/VPI-Backup-Restore.desktop
	echo 'Terminal=false' >> $shareapp/VPI-Backup-Restore.desktop
	echo 'StartupNotify=false' >> $shareapp/VPI-Backup-Restore.desktop
	echo 'Categories=X-VPI;' >> $shareapp/VPI-Backup-Restore.desktop
else
	sudo -S echo -e 'VPI-Backup-Restore.desktop présent'
fi

# VPI-ManageUser
if [ ! -f $shareapp/VPI-ManageUser.desktop ]; then
echo '[Desktop Entry]' > $shareapp/VPI-ManageUser.desktop
echo 'Version=1.0' >> $shareapp/VPI-ManageUser.desktop
echo 'Type=Application' >> $shareapp/VPI-ManageUser.desktop
echo 'Name=VPI-ManageUser' >> $shareapp/VPI-ManageUser.desktop
echo 'Exec=VPI-ManageUser' >> $shareapp/VPI-ManageUser.desktop
echo 'Icon=system-users' >> $shareapp/VPI-ManageUser.desktop
echo 'Terminal=false' >> $shareapp/VPI-ManageUser.desktop
echo 'StartupNotify=false' >> $shareapp/VPI-ManageUser.desktop
echo 'Categories=X-VPI;' >> $shareapp/VPI-ManageUser.desktop
else
	sudo -S echo -e 'VPI-ManageUser.desktop présent'
fi
#VPI-UPDATER
if [ ! -f $shareapp/VPI-UPDATER.desktop ]; then
echo '[Desktop Entry]' > $shareapp/VPI-UPDATER.desktop
echo 'Version=1.0' >> $shareapp/VPI-UPDATER.desktop
echo 'Type=Application' >> $shareapp/VPI-UPDATER.desktop
echo 'Name=VPI-UPDATER' >> $shareapp/VPI-UPDATER.desktop
echo 'Exec=VPI-UPDATER' >> $shareapp/VPI-UPDATER.desktop
echo 'Icon=system-software-update' >> $shareapp/VPI-UPDATER.desktop
echo 'Terminal=false' >> $shareapp/VPI-UPDATER.desktop
echo 'StartupNotify=false' >> $shareapp/VPI-UPDATER.desktop
echo 'Categories=X-VPI;' >> $shareapp/VPI-UPDATER.desktop
else
	echo 'VPI-UPDATER.desktop présent'
fi

# VPI-Void-install-USB
if [ ! -f $shareapp/VPI-Void-install-USB.desktop ]; then
echo '[Desktop Entry]' > $shareapp/VPI-Void-install-USB.desktop
echo 'Version=1.0' >> $shareapp/VPI-Void-install-USB.desktop
echo 'Type=Application' >> $shareapp/VPI-Void-install-USB.desktop
echo 'Name=VPI-Void-install-USB' >> $shareapp/VPI-Void-install-USB.desktop
echo 'Exec=VPI-Void-install-USB' >> $shareapp/VPI-Void-install-USB.desktop
echo 'Icon=system-run' >> $shareapp/VPI-Void-install-USB.desktop
echo 'Terminal=false' >> $shareapp/VPI-Void-install-USB.desktop
echo 'StartupNotify=false' >> $shareapp/VPI-Void-install-USB.desktop
echo 'Categories=X-VPI;' >> $shareapp/VPI-Void-install-USB.desktop
else
	echo 'VPI-Void-install-USB.desktop présent'
fi

# VPI-lxdm-config-launcher
if [ ! -f $shareapp/VPI-lxdm-config-launcher.desktop ]; then
echo '[Desktop Entry]' > $shareapp/VPI-lxdm-config-launcher.desktop
echo 'Version=1.0' >> $shareapp/VPI-lxdm-config-launcher.desktop
echo 'Type=Application' >> $shareapp/VPI-lxdm-config-launcher.desktop
echo 'Name=VPI-lxdm-config-launcher' >> $shareapp/VPI-lxdm-config-launcher.desktop
echo 'Exec=VPI-lxdm-config-launcher' >> $shareapp/VPI-lxdm-config-launcher.desktop
echo 'Icon=image-x-generic' >> $shareapp/VPI-lxdm-config-launcher.desktop
echo 'Terminal=false' >> $shareapp/VPI-lxdm-config-launcher.desktop
echo 'StartupNotify=false' >> $shareapp/VPI-lxdm-config-launcher.desktop
echo 'Categories=X-VPI;' >> $shareapp/VPI-lxdm-config-launcher.desktop
else
	echo 'VPI-lxdm-config-launcher.desktop présent'
fi

# VPI-vmware-registration
if [ $(ls /etc | grep -c "vmware") != 0 ]; then
	if [ ! -f $shareapp/VPI-vmware-registration.desktop ]; then
	echo '[Desktop Entry]' > $shareapp/VPI-vmware-registration.desktop
	echo 'Version=1.0' >> $shareapp/VPI-vmware-registration.desktop
	echo 'Type=Application' >> $shareapp/VPI-vmware-registration.desktop
	echo 'Name=VPI-vmware-registration' >> $shareapp/VPI-vmware-registration.desktop
	echo 'Exec=VPI-vmware-registration' >> $shareapp/VPI-vmware-registration.desktop
	echo 'Icon=error-correct' >> $shareapp/VPI-vmware-registration.desktop
	echo 'Terminal=false' >> $shareapp/VPI-vmware-registration.desktop
	echo 'StartupNotify=false' >> $shareapp/VPI-vmware-registration.desktop
	echo 'Categories=X-VPI;' >> $shareapp/VPI-vmware-registration.desktop
	else
		echo 'VPI-vmware-registration.desktop présent'
	fi
else
	sudo -S echo -e "vmware workstation absent du systeme"
fi
}
function I3INSTALLER(){
# configuration window manager i3
echo "===> i3"
cd $scripts
./08-VOID-i3.sh
cd $WDIR
}
function OHMYZSH(){

# Installation de OhmyZsh!
sudo -S echo -e "$colJAUNE\n[OHMYZSH] == Install ==\n$colDEFAULT"
sudo -S xbps-install -y zsh; 
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)";
sudo -S echo -e "$colVERT BONJOUR $colJAUNE BISOUS $colDEFAULT"
}

function CUPS(){
sudo -S echo -e "[CUPS][INSTALL]"
# Paquets a installer
sudo -S xbps-install -y cups cups-filters system-config-printer
sudo -S ln -s /etc/sv/cupsd /var/service

}
function TEAMVIEWER(){

# Installation TeamViewer
sudo -S echo "===> TeamViewer : Installation"
sudo -S xbps-install -y minizip qt5-quickcontrols
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
pycp $HOME/Applications/teamviewer/teamviewer.desktop $HOME/.local/share/applications

}
function VIRTMANAGER(){
sudo -S xbps-install -y virt-manager qemu libvirt dbus bridge-utils
if [ ! -d /var/service/dbus ]; then
sudo -S ln -s /etc/sv/dbus /var/service
sudo -S echo -e "Service dbus monté"
else
sudo -S echo -e "Service dbus déjà monté"
fi
if [ ! -d /var/service/libvirtd ]; then
sudo -S ln -s /etc/sv/libvirtd /var/service
sudo -S echo -e "Service libvirt monté"
else
sudo -S echo -e "Service libvirt déjà monté"
fi
if [ ! -d /var/service/virtlockd ]; then
sudo -S ln -s /etc/sv/virtlockd /var/service
sudo -S echo -e "Service virtlockd monté"
else
sudo -S echo -e "Service virtlockd déjà monté"
fi
if [ ! -d /var/service/virtlogd ]; then
sudo -S ln -s /etc/sv/virtlogd /var/service
sudo -S echo -e "Service virtlogd monté"
else
sudo -S echo -e "Service virtlogd déjà monté"
fi
sudo -S usermod -a -G libvirt $voiduser
}
function VIRTUALBOX(){
sudo -S xbps-install -y virtualbox-ose virtualbox-ose-dkms
sudo -S xbps-reconfigure -f virtualbox-ose-dkms
sudo -S modules-load
}
function VMWAREWSPLY(){
echo "==> APPS : VMWare Workstation Player 16"
sudo -S xbps-install -y libpcsclite pcsclite
sudo -S ln -s /etc/sv/pcscd /var/service
cd $HOME
mkdir VMWareInstall
cd VMWareInstall
wget https://download3.vmware.com/software/player/file/VMware-Player-16.0.0-16894299.x86_64.bundle?HashKey=d0d1117816424e5e5d9d2b1adb78361f&params=%7B%22sourcefilesize%22%3A%22160.60+MB%22%2C%22dlgcode%22%3A%22b1acfc7b4cdc5c976601b26eec4384a2%22%2C%22languagecode%22%3A%22fr%22%2C%22source%22%3A%22DOWNLOADS%22%2C%22downloadtype%22%3A%22manual%22%2C%22downloaduuid%22%3A%22601eda45-6233-4fbb-acbe-68b3f3eb841e%22%2C%22dlgtype%22%3A%22Product+Binaries%22%2C%22productversion%22%3A%2216.0.0%22%2C%22productfamily%22%3A%22VMware+Workstation+Player%22%7D&AuthKey=1648578131_4251ce7b8b701b45089c37195873cde6
chmod +x *
if [ ! -d /etc/init.d/ ];then
sudo -S mkdir /etc/init.d/
fi
sudo -S ./VMware-Player-16.0.0-16894299.x86_64.bundle
sudo -S sed -i 's/\(Exec=/usr/bin/vmware\).*/\Exec=vmware-launcher-player/' /usr/share/applications/vmware-player.desktop
cd $dirapp
if [ ! -f vmware-launcher-player ]; then
	touch vmware-launcher-player
else
	echo "#!/bin/bash" > vmware-launcher-player
	echo "PASS=$(yad --entry --hide-text --title="VMWare-Launcher-Player" --text="Pass :")" >> vmware-launcher-player
	echo "sudo -S /etc/init.d/vmware start && sudo -S vmware-usbarbitrator" >> vmware-launcher-player
	echo "vmplayer" >> vmware-launcher-player
	chmod +x vmware-launcher-player
	pycp $outils/VPI-vmware-registration $dirapp
	cd $HOME && sudo -S rm -Rf VMWareInstall
fi
}
function VMWAREWSPRO(){
sudo -S echo -e "==> APPS : VMWare Workstation Pro 16"
sudo -S xbps-install -y make libpcsclite pcsclite
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
sudo -S ./VMware-Workstation-Full-16.2.3-19376536.x86_64.bundle
# EDITION DES RACCOURCIS DESKTOP
sudo -S sed -i 's/\(Exec=/usr/bin/vmware\).*/\Exec=vmware-launcher/' /usr/share/applications/vmware-workstation.desktop
sudo -S sed -i 's/\(Exec=/usr/bin/vmware\).*/\Exec=vmware-launcher-player/' /usr/share/applications/vmware-player.desktop
# CREATION DES LAUNCHERS DANS $HOME/.local/bin (path)
# Pour VMPlayer
cd $dirapp
touch vmware-launcher vmware-launcher-player
echo "#!/bin/bash" > vmware-launcher-player
echo "PASS=$(yad --entry --hide-text --title="VMWare-Launcher-Player" --text="Pass :")" >> vmware-launcher
echo "sudo -S /etc/init.d/vmware start && sudo -S vmware-usbarbitrator" >> vmware-launcher-player
echo "vmplayer" >> vmware-launcher-player
chmod +x vmware-launcher-player
# Pour Workstation
echo "#!/bin/bash" > vmware-launcher
echo "PASS=$(yad --entry --hide-text --title="VMWare-Launcher" --text="Pass :")" >> vmware-launcher
echo "sudo -S /etc/init.d/vmware start && sudo -S vmware-usbarbitrator" >> vmware-launcher
echo "vmware" >> vmware-launcher
chmod +x vmware-launcher
# Outil d'enregistrement de license
pycp $outils/VPI-vmware-registration $dirapp
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
function DISCORDAPP(){
sudo -S echo -e "===> Discord : Installation"
cd $HOME

# Check directory d'installation
if [ ! -d $HOME/Applications ];then
	sudo -S echo -e "$colVERT\n[DISCORD] == Création Répertoire Applications ==\n$colDEFAULT"
	mkdir $HOME/Applications
	chown -R $voiduser:$voiduser $HOME/Applications
fi
if [ -d $HOME/Applications/Discord ]; then
	sudo -S echo -e "$colJAUNE\n[DISCORD] == Discord déjà installé, réinstallation en cours ==\n$colDEFAULT"
	sudo -S rm -rfv $HOME/Applications/Discord
fi

# Téléchargement & installation de Discord
sudo -S echo -e "$colJAUNE\n[DISCORD] == Discord : Téléchargement ==\n$colDEFAULT"
cd $HOME/Applications
wget -O discord.tar.gz "https://discordapp.com/api/download?platform=linux&format=tar.gz"
tar xfv discord.tar.gz; rm discord.tar.gz;
# Création launcher Discord (fonction auto detection update au lancement)
if [ ! -f $dirapp/VPI-Discord_Updater ]; then
pycp $outils/VPI-Discord_Updater $dirapp
chmod +x $dirapp/VPI-Discord_Updater
sudo -S echo -e "VPI-Discord_Updater : installé"
else
sudo -S echo -e "VPI-Discord_Updater : déjà installé"
fi

# Création raccourci pour le menu systeme
sudo -S echo -e "Discord : Création raccourci"	
	echo "[Desktop Entry]" > $shareapp/discord.desktop
	echo "Name=Discord" >> $shareapp/discord.desktop
	echo "StartupWMClass=discord" >> $shareapp/discord.desktop
	echo "Comment=All-in-one voice and text chat for gamers that's free, secure, and works on both your desktop and phone." >> $shareapp/discord.desktop
	echo "GenericName=Internet Messenger" >> $shareapp/discord.desktop
	echo "Exec=$HOME/.local/bin/VPI-Discord_Launcher" >> $shareapp/discord.desktop
	echo "Icon=discord" >> $shareapp/discord.desktop
	echo "Type=Application" >> $shareapp/discord.desktop
	echo "Categories=Network;InstantMessaging;" >> $shareapp/discord.desktop
	echo "Path=$HOME/.local/bin/" >> $shareapp/discord.desktop
	echo "Terminal=false" >> $shareapp/discord.desktop
	echo "StartupNotify=false" >> $shareapp/discord.desktop
}
=================

function DISCORDFLAT(){
sudo -S echo -e "===> Discord : Installation"
flatpak install --user com.discordapp.Discord -y
}
================
function PICOM(){
echo "Picom : Installation"
sudo -S xbps-install -y picom compton compton-conf
sudo -S pycp $config/picom.conf $HOME/.config/

# Installation Picom-ibhagwan
#cd $HOME
#git clone https://github.com/void-linux/void-packages
#cd void-packages
#core=$(cat /proc/cpuinfo | grep processor | wc -l)
#echo "XBPS_ALLOW_RESTRICTED=yes" > $HOME/void-packages/etc/conf
#echo "XBPS_CCACHE=yes" >> $HOME/void-packages/etc/conf
#echo "XBPS_MAKEJOBS=$core" >> $HOME/void-packages/etc/conf
#cd void-packages;
#./xbps-src binary-bootstrap
#git clone https://github.com/ibhagwan/picom-ibhagwan-template
#mv picom-ibhagwan-template ./srcpkgs/picom-ibhagwan
#./xbps-src pkg picom-ibhagwan
#sudo -S xbps-install --repository=hostdir/binpkgs picom-ibhagwan

# CONFIG PICOM

}
function PARSEC(){
sudo -S echo -e "Flatpak : Installation Parsec"
flatpak install --user -y Parsec
}
function STEAM(){
sudo -S echo -e "==> Install Steam"
# Installation de Steam sur VoidLinux.
sudo -S xbps-install -y libgcc-32bit libstdc++-32bit libdrm-32bit libglvnd-32bit
# Installation de Steam via flatpak (Easy Anti Cheat actif)
flatpak install --user -y com.valvesoftware.Steam
}
function GOG(){
sudo -S echo -e "[GOG] Installation"
sudo -S xbps-install -y minigalaxy LGOGDownloader python3-gogs-client
}
function WINE(){
# Installation de Wine pour Voidlinux
sudo -S xbps-install -y wine winetricks wine-tools wine-mono wine-gecko wine-32bit libwine-32bit;
# Installation des dépendances pour wine
winetricks allfonts d3dcompiler_47 d3drm d3dx10 d3dx9 d3dx11_43 dxvk vkd3d l3codecx gfw
}
function PROTONFLAT(){
# Installation ProtonGE pour Steam (steam flatpak version)

echo "==> Install Proton via Flatpak"
flatpak install --user -y com.valvesoftware.Steam.CompatibilityTool.Proton-GE
}
function AUTOINSTALL(){
sudo -S echo -e "$colJAUNE\n[AUTO] == AUTOINSTALL ==\n$colDEFAULT"
BASE
SSHKEYTEST
GUFW
NANORC
FLATPAK
STEAM
WINE
OHMYZSH
MENUFIN
}
function CUSTOMINSTALL(){
echo -e "\033[33,40m==>   CUSTOMINSTALL\033[0m"
MENUPARSER
BASE
SSHKEYTEST
NANORC
FLATPAK
XBPSLOADER
APPSLOADER
MENUFIN
}

function BANNER(){
ipcrm -M $KEY

PASS=$(yad --entry --hide-text --title="$TITLE $version" --text="Enter User Password")
echo $PASS|sudo -S clear;

echo -e "####################################"
echo -e "##"
echo -e "##\t\t$sTITLE"
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
sudo -S echo -e "===> START : MENU-PARSER"
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
# LISTE DES FIXS & PARSING
cat $res2 > $TMP01; sed '/^$/d' $TMP01 > $TMP02;
# ON RAJOUTE LES FIX AU DEBUT DE LA LISTE DES APPS POUR LA CHARGER DANS LE TABLEAU EN MEME TEMPS
cat $TMP03 >> $TMP02
unset customAPP
while read -r dataAPP
do
customAPP+=("$dataAPP")
done < $TMP02

sudo -S echo -e "customXBPS : ${customXBPS[@]}"
sudo -S echo -e "customAPPS : ${customAPP[@]}"
rm $res1 $res2 $res3 $TMP01 $TMP02 $TMP03 $TMP04
}
function XBPSLOADER(){
# MOULINETTE XBPSLOADER
sudo -S echo -e "===XBPSLOADER===> XBPSLOADER :"
sudo -S xbps-install -y ${customXBPS[@]}
}
function APPSLOADER(){
sudo -S echo -e "==> APPS LOADER START"
compteur=${#customAPP[@]}
sudo -S echo -e "Compteur = $compteur"
i=0
while (($compteur!=$i));
do
sudo -S echo -e "==> APPS LOADER BOUCLE WHILE "
${customAPP[$i]};
i=$(($i+1))
done
}
function MENULANG(){

BANNER
echo -e "==> MENULANG START"
vpiLANG=$(yad --title="$TITLE $version" --text="Choisissez votre langue :\n\nChoose your language :" \
	--center --on-top \
	--list --width="450" --height="530" --separator="" \
	--column="LANGUAGE :IMG" --column="" --print-column="2" --hide-column="2" \
	$icons/FR.png "FR" \
	$icons/UK.png "UK" \
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
	252)
	exit
	;;
esac
}
function MENU01START(){
echo -e "==>   MENU01START"
DETECT
source $WDIR/LANG/installer/$vpiLANG
menuCHOIX=$(yad --list --title="$TITLE $version" \
				--text="$vpiLANG\n$menu01START00 \
				\n\n==== AUTO DETECT ==== \
				\n\nUtilisateur\t : \t$voiduser \
				\nCPU TYPE\t : \t$cpuDETECT \
				\nGPU TYPE\t : \t$gpuDETECT \
				\n\nBluetooth\t : \t$blueDETECT \
				\nVirtio-net\t : \t$vmDETECT\n" \
				--width="530" --height="320" --center --on-top --icon --icon-size=32 \
				--column="TYPE" --column="Description" --print-column="1" --separator="" \
				"MINIMAL" "$menu01START01" \
				"CUSTOM" "$menu01START02")
valret=$?
case $valret in 
	0)
	if [ $(echo $menuCHOIX|grep -c MINIMAL) != 0 ];then
			# on active le mode minimal (a coder)
			AUTOINSTALL
	fi
	if [ $(echo $menuCHOIX|grep -c CUSTOM) != 0 ];then
			# on active le mode custom (a coder)
			MENU02CUSTOM
	fi
	;;
	1)
	exit
	;;
	252)
	exit
	;;
esac
}
function MENU02CUSTOM(){
echo -e "==>   MENU02CUSTOM"
source $WDIR/LANG/installer/$vpiLANG
yad --plug="$KEY" --tabnum="1" --form --image="abp.png" yad --text-info --text="$menuINTRO00 \
				\n\n==== AUTO DETECT ==== \
				\n\nUtilisateur\t : \t$voiduser \
				\nCPU TYPE\t : \t$cpuDETECT \
				\nGPU TYPE\t : \t$gpuDETECT \
				\nBluetooth\t : \t$blueDETECT \
				\nVirtio-net\t : \t$vmDETECT \
				\n\nTofdz 2023"&\
yad --plug="$KEY" --tabnum="2" --checklist --list --text="XBPS : Liste des paquets xbps utile" --hide-column="2" \
		--column="CHECK" --column="XBPS" --column="PAQUET" --column="DESCRIPTION" \
		true "XBPS" "cifs-utils" "Outil pour connexion SMB" \
		true "XBPS" "smbclient" "Outil pour connexion SMB (suite)" \
		false "XBPS" "thunderbird" "Client pour les Mails" \
		false "XBPS" "birdtray" "Garder Thunderbird en icone dans la barre des taches" \
		false "XBPS" "zenmap" "Tester la sécurité de votre réseau et +" \
		true "XBPS" "vlc" "Lecteur multimedia audio vidéo VLC" \
		false "XBPS" "gimp" "Logiciel d'édition d'image & photos" \
		false "XBPS" "blender" "Logiciel 3D" \
		false "XBPS" "ytmdl" "Téléchargez vos playlists youtube" \
		true "XBPS" "baobab" "Affichez le remplissage de vos dossiers & disques durs !" \
		false "XBPS" "lutris" "Jouez à vos jeu windows favoris préconfiguré pour linux." \
		false "XBPS" "CPU-X" "Affichez les informations CPU" \
		true "XBPS" "xfce4-plugins" "Suite de plugin pour personnaliser votre interface xfce" \
		true "XBPS" "xfce4-screenshooter" "Prendre des captures d'ecran" \
		false "XBPS" "deluge" "Telechargez vos torrent et magnet link" \
		true "XBPS" "caffeine-ng" "Gestion de l'écran de veille" &>$res1&\
yad --plug="$KEY" --tabnum="3" --form --text="FIX : Tous les correctifs dispo pour VoidLinux" --separator="\n" \
		--field="FIX - Lenovo Thinkpad :CB" "!T420!X250!T470" \
		--field="FIX - AZERTY at login:CB" "!ELOGIND" \
		--field="FIX - ShiftLock:CB" "^SHIFTLOCK"&>$res2&\
yad --plug="$KEY" --tabnum="4" --checklist --list --text="APPS : Toutes les applications déjà configuré pour vous" --hide-column="3" \
		--column="CHECK" --column=":IMG" --column="APPS" --column="PAQUET" --column="DESCRIPTION" \
		true "$icons/gufw-50.png" "APPS" "GUFW" "Un firewall avec interface graphique" \
		true "$icons/theme.png" "APPS" "THEME" "Theme Void Post Installer" \
		false "$icons/cups-50.png" "APPS" "CUPS" "Impression" \
		true "$icons/I3wm-color-50.png" "APPS" "VPIAPPS" "Ensemble d'applis assez utile !" \
		false "$icons/I3wm-color-50.png" "APPS" "I3INSTALLER" "Installation du gestionnaire de fenetre graphique i3" \
		true "$icons/I3wm-color-50.png" "APPS" "PICOM" "Composition : affichage effet graphique" \
		true "$icons/virt-manager-50.png" "APPS" "VIRTMANAGER" "Gestionnaire de serveur et de machines virtuelles" \
		false "$icons/Virtualbox-50.png" "APPS" "VIRTUALBOX" "Gestionnaire de machines virtuelles" \
		false "$icons/teamviewer_48.png" "APPS" "TEAMVIEWER" "TeamViewer" \
		false "$icons/VMWare-Workstation-50.png" "APPS" "MENUVMWAREWS" "VMWARE Workstation Pro / Player 16" \
		false "$icons/Parsec-50.png" "APPS" "PARSEC" "Gaming en streaming remote" \
		false "$icons/steelseries-light-50.png" "APPS" "STEELSERIES" "Reglages periphériques Steel Series (souris)" \
		false "$icons/Corsair-light-50.png" "APPS" "CORSAIR" "Reglages périphériques Corsair (clavier/souris)" \
		false "$icons/Gog-light-50.png" "APPS" "GOG" "Installation de Gog Galaxy (Minigalaxy)" \
		false "$icons/Wine-50.png" "APPS" "WINE" "Pouvoir installer des applications windows sur voidlinux" \
		false "$icons/Steam-color-50.png" "APPS" "STEAM" "Installation de Steam" \
		false "$icons/Steam-color-50.png" "APPS" "PROTONFLAT" "Version flatpak de Proton-GE pour steam flatpak" \
		false "$icons/Discord-light-50.png" "APPS" "DISCORDAPPS" "Célèbre plateforme de chat vocale (tar.gz)" \
  		true "$icons/Discord-light-50.png" "APPS" "DISCORDFLAT" "Célèbre plateforme de chat vocale (flatpak)" \
		true "$icons/ohmyzsh-50.png" "APPS" "OHMYZSH" "Shell bien plus avancé que le terminal de base ;) à essayer !" &>$res3&\
yad --notebook --key="$KEY" --title="$TITLE" --image="abp.png" --text="$TITLE" \
		--center --on-top \
		--width="780" --height="650" --separator="|" \
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
	252)
	pkill yad
	exit
	;;
esac
}
function MENUFIN(){
echo -e "[ FIN ]==> Installation terminée"
sudo -S yad --info --title="$TITLE v$version : Installation terminée" \
	--text="Installation terminée !\n\nReboot necessaire !!!\n\nBonne journée !\n\nTofdz" \
	--button="Reboot:1" --button="Fermer:0"
valret=$?
case $valret in
	0)
	sudo -S pkill yad
	exit
	;;
	1)
	sudo -S reboot -n
	;;
	252)
	exit
	;;
esac
}
NET;
MENULANG | tee $WDIR/VPI_install.log;
