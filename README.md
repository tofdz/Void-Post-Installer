# VOID-Post-Installer

Compatibilité CPU : AMD & Intel
Compatibilité GPU : (Nvidia & AMD)
OS : VoidLinux

# Description

Permet la post installation de VoidLinux pour les débutants qui veulent passer de Windows à VoidLinux
Une installation avec en objectif : 

- STABILITE (je l'utilise personnellement et RAS)
- FACILITE (un parfait débutant doit pouvoir l'utiliser et passer de windows a linux en un claquement de doigts)
- LEGERETE (le moins d'espace possible utilisé, que des applications utile qu'on utilise 100% du temps)
- GAMING (pouvoir jouer sur linux n'est plus une utopie, votre bibliothèque Steam vous attend !!!)
- SECURITE (ne pas etre exposé inutiliment sur le net, pas de télémétrie, pas de mouchards, sniffeurs bref : PROPRE)

Démarré, void consomme 300mo de RAM.
Sur un pc portable qui ne digère pas windows 10, ça permet de lui redonner une jeunesse.
Sur un pc correct, de liberer de l'espace (environ 40G de récuperer vs windows10).
Une fois ce script executé sur votre version fraichement installée de voidlinux,
Vous serez pret à l'utiliser sans avoir a regler le moindre probleme.

# Liste des modifications 

- Création des clés SSH (ed pas RSA)
- Ajout des repository VoidLinux.
- Correction du bug du clavier QWERTY au login
- Gestion de la mise en veille de l'ecran avec verrouillage session sur timer
- Verrouillage l'ecran avec un effet de floutage en faisant Mod+x.
- Desactivation dhcpcd (conflit avec NetworkManager)
- Desactivation des TTY inutiles
- configuration de nano (highlighting et affichage ligne & co)
- Installation des drivers graphique

# Application installées de base :

(Graphique)

- Steam		: Jouez avec support manette Xbox/Dualshock4 natif
- ProtonUP	: Pour jouer avec les derniers mise a jour Proton sur Steam
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
- OctoXBPS	: Gestionnaire de paquets & Mise a jour systeme

(Terminal)

- vpm 		: Gestionnaire de paquets.
- vsv 		: Gestionnaire de service.
- nano 		: Editeur de fichiers
- mc 		: MidnightCommander le gestionnaire de fichiers en terminal capable de faire aussi du FTP, SFTP et bien d'autres choses.
- ytmdl 	: pour recuper vidéo et musique directement depuis Youtube sur le terminal
- rivalcfg 	: Gestion des souris steelseries grace à l'ajout du script rivalcfg.
- Htop & ytop 	: pour monitorer votre systeme
- neofetch	: pour afficher le motd !
- Et pleins d'autres applications sympa sur les dépots de void et de github !

# Interface graphique : 

Le choix entre deux bureau : 
        
   - xfce4 pour une interface plus typée windows (typé débutant : fait pour se passer du terminal au maximum) 
   - i3 pour une expérience épurée et intuitive (typé Gamer full patate, pour tirer le max de la machine, 
               déjà préconfigurée avec toute l'installation de base, n'hésitez pas à l'essayer !)

# Installation

Dans un terminal, tapez :

        sudo xbps-install -Suyv git-all && git clone https://github.com/tofdz/Void-Post-Installer/  && cd Void-Post-Installer && sudo chmod +x install.sh

Modifiez le fichier install.sh dans le dossier /home/$USER/Void-Post-Installer/ pour coller à votre installation.
Descendez tout en bas du fichier, et placez vous dans la fonction MAIN ( function MAIN(){ symbolise le début de la fonction)
Pour ce faire, rajoutez des # pour commenter les fonctions a desactiver ou retirez les pour les activer.

Lancer le script en tapant dans le terminal : 
        
        clear;cd ~/Void-Post-Installer/;./install.sh

Enjoy ^^  
2021 Tofdz

# source github (Merci à eux !) :

Programme               Lien 

octoxbps        https://github.com/aarnt/octoxbps
vsv             https://github.com/bahamas10/vsv
vpm             https://github.com/netzverweigerer/vpm
protonup        https://github.com/AUNaseef/protonup
rivalcfg        https://github.com/flozz/rivalcfg  
San Francisco   https://github.com/supermarin/YosemiteSanFranciscoFont  
ytmdl           https://github.com/deepjyoti30/ytmdl

Et toutes celles et ceux qui ont laissé une trace sur le net pour permettre aux autres de faire de meme :)
