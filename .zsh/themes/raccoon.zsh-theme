# TODO
# - Handle command result display (err or ok)
# - Display git status and info

setup_git_prompt() {
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1
    then
        unset GIT_PROMPT
        unset GIT_PROMPT_STYLIZED
        return 0
    fi

    local branch_name="${$(git symbolic-ref HEAD 2>/dev/null)#refs/heads/}"
    local repo_name="$(basename $(git rev-parse --show-toplevel))"

    if [[ ${#branch_name} -gt 0 ]]
    then
        # with branch
        GIT_PROMPT="$repo_name [$branch_name]"
        GIT_PROMPT_STYLIZED="%F{magenta}$repo_name%f  %B$branch_name%b"

        return 0
    fi

    # without branch
    GIT_PROMPT="$repo_name detached"
    GIT_PROMPT_STYLIZED="%F{magenta}$repo_name%f  detached"
}

precmd() {
    # Expands to current path
    CUR_PATH=${(%):-%~}

    # Calculate terminal available width
    local AVAILABLE_SPACE
    (( AVAILABLE_SPACE = ${COLUMNS} - 1 ))

    TERM_WIDTH=$AVAILABLE_SPACE

    # Additional setups
    setup_git_prompt
}

setup_info_left_side() {
    if [[ ${#GIT_PROMPT} -gt 0 ]]
    then
        LSIDE="$GIT_PROMPT"
        LSIDE_STYLIZED="$GIT_PROMPT_STYLIZED%f"
    else
        # name@machine
        LSIDE="${(%):-%n@%m}"
        LSIDE_STYLIZED='%F{yellow}%n%f@%F{magenta}%m%f'
    fi
}

info_line() {
    RSIDE="$CUR_PATH"
    RSIDE_STYLIZED="%F{blue}$CUR_PATH%f"

    setup_info_left_side

    # Fill the gap between left side and right side
    local FILL_CHAR=" "
    local FILL_WIDTH=$(( $TERM_WIDTH - (${#RSIDE} + ${#LSIDE}) ))
    local FILL="\${(l.${FILL_WIDTH}..${FILL_CHAR}.)}"

    echo $LSIDE_STYLIZED${(e)FILL}$RSIDE_STYLIZED
}

prompt_line() {
    #echo '%F{magenta}%Bλ%b%f '
    # TODO  check if terminal supports emoji
    echo '🦝 '
}

setprompt() {
    PROMPT=$(printf '%s\n%s' '$(info_line)' '$(prompt_line)')
}

setprompt

# vim: set filetype=zsh:
