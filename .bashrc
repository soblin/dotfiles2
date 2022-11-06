# from .bashrc
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# from .bash_aliases
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"
alias mkdir="mkdir -p"
alias tree='tree -I ".git|__pycache__|node_modules|.ipynb_checkpoints|build|gitignore"'
alias dc='cd'

alias gcm='git commit --signoff -m'
alias gst='git status -uall'
alias gck='git checkout'
alias gfp='git fetch --prune'
alias glg='git log --graph --oneline --decorate --all --pretty="format:%C(yellow)%h %C(cyan)%ad %C(green)%an%Creset%x09%s %C(red)%d%Creset"'
alias gls='git log -S'
alias glgrep='git log --grep'
alias gdf='git diff'
alias gdfs='git diff --staged'
function psgrep() {
    ps aux | grep "$1"
}

# .local/custom/bin
function e() {
    if ! emacsclient -nw $@; then
        emacs -q --daemon --load ~/.soblin/.emacs
        emacsclient -nw $@
    fi
}

function pbcopy() {
    temp_file=`tempfile`
    tmux save-buffer $temp_file
    xsel -i -b < $temp_file
    rm -rf $temp_file
}

function kill-emacs() {
    emacsclient -e "(kill-emacs)"
}

function tmux-soblin() {
    tmux -L soblin -f ~/.soblin/tmux.conf
}

# ROS2
#!/bin/bash

ROS2_VER="None"

if [ -d /opt/ros/foxy ]; then
    ROS2_VER="foxy"
elif [ -d /opt/ros/eloquent ]; then
    ROS2_VER="eloquent"
elif [ -d /opt/ros/dashing ]; then
    ROS2_VER="dashing"
elif [ -d /opt/ros/galactic ]; then
    ROS2_VER="galactic"
elif [ -d /opt/ros/humble ]; then
    ROS2_VER="humble"
fi

if [ "$ROS2_VER" != "None" ]; then
    if [ -f /opt/ros/${ROS2_VER}/setup.bash ]; then
        source /opt/ros/${ROS2_VER}/setup.bash
    fi

    source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash
    export RCUTILS_CONSOLE_OUTPUT_FORMAT="[{severity} {time}] [{name}]: {message}"
    export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
    export ROS_LOCALHOST_ONLY=1

    if [ ! -e /tmp/cycloneDDS_configured ]; then
	    sudo sysctl -w net.core.rmem_max=2147483647
	    sudo ifconfig lo multicast
	    touch /tmp/cycloneDDS_configured
    fi

    if command -v ccache &> /dev/null; then
        export CC=/usr/lib/ccache/gcc
        export CXX=/usr/lib/ccache/g++
        export USE_CCACHE=1
        export CCACHE_DIR=$HOME/.ccache
    fi

    colcon_all(){
        colcon build --symlink-install --continue-on-error --cmake-args -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    }

    colcon_select(){
        colcon build --packages-up-to $@ --cmake-args -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    }
fi
