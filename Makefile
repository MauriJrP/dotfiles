.DEFAULT_GOAL := help

# Pick the right brew path automatically
BREW := $(shell test -x /opt/homebrew/bin/brew && echo /opt/homebrew/bin/brew || echo /usr/local/bin/brew)
SHELL := /bin/zsh

.PHONY: bootstrap brew brew-bundle devtools stow zsh-omz zsh-plugins zsh-fzf shells nvim tmux ghostty macos java pyenv-install


help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .+$$' $(MAKEFILE_LIST) | sed 's/:.*##/ ->/' | sort

bootstrap: xcode brew brew-bundle stow fonts shells devtools nvim tmux ghostty macos java pyenv-install ## Full first-time setup

xcode: ## Install Xcode CLT (no-op if present)
	@xcode-select -p >/dev/null 2>&1 || xcode-select --install || true

brew: ## Install Homebrew (no-op if present)
	@command -v brew >/dev/null || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	@# Add brew shellenv to login profiles (idempotent)
	@BrewBin="$$($(BREW) --prefix)"; \
	if ! grep -q 'brew shellenv' $$HOME/.zprofile 2>/dev/null; then \
	  echo 'eval $$($(BREW) shellenv)' >> $$HOME/.zprofile; \
	fi; \
	if ! grep -q 'brew shellenv' $$HOME/.zshrc 2>/dev/null; then \
	  echo 'eval $$($(BREW) shellenv)' >> $$HOME/.zshrc; \
	fi

brew-bundle: ## Install apps from Brewfile
	@eval $$($(BREW) shellenv); HOMEBREW_NO_AUTO_UPDATE=1 $(BREW) bundle --file=./Brewfile


stow: ## Symlink dotfiles into $$HOME using stow (backs up conflicts)
	@eval $$($(BREW) shellenv); \
	mkdir -p $$HOME/.dotfiles_backups; \
	for f in .zshrc .tmux.conf .config/ghostty/config; do \
	  [ -e $$HOME/$$f ] && [ ! -L $$HOME/$$f ] && mv $$HOME/$$f $$HOME/.dotfiles_backups/  || true; \
	done; \
	stow --no-folding --dir stow --target $$HOME zsh tmux ghostty

fonts: ## Install Nerd Font (JetBrains Mono by default)
	@eval $$($(BREW) shellenv); $(BREW) tap homebrew/cask-fonts || true
	@$(BREW) install --cask font-jetbrains-mono-nerd-font

shells: ## Set login shell to best available zsh
	@eval $$($(BREW) shellenv); \
	SYS_ZSH="/bin/zsh"; \
	BREW_ZSH="$$( $(BREW) --prefix )/bin/zsh"; \
	USE_ZSH="$$SYS_ZSH"; \
	[ -x "$$BREW_ZSH" ] && USE_ZSH="$$BREW_ZSH"; \
	grep -q "$$USE_ZSH" /etc/shells || echo "$$USE_ZSH" | sudo tee -a /etc/shells >/dev/null; \
	chsh -s "$$USE_ZSH" || true


devtools: ## CLI you likely want everywhere
	@eval $$($(BREW) shellenv); $(BREW) install coreutils gnu-sed gnu-tar wget curl jq ripgrep fd bat eza zoxide direnv tmux git gh asdf

java: ## Install a JDK and Maven; set JAVA_HOME via /usr/libexec/java_home
	@eval $$($(BREW) shellenv); \
	$(BREW) install maven || true; \
	$(BREW) install --cask temurin || true; \
	if ! grep -q 'JAVA_HOME' $$HOME/.zprofile 2>/dev/null; then \
	  echo 'export JAVA_HOME="$$(/usr/libexec/java_home)"' >> $$HOME/.zprofile; \
	  echo 'export PATH="$$JAVA_HOME/bin:$$PATH"' >> $$HOME/.zprofile; \
	fi

pyenv-install: ## Install pyenv
	@eval $$($(BREW) shellenv); $(BREW) install pyenv || true

# zsh-plugins: ## Install OMZ plugins (brew + symlinks + git clone)
# 	@eval $$($(BREW) shellenv); \
# 	$(BREW) install zsh-autosuggestions zsh-syntax-highlighting || true; \
# 	ZSH_CUSTOM="$${ZSH_CUSTOM:-$${ZSH:-$$HOME/.oh-my-zsh}/custom}"; \
# 	mkdir -p "$$ZSH_CUSTOM/plugins"; \
# 	LNA="$$($(BREW) --prefix)/share/zsh-autosuggestions"; \
# 	LNS="$$($(BREW) --prefix)/share/zsh-syntax-highlighting"; \
# 	[ -L "$$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] || ln -s "$$LNA" "$$ZSH_CUSTOM/plugins/zsh-autosuggestions"; \
# 	[ -L "$$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] || ln -s "$$LNS" "$$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"; \
# 	[ -d "$$ZSH_CUSTOM/plugins/you-should-use" ] || git clone https://github.com/MichaelAquilina/zsh-you-should-use "$$ZSH_CUSTOM/plugins/you-should-use"

zsh-plugins: ## Install OMZ plugins by cloning repos (OMZ-friendly)
	@ZSH_DIR="$${ZSH:-$$HOME/.oh-my-zsh}"; \
	ZSHC="$${ZSH_CUSTOM:-$$ZSH_DIR/custom}"; \
	mkdir -p "$$ZSHC/plugins"; \
	[ -d "$$ZSHC/plugins/zsh-autosuggestions" ] || git clone https://github.com/zsh-users/zsh-autosuggestions "$$ZSHC/plugins/zsh-autosuggestions"; \
	[ -d "$$ZSHC/plugins/zsh-syntax-highlighting" ] || git clone https://github.com/zsh-users/zsh-syntax-highlighting "$$ZSHC/plugins/zsh-syntax-highlighting"; \
	[ -d "$$ZSHC/plugins/you-should-use" ] || git clone https://github.com/MichaelAquilina/zsh-you-should-use "$$ZSHC/plugins/you-should-use"; \
	echo "→ OMZ plugins are in $$ZSHC/plugins"

zsh-fzf: ## Enable fzf keybindings & completion
	@eval $$($(BREW) shellenv); \
	$(BREW) install fzf || true; \
	FZF_PREFIX="$$( $(BREW) --prefix fzf )"; \
	"$$FZF_PREFIX"/install --no-bash --no-fish --key-bindings --completion --no-update-rc

# nvim: ## Install NVChad and your custom layer
# 	@[ -d "$$HOME/.config/nvim" ] || git clone https://github.com/NvChad/starter "$$HOME/.config/nvim"
# 	@# If you prefer full NVChad: git clone https://github.com/NvChad/NvChad "$$HOME/.config/nvim" --depth 1
# 	@# Ensure your custom files are stowed into ~/.config/nvim/lua/custom
#
nvim: ## Install Neovim (PATH) + NVChad + your custom layer
	@eval $$($(BREW) shellenv); \
	$(BREW) install neovim || true; \
	mkdir -p $$HOME/.config; \
	# Install NVChad only if ~/.config/nvim doesn't exist
	[ -d $$HOME/.config/nvim ] || git clone https://github.com/NvChad/NvChad $$HOME/.config/nvim --depth 1; \
	# If you keep your custom files under stow/nvim/.config/nvim/lua/custom, stow them into place
	if [ -d stow/nvim/.config/nvim/lua/custom ]; then \
	  stow --no-folding --dir stow --target $$HOME nvim; \
	fi


# tmux: ## TPM and sensible defaults
# 	@[ -d "$$HOME/.tmux/plugins/tpm" ] || git clone https://github.com/tmux-plugins/tpm "$$HOME/.tmux/plugins/tpm"
# 	@# Plugins install on first tmux start: prefix + I

tmux: ## TPM and config
	@[ -d $$HOME/.tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm $$HOME/.tmux/plugins/tpm
	@# If a tmux server is already running, reload config
	@if tmux info >/dev/null 2>&1; then tmux source-file $$HOME/.tmux.conf; fi

ghostty: ## Ensure Ghostty exists (from Brewfile) and pick font
	@echo "Set Ghostty font in stow/ghostty/.config/ghostty/config then re-stow."
	@true

macos: ## Optional macOS defaults (safe to skip)
	@./macos.sh || true

