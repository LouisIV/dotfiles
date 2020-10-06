# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# /////////////////////////////////////////////////////////////////////////////
# Helper Functions
# /////////////////////////////////////////////////////////////////////////////

function configError {
  print -P "$(tput setaf 7)$(tput setab 1) ERRR $(tput sgr 0) $1"
}

function configInfo {
  print -P "$(tput setaf 7)$(tput setab 4) INFO $(tput sgr 0) $1"
}

function configWarning {
  print -P "$(tput setaf 7)$(tput setab 9) WARN $(tput sgr 0) $1"
}

function zsh_source_file {
  if [ -f $1 ]
  then
    source $1
  else
    configWarning "$1 is not available!"
  fi
}

function zsh_source_file_dash_s_test {
  if [ -s $1 ]
  then
    source $1
  else
    configWarning "$1 could not be sourced!"
  fi
}

function warn_function_missing
{
  type "$1" &>/dev/null || configWarning "$1 not found."
}

function err_function_missing
{
  type "$1" &>/dev/null || configError "$1 not found."
}

function isWSL {
  if [ -f "/proc/version" ]
  then
    if grep -q "Microsoft" "/proc/version"; then
      configInfo "You appear to be on WSL"
    fi
  fi
}

# /////////////////////////////////////////////////////////////////////////////
# ZSH
# /////////////////////////////////////////////////////////////////////////////

# Path to your oh-my-zsh installation.
export ZSH=/Users/louislombardo/.oh-my-zsh

ZSH_THEME=powerlevel10k/powerlevel10k

# Uncomment the following line to use case-insensitive completion.
CASE_SENSITIVE="false"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=13

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_PATTERNS=('rm -rf *' 'fg=white,bold,bg=red')

setopt RM_STAR_WAIT

export HISTCONTROL=ignoredups;
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help";

if [[ -n $SSH_CONNECTION ]]; then
  plugins=(
    git
    brew
    z
    sublime
    osx
    git-extras
  )
else
  plugins=(
    git
    brew
    z
    sublime
    osx
    catimg
    git-extras
    github
    lol
    zsh-autosuggestions
  )
fi

# Oh My Zsh
zsh_source_file $ZSH/oh-my-zsh.sh

# Powerlevel9K theme
if [[ ! -n $SSH_CONNECTION ]]; then
  zsh_source_file $HOME/.dotfiles/powerlevel9k.sh
  # zsh_source_file /usr/local/opt/powerlevel9k/powerlevel9k.zsh-theme
fi

# /////////////////////////////////////////////////////////////////////////////
# Terminal • Defaults
# /////////////////////////////////////////////////////////////////////////////

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='code'
fi

export TERM="xterm-256color"

# /////////////////////////////////////////////////////////////////////////////
# Terminal • aliases
# /////////////////////////////////////////////////////////////////////////////

alias cd..='cd ../'                                    # Go back 1 directory level (for fast typers)
alias ..='cd ../'                                      # Go back 1 directory level
alias ...='cd ../../'                                  # Go back 2 directory levels
alias .3='cd ../../../'                                # Go back 3 directory levels
alias .4='cd ../../../../'                             # Go back 4 directory levels
alias .5='cd ../../../../../'                          # Go back 5 directory levels
alias .6='cd ../../../../../../'                       # Go back 6 directory levels

alias ~="cd ~"                                         # ~:            Go Home
alias c='clear'                                        # c:            Clear terminal display
alias path='echo -e ${PATH//:/\\n}'                    # path:         Echo all executable Paths
alias cic='set completion-ignore-case On'              # cic:          Make tab-completion case-insensitive
alias speedtest='speedtest-cli'                        # speedtest:	   Run a speed test
function mcd () { mkdir -p "$1" && cd "$1"; }          # mcd:          Makes new Dir and jumps inside

function quick {
  if [ "$1" = "--list" ]
  then
    ls "$HOME/.dotfiles/quick-ref-scripts"
  else
    if [ -f "$HOME/.dotfiles/quick-ref-scripts/$1.sh" ]
    then
      $HOME/.dotfiles/quick-ref-scripts/$1.sh
    else
      echo "You need to provide a valid command"
    fi
  fi
}

# /////////////////////////////////////////////////////////////////////////////
# MacOS • extras
# /////////////////////////////////////////////////////////////////////////////

alias f='open -a Finder ./'                            # f:            Opens current directory in MacOS Finder
alias kllspot='killall Spotlight'                      # kllspot:      Restart spotlight
function trash () { command mv "$@" ~/.Trash ; }       # trash:        Moves a file to the MacOS trash
function ql () { qlmanage -p "$*" >& /dev/null; }      # ql:           Opens any file in MacOS Quicklook Preview

# /////////////////////////////////////////////////////////////////////////////
# GO
# /////////////////////////////////////////////////////////////////////////////

# Go Development
export GOPATH=\$HOME/gopath
alias drive='~/.go/bin/drive'

# /////////////////////////////////////////////////////////////////////////////
# Node
# /////////////////////////////////////////////////////////////////////////////

NODE_PATH="/usr/local/lib/node_modules"

# Load NVM
export NVM_DIR="$HOME/.nvm"
zsh_source_file_dash_s_test /usr/local/opt/nvm/nvm.sh

err_function_missing "nvm"

# This loads nvm bash_completion
zsh_source_file_dash_s_test /usr/local/opt/nvm/etc/bash_completion.d/nvm

# Display the current node version
NODE_VERSION="$(node --version)"
configInfo "Current $(tput setaf 7)$(tput setab 4)Node Version$(tput sgr 0) is $(tput setaf 7)$(tput setab 4)${NODE_VERSION}$(tput sgr 0)"

# Fastlane path
export PATH="$HOME/.fastlane/bin:$PATH"
warn_function_missing "fastlane"

err_function_missing   "yarn"
err_function_missing   "npm"
err_function_missing   "npx"
warn_function_missing  "emma"
warn_function_missing  "share"

# /////////////////////////////////////////////////////////////////////////////
# tabtab
# /////////////////////////////////////////////////////////////////////////////

# tabtab source for electron-forge package
# uninstall by removing these lines or running `tabtab uninstall electron-forge`
[[ -f /usr/local/lib/node_modules/electron-forge/node_modules/tabtab/.completions/electron-forge.zsh ]] && . /usr/local/lib/node_modules/electron-forge/node_modules/tabtab/.completions/electron-forge.zsh
# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh

# /////////////////////////////////////////////////////////////////////////////
# NTFY
# /////////////////////////////////////////////////////////////////////////////

if [[ ! -n $SSH_CONNECTION ]]; then
  err_function_missing "ntfy"

  # What commands should ntfy ignore?
  # What about sub-commands? - https://github.com/dschep/ntfy/issues/191
  ntfy_ignore=(
    vim
    screen
    now
    tmux
    nano
    gtop
    "yarn start"
  )
  export AUTO_NTFY_DONE_IGNORE="${ntfy_ignore[*]}"
  eval "$(ntfy shell-integration)"
fi

# /////////////////////////////////////////////////////////////////////////////
# Android
# /////////////////////////////////////////////////////////////////////////////

# Android Development
if [[ ! -n $SSH_CONNECTION ]]; then
  export ANDROID_HOME=$HOME/Library/Android/sdk
  export PATH=$PATH:$ANDROID_HOME/emulator
  export PATH=$PATH:$ANDROID_HOME/tools
  export PATH=$PATH:$ANDROID_HOME/tools/bin
  export PATH=$PATH:$ANDROID_HOME/platform-tools
fi

# /////////////////////////////////////////////////////////////////////////////
# Homebrew
# /////////////////////////////////////////////////////////////////////////////

# Homebrew Cellar
export PATH="$PATH:/usr/local/Cellar"

err_function_missing "brew"

# /////////////////////////////////////////////////////////////////////////////
# Python
# /////////////////////////////////////////////////////////////////////////////

err_function_missing "python3"
# warn_function_missing "python2"

# /////////////////////////////////////////////////////////////////////////////
# IBM
# /////////////////////////////////////////////////////////////////////////////

zsh_source_file /usr/local/ibmcloud/autocomplete/zsh_autocomplete
export IBMCLOUD_COLOR=true
export IBMCLOUD_ANALYTICS=false
export IBMCLOUD_VERSION_CHECK=true

# /////////////////////////////////////////////////////////////////////////////
# Ruby
# /////////////////////////////////////////////////////////////////////////////

# Ruby Version Manager
err_function_missing "ruby"
err_function_missing "rvm"
err_function_missing "colorls"

export PATH="$PATH:$HOME/.rvm/bin"

# Display the current Ruby Version
RUBY_VERSION="$(ruby --version)"
configInfo "Current Ruby Version is ${RUBY_VERSION}"

# /////////////////////////////////////////////////////////////////////////////
# Misc.
# /////////////////////////////////////////////////////////////////////////////

if [[ -n $SSH_CONNECTION ]]; then
  configInfo "You are SSHed into this machine!"
fi

# Let the user know if they are running WSL
isWSL

if [[ ! -n $SSH_CONNECTION ]]
  then
  warn_function_missing "code"
  warn_function_missing "subl"
fi

err_function_missing "vim"
err_function_missing "tmux"

# Fuzzy Back Search
zsh_source_file $HOME/.fzf.zsh

function ipinfo {
  LOCAL_IP_ADDR="$(ipconfig getifaddr en0)"
  configInfo "Your local IP is \t$(tput setaf 7)$(tput setab 4)${LOCAL_IP_ADDR}$(tput sgr 0)"

  EXTERN_IP_ADDR="$(curl -s ipecho.net/plain ; echo)"
  configInfo "Your external IP is \t$(tput setaf 7)$(tput setab 4)${EXTERN_IP_ADDR}$(tput sgr 0)"
}

[ -f "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env" ] && source "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/louislombardo/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/louislombardo/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/louislombardo/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/louislombardo/google-cloud-sdk/completion.zsh.inc'; fi
