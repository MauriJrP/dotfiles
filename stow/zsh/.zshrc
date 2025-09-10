export PATH=$PATH:/Users/maurrrod/Downloads/chromedriver_mac_arm64
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

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
plugins=(git zsh-autosuggestions you-should-use mvn zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# You may need to manually set your language environment
#export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"


# Load Homebrew
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# History & shells
setopt histignoredups share_history
export EDITOR="nvim"
export PATH="$HOME/bin:$PATH"


# fzf, zoxide, direnv
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
command -v direnv >/dev/null && eval "$(direnv hook zsh)"
# fzf completion/bindings (installed by `make devtools`)
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh


# Aliases -------
alias qcli='python manage.py'

alias gswf='git switch $(git branch | sed "s/* //" | fzf)'
# Load fzf if installed
if [[ -f ~/.fzf.zsh ]]; then
  source ~/.fzf.zsh
fi

autoload -Uz fzf-history-widget
# Ensure key bindings work
bindkey '^R' fzf-history-widget

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias cd='z'

alias k=kubectl

alias ls='eza -lah --group-directories-first'
alias cat='bat'
alias gs='git status -sb'
alias v='nvim'
alias t='tmux'


# Functions -----

auth() {
    region=${1:-us-ashburn-1}
    oci session authenticate --tenancy-name "bmc_operator_access" --region "$region" --profile-name oc1
}

pod_images() {
  "@1" -o jsonpath="{range .items[*]}{.metadata.name}{':\t'}{.spec.containers[*].image}{'\n'}{end}"
}


export JAVA_HOME=`/usr/libexec/java_home -v 17`
export PATH=/opt/apache-maven-3.9.2/bin:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

show-profile (){
    echo "OCI CLI profile: $OCI_CLI_PROFILE"
}

export HISTTIMEFORMAT="%F %T "
HIST_STAMPS="yyyy-mm-dd"

# pyenv (guarded)
if command -v pyenv >/dev/null; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  # If you use virtualenvs:
  # eval "$(pyenv virtualenv-init -)"
fi

# bind keys

eval "$(zoxide init zsh)"


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
