#!/bin/sh

echo -n '' > $AUTO_UPDATE_FILE

excludePath=$HOME/dotfiles
excludeFileName='.exclude'
excludeFile=$excludePath/$excludeFileName
excludeList=$(cat $excludeFile)
args="-I $excludeFile "
for i in $excludeList
do
  args+=$(echo -n '-I' $i' ')
done

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
    echo $current
    echo $current >> $AUTO_UPDATE_FILE
  fi
done
