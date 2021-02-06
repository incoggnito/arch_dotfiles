#!/bin/zsh

# Add poetry autocompletion
fpath+=~/.zfunc

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

#####################
# PROMPT            #
#####################
zinit lucid for \
    as"command" from"gh-r" atinit'export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"' atload'eval "$(starship init zsh)"' bpick'*unknown-linux-gnu*' \
    starship/starship \


##########################
# OMZ Libs and Plugins   #
##########################

# IMPORTANT:
# Ohmyzsh plugins and libs are loaded first as some these sets some defaults which are required later on.
# Otherwise something will look messed up
# ie. some settings help zsh-autosuggestions to clear after tab completion

setopt promptsubst

# Explanation:
# - Loading tmux first, to prevent jumps when tmux is loaded after .zshrc
# - History plugin is loaded early (as it has some defaults) to prevent empty history stack for other plugins
zinit lucid for \
    atinit"HIST_STAMPS=dd.mm.yyyy" \
    OMZL::history.zsh \


# zinit wait lucid for \
	# OMZL::clipboard.zsh \
	# OMZL::compfix.zsh \
	# OMZL::completion.zsh \
	# OMZL::correction.zsh \
    # atload"
        # alias ..='cd ..'
        # alias ...='cd ../..'
        # alias ....='cd ../../..'
        # alias .....='cd ../../../..'
    # " \
	# OMZL::directories.zsh \
	# OMZL::git.zsh \
	# OMZL::grep.zsh \
	# OMZL::key-bindings.zsh \
	# OMZL::spectrum.zsh \
	# OMZL::termsupport.zsh \
    # atload"
        # alias gcd='gco dev'
    # " \
	# OMZP::git \
	# OMZP::fzf \
    # atload"
        # alias dcupb='docker-compose up --build'
    # " \
	# OMZP::docker-compose \
	# as"completion" \
    # OMZP::docker/_docker \
    # djui/alias-tips \
    # hlissner/zsh-autopair \
    # chriskempson/base16-shell \

#####################
# PLUGINS           #
#####################
# @source: https://github.com/crivotz/dot_files/blob/master/linux/zplugin/zshrc

# IMPORTANT:
# These plugins should be loaded after ohmyzsh plugins

zinit wait lucid for \
    light-mode atinit"ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20" atload"_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions \
    light-mode atinit"
        typeset -gA FAST_HIGHLIGHT;
        FAST_HIGHLIGHT[git-cmsg-len]=100;
        zpcompinit;
        zpcdreplay;
    " \
        zdharma/fast-syntax-highlighting \
    light-mode blockf atpull'zinit creinstall -q .' \
    atinit"
        zstyle ':completion:*' completer _expand _complete _ignored _approximate
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
        zstyle ':completion:*' menu select=2
        zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
        zstyle ':completion:*:descriptions' format '-- %d --'
        zstyle ':completion:*:processes' command 'ps -au$USER'
        zstyle ':completion:complete:*:options' sort false
        zstyle ':fzf-tab:complete:_zlua:*' query-string input
        zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,comm,cmd -w -w'
        zstyle ':fzf-tab:complete:kill:argument-rest' extra-opts --preview=$extract'ps --pid=$in[(w)1] -o cmd --no-headers -w -w' --preview-window=down:3:wrap
        zstyle ':fzf-tab:complete:cd:*' extra-opts --preview=$extract'exa -1 --color=always ${~ctxt[hpre]}$in'
    " \
        zsh-users/zsh-completions \
    bindmap"^R -> ^H" atinit"
        zstyle :history-search-multi-word page-size 10
        zstyle :history-search-multi-word highlight-color fg=red,bold
        zstyle :plugin:history-search-multi-word reset-prompt-protect 1
    " \
        zdharma/history-search-multi-word \
    reset \
    atclone"local P=${${(M)OSTYPE:#*darwin*}:+g}
            \${P}sed -i \
            '/DIR/c\DIR 38;5;63;1' LS_COLORS; \
            \${P}dircolors -b LS_COLORS > c.zsh" \
    atpull'%atclone' pick"c.zsh" nocompile'!' \
    atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”' \
        trapd00r/LS_COLORS

#####################
# Misc Stuff        #
#####################

# VIM like
#{{{
bindkey -v
bindkey 'jk' vi-cmd-mode
bindkey -v '^?' backward-delete-char

# xsel copy
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

x-yank() {
    zle copy-region-as-kill
    print -rn -- $cutbuffer | pbcopy
}
zle -N x-yank

x-cut() {
    zle kill-region
    print -rn -- $cutbuffer | pbcopy
}
zle -N x-cut

x-paste() {
    PASTE=$(pbpaste)
    LBUFFER="$LBUFFER${RBUFFER:0:1}"
    RBUFFER="$PASTE${RBUFFER:1:${#RBUFFER}}"
}
zle -N x-paste

bindkey -M vicmd "y" x-yank
bindkey -M vicmd "Y" x-cut
bindkey -M vicmd "p" x-paste

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

#}}}

# External Sources
#{{{

# Load aliases and shortcuts if existent.
[ -f "$HOME/.config/zsh/aliases" ] && source "$HOME/.config/zsh/aliases"


# Colorize manpages
export PAGER="most"
export CONDA_HOME="home/inco/miniconda3"

# Use vim like manpages
viman () { text=$(man "$@") && echo "$text" | vim -R +":set ft=man" - ; }

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/inco/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/inco/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/inco/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/inco/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# >>> direnv init >>>
# eval "$(direnv hook zsh)"
# <<< direnv init <<<

# Created by `userpath` on 2021-01-31 09:01:59
export PATH="$PATH:/home/inco/.local/bin"

# Pyenv automatic
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
