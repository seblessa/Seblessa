# Paths needed in both interactive and non-interactive Zsh sessions.
typeset -U path
export VOLTA_HOME="$HOME/.volta"
path=("$VOLTA_HOME/bin" "$HOME/.local/bin" $path)
