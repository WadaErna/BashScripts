#!/bin/bash

ERR_ARGS=128 #Insuficient Args
SUCCESS=0 

DIR=~/.config/awesome/themes/Nath/icons/colors/
COLOR=$1

fncConvert(){
    for i in $DIR*.xbm; 
        do convert -bordercolor transparent\
        -border 5x5 -fill "#$COLOR" -opaque "#000000"\
        -transparent "#FFFFFF" -gravity center\
        -crop 15x15+0+0 "${i}" "${i%.*}.png"; 
    done
}

if [ "$#" -eq 0 ]; then
    printf "Insuficient args.\n"
    printf "%d\n" "$#"
    exit $ERR_ARGS
else
    fncConvert
    exit $SUCCESS
fi
