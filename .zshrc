# Setup Zinit (Plugin Manager)
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"


# Add zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab # Fzf for completions

# Add in snippets fom Oh-My-Zsh
#zinit snippet OMZP::git # Git aliases


# Load completions
# autoload -Uz compinit && compinit
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

zinit cdreplay -q


# Prompt
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/config.toml)"
echo '' # HACK: Oh-My-Posh ships the first newline, so we add one one ourselves


# Keybindings
bindkey -e # Use Emacs mode
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward


# Configure history
HISTSIZE=5000000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups


# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no # Disable default completion menu (replaced by fzf)
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd --color=always --icon=always $realpath'
zstyle ':fzf-tab:complete:ls:*' fzf-preview 'lsd --color=always --icon=always $realpath'
# zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'lsd --color=always --icon=always $realpath' # TODO: Doesn't work?


# Aliases
if [ "$(command -v lsd)" ]; then
    alias ls='lsd  --color=auto --hyperlink=auto --group-directories-first --almost-all'
    alias ll='lsd  --color=auto --hyperlink=auto --group-directories-first -l'
    alias l='ll'
    alias la='lsd  --color=auto --hyperlink=auto --group-directories-first -la'
else
    alias ls='ls  --color --hyperlink=auto --group-directories-first --almost-all'
    alias ll='ls  --color --hyperlink=auto --group-directories-first -l'
    alias l='ll'
    alias la='ls  --color --hyperlink=auto --group-directories-first -la'
fi


# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
