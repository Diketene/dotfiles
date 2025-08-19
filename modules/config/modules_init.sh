#!/bin/zsh

[ -f /etc/profile.d/modules.sh ] && source /etc/profile.d/modules.sh

module use $HOME/dotfiles/modules/modulefiles
