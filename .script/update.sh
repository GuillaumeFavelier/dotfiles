#!/usr/bin/zsh

# make display available
export DISPLAY=$(ps -u $(id -u) -o pid= | \
  while read pid; do
    cat /proc/$pid/environ 2>/dev/null | tr '\0' '\n' | grep '^DISPLAY=:'
  done | grep -o ':[0-9]*' | sort -u)

notify-send -u low 'System' 'Checking source packages...'

# upgrade environment
source $HOME/.zshrc

echo -n '' > $AUTO_UPDATE_FILE

excludePath=$HOME/dotfiles
excludeFileName='.exclude'
excludeFile=$excludePath/$excludeFileName
for i in $(cat $excludeFile)
do
  args+=$(echo -n '-I' $i' ')
done

packageList=''

# remove all fancy options on ls
alias ls=ls
ls_cmd='ls '$SRC_PATH' '$args
for i in $(eval $ls_cmd)
do
  current=$SRC_PATH/$i
  echo $current

  # move to the target directory
  cd $current

  if [ ! -d '.git' ]; then
    if [ -d 'source' ]; then
      current=$current/source
      cd $current
    else
      echo 'Error: neither a source directory or a git repository.'
      continue
    fi
  fi

  # update tracking refs
  ret=$(git remote update)
  if [ $? -ne '0' ]
  then
    echo 'Error: problem during refs tracking.'
    continue
  fi

  ret=$(git rev-parse --abbrev-ref HEAD)
  if [ $ret != 'master' ]
  then
    echo 'Error: not on master.'
    continue
  fi

  # check if updates available
  ret=$(git status -uno)

  if [[ $ret = *"behind"* ]] && [[ $ret = *"fast-forward"* ]]
  then
    packageList+=$i' '
    echo $current >> $AUTO_UPDATE_FILE
  elif [ -f 'PKGBUILD' ]
  then
    pkgname=$(makepkg --printsrcinfo | grep 'pkgname =' | cut -f 2 -d =)

    # AUR: updated but check if installed
    ret=$(pacman -Q ${pkgname/ /})
    if [ $? -ne '0' ]
    then
      packageList+=$i' '
      echo $current >> $AUTO_UPDATE_FILE
    fi
    echo $ret
  fi
done

toNotify=$(wc -l $AUTO_UPDATE_FILE | cut -f1 -d \  )
if [ $toNotify -gt '0' ]
then
  notify-send -u normal 'System update' 'Custom Packages: '$packageList
fi

nbupdates=$(checkupdates | wc -l)
if [ $nbupdates -gt '1' ]
then
  notify-send -u normal 'System update' 'Base packages: '$nbupdates
fi
