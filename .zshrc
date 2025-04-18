# vim:foldmethod=marker:foldlevel=0

# Setup Zinit (Plugin Manager) {{{
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"
# }}}

# Setup Home-Manager {{{
# "If you do not plan on having Home Manager manage your shell configuration then you must source the [following] file in your shell configuration."
source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
# }}}

# Selective shellrc.d imports {{{
source $HOME/.shellrc.d/home-manager-alias.sh
source $HOME/.shellrc.d/git-subrepo.sh
source $HOME/.shellrc.d/mkcd.zsh
source $HOME/.shellrc.d/mkcdtmp.bash
# }}}

# Add zsh plugins {{{
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab # Fzf for completions
zinit light nix-community/nix-zsh-completions
# }}}

# Add in snippets fom Oh-My-Zsh {{{
#zinit snippet OMZP::git # Git aliases
# }}}

# Add deno completions to search path {{{
if [[ ":$FPATH:" != *":/home/x3ro/.zsh/completions:"* ]]; then export FPATH="/home/x3ro/.zsh/completions:$FPATH"; fi
# }}}

# Load completions {{{
# autoload -Uz compinit && compinit
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

zinit cdreplay -q
# }}}

# Extra completions {{{
eval "$(just --completions zsh)"
# }}}

# Prompt {{{
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/config.toml)"
echo '' # HACK: Oh-My-Posh skips the first newline, so we add one ourselves
# }}}

# Disable "sroll-lock" (= Freeze terminal on Ctrl+s) {{{
stty ixoff -ixon
# }}}

# Keybindings {{{
bindkey -e # Use Emacs mode
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey "^[[1;5C" forward-word # Ctrl+Right
bindkey "^[[1;5D" backward-word # Ctrl+Left
bindkey '^[[127;5u' backward-kill-word # Ctrl+Backspace for "extended keys"
# }}}

# Configure history {{{
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
# }}}

# Completion styling {{{
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no # Disable default completion menu (replaced by fzf)
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd --color=always --icon=always $realpath'
zstyle ':fzf-tab:complete:ls:*' fzf-preview 'lsd --color=always --icon=always $realpath'
# zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'lsd --color=always --icon=always $realpath' # TODO: Doesn't work?
# }}}

# Aliases {{{
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

alias ,zsh='nvim ~/.zshrc'
alias ,tmux='nvim ~/.config/tmux/tmux.conf'
alias doc='docker  compose'
alias o='handlr open'
alias cat=bat
alias gg=lazygit
alias typescript-recorder='script'
alias duff='duf -only-mp "/,/data/*,/mnt/*"'
alias RR='. ~/.zshrc'
# }}}

# Set default EDITOR {{{
export EDITOR="nvim"
# }}}

# File manager with `cd` (using Yazi) {{{
function x() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
# }}}

# Trash-CLI {{{
function __rm-disabled() {
    echo >&2 'WARN: Use `rt` instead of `rm` to move files to trash.'
    echo >&2 '      Use `\\rm` if you really want to permanently delete files.'
    return 1
}

function __empty-trash() {
    echo >&2 -n "Do you really want to PERMANENTLY delete all files in the trash bin? Type uppercase yes to confirm: "
    read answer

    if [[ ${answer} == "YES" ]]; then
        trash-empty
        return
    fi
    
    echo >&2 "=> No files were deleted"
}

alias rm=__rm-disabled

alias rt=trash-put
alias rt-ls=trash-list
alias rt-empty=__empty-trash
alias rt-rm=trash-rm
# }}}

# Additional PATH entries {{{
PATH="${HOME}/.local/bin:${PATH}"
. "/home/x3ro/.deno/env"
# }}}

# Shell integrations {{{
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
eval "$(batman --export-env)"
eval "$(direnv hook zsh)"
# }}}

# Refresh ENV from tmux {{{
function _refresh_tmux_env() {
    [ -z "$TMUX" ] && return

    allowed_vars=(
        "DISPLAY"
        "XAUTHORITY"
        "SSH_CONNECTION"
        "SSH_AUTH_SOCK"
    )

    for var in $allowed_vars; do
        eval $(tmux show-environment -s "$var" 2>/dev/null)
    done
}

# Hook into preexec
function preexec() {
    _refresh_tmux_env
}
# }}}

# TODO: int tmux, alt+h is bound to switching panes. In zsh alt+h is bound to "open man for current command". Find alternative mapping in zsh
# TODO: config aliases
