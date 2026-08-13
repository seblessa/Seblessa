# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi



# KEYS

export BINANCE_API_KEY="5pqcnojKWa86Cj9hSLMfPqZficozS86CcNXCOx3xV4n4EHk5spp8RH0F78ry7OAc"
export BINANCE_API_SECRET="0xqsuNnP9sp57zZFLib4Be5Cekthv70YybyhhCnyBOjShjIEMofByKP7ozjjA633"


# ALIAS

alias start-n8n="tmux new-session -d -s n8n-session '~/Documents/Projects/n8n-local/start-n8n.sh'"
alias stop-n8n='tmux kill-session -t n8n-session'

alias reverse_tunnel_ollama="ssh -R 11434:localhost:11434 seb@89.114.122.40 -p 2223"


alias dcup="docker compose up --build -d"
alias dcclean="docker compose build --no-cache"
alias dcdown="docker compose down -v"
alias dcreload="dcdown && dcup"
alias dclogs="docker compose logs -f"

alias dcrm='docker stop $(docker ps -q) && docker rm $(docker ps -aq)'


alias git_sync_main="git push && git checkout main && git merge dev && git push && git checkout dev"


alias dchelp='echo "
Available Docker aliases:
  dcup      → docker compose up --build -d
  dcclean   → docker compose build --no-cache
  dcdown    → docker compose down -v
  dcreload  → dcdown && dcup
  dcrm      → docker stop \$(docker ps -q) && docker rm \$(docker ps -aq)
"'

open_port() {
  if [ -z "$1" ]; then
    echo "Usage: open_port <port>"
    return 1
  fi
  echo "Opening port $1 to the internet..."
  cloudflared tunnel --url http://localhost:$1
}


alias screen_share_ooh="ssh -N -L 5900:localhost:5900 sebs-macmini"

alias icloud='cd "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Documents"'

alias zshconfig="code ~/.zshrc"
alias themeconfig="code ~/.p10k.zsh"
alias hyperconfig="code ~/.hyper.js"
alias fcup="cd ~/OneDrive\ -\ Universidade\ do\ Porto"
alias status="sudo btop"
alias me="fastfetch"

alias python="python3"
alias pip="pip3"

alias brew_update="brew update && brew upgrade && brew cleanup"
alias storage="du -sh .[!.]* * 2>/dev/null | sort -hr"
alias la="ls -a"


export WEBOTS_HOME="/Applications/Webots.app/Contents"
export PATH="$WEBOTS_HOME/bin:$PATH"
export PYTHONPATH="$WEBOTS_HOME/lib/controller/python3.9"



# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

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
zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 1

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
COMPLETION_WAITING_DOTS="true"

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
plugins=(
git
zsh-autosuggestions
zsh-syntax-highlighting
fast-syntax-highlighting)

# Custom colors for autosuggestions and path highlighting.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#c7ced8'

source $ZSH/oh-my-zsh.sh

FAST_HIGHLIGHT_STYLES[path]='fg=#ff8a80'
FAST_HIGHLIGHT_STYLES[path-to-dir]='fg=#ff8a80,underline'

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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'micromamba shell init' !!
export MAMBA_EXE='/opt/homebrew/bin/micromamba';
export MAMBA_ROOT_PREFIX='/Users/seb/.local/share/mamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from micromamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/seb/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

# Added by Antigravity
export PATH="/Users/seb/.antigravity/antigravity/bin:$PATH"

# Local Codex helper commands
export PATH="$HOME/.codex/bin:$PATH"
