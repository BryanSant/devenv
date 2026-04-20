export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
plugins=(git sudo direnv zsh-autosuggests zsh-syntax-highlighting colored-man-pages)
export EDITOR="vim"

# SDKMan
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Setup GraalVM
JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2)
export GRAALVM_HOME="$HOME/.sdkman/candidates/java/${JAVA_VERSION}-graal"

# Setup local commands
export PATH="$HOME/.local/bin:$PATH"

# zoxide (z command)
eval "$(zoxide init zsh)"

# Load Angular CLI autocompletion.
source <(ng completion script)

# Starship.rs
eval "$(starship init zsh)"

# Aliases
alias ll='ls -lh'
alias l='ls -alh'
