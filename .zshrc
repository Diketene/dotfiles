# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

#clang的环境变量
export PATH=/usr/local/clang/bin:$PATH

#clang库文件的环境变量
export LD_LIBRARY_PATH=/usr/local/clang/lib/x86_64-unknown-linux-gnu/:$LD_LIBRARY_PATH

#gcc13.3.0的环境变量
export PATH=/gcc13.3.0/bin:$PATH

#gcc13.3.0库文件的环境变量
export LD_LIBRARY_PATH=/gcc13.3.0/lib64:$LD_LIBRARY_PATH

#为eigen3创建预处理C/C++代码时的头文件搜索路径
export CPATH=/usr/include/eigen3:$CPATH

#为mdspan创建预处理C/C++代码时的头文件搜索路径
export CPATH=$HOME/mdspan/include:$CPATH

#为boost设置头文件搜索路径
export CPATH=/boost/boost_1_86_0:$CPATH

#为boost设置库文件的环境变量
export LD_LIBRARY_PATH=/boost/boost_1_86_0/stage/lib:$LD_LIBRARY_PATH

#设置conda的环境变量
__conda_setup="$('/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup

#为libcint创建头文件搜索路径
export CPATH=/usr/local/include:$CPATH

#为libcint创建库文件环境变量
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
#

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="af-magic"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git 
         zsh-autosuggestions
         zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#为fdfind创建一个方便的关键词
alias fd='fdfind'

# 绑定 Ctrl+R 到 fzf 历史命令搜索
bindkey '^R' fzf-history-widget

function fzf-history-widget() {
    LBUFFER+="$(fc -l 1 | fzf --tac --query=${LBUFFER})"
    local ret=$?
    if [ $ret -eq 1 ]; then
        zle redisplay
    elif [ $ret -eq 0 ]; then
        zle .kill-whole-line
    fi
    zle clear-screen
}
zle -N fzf-history-widget

#添加rustup为环境变量
export PATH="$HOME/.cargo/bin:$PATH"

#broot安装的一个shell函数
source /home/diketene/.config/broot/launcher/bash/br

#为broot创建一个方便的关键词
alias br='broot'


#为mv -i创建一个方便的别名，使mv操作更安全
alias mv="mv -i"

#在打开zsh时即加载ssh-agent
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
     eval "$(ssh-agent -s)"
fi



