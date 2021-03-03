# Paths
PATH=$PATH:~/.cargo/bin
EDITOR=/usr/bin/nvim

# Aliases
alias pv=$HOME/source/paraview/install/bin/paraview
alias cda="conda activate"
alias cdd="conda deactivate"
alias mkv2gif="ffmpeg -f gif output.gif -i"
alias mkv2mp4="ffmpeg -f mp4 output.mp4 -i"
alias ls=exa
alias cat=bat
alias find=fd
alias du=dust

# Starship
eval "$(starship init zsh)"

# added by Anaconda3 5.3.1 installer
# >>> conda init >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$(CONDA_REPORT_ERRORS=false '/home/guillaume/source/anaconda3/bin/conda' shell.bash hook 2> /dev/null)"
if [ $? -eq 0 ]; then
    \eval "$__conda_setup"
else
    if [ -f "/home/guillaume/source/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/guillaume/source/anaconda3/etc/profile.d/conda.sh"
        CONDA_CHANGEPS1=false conda activate base
    else
        \export PATH="/home/guillaume/source/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda init <<<
