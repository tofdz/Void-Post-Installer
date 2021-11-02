#!/bin/bash
VPIDIR=$(pwd)

sudo chmod +x $VPIDIR/scripts/*
.$VPIDIR/scripts/01-VOID-Post-Installer.sh
