#!/usr/bin/zsh

## Configuration variables ##
waitingTime='300'
enableNotification='yes'
autoUpdateFile='/tmp/auto_update.log'
autoUpdateLock='/tmp/auto_update.lock'
sourcePath=$HOME'/source'
excludeFile=$HOME'/dotfiles/.exclude'

if [[ $# -gt '0' ]] && [[ $1 = '--scan' ]]
then
  ## Start update detection system ##

  # make display available
  if [ $enableNotification = 'yes' ]
  then
    export DISPLAY=$(ps -u $(id -u) -o pid= | \
      while read pid; do
        cat /proc/$pid/environ 2>/dev/null | tr '\0' '\n' | grep '^DISPLAY=:'
      done | grep -o ':[0-9]*' | sort -u)

      notify-send -u low 'System' 'Checking source packages...'
    fi

    echo -n '' > $autoUpdateFile

    if [ -f $excludeFile ]
    then
      for i in $(cat $excludeFile)
      do
        args+=$(echo -n '-I' $i' ')
      done
    fi

    packageList=''

    # remove all fancy options on ls
    ls_cmd='\ls '$sourcePath' '$args
    for i in $(eval $ls_cmd)
    do
      current=$sourcePath/$i

      # move to the target directory
      cd $current

      if [ ! -d '.git' ]
      then
        if [ -d 'source' ]
        then
          current=$current'/source'
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
        echo $current >> $autoUpdateFile
      elif [ -f 'PKGBUILD' ]
      then
        pkgname=$(makepkg --printsrcinfo | grep 'pkgname =' | cut -f 2 -d =)

        # AUR: updated but check if installed
        ret=$(pacman -Q ${pkgname/ /})
        if [ $? -ne '0' ]
        then
          packageList+=$i' '
          echo $current >> $autoUpdateFile
        fi
      fi
    done

    toNotify=$(wc -l $autoUpdateFile | cut -f1 -d \  )
    if [[ $toNotify -gt '0' ]] && [[ $enableNotification = 'yes' ]]
    then
      notify-send -u normal 'System update' 'Custom Packages: '$packageList
    fi

    nbupdates=$(checkupdates | wc -l)
    if [[ $nbupdates -gt '0' ]] && [[ $enableNotification = 'yes' ]]
    then
      notify-send -u normal 'System update' 'Base packages: '$nbupdates
    fi
  else
    # detect if being sourced
    if [[ $_ != $0 ]] && [[ $_ != $SHELL ]]
    then
      ## Start auto-update system ##
      if [[ ! -f $autoUpdateLock ]] && [[ -f $autoUpdateFile ]]
      then
        packages=$(cat $autoUpdateFile 2> /dev/null)
        numberOfUpdates=$(wc -l $autoUpdateFile 2> /dev/null | cut -f1 -d\ )
        if [ $numberOfUpdates -ge 1 ]; then
          auto_update_answer=""
          echo $packages
          echo -n 'The packages above need to be updated, do you want to proceed? [y/n] : '
          read auto_update_answer
          if [ $auto_update_answer = 'y' ]
          then
            saved_dir=$(pwd)

            for package in $(cat $autoUpdateFile); do
              cd $package

              # AUR build
              if [ -f 'PKGBUILD' ]; then
                git pull origin master
                makepkg -si
              else
                git pull
                git submodule update --init

                # project with CMakeLists.txt
                name=${PWD##*/}
                if [[ $name == 'source' ]] && [[ -f 'CMakeLists.txt' ]]
                then
                  # move to build directory
                  cd ../build

                  # build with ninja
                  if [ -f 'build.ninja' ]
                  then
                    ninja install
                  elif [ -f 'Makefile' ]
                  then
                    ncores=$(grep -c 'processor' /proc/cpuinfo)
                    make -j $ncores && make install
                  fi
                fi
              fi
            done

            # return to original directory
            cd $saved_dir
          elif [ $auto_update_answer = 'n' ]
          then
            touch $autoUpdateLock

            if [ $enableNotification = 'yes']
            then
              notify-send -u low 'System' "packages auto-install delayed for $waitingTime s."
            fi
            (sleep $waitingTime && rm -f $autoUpdateLock 2> /dev/null)&
          fi
        fi

        echo -n '' > $autoUpdateFile
      fi
    fi
  fi
