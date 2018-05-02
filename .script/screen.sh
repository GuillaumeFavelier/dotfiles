#!/usr/bin/zsh

## Configuration variables ##
# store the screen sessions in here
sessionPath=$HOME/.screen/sessions

# detect if being sourced
if [[ $_ != $0 ]] && [[ $_ != $SHELL ]]
then
  # detect if gnu screen is used
  if [[ $TERM =~ 'screen' ]]
  then
    screen_parsed_file=${STY#[0-9]*.}
    screen_session_file=$sessionPath/$screen_parsed_file
    if [ -f $screen_session_file ]
    then
      if [ ! -f /tmp/$STY ]
      then
        screen_load_answer=""
        echo -n '['$screen_parsed_file'] session file detected, do you want to load it? [y/n] : '
        read screen_load_answer
        if [ $screen_load_answer = "y" ]
        then
          clear
          screen -X source $screen_session_file
          touch /tmp/$STY
        fi
      fi
    fi
  fi
fi
