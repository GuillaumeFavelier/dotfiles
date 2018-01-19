#!/usr/bin/zsh

export DISPLAY=:0

hour=$(date +%H)
data_path=$HOME/dotfiles/.data/firewatch

if [ $hour -ge 5 ] && [ $hour -lt 11 ]
then
  nitrogen --set-zoom-fill $data_path/firewatch_morning.jpg
elif [ $hour -ge 11 ] && [ $hour -lt 19 ]
then
  nitrogen --set-zoom-fill $data_path/firewatch_afternoon.jpg
else
  nitrogen --set-zoom-fill $data_path/firewatch_night.jpg
fi
