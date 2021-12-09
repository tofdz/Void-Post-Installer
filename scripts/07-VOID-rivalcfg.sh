#!/bin/bash
BASEDIR=$(pwd)
cd $HOME
git clone https://github.com/flozz/rivalcfg.git
cd rivalcfg
pip3 install .
sudo rivalcfg --update-udev
sudo rivalcfg -p 125
cd $BASEDIR
