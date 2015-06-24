# Query/use custom command for `git`.
zstyle -s ":vcs_info:git:*:-all-" "command" _omz_git_git_cmd
: ${_omz_git_git_cmd:=git}

#
# Functions
#

# The current branch name
# Usage example: git pull origin $(current_branch)
# Using '--quiet' with 'symbolic-ref' will not cause a fatal error (128) if
# it's not a symbolic ref, but in a Git repo.
function current_branch() {
  local ref
  ref=$($_omz_git_git_cmd symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$($_omz_git_git_cmd rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}
# The list of remotes
function current_repository() {
  if ! $_omz_git_git_cmd rev-parse --is-inside-work-tree &> /dev/null; then
    return
  fi
  echo $($_omz_git_git_cmd remote -v | cut -d':' -f 2)
}
# Pretty log messages
function _git_log_prettily(){
  if ! [ -z $1 ]; then
    git log --pretty=$1
  fi
}
# Warn if the current branch is a WIP
function work_in_progress() {
  if $(git log -n 1 2>/dev/null | grep -q -c "\-\-wip\-\-"); then
    echo "WIP!!"
  fi
}

#
# Aliases
# (sorted alphabetically)
#

alias g='git'
compdef g=git

# git status
compdef _git gs=git-status
alias gs='git status -sb'
compdef _git gsb=git-status

# git diff
alias gd='git diff'
gdv() { git diff -w "$@" | view - }
compdef _git gdv=git-diff
alias gdc='git diff --cached'
compdef _git gdc=git-diff
alias gdt='git diff-tree --no-commit-id --name-only -r'
compdef _git gdc=git diff-tree --no-commit-id --name-only -r
gdv() { git diff -w "$@" | view - }
compdef _git gdv=git-diff
alias gdw='git diff --word-diff'

# git push
alias gp='git push'
compdef _git gp=git-push
alias gpo='git push origin'
compdef _git gpo=git-push
alias gpom='git push origin master'
compdef _git gpom=git-push
alias gpom!='git push -f origin master'
compdef _git gpom!=git-push
alias gpd='git push --dry-run'
compdef _git gpd=git-push
alias gpu='git push upstream'
compdef _git gpu=git-push
alias gpv='git push -v'
compdef _git gpv=git-push

# git add
alias ga='git add'
compdef _git ga=git-add
alias gaa='git add --all'
compdef _git gaa=git-add
alias gap='git add --patch'
compdef _git gap=git-add

# git branch
alias gb='git branch'
alias gbda='git branch --merged | command grep -vE "^(\*|\s*master\s*$)" | command xargs -n 1 git branch -d'
alias gbnm='git branch --no-merged'
alias gbr='git branch --remote'

# git blame || git bisect
alias gbl='git blame -b -w'
alias gbs='git bisect'
alias gbsb='git bisect bad'
alias gbsg='git bisect good'
alias gbsr='git bisect reset'
alias gbsi='git bisect start'
alias gbss='git bisect skip'
alias gbsr='git bisect replay'

# git commit
alias gc='git commit'
compdef _git gc=git-commit
alias gcv='git commit -v'
compdef _git gcv=git-commit
alias gcam='git commit -am'
compdef _git gcam=git-commit
alias gca='git commit --amend'
compdef _git gca=git-commit
# Sign and verify commits with GPG
alias gcs='git commit -S'
compdef _git gcs=git-commit
alias gcan!='git commit -v -a -s --no-edit --amend'

# git remote
alias gr='git remote'
compdef _git gr=git-remote
alias grr='git remote rename'
compdef _git grr=git-remote
alias grrm='git remote remove'
compdef _git grrm=git-remote

# git rebase
alias grb='git rebase'
compdef _git grb=git-rebase
alias grbi='git rebase -i'
compdef _git grbi=git-rebase
alias grbc='git rebase --continue'
compdef _git grbc=git-rebase
alias grba='git rebase --abort'
compdef _git grba=git-rebase
alias grbs='git rebase --skip'
compdef _git grbs=git-rebase

# git checkout
alias gco='git checkout'
compdef _git gco=git-checkout
alias gcom='git checkout master'
compdef _git gcom=git-checkout
alias gcod='git checkout develop'
compdef _git gcod=git-checkout
alias gcob='git checkout -b'
compdef _git gcob=git-checkout

# git config
alias gcf='git config --list'

# git cherry-pick
alias gcp='git cherry-pick'
compdef _git gcp=git-cherry-pick

# git log
alias gl='git log --pretty=format:\
"\
%C(yellow)%h%C(reset)\
%C(red) %ar%C(reset)\
%C(green) %cn%C(reset)\
%C(bold magenta)%d%C(reset)\
%C(white) \"%s\"%C(reset)\
" \
--decorate --date=short'
compdef _git gl=git-log
alias gll='git log --abbrev-commit --all --graph --color --pretty=format:"\
    %C(green) %cN %C(reset) %C(red)%ar%C(reset) %C(bold magenta)%d%C(reset)%n\
%C(yellow)%h%Creset \"%s\"%n"'
compdef _git gll=git-log
alias glll='git log --stat --all --decorate --color --graph --max-count=30'
compdef _git glll=git-log

# git log --all
alias gl='git log --pretty=format:\
"\
%C(yellow)%h%C(reset)\
%C(red) %ar%C(reset)\
%C(green) %cn%C(reset)\
%C(bold magenta)%d%C(reset)\
%C(white) \"%s\"%C(reset)\
" \
--decorate --date=short --all'
compdef _git gL=git-log
alias gLL='git log --abbrev-commit --all --graph --color --pretty=format:"\
    %C(green) %cN %C(reset) %C(red)%ar%C(reset) %C(bold magenta)%d%C(reset)%n\
%C(yellow)%h%Creset \"%s\"%n" --decorate --all'
compdef _git gLL=git-log
alias gLLL='git log --stat --all --decorate --color --graph --max-count=30'
compdef _git gLLL=git-log
alias gdd='git whatchanged -p --abbrev-commit --pretty=medium' # what changed from last commit
compdef _git glp=git-log

# git add
alias ga='git add'
compdef _git ga=git-add
alias ga!='git add --all'

# git merge
alias gm='git merge'
compdef _git gm=git-merge
alias gmom='git merge origin/master'
compdef _git gmom=git-merge
alias gmt='git mergetool --no-prompt'
compdef _git gmt=git-merge
alias gmtvim='git mergetool --no-prompt --tool=vimdiff'
compdef _git gmtvi=git-merge
alias gmum='git merge upstream/master'
compdef _git gmum=git-merge

# git reset && git clean
alias grh!='git reset --hard'
alias grhh!='git reset --hard HEAD'
alias grhh1!='git reset --hard HEAD~1'
alias grs!='git reset --soft'
alias grsh!='git reset --soft HEAD'
alias grsh1!='git reset --soft HEAD~1'
alias gclean!='git clean -dfx'

ggf() {
[[ "$#" != 1 ]] && local b="$(current_branch)"
git push --force origin "${b:=$1}"
}
compdef _git ggf=git-checkout
ggl() {
if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
git pull origin "${*}"
else
[[ "$#" == 0 ]] && local b="$(current_branch)"
git pull origin "${b:=$1}"
fi
}
compdef _git ggl=git-checkout
alias ggpull='git pull origin $(current_branch)'
compdef _git ggpull=git-checkout
ggp() {
if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
git push origin "${*}"
else
[[ "$#" == 0 ]] && local b="$(current_branch)"
git push origin "${b:=$1}"
fi
}
compdef _git ggp=git-checkout
ggpnp() {
if [[ "$#" == 0 ]]; then
ggl && ggp
else
ggl "${*}" && ggp "${*}"
fi
}
compdef _git ggpnp=git-checkout
alias ggsup='git branch --set-upstream-to=origin/$(current_branch)'
ggu() {
[[ "$#" != 1 ]] && local b="$(current_branch)"
git pull --rebase origin "${b:=$1}"
}
compdef _git ggu=git-checkout
alias ggpur='ggu'
compdef _git ggpur=git-checkout

alias gignore='git update-index --assume-unchanged'
alias gignored='git ls-files -v | grep "^[[:lower:]]"'
alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'
compdef git-svn-dcommit-push=git

alias gk='\gitk --all --branches'
compdef _git gk='gitk'
alias gke='\gitk --all $(git log -g --pretty=format:%h)'
compdef _git gke='gitk'

alias gsd='git svn dcommit'
alias gsi='git submodule init'
alias gsps='git show --pretty=short --show-signature'
alias gsr='git svn rebase'
alias gsta='git stash'
alias gstaa='git stash apply'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash show --text'
alias gsu='git submodule update'

alias gts='git tag -s'

alias gunignore='git update-index --no-assume-unchanged'
alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'

alias gvt='git verify-tag'

alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit -m "--wip--"'
