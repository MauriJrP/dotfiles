# 🛠️ Dotfiles

My personal macOS/Linux dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/) and a [Makefile](Makefile).  
This repo makes it easy to bootstrap a new machine with all my terminal tooling and configs.

---

## 📦 What’s inside

- **zsh** → [oh-my-zsh](https://ohmyz.sh/) with plugins (`zsh-autosuggestions`, `zsh-syntax-highlighting`, `you-should-use`), fzf widgets, pyenv/nvm integration.
- **tmux** → custom config with `Ctrl+Space` as prefix, mouse tweaks, TPM plugins (`tmux-sensible`, `tmux-resurrect`), centered status bar.
- **nvim** → [NvChad](https://nvchad.com/) + custom layer.
- **ghostty** → terminal config (font, padding, dark theme, keybinds).
- **git** → global `.gitconfig` with aliases, delta for diffs.
- **brew** → all CLI tools + apps via Brewfile (`fzf`, `zoxide`, `bat`, `eza`, `asdf`, `ghostty`, etc.).
- **Makefile** → orchestrates everything (`make bootstrap`).

---

## 🚀 Bootstrap a new machine

```bash
# Clone repo
git clone git@github.com:<your-username>/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run bootstrap with one of these 2 options (installs brew, apps, configs, plugins)
1 make bootstrap
2 chmod +x bootstrap.sh && ./boostrap.sh


