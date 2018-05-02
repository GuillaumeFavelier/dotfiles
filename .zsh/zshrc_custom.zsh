### User config ###

# add home bin to the PATH
export PATH=$HOME/bin:$PATH

# add cargo to the PATH
export PATH=$PATH:$HOME/.cargo/bin

### User variables ###
# Source directory
export SRC_PATH=$HOME/source

# TTK variables
#export TTK_PATH=$SRC_PATH/ttk/ttk-guillaume/source

# ParaView variables
PV_PATH=$SRC_PATH/paraview
export PV_PLUGIN_PATH=$PV_PATH/plugins
export ParaView_DIR=$PV_PATH/build

# VTK variables
export VTK_DIR=$SRC_PATH/vtk/build

# Firefox central variable
export MOZCONFIG=$HOME/.mozconfig

### User aliases ###
alias emacs='emacs -nw'
alias paraview=$PV_PATH'/install/bin/paraview'
alias pvpython=$PV_PATH'/install/bin/pvpython'
alias docker_cleanc='docker rm $(docker ps -a -q)'
alias docker_cleani='docker rmi $(docker images -q -f dangling=true)'
alias docker_deli='docker rmi $(docker images -q)'

### Auto-updated sources ###
source $HOME/dotfiles/.script/update.sh

### GNU Screen ###
source $HOME/dotfiles/.script/screen.sh
