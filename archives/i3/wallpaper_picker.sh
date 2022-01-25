#!/bin/bash

files=(~/Pictures/Wallpapers/*)
echo ${files[RANDOM % ${#files[@]}]} | xargs -I file ln -s -f file ~/.i3/wallpaper
exit 0
