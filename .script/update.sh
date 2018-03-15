#!/usr/bin/zsh

# make display available
export DISPLAY=:0

notify-send 'checking source packages...'

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
for i in $(ls $SRC_PATH $args)
do
  current=$SRC_PATH/$i

  # move to the target directory
  cd $current

  if [ ! -d .git ]; then
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
  if [ $? -ne 0 ]
  then
    echo 'Error: problem during refs tracking.'
    continue
  fi

  res=$(git rev-parse --abbrev-ref HEAD)
  if [ $res != 'master' ]
  then
    echo 'Error: not on master.'
    continue
  fi

  # check if updates available
  res=$(git status -uno)

  if [[ $res = *"behind"* ]] && [[ $res = *"fast-forward"* ]]
  then
    packageList+=$i' '
    echo $current >> $AUTO_UPDATE_FILE
  fi
done

toNotify=$(wc -l $AUTO_UPDATE_FILE | cut -f1 -d \  )
if [ $toNotify -gt 0 ]
then
  notify-send $packageList
fi
