#!/usr/bin/zsh

## Configuration variables ##
# path to the data
data_path=$HOME/dotfiles/.data/firewatch
# name of the wallpaper files
data_list=(firewatch_morning.jpg firewatch_afternoon.jpg firewatch_night.jpg)

# get the current hour
hour=$(date +%H)

# hours of the day (end_of_night midday beginning_of_night)
timeframe=(6 12 18)

# make display available
DBUS_SESSION_BUS_ADDRESS=$(ps -u $(id -u) -o pid= | while read pid; do
  cat /proc/$pid/environ 2>/dev/null | tr '\0' '\n' | grep '^DBUS_SESSION_BUS_ADDRESS';
done | sort -u | grep user | grep -v ,)
export DBUS_SESSION_BUS_ADDRESS=${DBUS_SESSION_BUS_ADDRESS#*=}

# cmd that changes the background
cmd='nitrogen --set-zoom-fill'

if [ $hour -ge ${timeframe[1]} ] && [ $hour -lt ${timeframe[2]} ]
then
  eval $cmd $data_path/${data_list[1]}
elif [ $hour -ge ${timeframe[2]} ] && [ $hour -lt ${timeframe[3]} ]
then
  eval $cmd $data_path/${data_list[2]}
else
  eval $cmd $data_path/${data_list[3]}
fi
