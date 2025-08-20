zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion:*:descriptions' format '%U%F{cyan}%d%f%u'

zstyle :compinstall filename '$HOME/.zshrc'

#fpath=("$HOME/.zprompts" "$fpath[@]")

autoload -Uz compinit promptinit
compinit
promptinit

source ~/.zsh/themes/raccoon.zsh-theme

#################
# Shell Configs #
#################

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd notify
setopt prompt_subst
setopt extended_glob
set -o ignoreeof
unsetopt beep
bindkey -v

########
# Path #
########

# common bin
path+=('$HOME/.local/bin')

#rust
path+=('$(rustc --print sysroot)/lib/rustlib/src/rust/library')
path+=('$HOME/.cargo/bin')

# c-sharp
path+=('$HOME/.dotnet')
path+=('$HOME/.dotnet/tools')

# haskell
path+=('$HOME/.cabal/bin')
path+=('$HOME/.ghcup/bin')

export PATH

#############
# Variables #
#############

export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR='nvim'

###########
# Aliases #
###########

# zshrc
alias reload="source $HOME/.zshrc"

# git aliases
#alias gl="git log --oneline --graph --max-count=20"
#alias gs="git status"
#alias gd="git diff"
#alias gpl="git pull"
#alias gp="git push"
#alias gaac="git add . && git commit -e"
#alias gaic="git add -i && git commit -e"
#alias grh="git reset --hard HEAD"
#alias grst="git reset HEAD -- ."

# neovide
n() {
    neovide $@ &
}

# paru
p() {
    # improve search result display
    paru --bottomup --limit 10 $@
}

# shadowing
alias ls="eza"
alias rm="rm -i"
alias mv="mv -i"
alias zz="clear"
alias cat="bat --theme Dracula"

# quick launch
alias rr="ranger"
alias rrcd='ranger --choosedir=$HOME/.rangerdir; cd "$()"; rm -f "$HOME/.rangerdir"'
alias ase="aseprite"
alias py="python"
alias davinci-resolve="prime-run /opt/resolve/bin/resolve"
alias browser="$DEFAULT_BROWSER"
alias g="git"

#################

confirm() {
    local answer
    print -Pn "%Bzsh%b: $* [%F{green}y%f/%F{red}N%f]? "
    read -q answer
    echo

    if [[ "${answer}" =~ ^[Yy]$ ]]
    then
        command "${@}"
    else
        return 1
    fi
}

poweroff() {
    confirm shutdown -P now
}

reboot() {
    confirm shutdown -r now
}

upgrade() {
    p -Syu && sudo mkinitcpio -P
}

# extracts files using it's extension to choose the right tool
# accepts multiple filenames as args
x() {
    for filename in "$@"
    do
        local ext="${filename##*.}"
        print -P "%F{magenta}->%f %Bextracting%b  $filename"

        case "$ext" in
            zip)
                unzip "$filename"
                ;;
            rar)
                #x_or_fallback unrar x "$filename"
                if unrar_loc="$(type -p "unrar")" && [[ $unrar_loc ]]
                then
                    unrar x "$filename"
                else
                    7z x "$filename"
                fi
                ;;
            gz)
                tar -xvzf "$filename"
                ;;
            bz2)
                tar -xvjf "$filename"
                ;;
            7z)
                7z x "$filename"
                ;;
            *)
                print -P "%B%F{red}extract%f%b  Extension %B$ext%b isn't supported."
                ;;
        esac
        echo
    done
}

#x_or_fallback() {
#    if x_loc="$(type -p "$1")" && [[ $x_loc ]]
#        # execute $1 $2 "$3"
#        return 0
#    fi
#
#    7z x "$filename"
#
#    if [[ "$@" == 0 ]]
#        # if fallback failed
#        print -P "%B%F{red}extract%f%b  Extension %B$ext%b isn't supported."
#        return 1
#    fi
#
#    return 0
#}

#################

fd_command="fd"

if [[ "$OSTYPE" == "win32" ]]
then
    alias fd=fdfind
    fd_command="fdfind"
fi

export FZF_DEFAULT_COMMAND="$fd_command --type file --hidden --follow --no-ignore-vcs --exclude .git"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

###############
# Keybindings #
###############

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# History Search

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

##########
# Others #
##########

# Dirstack

autoload -Uz add-zsh-hook

DIRSTACKFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/dirs"

if [ ! -d "${DIRSTACKFILE%dirs}" ]
then
    mkdir -p "${DIRSTACKFILE%dirs}"
fi

if [[ -f "$DIRSTACKFILE" ]] && (( ${#dirstack} == 0 )); then
	dirstack=("${(@f)"$(< "$DIRSTACKFILE")"}")
	[[ -d "${dirstack[1]}" ]] && cd -- "${dirstack[1]}"
fi
chpwd_dirstack() {
	print -l -- "$PWD" "${(u)dirstack[@]}" > "$DIRSTACKFILE"
}
add-zsh-hook -Uz chpwd chpwd_dirstack

DIRSTACKSIZE='20'

setopt AUTO_PUSHD PUSHD_SILENT PUSHD_TO_HOME

## Remove duplicate entries
setopt PUSHD_IGNORE_DUPS

## This reverts the +/- operators.
setopt PUSHD_MINUS

# Zoxide - A smarter cd
# https://github.com/ajeetdsouza/zoxide
eval "$(zoxide init zsh)"

# broot - A new way to see and navigate directory trees
# https://github.com/Canop/broot
source /home/luke/.config/broot/launcher/bash/br

# git diff before commit
function gg {
    br --conf ~/.config/broot/git-diff-conf.toml --git-status
}

GPG_TTY=$(tty)
export GPG_TTY
