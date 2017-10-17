#!/bin/zsh

src_img=/tmp/screenshot.png
blur_img=/tmp/screenshot_blur.png
final_img=/tmp/screenshot_final.png

scrot $src_img
convert $src_img -blur 0x5 $blur_img
convert $blur_img ~/dotfiles/.data/lock.png -gravity center -composite -matte $final_img
i3lock -i $final_img
