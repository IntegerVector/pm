#!/bin/bash

DEBS_FILE="resources/debs.txt"
SNAPS_FILE="resources/snaps.txt"
FLATPAKS_FILE="resources/flatpaks.txt"
APP_IMAGES_FILE="resources/appimages.txt"

APT_EXEC="sudo apt install -y"
SNAP_EXEC="sudo snap install"
FLATPAK_EXEC="flatpak install flathub -y"
APP_IMAGES_FOLDER="Applications"
APP_IMAGE_EXEC="wget -P /home/$USER/$APP_IMAGES_FOLDER"

echo "install.sh" $@ "script, designed for elementary OS"

function parse_arguments {
    case $1 in
    "--help")
        print_help
        ;;
    # TODO:
    "--skip")
        set_skip $@
        ;;
    esac
}

function print_help {
    echo "Usage: bash install.sh [options] [packages list]"
    echo ""
    echo "Created for simple installation of packages"
    echo "Write list of necessary pakages in related .txt files and script will install them"
    echo ""
    echo "options:"
    echo "  --help - for printing this help message"
    echo "  --skip [list of packages names to ignore their installation] - specifies packages instalation of wich will be skipped"
    echo ""
    echo "This script will forse to use 'sudo' privileges"
    exit
}

function set_skip {
    echo "feature not implemented"
}

function install_pakages {
    echo "Installing" $1 "..."

    case $1 in
    "debs")
        file_name=$DEBS_FILE
        execute=$APT_EXEC
        ;;
    "snaps")
        file_name=$SNAPS_FILE
        execute=$SNAP_EXEC
        ;;
    "flatpaks")
        file_name=$FLATPAKS_FILE
        execute=$FLATPAK_EXEC
        ;;
    "appimages")
        file_name=$APP_IMAGES_FILE
        execute=$APP_IMAGE_EXEC
        mkdir -p "/home/$USER/Applications"
        ;;
    esac

    if [ -e $file_name ]
    then
        while IFS=, read -r package_name
        do
            eval "$execute $package_name" && echo $package_name "installed"
        done < "$file_name"
    fi
}

if [ $# -gt 0 ]
then
    parse_arguments $1
fi

echo -n "Install DEBs? [Y/n]: "
read install_debs

echo -n "Install snaps [Y/n]: "
read install_snaps

echo -n "Install flatpaks [Y/n]: "
read install_flatpaks

echo -n "Install AppImages [Y/n]: "
read install_appimages

if [ $install_debs == "Y" ] || [ $install_debs == "y" ]
then
    install_pakages "debs"
fi

if [ $install_snaps == "Y" ] || [ $install_snaps == "y" ]
then
    install_pakages "snaps"
fi

if [ $install_flatpaks == "Y" ] || [ $install_flatpaks == "y" ]
then
    install_pakages "flatpaks"
fi

if [ $install_appimages == "Y" ] || [ $install_appimages == "y" ]
then
    install_pakages "appimages"
fi

echo ""
echo "All Done!"
