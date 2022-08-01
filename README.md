# VOID-Post-Installer

Compatibilité CPU : AMD & Intel
Compatibilité GPU : (Nvidia & AMD)
OS : VoidLinux
![VPI-Menu1](https://user-images.githubusercontent.com/80813116/145446339-2390a5ca-f5a9-4f7b-a726-5b6b77c97df4.png)


# Description
Une post installation de void linux qui permet de jouer clé en main à Elden Ring.

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

Ouvrez un terminal et copîez collez la commande suivante :

    sudo xbps-install -Suyv xbps;sudo xbps-install -Suyv && sudo xbps-install -Suyv git-all yad && git clone https://github.com/tofdz/Void-Post-Installer/  && cd Void-Post-Installer && sudo chmod +x install-GUI.sh;./install-GUI.sh
              
                
Un menu graphique s'ouvrira alors vous permettant de choisir directement la bonne installation :

- Minimal : pas de gaming ici, le mi-ni-mum pour dire d'etre viable (la selection est figée et ne tiens pas compte de la checklist).
- Install : pour avoir le choix (la selection dans la liste est fonctionnelle, j'ai laissé le choix pour la prise en compte du clavier AZERTY au login pour les amoureux du QWERTY ;).

Enjoy ^^  
2021 Tofdz

# source github (Merci à eux !) :

Programme               Lien 

- octoxbps :       https://github.com/aarnt/octoxbps
- vsv :https://github.com/bahamas10/vsv
- vpm :            https://github.com/netzverweigerer/vpm
- protonup :       https://github.com/AUNaseef/protonup
- rivalcfg :       https://github.com/flozz/rivalcfg  
- San Francisco : https://github.com/supermarin/YosemiteSanFranciscoFont  
- ytmdl :         https://github.com/deepjyoti30/ytmdl

Et toutes celles et ceux qui ont laissé une trace sur le net pour permettre aux autres de faire de meme :)
