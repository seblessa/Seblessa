#!/bin/zsh
set -e
repo_dir=${0:A:h:h}

for file in .zshenv .zprofile .zshrc .p10k.zsh; do
  zsh -n "$repo_dir/$file"
done
node --check "$repo_dir/.hyper.js"

# Test the real function with a mock: never start a public tunnel.
eval "$(sed -n '/^open_port() {/,/^}/p' "$repo_dir/.zshrc")"
cloudflared() { tunnel_args=("$@"); }

for value in '' 0 65536 -1 abc '80 90' '80;false' '$(false)' 999999999999999999999999999999; do
  tunnel_args=()
  if open_port "$value" >/dev/null 2>&1; then
    print -u2 "Accepted an invalid port: $value"
    exit 1
  fi
  (( ${#tunnel_args} == 0 ))
done
if open_port >/dev/null 2>&1 || open_port 80 90 >/dev/null 2>&1; then
  print -u2 'Accepted an invalid argument count'
  exit 1
fi

for value in 1 3000 65535; do
  tunnel_args=()
  open_port "$value" >/dev/null
  [[ ${#tunnel_args} == 3 && $tunnel_args[1] == tunnel && $tunnel_args[2] == --url && $tunnel_args[3] == "http://localhost:$value" ]]
done
print 'Configuration syntax and public-tunnel input validation passed.'
