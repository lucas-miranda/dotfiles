# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH


path+=('/home/luke/.cargo/bin')
path+=('/home/luke/.local/bin')
path+=('/home/luke/.dotnet/tools')
export PATH

export XDG_CONFIG_HOME="/home/luke/.config"

# Path to your oh-my-zsh installation.
export ZSH="/home/luke/.oh-my-zsh"

# Good Themes:
# - Avit
ZSH_THEME="spaceship"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
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
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    # vi-mode
    git-extras
    extract
    web-search
    wd
    grimoire
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='nvim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# git aliases
alias gl="git log --oneline --graph --max-count=20"
alias gs="git status"
alias gd="git diff"
alias gpl="git pull"
alias gp="git push"
alias gaac="git add . && git commit -e"
alias gaic="git add -i && git commit -e"
alias grh="git reset --hard HEAD"
alias grst="git reset HEAD -- ."

# shadowing
alias ls="exa"
alias rm="rm -i"
alias mv="mv -i"
alias zz="clear"

# quick launch
alias rr="ranger"
alias rrcd='ranger --choosedir=$HOME/.rangerdir; cd $(cat $HOME/.rangerdir); rm -f "$HOME/.rangerdir"'
alias ase="aseprite"
alias py="python"
alias davinci-resolve="prime-run /opt/resolve/bin/resolve"

#################

fd_command="fd"

if [[ "$OSTYPE" == "win32" ]]
then
    alias fd=fdfind
    fd_command="fdfind"
fi

export FZF_DEFAULT_COMMAND="$fd_command --type file --hidden --follow --no-ignore-vcs --exclude .git"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# kitty specifics
#autoload -Uz compinit
#compinit
# Completion for kitty
#~/.local/kitty.app/bin/kitty + complete setup zsh | source /dev/stdin
