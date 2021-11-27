# VOID-Post-Installer

Permet la post installation de VoidLinux pour les débutants qui veulent passer de Windows à VoidLinux

- Ajout des repository VoidLinux.
- Correction du bug du clavier QWERTY au login
- Gestion de la mise en veille de l'ecran avec verrouillage session sur timer
- Verrouillage l'ecran avec un effet de floutage en faisant Mod+x.
- Desactivation dhcpcd (conflit avec NetworkManager)
- Desactivation des TTY inutiles

# Application installées de base :
(Graphique)
- Steam		: Jouez avec support manette Xbox/Dualshock4 natif
- Parsec	: Connectez sur vos autres machines à distance
- Discord	: Restez en contacts avec vos amis !
- VirtualBox	: Créez des machines virtuelles
- Gparted	: Gérez vos disques durs & partitions 
- Minitube	: Navigez sur youtube épurée de toute publicité
- LibreOffice	: La suite office (word, excell ...)
- Notepadqq	: Codez !!!! (équivalent à notepad++)
- Gimp		: Retouchez/Editez vos images/photos (équivalent photoshop)
- Xarchiver	: Compressez/décompressez vos archives (winrar)
- Zenmap	: Testez votre réseau privé

(Terminal)
- Gestionnaire de paquet vpm pour une utilisation simplifiée dans le terminal et octoxbps en mode graphique depuis le bureau.
- ytmdl pour recuper vidéo et musique directement depuis Youtube sur le terminal
- Gestion des souris steelseries grace à l'ajout du script rivalcfg.
- Htop & ytop pour monitorer votre systeme
- Et pleins d'autres applications sympa sur les dépots de void et de github !

# Interface graphique : 

Le choix entre deux bureau : xfce4 pour une interface plus typée windows, i3 pour une expérience épurée et intuitive 
		(déjà préconfigurée avec toute l'installation de base, n'hésitez pas à l'essayer !)

# Installation

Dans un terminal, tapez :

sudo xbps-install -Suyv git-all  
git clone https://github.com/tofdz/Void-Post-Installer/  
cd Void-Post-Installer  
sudo chmod +x install.sh  
./install.sh

Enjoy ^^  
2021 Tofdz

source github (Merci à eux !) :

rivalcfg			https://github.com/flozz/rivalcfg  
Fonts San Francisco		https://github.com/supermarin/YosemiteSanFranciscoFont  
Et toutes celles et ceux qui ont laissé une trace sur le net pour permettre aux autres de faire de meme :)
