# +=========================+
# | Nix package manager     |
# +-------------------------+

[ -f $HOME/.nix-profile/etc/profile.d/nix.sh ] && . $HOME/.nix-profile/etc/profile.d/nix.sh


# +=========================+
# | Fuzzy finder            |
# +-------------------------+

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_OPTS='--no-height --extended'
export FZF_DEFAULT_COMMAND='fd --no-ignore --hidden --exclude ".git" --exclude "~/go"'
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
# TODO transform these commands to functions
FZF_PREVIEW_MAX_LINES=200
FZF_DIRECTORY_PREVIEW_CMD="exa -l --group-directories-first -T --color=always --color-scale {} | head -${FZF_PREVIEW_MAX_LINES}"
FZF_TEXT_FILE_PREVIEW_CMD="bat -pp --italic-text=always --color=always -r:${FZF_PREVIEW_MAX_LINES}"
export FZF_ALT_C_OPTS="--preview '${FZF_DIRECTORY_PREVIEW_CMD}'"

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  eval ${FZF_DEFAULT_COMMAND} --follow . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  eval ${FZF_DEFAULT_COMMAND} --follow --type d . "$1"
}

# (EXPERIMENTAL) Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview "${FZF_DIRECTORY_PREVIEW_CMD}" ;;
    export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
    ssh)          fzf "$@" --preview 'dig {}' ;;
    man)          man -k . | fzf --prompt='Man> ' --preview 'man $(echo {} | awk "{print \$1}") | '"${FZF_TEXT_FILE_PREVIEW_CMD} -lman" | awk '{print $1}' ;;
    vi|vim|nvim)  fzf "$@" --preview "[ -f {} ] && ${FZF_TEXT_FILE_PREVIEW_CMD} {} || ${FZF_DIRECTORY_PREVIEW_CMD}" ;;
    *)            fzf "$@" ;;
  esac
}

fzf-find-command-widget() {
  # TODO Add aliases and maybe builtins and functions
  LBUFFER=$(printf '%s\n' "${commands[@]}" \
    | fzf --preview '
      set -o pipefail
      cmd=$(basename {})
      pacman --color=always -Qo {}
      ( man $cmd | '"${FZF_TEXT_FILE_PREVIEW_CMD} -lman"' ) \
      || (
        set -e
        pkg=$(pacman -Qoq {} 2>/dev/null)
        pacman -Qi ${pkg} | rg "Description\s+:\s*(.*)" --only-matching --replace="\$1"
      )')
  zle redisplay
}

zle     -N    fzf-find-command-widget
bindkey '\ex' fzf-find-command-widget

# +=========================+
# | History Configuration   |
# +-------------------------+

HISTSIZE=10000              #How many lines of history to keep in memory
HISTFILE=~/.zsh_history     #Where to save history to disk
SAVEHIST=10000              #Number of history entries to save to disk
HISTDUP=erase               #Erase duplicates in the history file
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt appendhistory     #Append history to the history file (no overwriting)
setopt sharehistory      #Share history across terminals
setopt incappendhistory  #Immediately append to the history file, not just when a term is killed


# +=========================+
# | Shell configuration     |
# +-------------------------+

setopt autocd extendedglob
bindkey -v

autoload -U edit-command-line
zle -N edit-command-line

bindkey -M vicmd v edit-command-line

# The following lines were added by compinstall
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Za-z}' 'l:|=* r:|=*' 'r:|[._-]=* r:|=*'
#zstyle ':completion:*' max-errors 3
zstyle :compinstall filename '${HOME}/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

export LANG=en_US.UTF-8
export LC_TIME=en_DK.UTF-8
export EDITOR='nvim'
export MANPAGER='nvim +Man!'


# +=========================+
# | Antibody plugin manager |
# +-------------------------+

if [ ! -f ~/.zsh_plugins.sh -a -f ~/.zsh_plugins.txt ];
then
    antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh
fi
[ -f ~/.zsh_plugins.sh ] && source ~/.zsh_plugins.sh


# +=========================+
# | Aliases                 |
# +-------------------------+

# To use `sudo` with aliases
alias sudo='sudo '

alias ls='exa'
alias l='ls -l --group-directories-first --git --color-scale'
alias la='l -a'
alias lt='la -s newest'

alias cat='bat'
alias caty='bat -lyaml'
alias tf="terraform"
alias tf11="terraform11"

alias cp="rsync --archive --human-readable --partial --progress"

alias k="kubectl"
alias kd="kubectl describe"
alias kgy="kubectl get -oyaml"
alias kga="kubectl get -A"
alias kc="kubectx"
alias kn="kubens"

function kk() {
  local kroot=~/.kube/konfigs
  local konfigs=$('ls' -A $kroot)

  if [ ! -n "$konfigs" ]
  then
    echo There are no konfigs at $kroot
    return
  fi


  if [ -z ${1+x} ]
  then
    local kubeconfig=$kroot/$(echo $konfigs | fzf)
  else
    local kubeconfig=$kroot/$1
  fi

  if [ -n "$('ls' $kubeconfig)" ]
  then
    export KUBECONFIG=$kubeconfig
  fi
}

alias gmerge='( read branch && git pull && git merge origin/$branch -m "Merge $branch → $(git symbolic-ref --short -q HEAD)" && git push ) <<<'
alias gship='( read branch && gmerge $branch && git push origin :$branch ) <<<'
alias cpdiff='git diff --color | iconv -f cp1251 -t utf8 | less -r'

alias tru='trans -j en:ru'
alias ten='trans -j ru:en'
alias пер='trans -j ru:en'

alias truen='trans -j ru:en'
alias tenru='trans -j en:ru'

alias tende='trans -j en:de'
alias tdeen='trans -j de:en'

alias trude='trans -j ru:de'
alias tderu='trans -j de:ru'

alias t='task'

alias tt='timew'

alias todo='topydo'
alias todoc='topydo columns'

alias dontgiveup='( read p; until eval $p; do sleep 1; done ) <<<'
alias wanip='dig +short myip.opendns.com @resolver1.opendns.com'
alias cleanup='find . -name "*~" -print -exec rm -f {} \;'

alias ffmpeg='ffmpeg -hide_banner'

if [ ! $commands[pbcopy] ]; then
  alias pbcopy="xclip -selection c"
  alias pbpaste="xclip -selection clipboard -o"
fi


# +=========================+
# | PATHs                   |
# +-------------------------+

export PATH="$HOME/.local/bin:${PATH}"
export PATH="$HOME/.cargo/bin:${PATH}"
export PATH="$HOME/.krew/bin:${PATH}"
export PATH="$HOME/go/bin:${PATH}"
export PATH="$HOME/bin:${PATH}"


# +=========================+
# | pyenv                   |
# +-------------------------+

if [ $commands[pyenv] ]; then
    eval "$(pyenv init -)"
fi


# +=========================+
# | Local npm packages      |
# +-------------------------+

if [ $commands[npm] ]; then
    NPM_PACKAGES="${HOME}/.local/lib/npm_packages"
    export PATH="$NPM_PACKAGES/bin:$PATH"
    NO_UPDATE_NOTIFIER=1 npm config set prefix $NPM_PACKAGES

    # Unset manpath so we can inherit from /etc/manpath via the `manpath` command
    unset MANPATH # delete if you already modified MANPATH elsewhere in your config
    export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
fi


# +=========================+
# | Spaceship prompt        |
# +-------------------------+

SPACESHIP_PROMPT_ORDER=(
    #time          # Time stampts section
    user          # Username section
    dir           # Current directory section
    host          # Hostname section
    git           # Git section (git_branch + git_status)
    # hg            # Mercurial section (hg_branch  + hg_status)
    package       # Package version
    # node          # Node.js section
    # ruby          # Ruby section
    # elm           # Elm section
    # elixir        # Elixir section
    # xcode         # Xcode section
    # swift         # Swift section
    golang        # Go section
    php           # PHP section
    rust          # Rust section
    # haskell       # Haskell Stack section
    # julia         # Julia section
    # docker        # Docker section
    # aws           # Amazon Web Services section
    venv          # virtualenv section
    # conda         # conda virtualenv section
    pyenv         # Pyenv section
    # dotnet        # .NET section
    # ember         # Ember.js section
    # kubectl       # Kubectl context section
    terraform     # Terraform workspace section
    exec_time     # Execution time
    line_sep      # Line break
    battery       # Battery level and status
    vi_mode       # Vi-mode indicator
    jobs          # Background jobs indicator
    exit_code     # Exit code section
    char          # Prompt character
)
spaceship_vi_mode_enable

SPACESHIP_RPROMPT_ORDER=(docker_machine kubeconfig)

spaceship_docker_machine() {
  [[ -z $DOCKER_MACHINE_NAME ]] && return

  spaceship::section \
    "$SPACESHIP_DOCKER_COLOR" \
    "$SPACESHIP_DOCKER_PREFIX" \
    "${SPACESHIP_DOCKER_SYMBOL} via ($DOCKER_MACHINE_NAME)" \
    "$SPACESHIP_DOCKER_SUFFIX"
}

spaceship_kubeconfig() {
  [[ -z $KUBECONFIG ]] && return

  spaceship_kubectl_context
}


# +=========================+
# | Library                 |
# +-------------------------+

export TIMEFMT='%J   %U  user %S system %P cpu %*E total'$'\n'\
'avg shared (code):         %X KB'$'\n'\
'avg unshared (data/stack): %D KB'$'\n'\
'total (sum):               %K KB'$'\n'\
'max memory:                %M MB'$'\n'\
'page faults from disk:     %F'$'\n'\
'other page faults:         %R'

# Use fd and fzf to get the args to a command.
# Works only with zsh
# Examples:
# f mv # To move files. You can write the destination after selecting the files.
# f 'echo Selected:'
# f 'echo Selected music:' --extention mp3
# fm rm # To rm files in current directory
f() {
    sels=( "${(@f)$(fd "${fd_default[@]}" "${@:2}"| fzf)}" )
    test -n "$sels" && print -z -- "$1 ${sels[@]:q:q}"
}

# Like f, but not recursive.
fm() f "$@" --max-depth 1

# fco_preview - checkout git branch/tag, with a preview showing the commits between the tag/branch and HEAD
fco_preview() {
  local tags branches target
  branches=$(
    git --no-pager branch --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches"; echo "$tags") |
    fzf --no-hscroll --no-multi -n 2 \
        --ansi --preview="git --no-pager log -150 --pretty=format:%s '..{2}'") || return
  git checkout $(awk '{print $2}' <<<"$target" )
}


# +=========================+
# | Autocompletion          |
# +-------------------------+

if [ $commands[stern] ]; then source <(stern --completion zsh); fi

if [ $commands[hcloud] ]; then source <(hcloud completion zsh); fi

if [ $commands[kubectl] ]; then source <(kubectl completion zsh | sed '/"-f"/d'); fi

if [[ -f ~/.config/tabtab/__tabtab.zsh ]]; then source ~/.config/tabtab/__tabtab.zsh; fi


# +=========================+
# | Gnome keyring           |
# +-------------------------+

if [ $commands[gnome-keyring-daemon] ];
then
    eval $(gnome-keyring-daemon -s --components=gpg,pkcs11,secrets,ssh)
    export SSH_AUTH_SOCK
fi



GPG_TTY=$(tty)
export GPG_TTY


# +=========================+
# | Command line hooks      |
# +-------------------------+

if [ $commands[fasd] ]; then eval "$(fasd --init auto)"; fi
export FZFZ_SUBDIR_LIMIT=0
export FZFZ_RECENT_DIRS_TOOL=fasd

[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh

if [ $commands[direnv] ]; then eval "$(direnv hook zsh)"; fi


# +=========================+
# | Various adjustments     |
# +-------------------------+

# Use Docker buildkit by default
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1


# +=========================+
# | Local overrides         |
# +-------------------------+

. $HOME/.zshrc.local
