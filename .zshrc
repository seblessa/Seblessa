# Keep instant prompt before anything that can print to the terminal.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

typeset -U path fpath
path=("$HOME/.codex/bin" "$HOME/.antigravity/antigravity/bin" "$HOME/bin" "$HOME/.local/bin" /usr/local/bin $path)
export EDITOR='code --wait'
export VISUAL="$EDITOR"

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME='powerlevel10k/powerlevel10k'
plugins=(git zsh-autosuggestions fast-syntax-highlighting)
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 14
COMPLETION_WAITING_DOTS=true
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#7F899B'
[[ ! -d "$HOME/.docker/completions" ]] || fpath=("$HOME/.docker/completions" $fpath)

if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
  FAST_HIGHLIGHT_STYLES[path]='fg=#F08080'
  FAST_HIGHLIGHT_STYLES[path-to-dir]='fg=#F08080,underline'
fi
[[ ! -r "$HOME/.p10k.zsh" ]] || source "$HOME/.p10k.zsh"

# Share a local HTTP service through a temporary public Cloudflare tunnel.
open_port() {
  if [[ $# != 1 || $1 != <1-65535> ]]; then
    print -u2 'Usage: open_port <port from 1 to 65535>'
    return 2
  fi
  print "Opening a public tunnel to localhost:$1. Stop it with Ctrl-C."
  cloudflared tunnel --url "http://localhost:$1"
}

alias screen_share_ooh='ssh -N -L 5900:localhost:5900 sebs-macmini'
alias icloud='cd "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Documents"'
alias fcup='cd "$HOME/OneDrive - Universidade do Porto"'
alias zshconfig='code ~/.zshrc'
alias themeconfig='code ~/.p10k.zsh'
alias hyperconfig='code ~/.hyper.js'
alias status='btop'
alias me='fastfetch'
alias python='python3'
alias pip='python3 -m pip'
alias brew_update='brew update && brew upgrade && brew cleanup'
alias storage='du -sh -- *(DN) 2>/dev/null | sort -hr'
alias la='ls -a'

# Initialise environment managers only when installed.
if (( $+commands[conda] )); then
  if _conda_hook="$(command conda shell.zsh hook 2>/dev/null)"; then
    eval "$_conda_hook"
  elif [[ -r "${commands[conda]:A:h:h}/etc/profile.d/conda.sh" ]]; then
    source "${commands[conda]:A:h:h}/etc/profile.d/conda.sh"
  fi
  unset _conda_hook
fi
if (( $+commands[micromamba] )); then
  export MAMBA_EXE="${commands[micromamba]}"
  export MAMBA_ROOT_PREFIX="$HOME/.local/share/mamba"
  if _mamba_hook="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2>/dev/null)"; then
    eval "$_mamba_hook"
  else
    alias micromamba="$MAMBA_EXE"
  fi
  unset _mamba_hook
fi

# Machine-specific settings and credentials stay outside this public repo.
[[ ! -r "$HOME/.zshrc.local" ]] || source "$HOME/.zshrc.local"
