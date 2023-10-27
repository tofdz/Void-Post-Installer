#!/bin/bash
# VPI-Discord_Updater
# Pour mettre a jour directement Discord lorsqu'il le demande

clear
cd $HOME/Applications/Discord
./Discord &
cd ~
function KILL(){
ps -eo pid,user,fname|grep "Discord"|grep $USER|awk '{print $1}' > $DIR/KTMP1;
cat $DIR/KTMP1 | tr '\r\n' ' ' > $DIR/KTMP2;
kill $(cat $DIR/KTMP2)
}
function UPDATE(){
echo -e "Discord : Mise à jour"

	cd $HOME/Applications
	wget -O discord.tar.gz "https://discordapp.com/api/download?platform=linux&format=tar.gz"
	tar xfv discord.tar.gz; rm discord.tar.gz;

echo -e "Installation terminée"
cd Discord
./Discord &
exit
}
function CHECKVERS(){
DIR=$(pwd) && echo -e "============== START =============\n=====  $DIR  =======";
curl https://discordapp.com/api/download\?platform\=linux\&format\=tar.gz > test1;
cat test1 | grep "discord" > test2;
cat test2 | cut -d '/' -f6 > test1;
versonline=$(cat test1);
cd $HOME/Applications/Discord;
./Discord -v > $DIR/disc1 && KILL;
cat $DIR/disc1 | grep "Discord" > $DIR/disc2;
cat $DIR/disc2 | cut -d ' ' -f2 > $DIR/disc1;
versInstall=$(cat $DIR/disc1);
echo -e "Version Online\t\t : $versonline\nVersion Installée\t : $versInstall";
cd ~;
if [ $versonline != $versInstall ]; then
	echo -e "Discord doit etre mis a jour"
	CLEAN
	UPDATE
else
	echo -e "Discord est a jour"
	CLEAN
	cd $HOME/Applications/Discord;./Discord
fi

exit
}
function CLEAN(){
cd $DIR; rm test1 test2 disc1 disc2 KTMP1 KTMP2
}
CHECKVERS
