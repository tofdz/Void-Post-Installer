#!/bin/bash
echo "==> 00 Void : System modifications"


# CLEANINSTALL
echo -e "==> CLEANER"
#CLEANER
echo "===> BASE CLEANING - PLEASE WAIT !"
sudo -S touch /etc/xbps.d/Base_Install.conf
sudo -S echo "ignorepkg=linux-firmware-amd" >> /etc/xbps.d/Base_Install.conf
sudo -S echo "ignorepkg=linux-firmware-intel" >> /etc/xbps.d/Base_Install.conf
sudo -S echo "ignorepkg=linux-firmware-nvidia" >> /etc/xbps.d/Base_Install.conf
sudo -S echo "ignorepkg=xf86-video-amdgpu" >> /etc/xbps.d/Base_Install.conf
sudo -S echo "ignorepkg=xf86-video-ati" >> /etc/xbps.d/Base_Install.conf
sudo -S echo "ignorepkg=xf86-video-dummy" >> /etc/xbps.d/Base_Install.conf
sudo -S echo "ignorepkg=xf86-video-fbdev" >> /etc/xbps.d/Base_Install.conf
sudo -S echo "ignorepkg=xf86-video-intel" >> /etc/xbps.d/Base_Install.conf
sudo -S echo "ignorepkg=xf86-video-nouveau" >> /etc/xbps.d/Base_Install.conf
sudo -S echo "ignorepkg=xf86-video-vesa" >> /etc/xbps.d/Base_Install.conf
sudo -S echo "ignorepkg=xf86-video-vmware" >> /etc/xbps.d/Base_Install.conf

sudo vpm remove -y linux-firmware-amd linux-firmware-intel linux-firmware-nvidia xf86-video-amdgpu xf86-video-ati xf86-video-dummy xf86-video-fbdev xf86-video-intel xf86-video-nouveau xf86-video-vesa xf86-video-vmware 
echo "==> Suppression Base_Install.conf"
sudo -S rm /etc/xbps.d/Base_Install.conf

# Verification /etc/sysctl.conf

VER1=$(cat /etc/sysctl.conf|grep vm.max_map_count=1048576)
VER2=$(cat /etc/sysctl.conf|grep "abi.vsyscall32 = 0")
VER4=$(cat /etc/security/limits.conf|grep '1048576')
VER5=$(cat /etc/environment|grep -c 'qt5ct')

echo "==> Vérification /etc/sysctl.conf : $VER1"
sudo -S echo "===> 02 /etc/sysctl.conf : vm.max_map_count=1048576"
if [ -e $VER1 ]; then
	sudo -S echo "==!> Modification /etc/sysclt absente : modification en cours"
	sudo -S echo "vm.max_map_count=1048576" >> /etc/sysctl.conf
	VER1A=$(cat /etc/sysctl.conf|grep vm.max_map_count=1048576)
	sudo -S echo "==> Vérification /etc/sysctl.conf : $VER1A"
	else
	sudo -S echo "==> Fichier /etc/sysctl.conf : déjà modifié"
fi

sudo -S echo "===> 03 /etc/sysctl.conf : abi.vsyscall32 = 0"
if [ -e $VER2 ]; then
	sudo -S echo "Modification /etc/sysclt absente : modification en cours"
	sudo -S echo "abi.vsyscall32 = 0" >> /etc/sysctl.conf
	VER2A=$(cat /etc/sysctl.conf|grep "abi.vsyscall32 = 0")
	sudo -S echo "Vérification /etc/sysctl.conf : $VER2A"
	else
	sudo -S echo "Fichier /etc/sysctl.conf : déjà modifié"
fi

# VERIFICATION /etc/security/limits.conf
sudo -S echo "===> 05 /etc/security/limits.conf"
if [ -e $VER4 ]; then
	echo "==> Modification /etc/security/limits.conf"
	sudo -S echo "@users           -       nice            -20" >> /etc/security/limits.conf
	sudo -S echo "@users           -       nofile          1048576" >> /etc/security/limits.conf
else
	sudo -S echo "==> /etc/security/limits.conf déjà modifié"
fi

# Modification /etc/environment
if [ -e $VER5 ]; then
sudo -S echo "==> Modification /etc/environment QT_QPA_PLATEFORMTHEME=qt5ct"
sudo -S echo 'export QT_QPA_PLATFORMTHEME=qt5ct' >> /etc/environment
else
sudo -S echo "PASS ==> /etc/environment déjà modifié"
fi
# Prendre en compte le $HOME/$USER/.local/bin en compte dans le $PATH
sudo -S echo "===> $HOME/$USER/.local/bin : Modification fichiers"
if [ -e $(cat /etc/profile|grep "/.local/bin") ]; then
	sudo -S echo "==> /etc/profile : Modification en cours ..."
	sudo -S echo 'if [ -d "$HOME/.local/bin" ]; then' >> /etc/profile
	sudo -S echo 'PATH=$HOME/.local/bin:$PATH' >> /etc/profile
	sudo -S echo 'fi' >> /etc/profile
	sudo -S echo 'if [ -d /var/lib/flatpak/exports/share ]; then' >> /etc/profile
	sudo -S echo 'PATH=/var/lib/flatpak/exports/share:$PATH' >> /etc/profile
	sudo -S echo 'fi' >> /etc/profile
	sudo -S echo 'if [ -d $HOME/.local/share/flatpak/exports/share ]; then'  >> /etc/profile
	sudo -S echo 'PATH=$HOME/.local/share/flatpak/exports/share:$PATH' >> /etc/profile
	sudo -S echo 'fi' >> /etc/profile
	sudo -S echo 'Fichier profile - Terminé !'
	sudo -S source /etc/profile
else
	sudo -S echo -e "==> /etc/profile : Fichier /etc/profile déjà modifié : "
	sudo -S echo -e "==> /etc/profile : TERMINE"
fi

# AJOUT DE L'AUTO UPDATER & CONFIGURATION
if [ ! -d /var/service/snooze-daily ]; then
	if [ ! -d /etc/cron.daily ]; then
	echo -e "Repertoire cron.daily absent : création en cours..."
	sudo -S mkdir /etc/cron.daily
	else
	echo -e "Repertoire Cron.daily présent"
	fi
	echo -e "Création service snooze-daily en cours ..."
	sudo -S ln -s /etc/sv/snooze-daily /var/service
else
	echo -e "Service snooze-daily déjà présent"
fi
pycp $WDIR/outils/VOID-UPDATER.sh $HOME/.local/bin/;
chmod +x $HOME/.local/bin/VOID-UPDATER.sh;
if [ ! -f /etc/cron.daily/update ];then
	sudo -S echo -e '#!/bin/bash' > /etc/cron.daily/update
	sudo -S echo -e "cd /home/$USER/" >> /etc/cron.daily/update
	sudo -S echo -e 'exec ./VOID-UPDATER.sh' >> /etc/cron.daily/update
	sudo -S chmod +x /etc/cron.daily/update
else
	echo -e "Fichier deja présent"
fi
# AJOUT DE LA FONCTION RECHERCHE DANS THUNAR
sudo -S echo "<?xml version="1.0" encoding="UTF-8"?>" > $HOME/.config/Thunar/uca.xml
sudo -S echo "<actions>" >> $HOME/.config/Thunar/uca.xml
sudo -S echo "<action>" >> $HOME/.config/Thunar/uca.xml
sudo -S echo "	<icon>utilities-terminal</icon>" >> $HOME/.config/Thunar/uca.xml
sudo -S echo "	<name>Ouvrir un terminal ici</name>" >> $HOME/.config/Thunar/uca.xml
sudo -S echo "	<unique-id>1659223755776079-1</unique-id>" >> $HOME/.config/Thunar/uca.xml
sudo -S echo "	<command>exo-open --working-directory %f --launch TerminalEmulator</command>" >> $HOME/.config/Thunar/uca.xml
sudo -S echo "	<description>Exemple d’une action personnalisée</description>" >> $HOME/.config/Thunar/uca.xml
sudo -S echo "	<patterns>*</patterns>" >> $HOME/.config/Thunar/uca.xml
sudo -S echo "	<startup-notify/>" >> $HOME/.config/Thunar/uca.xml
sudo -S echo "	<directories/>" >> $HOME/.config/Thunar/uca.xml
sudo -S echo "</action>" >> $HOME/.config/Thunar/uca.xml
sudo -S echo "<action>" >> $HOME/.config/Thunar/uca.xml
sudo -S echo "	<icon>searching</icon>" >> $HOME/.config/Thunar/uca.xml
sudo -S echo "	<name>Recherche</name>" >> $HOME/.config/Thunar/uca.xml
sudo -S echo "	<unique-id>1663781577501216-1</unique-id>" >> $HOME/.config/Thunar/uca.xml
sudo -S echo "	<command>/usr/bin/catfish --path=%f</command>" >> $HOME/.config/Thunar/uca.xml
sudo -S echo "	<description>Effectuer une recherche</description>" >> $HOME/.config/Thunar/uca.xml
sudo -S echo "	<patterns>*</patterns>" >> $HOME/.config/Thunar/uca.xml
sudo -S echo "	<directories/>" >> $HOME/.config/Thunar/uca.xml
sudo -S echo "	<text-files/>" >> $HOME/.config/Thunar/uca.xml
sudo -S echo "</action>" >> $HOME/.config/Thunar/uca.xml
sudo -S echo "</actions>" >> $HOME/.config/Thunar/uca.xml
