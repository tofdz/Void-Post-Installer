#!/bin/bash

# CONFIGURATION IPTABLES
# Pour Void-Post-Installer

# ON EFFACE TOUTES LES REGLES IPTABLES
echo "01-VOID-Firewall ===>"
sudo iptables -F

sudo iptables -P INPUT DROP
sudo iptables -P OUTPUT DROP
sudo iptables -P FORWARD DROP

sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT

    sudo iptables -A OUTPUT -o eth0 -p tcp --dport 80 --sport 1024:65535 -j ACCEPT
    sudo iptables -A OUTPUT -o eth0 -p tcp --dport 443 --sport 1024:65535 -j ACCEPT

    sudo iptables -A INPUT -i eth0 -m state -state RELATED,ESTABLISHED -j ACCEPT
    sudo iptables -A OUTPUT -o eth0 -m state -state RELATED,ESTABLISHED -j ACCEPT

sudo iptables-save > /etc/iptables/iptables.rules
