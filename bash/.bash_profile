export PATH="~/.local/bin/lvim"export PATH="$PATH:/Users/ezramagaram/.local/bin/lvim"
export PATH="$PATH:/Users/ezramagaram/.local/bin"
export PATH="$PATH:/Users/ezramagaram/.local/bin"
. "$HOME/.cargo/env"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/ezramagaram/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/ezramagaram/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/ezramagaram/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/ezramagaram/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

