# Homebrew on Apple Silicon or Intel Macs.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Docker Desktop and JetBrains Toolbox add their commands here.
path+=("$HOME/.docker/bin" "$HOME/Library/Application Support/JetBrains/Toolbox/scripts")
