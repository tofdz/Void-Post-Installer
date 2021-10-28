#!/bin/bash

#MODIFIER LE FICHIER HOST

if [ -n $(sudo grep 'tower.local' /etc/hosts) ] || [ -n $(sudo grep 'Cerberus.localdomain' /etc/hosts) ];then
		if [ -n $(sudo grep 'Cerberus.localdomain' /etc/hosts) ];then
		echo "Ajout des adresses dans /etc/hosts"
		echo "192.168.20.1	Cerberus.localdomain" >> /etc/hosts
		echo "Cerberus.localdomainAdresses ajoutées"
		else
		echo "Cerberus.localdomain Adresse deja présente"
		fi
		
		if [ -n $(sudo grep 'tower.local' /etc/hosts) ];then
		echo "Ajout des adresses dans /etc/hosts"
		echo "192.168.20.2	tower.local" >> /etc/hosts
		echo "Adresses ajoutées"
		else
		echo "tower.local Adresse deja présente"
		fi
fi
exit