# -------- basics --------
export ZDOTDIR="$HOME"
export EDITOR="micro"
export TERMINAL="alacritty"

# -------- history --------
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY

# -------- completion --------
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select

# -------- plugins --------
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# -------- colors --------
export LS_COLORS="di=32:ln=36:so=35:pi=33:ex=92"

# -------- aliases --------
alias ls="eza --icons --group-directories-first"
alias ll="eza -lh --icons"
alias la="eza -lha --icons"
alias cat="bat"
alias grep="rg"

# -------- starship --------
eval "$(starship init zsh)"

# -------- fzf --------
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

export FZF_DEFAULT_OPTS="
--height=40%
--layout=reverse
--border
--prompt='❯ '
--pointer='▶'
--marker='✓'
--color=bg+:#1f2a1f,bg:#141a14,spinner:#f9e2af,hl:#a6e3a1
--color=fg:#cdd6f4,header:#f9e2af,info:#89b4fa,pointer:#a6e3a1
--color=marker:#f9e2af,fg+:#ffffff,hl+:#a6e3a1
"

export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"

export FZF_CTRL_T_OPTS="
--preview 'bat --style=numbers --color=always {} 2>/dev/null || eza -T {}'
"

export FZF_ALT_C_OPTS="
--preview 'eza -T {} | head -200'
"

export FZF_CTRL_R_OPTS="
--preview 'echo {}'
--preview-window=down:3:hidden:wrap
--bind '?:toggle-preview'
"

# -------- fastfetch --------
fastfetch
