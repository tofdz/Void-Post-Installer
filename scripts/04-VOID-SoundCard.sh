#!/bin/bash

SOUNDCONF="/etc/acpi/soundconf.sh"

touch $SOUNDCONF
lsusb | grep -i "audio" > $SOUNDCONF &&lspci | grep -i "audio" > $SOUNDCONF;

echo "amixer -D pulse set Master toggle" >> $SOUNDCONF
echo "amixer -D pulse set Master playback toggle" >> $SOUNDCONF
echo "#commande super interressante !!!!" >> $SOUNDCONF
echo "amixer -D pulse set Master 1+ toggle" >> $SOUNDCONF
echo "#Liste toutes les fonctions dispo par la carte son" >> $SOUNDCONF
echo "amixer -c <card-number>" >> $SOUNDCONF

}
