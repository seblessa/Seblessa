# Restore my Mac setup

This guide restores my terminal configuration and the Homebrew software snapshot from **12 October 2026**. It supports the standard Homebrew paths on Apple Silicon and Intel Macs.

The [Brewfile](Brewfile) lists installed Homebrew tools and applications. It does not pin versions or restore app preferences, files, Python environments, Docker volumes, SSH access, or account sessions. Keep those in a private backup such as Time Machine.

## 1. Install Homebrew and clone this repo

Install Apple's Command Line Tools if they are missing:

```sh
xcode-select --install
```

Install [Homebrew](https://docs.brew.sh/Installation), then run the `brew shellenv` command shown by its installer:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Install GitHub CLI and clone using my account:

```sh
brew install gh
gh auth login --hostname github.com
gh auth switch --hostname github.com --user seblessa
gh repo clone seblessa/Seblessa "$HOME/Seblessa"
```

If the checkout already exists, use `git -C "$HOME/Seblessa" status --short` and inspect local changes before updating it.

## 2. Install applications and tools

For just the terminal setup:

```sh
brew install btop fastfetch cloudflared gitleaks
brew install --cask hyper visual-studio-code
```

To restore the full Homebrew software list instead:

```sh
brew bundle install --file="$HOME/Seblessa/Brewfile" --no-upgrade
```

Review the Brewfile first: it also includes large applications such as MacTeX, Blender, and Docker Desktop. Availability can change; resolve retired packages individually. `--no-upgrade` leaves existing versions in place. No cleanup or uninstall command is needed.

## 3. Install Oh My Zsh, plugins, and theme

Zsh is the default shell on recent macOS versions. If the account uses another shell, change it with `chsh -s /bin/zsh`.

Install [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) while preserving any existing `.zshrc`:

```sh
KEEP_ZSHRC=yes CHSH=no RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Install the two plugins used by this configuration and the theme:

```sh
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git \
  "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
git clone --depth=1 https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
  "$HOME/.oh-my-zsh/custom/plugins/fast-syntax-highlighting"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
```

Skip installation commands for directories that already exist. The `git` plugin ships with Oh My Zsh. A second syntax-highlighting plugin is unnecessary.

## 4. Back up and apply the configuration

Run the following in Zsh. It saves existing files before replacing them:

```zsh
backup_dir="$HOME/.config-backups/seblessa-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"
chmod 700 "$backup_dir"

for file in .zshenv .zprofile .zshrc .p10k.zsh .hyper.js; do
  if [[ -f "$HOME/$file" ]]; then
    cp -p "$HOME/$file" "$backup_dir/$file"
  fi
  cp "$HOME/Seblessa/$file" "$HOME/$file"
done

# Hyper prefers its application-directory config when that file exists.
hyper_config="$HOME/Library/Application Support/Hyper/.hyper.js"
if [[ -f "$hyper_config" ]]; then
  cp -p "$hyper_config" "$backup_dir/hyper-app.js"
  cp "$HOME/Seblessa/.hyper.js" "$hyper_config"
fi
```

The [Hyper configuration documentation](https://hyper.is/#cfg) explains its two config locations. The home-directory copy remains useful as the public backup source.

Open a new terminal window to load the shell files. Restart Hyper after finishing running commands to apply all terminal settings, including ⌘+click for links. Hyper installs `hyper-transparent` from the `plugins` list automatically; it may need network access and a reload.

The default font is Menlo. If Powerlevel10k symbols look wrong, follow its [font instructions](https://github.com/romkatv/powerlevel10k#fonts), select the installed font in `.hyper.js`, and sync that change back to this repo.

To roll back, copy the saved shell files from `backup_dir` to the home directory. If `hyper-app.js` exists, restore it to Hyper's application-directory config too.

## 5. Python and Node.js

The shell only initialises Conda and micromamba when their executables are available. The software snapshot includes Miniconda; micromamba is optional.

To match the current Conda behaviour, which does not activate `base` in every new terminal:

```sh
conda config --set auto_activate_base false
```

The snapshot includes `uv` and Homebrew Node.js. Volta is installed separately on my current Mac; to use it on a new machine, follow the [Volta installation guide](https://docs.volta.sh/guide/getting-started), then install the project-required Node.js version with `volta install node@VERSION`.

Project dependencies and Python environments must be restored from each project's manifests. The `pip` alias uses `python3 -m pip` so it follows the active Python environment.

## 6. Private and machine-specific settings

Put credentials and private overrides in `~/.zshrc.local`. It is loaded at the end of `.zshrc` and ignored by Git:

```sh
touch "$HOME/.zshrc.local"
chmod 600 "$HOME/.zshrc.local"
```

Keep tokens out of the public files and command arguments. Do not copy `.ssh`, cloud credentials, `.env` files, or shell history into this repo. Ignore rules do not remove files already tracked or secrets in old commits; any credential published in Git must be revoked or rotated.

Restore these separately when needed:

- GitHub and cloud sign-ins, with the intended accounts.
- The private SSH configuration for `sebs-macmini`, used by `screen_share_ooh`.
- iCloud and OneDrive sync before using the `icloud` and `fcup` aliases. The university OneDrive folder name may need a local override.
- Docker Desktop, JetBrains Toolbox, and helper commands installed outside Homebrew. Missing optional command directories do not stop the shell from starting.

## 7. Everyday shortcuts

| Shortcut or command | Action |
| --- | --- |
| ⌘F in Hyper | Search terminal output. |
| ⌘D / ⌘⇧D in Hyper | Split right / down. |
| ⌘+click in Hyper | Open a link. |
| Ctrl-R | Search command history. |
| Start typing, then ↑ / ↓ | Search matching history. |
| Ctrl-X, Ctrl-E | Edit the current command in VS Code. |
| `status` / `me` | Open btop / show system information. |
| `storage` | Show sizes of visible and hidden items in the current directory. |
| `zshconfig`, `themeconfig`, `hyperconfig` | Edit the corresponding configuration. |
| `open_port 3000` | Publish a temporary HTTP tunnel to localhost:3000; Ctrl-C stops it. |
| `brew_update` | Update Homebrew, upgrade packages, and clean old package downloads. |

`open_port` makes the local service reachable from the internet. Use it only for services you intend to share. Ports must be between 1 and 65535.

## 8. Update the public backup

Copy the five home-directory files back into the checkout. If you edited Hyper's application-directory file, use that as the source for `.hyper.js` instead.

```zsh
for file in .zshenv .zprofile .zshrc .p10k.zsh .hyper.js; do
  cp "$HOME/$file" "$HOME/Seblessa/$file"
done
hyper_config="$HOME/Library/Application Support/Hyper/.hyper.js"
[[ ! -f "$hyper_config" ]] || cp "$hyper_config" "$HOME/Seblessa/.hyper.js"
```

Refresh the software snapshot when applications change:

```sh
brew bundle dump --file="$HOME/Seblessa/Brewfile" --force --no-describe --no-restart \
  --no-mas --no-vscode --no-go --no-cargo --no-uv --no-npm --no-krew --no-flatpak --no-winget
```

Review and scan before publishing:

```sh
cd "$HOME/Seblessa"
zsh tests/check.zsh
git diff --check
git diff --stat
gitleaks dir . --redact --no-banner
```

Only continue if the scan exits successfully and the diff contains the intended public changes:

```sh
git add .hyper.js .p10k.zsh .zshenv .zprofile .zshrc .gitignore Brewfile README.md init.md tests/check.zsh
git diff --cached
git commit -m "Update Mac configuration backup"
git push origin main
```

A Gitleaks scan reduces risk; it does not replace reviewing the diff. Scanning current files also does not clear credentials from Git history. Keep private backups outside this public checkout.
