#!/bin/bash


sudo vpm i -y virtualbox-ose virtualbox-ose-dkms
sudo xbps-reconfigure -f virtualbox-ose-dkms
sudo modules-load
