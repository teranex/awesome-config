#!/bin/sh

export DISPLAY=":0.0"

wallpapers=~/Pictures/wallpapers
image=`ls $wallpapers | sort -R | tail -n1`
feh --bg-fill "$wallpapers/$image"
