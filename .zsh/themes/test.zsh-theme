prompt_line() {
    # Expands to current path
    CUR_PATH=${(%):-%~}

    echo "$CUR_PATH "
}

setprompt() {
    PROMPT=$(printf '$(prompt_line)')
}

setprompt

# vim: set filetype=zsh:
