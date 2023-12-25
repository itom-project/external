#!/bin/bash
# This script overload the dynamic library path.
# Please run it as superuser exclusively

#export HISTIGNORE='*sudo -S*'
#echo "<your_password>" | sudo -S -k whoami

if [ "$(whoami)" != "root" ]
then
    sudo -s "$0" "$@"
    #sudo su -s "$0" "$1"
    exit
else
    ICF=/etc/ld.so.conf.d/ITOM.conf #itom configuration path

    echo $ICF
    #echo ADD $1 to environment

    if ! test -f "$ICF"
        then
            echo "Created File: $ICF"
            > "$ICF"
            
    fi

    # Append Args to the file
    for var in "$@"
    do
        if ! grep -Fxq "$var" $ICF
        then
            echo "--   Added to PATH Environment"
            echo "$var" >> "$ICF"
        fi
    done

fi

ldconfig