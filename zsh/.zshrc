# Nix package manager
[ -f $HOME/.nix-profile/etc/profile.d/nix.sh ] && . $HOME/.nix-profile/etc/profile.d/nix.sh

##############################################################################
# History Configuration
##############################################################################
HISTSIZE=10000              #How many lines of history to keep in memory
HISTFILE=~/.zsh_history     #Where to save history to disk
SAVEHIST=10000              #Number of history entries to save to disk
HISTDUP=erase               #Erase duplicates in the history file
setopt appendhistory     #Append history to the history file (no overwriting)
setopt sharehistory      #Share history across terminals
setopt incappendhistory  #Immediately append to the history file, not just when a term is killed

# Lines configured by zsh-newuser-install
setopt autocd extendedglob
bindkey -e
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Za-z}' 'l:|=* r:|=*' 'r:|[._-]=* r:|=*'
#zstyle ':completion:*' max-errors 3
zstyle :compinstall filename '${HOME}/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

if [ ! -f ~/.zsh_plugins.sh -a -f ~/.zsh_plugins.txt ];
then
    antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh
fi
[ -f ~/.zsh_plugins.sh ] && source ~/.zsh_plugins.sh

export EDITOR='nvim'

setopt extended_glob

# custom aliases
alias ls='exa'
alias l='ls -l --group-directories-first --git'
alias la='l -a'
alias lt='la -s created'
alias cat='bat'
alias gmerge='( read branch && git pull && git merge origin/$branch -m "Merge $branch → $(git symbolic-ref --short -q HEAD)" && git push ) <<<'
alias gship='( gmerge && git push origin :$branch ) <<<'
alias cpdiff='git diff --color | iconv -f cp1251 -t utf8 | less -r'
alias tru='trans en:ru'
alias ten='trans ru:en'
alias пер='trans ru:en'
alias t='task'
alias ts='taskupd'
alias touch='( read p; d=$(dirname $p); mkdir -p $d && touch $p ) <<<'
alias dontgiveup='( read p; until eval $p; do sleep 1; done ) <<<'
alias wanip='dig +short myip.opendns.com @resolver1.opendns.com'
alias cleanup='find . -name "*~" -print -exec rm -f {} \;'
alias pbcopy="xclip -selection c"
alias pbpaste="xclip -selection clipboard -o"

export PATH="${PATH}:$HOME/.local/bin"
export PATH="${PATH}:$HOME/.cargo/bin"
export PATH="${PATH}:$HOME/go/bin"
export PATH="${PATH}:$HOME/bin"

export TIMEFMT='%J   %U  user %S system %P cpu %*E total'$'\n'\
'avg shared (code):         %X KB'$'\n'\
'avg unshared (data/stack): %D KB'$'\n'\
'total (sum):               %K KB'$'\n'\
'max memory:                %M MB'$'\n'\
'page faults from disk:     %F'$'\n'\
'other page faults:         %R'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

######################
# Local npm packages #
######################
NPM_PACKAGES="${HOME}/.npm-packages"
export PATH="$NPM_PACKAGES/bin:$PATH"
# Unset manpath so we can inherit from /etc/manpath via the `manpath` command
unset MANPATH # delete if you already modified MANPATH elsewhere in your config
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

. $HOME/.zshrc.local
