#!/bin/zsh

#####   OPTIONS     #####

USE_SYNTAX_HIGHLIGHTING=yes
AUTO_DOWNLOAD_SYNTAX_HIGHLIGHTING_PLUGIN=yes

USE_ZSH_AUTOSUGGESTIONS=no
AUTO_DOWNLOAD_ZSH_AUTOSUGGESTIONS_PLUGIN=no

PROMPT_ALTERNATIVE=twoline
NEWLINE_BEFORE_PROMPT=yes

#### END OF OPTIONS #####

setopt autocd
setopt interactivecomments
setopt magicequalsubst
setopt nonomatch
setopt notify
setopt numericglobsort
setopt promptsubst
setopt share_history

WORDCHARS=${WORDCHARS//\/}
PROMPT_EOL_MARK=""

bindkey -e
bindkey ' ' magic-space
bindkey '^U' backward-kill-line
bindkey '^[[3;5~' kill-word
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[5~' beginning-of-buffer-or-history
bindkey '^[[6~' end-of-buffer-or-history
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[Z' undo

setopt hist_verify
alias history="history 0"

TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

configure_prompt() {

    ZSH_THEME_GIT_PROMPT_PREFIX="%{$FG[160]%}["
    ZSH_THEME_GIT_PROMPT_SUFFIX="] %{$reset_color%}"

    if [[ $UID == 0 || $EUID == 0 ]]; then
        FGPROMPT="$FG[196]"   # bright red for root
        REDACCENT="$FG[160]"
    else
        FGPROMPT="$FG[160]"   # main red
        REDACCENT="$FG[124]"  # darker red accent
    fi

    case "$PROMPT_ALTERNATIVE" in
        twoline)
            PROMPT=$'$REDACCENT┌$(if [[ -n $VIRTUAL_ENV ]]; then echo "─(%F{white}$(basename $VIRTUAL_ENV)$REDACCENT)"; fi)\(%B$FGPROMPT%n@%m%b$REDACCENT)-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b$REDACCENT]$(git_prompt_info)\n$REDACCENT└─%B%(#.%F{196}#.$FGPROMPT$)%b%F{reset} '
            RPROMPT=
            ;;
        oneline)
            PROMPT=$'%B$FGPROMPT%n@%m%b%F{reset}:%B$REDACCENT%~%b$(git_prompt_info)%F{reset}%(#.#.$) '
            RPROMPT=
            ;;
    esac
}

configure_prompt

############################################################
# ZSH SYNTAX HIGHLIGHTING (RED THEME)
############################################################

if [ "$USE_SYNTAX_HIGHLIGHTING" = yes ]; then

    if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        . ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    elif [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        . /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    fi

    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

    ZSH_HIGHLIGHT_STYLES[default]=none
    ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=white,underline
    ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=red,bold
    ZSH_HIGHLIGHT_STYLES[command]=fg=red,bold
    ZSH_HIGHLIGHT_STYLES[builtin]=fg=red
    ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=red
    ZSH_HIGHLIGHT_STYLES[global-alias]=fg=red,bold
    ZSH_HIGHLIGHT_STYLES[precommand]=fg=red
    ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=red,bold
    ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=red
    ZSH_HIGHLIGHT_STYLES[path]=fg=white,bold
    ZSH_HIGHLIGHT_STYLES[globbing]=fg=red,bold
    ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=red,bold
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=red
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=red
    ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=red
    ZSH_HIGHLIGHT_STYLES[arg0]=fg=red,bold
    ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=196,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=160,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=124,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=196
fi

############################################################
# LS / LESS RED COLORS
############################################################

if [ -x /usr/bin/dircolors ]; then
    eval "$(dircolors -b)"

    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m'
    export LESS_TERMCAP_md=$'\E[1;31m'
    export LESS_TERMCAP_me=$'\E[0m'
    export LESS_TERMCAP_so=$'\E[01;31m'
    export LESS_TERMCAP_se=$'\E[0m'
    export LESS_TERMCAP_us=$'\E[1;31m'
    export LESS_TERMCAP_ue=$'\E[0m'
fi

############################################################
# OPTIONAL AUTOSUGGEST RED
############################################################

if [ "$USE_ZSH_AUTOSUGGESTIONS" = yes ]; then
    if [ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
        . ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
        ZSH_AUTOSUGGEST_STRATEGY=(completion history)
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#8b0000'
    fi
fi

############################################################

export VIRTUAL_ENV_DISABLE_PROMPT=1
export CONDA_CHANGEPS1=false
