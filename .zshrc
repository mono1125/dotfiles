# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


### Added by Zinit's installer (zdharma-continuum)
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓ ▒ ░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})… %f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
       print -P "%F{33}▓ ▒ ░ %F{34}Installation successful.%f%b" || \
       print -P "%F{160}▓ ▒ ░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/z-a-rust \
    zdharma-continuum/z-a-as-monitor \
    zdharma-continuum/z-a-patch-dl \
    zdharma-continuum/z-a-bin-gem-node \
    zsh-users/zsh-syntax-highlighting \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-completions \
    zdharma-continuum/history-search-multi-word \
    romkatv/powerlevel10k
### End of Zinit's installer chunk

### Oh-my-zsh setup ###
# OMZL: Library, OMZP: Plugin
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit cdclear -q
### End of Oh-my-zsh setup ###

setopt autocd              # change directory just by typing its name
setopt correct            # auto correct mistakes
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt
setopt print_eight_bit # 日本語ファイル名を表示可能にする
setopt auto_param_keys # 括弧の対応などを自動補完
setopt list_packed # 補完候補をできるだけ詰めて表示
autoload -Uz colors && colors
WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word

# hide EOL sign ('%')
PROMPT_EOL_MARK=""

# configure key keybindings
bindkey -e                                        # emacs key bindings
bindkey ' ' magic-space                           # do history expansion on space
bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo last action

# enable completion features
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case insensitive tab completion

# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=200000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history         # share command history data

# force zsh to show the complete history
alias history="history 0"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# neovim color
## .vimrcで set termguicolors 指定。
## vimでTrueColorを使用するために必要
COLORTERM='truecolor'

# GNU Command
alias ls="gls --color=auto"
alias grep="ggrep --color=auto"
alias tar="gtar"
alias diff="diff --color=auto"

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
# 安全対策
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# クリップボード 要xsel
# alias pbcopy='xsel --clipboard --input'
# alias pbpaste='xsel --clipboard --output'
# カレントディレクトリのパスをクリップボードにコピー
# alias pwdc='pwd | tr -d "\n" | pbcopy'
# treeコマンド代用
alias tree="pwd;find . | sort | sed '1d;s/^\.//;s/\/\([^/]*\)$/|--\1/;s/\/[^/|]*/| /g'"

# alias vi='nvim'
# alias vim='nvim'
# neovim
export XDG_CONFIG_HOME="$HOME/.config"

# ============================== Start of fzf =============================== #

# -------------------- How to Install -------------------- #
# = Using git = #
# $ git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
# $ ~/.fzf/install
# = Using package manager = #
# $ sudo apt update && sudo apt install fzf
# $ sudo apt install bat <- batcatになる可能性がある(名前衝突回避のため)
# --> $ mkdir -p ~/.local/bin && ln -s /usr/bin/batcat ~/.local/bin/bat
# = Upgrading fzf = #
# git: $ cd ~/.fzf && git pull && /.install
# -------------------- End of Install -------------------- #

export FZF_DEFAULT_OPTS='--color=fg+:11 --height 70% --reverse --select-1 --exit-0 --multi'

# git checkout branchをfzfで選択
alias co='git checkout $(git branch -a | tr -d " " |fzf --height 100% --prompt "CHECKOUT BRANCH>" --preview "git log --color=always {}" | head -n 1 | sed -e "s/^\*\s*//g" | perl -pe "s/remotes\/origin\///g")'

# fshow - git commit browser
fshow() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

# git add(複数選択可能)
## lessにパイプで結果を流した際に色が消えるのを回避するために
## expectパッケージのunbufferというツールを使っている
## $ sudo apt install expect
function gadd() {
    local selected
    selected=$(unbuffer git status -s | fzf -m --ansi --preview="echo {} | awk '{print \$2}' | xargs git diff --color" | awk '{print $2}')
    if [[ -n "$selected" ]]; then
        selected=$(tr '\n' ' ' <<< "$selected")
        git add $selected
        echo "Completed: git add $selected"
    fi
}

# fkill - kill process
fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

# ------------------------------------------------------------------- #
# directory ( https://github.com/atweiden/fzf-extras )

# cdコマンドをまとめたもの
## zd -d カレントディレクトリを再帰的に検索
## zd -a カレントディレクトリを隠しディレクトリ含めて再帰的に検索
## zd -s ディレクトリスタックを検索(現在セッションで過去にいたディレクトリ)
## zd -r 親ディレクトリを再帰的に検索
## zf -f ファイルを検索してそのファイルがあるディレクトリにcdする
## zd -z 行ったことのあるディレクトリに移動(clvv/fasdが必要)
## zd -h ヘルプメッセージを表示
# ------------------------------------------------------------------- #

# fzf --preview command for file and directory
if type bat >/dev/null 2>&1; then
    FZF_PREVIEW_CMD='bat --color=always --plain --line-range :$FZF_PREVIEW_LINES {}'
elif type pygmentize >/dev/null 2>&1; then
    FZF_PREVIEW_CMD='head -n $FZF_PREVIEW_LINES {} | pygmentize -g'
else
    FZF_PREVIEW_CMD='head -n $FZF_PREVIEW_LINES {}'
fi

# zdd - cd to selected directory
zdd() {
  local dir
  dir="$(
    find "${1:-.}" -path '*/\.*' -prune -o -type d -print 2> /dev/null \
      | fzf +m \
          --preview='tree -C {} | head -n $FZF_PREVIEW_LINES' \
          --preview-window='right:hidden:wrap' \
          --bind=ctrl-v:toggle-preview \
          --bind=ctrl-x:toggle-sort \
          --header='(view:ctrl-v) (sort:ctrl-x)' \
  )" || return
  cd "$dir" || return
}

# zda - including hidden directories
zda() {
  local dir
  dir="$(
    find "${1:-.}" -type d 2> /dev/null \
      | fzf +m \
          --preview='tree -C {} | head -n $FZF_PREVIEW_LINES' \
          --preview-window='right:hidden:wrap' \
          --bind=ctrl-v:toggle-preview \
          --bind=ctrl-x:toggle-sort \
          --header='(view:ctrl-v) (sort:ctrl-x)' \
  )" || return
  cd "$dir" || return
}

# zdr - cd to selected parent directory
zdr() {
  local dirs=()
  local parent_dir

  get_parent_dirs() {
    if [[ -d "$1" ]]; then dirs+=("$1"); else return; fi
    if [[ "$1" == '/' ]]; then
      for _dir in "${dirs[@]}"; do echo "$_dir"; done
    else
      get_parent_dirs "$(dirname "$1")"
    fi
  }

  parent_dir="$(
    get_parent_dirs "$(realpath "${1:-$PWD}")" \
      | fzf +m \
          --preview 'tree -C {} | head -n $FZF_PREVIEW_LINES' \
          --preview-window='right:hidden:wrap' \
          --bind=ctrl-v:toggle-preview \
          --bind=ctrl-x:toggle-sort \
          --header='(view:ctrl-v) (sort:ctrl-x)' \
  )" || return

  cd "$parent_dir" || return
}

# zst - cd into the directory from stack
zst() {
  local dir
  dir="$(
    dirs \
      | sed 's#\s#\n#g' \
      | uniq \
      | sed "s#^~#$HOME#" \
      | fzf +s +m -1 -q "$*" \
            --preview='tree -C {} | head -n $FZF_PREVIEW_LINES' \
            --preview-window='right:hidden:wrap' \
            --bind=ctrl-v:toggle-preview \
            --bind=ctrl-x:toggle-sort \
            --header='(view:ctrl-v) (sort:ctrl-x)' \
  )"
  # check $dir exists for Ctrl-C interrupt
  # or change directory to $HOME (= no value cd)
  if [[ -d "$dir" ]]; then
    cd "$dir" || return
  fi
}

# zdf - cd into the directory of the selected file
zdf() {
  local file
  file="$(fzf +m -q "$*" \
           --preview="${FZF_PREVIEW_CMD}" \
           --preview-window='right:hidden:wrap' \
           --bind=ctrl-v:toggle-preview \
           --bind=ctrl-x:toggle-sort \
           --header='(view:ctrl-v) (sort:ctrl-x)' \
       )"
  cd "$(dirname "$file")" || return
}

# zde - edit of the selected file
zde() {
  local file
  file="$(fzf +m -q "$*" \
           --preview="${FZF_PREVIEW_CMD}" \
           --preview-window='right:hidden:wrap' \
           --bind=ctrl-v:toggle-preview \
           --bind=ctrl-x:toggle-sort \
           --header='(view:ctrl-v) (sort:ctrl-x)' \
       )"
  nvim "$file" || return
}

# zz - selectable cd to frecency directory
zz() {
  local dir

  dir="$(
    fasd -dl \
      | fzf \
          --tac \
          --reverse \
          --select-1 \
          --no-sort \
          --no-multi \
          --tiebreak=index \
          --bind=ctrl-x:toggle-sort \
          --query "$*" \
          --preview='tree -C {} | head -n $FZF_PREVIEW_LINES' \
          --preview-window='right:hidden:wrap' \
          --bind=ctrl-v:toggle-preview \
          --bind=ctrl-x:toggle-sort \
          --header='(view:ctrl-v) (sort:ctrl-x)' \
  )" || return

  cd "$dir" || return
}

# zd - cd into selected directory with options
# The super function of zdd, zda, zdr, zst, zdf, zz
zd() {
  read -r -d '' helptext <<EOF
usage: zd [OPTIONS]
  zd: cd to selected options below
OPTIONS:
  -d [path]: Directory (default)
  -a [path]: Directory included hidden
  -r [path]: Parent directory
  -s [query]: Directory from stack
  -f [query]: Directory of the selected file
  -z [query]: Frecency directory
  -h: Print this usage
EOF

  usage() {
    echo "$helptext"
  }

  if [[ -z "$1" ]]; then
    # no arg
    zdd
  elif [[ "$1" == '..' ]]; then
    # arg is '..'
    shift
    zdr "$1"
  elif [[ "$1" == '-' ]]; then
    # arg is '-'
    shift
    zst "$*"
  elif [[ "${1:0:1}" != '-' ]]; then
    # first string is not -
    zdd "$(realpath "$1")"
  else
    # args is start from '-'
    while getopts darfszh OPT; do
      case "$OPT" in
        d) shift; zdd  "$1";;
        a) shift; zda "$1";;
        r) shift; zdr "$1";;
        s) shift; zst "$*";;
        f) shift; zdf "$*";;
        z) shift; zz  "$*";;
        h) usage; return 0;;
        *) usage; return 1;;
      esac
    done
  fi
}

# =============================== End of fzf =============================== #

# Node.js version manager
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# GNU Command Paths
PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
PATH="/opt/homebrew/opt/difftils/bin:$PATH"
PATH="/opt/homebrew/opt/gnu-tar/libexec/gnubin:$PATH"
PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"
PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniforge/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

