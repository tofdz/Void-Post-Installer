#!/bin/bash
# VOID AUTO UPDATE By Tofdz
# MISE A JOUR XBPS
LOGSTOR="/var/log/VoidUpdate.log"
DATE=$(date)
touch $LOGSTOR
echo "=================================="  >> $LOGSTOR
echo "XBPS : UPDATE => XBPS" >> $LOGSTOR
xbps-install -Suyv xbps >> $LOGSTOR
echo "XBPS : UPDATE ALL" >> $LOGSTOR
xbps-install -Suyv >> $LOGSTOR
echo "XBPS : AUTOREMOVE" >> $LOGSTOR
yes "Y"|vpm autoremove >> $LOGSTOR
# MISE A JOUR FLATPAK
echo "=================================="  >>$LOGSTOR
echo "FLATPAK UPDATE" >> $LOGSTOR
flatpak update -y >> $LOGSTOR
# FIN DE LA MAJ
echo "==> FIN DE LA MAJ $DATE"  >> $LOGSTOR
echo "===================================" >> $LOGSTOR