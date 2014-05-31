# Attractive

# aliases to use in this code
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
  eval FONT_$color='%{$fg[${(L)color}]%}'
done
eval FONT_NO_COLOR="%{$terminfo[sgr0]%}"
eval FONT_BOLD="%{$terminfo[bold]%}"

# main prompt settings
PROMPT='
$(_date_and_time) $(_user_host)${_current_dir} $(git_prompt_info) $(_ruby_version)
${_return_status}$(_prompt_sign)'

#PROMPT2='%{$fg[grey]%}◀%{$reset_color%} '

RPROMPT='$(_vi_status)%{$(echotc UP 1)%} \
    $(_git_time_since_commit) %{$(echotc DO 1)%}'

local _current_dir="%{$fg[blue]%}%3~%{$reset_color%} "
local _return_status="%{$fg[red]%}%(?..!)%{$reset_color%}"
local _hist_no="%{$fg[grey]%}%h%{$reset_color%}"

function _date_and_time() {
  date "+‹%Y.%m.%d %H:%M:%S›"
}

function _prompt_sign() {
  if [[ $USER == "root" ]]; then
    echo "${FONT_BOLD}%{$fg[red]%}# %{$reset_color%}"
  else 
    echo "${FONT_BOLD}%{$fg[green]%}$ %{$reset_color%}"
  fi
}

function _user_host() {
  local _me=''

  if [[ -n $SSH_CONNECTION || -n $SSH_CLIENT || -n $SSH2_CLIENT ]]; then # We're on SSH
    _me="%n@%m"
  else 
    _me="%n"
  fi

  if [[ ${USER} == 'root' ]]; then
    echo "%{$fg[red]%}${_me}%{$reset_color%}:"
  elif [[ -n ${_me} ]]; then
    echo "%{$fg[green]%}${_me}%{$reset_color%}:"
  fi
}

function _vi_status() {
  if {echo $fpath | grep -q "plugins/vi-mode"}; then
    echo "$(vi_mode_prompt_info)"
  fi
}

function _ruby_version() {
  if {echo $fpath | grep -q "plugins/rvm"};
    then
    
    echo "%{$fg[grey]%}$(rvm_prompt_info)%{$reset_color%}"
  fi
}

# Determine the time since last commit. If branch is clean,
# use a neutral color, otherwise colors will vary according to time.
function _git_time_since_commit() {
  if git rev-parse --git-dir > /dev/null 2>&1; 
  then

    # Only proceed if there is actually a commit.
    if [[ $(git log 2>&1 > /dev/null | grep -c "^fatal: bad default revision") == 0 ]]; then
      # Get the last commit.
      local last_commit=$(git log --pretty=format:'%at' -1 2> /dev/null)
      local now=$(date +%s)
      local seconds_since_last_commit=$((now-last_commit))

      # Totals
      local minutes=$((seconds_since_last_commit / 60))
      local hours=$((seconds_since_last_commit/3600))
      local days=$((seconds_since_last_commit / 86400))
      local weeks=$((seconds_since_last_commit / 604800))

      # Sub-hours and sub-minutes
      local sub_hours=$((hours % 24))
      local sub_minutes=$((minutes % 60))
      local sub_days=$((days % 7))

      if [ ${seconds_since_last_commit} -ge 0 ] && [ ${seconds_since_last_commit} -lt 10 ]; then
        commit_age="just moments"
        color=$ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT
      elif [ ${seconds_since_last_commit} -ge 10 ] && [ ${seconds_since_last_commit} -lt 60 ]; then
        commit_age="${seconds_since_last_commit} seconds"
        color=$ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT
      elif [ ${seconds_since_last_commit} -ge 60 ] && [ ${seconds_since_last_commit} -lt 120 ]; then
        commit_age="a minute"
        color=$ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT
      elif [ ${seconds_since_last_commit} -ge 120 ] && [ ${seconds_since_last_commit} -lt 3540 ]; then
        commit_age="${sub_minutes} minutes"
        color=$ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT
      elif [ ${seconds_since_last_commit} -ge 3540 ] && [ ${seconds_since_last_commit} -lt 7100 ]; then
        commit_age="an hour"
        color=$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL
      elif [ ${seconds_since_last_commit} -ge 7100 ] && [ ${seconds_since_last_commit} -lt 82800 ]; then
        commit_age="${sub_hours} hours"
        color=$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL
      elif [ ${seconds_since_last_commit} -ge 82800 ] && [ ${seconds_since_last_commit} -lt 172000 ]; then
        commit_age="a day"
        color=$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL
      elif [ ${seconds_since_last_commit} -ge 172000 ] && [ ${seconds_since_last_commit} -lt 518400 ]; then
        commit_age="${sub_days} days"
        color=$ZSH_THEME_GIT_TIME_SINCE_COMMIT_MEDIUM
      elif [ ${seconds_since_last_commit} -ge 518400 ] && [ ${seconds_since_last_commit} -lt 1036800 ]; then
        commit_age="a week"
        color=$ZSH_THEME_GIT_TIME_SINCE_COMMIT_MEDIUM
      else
        commit_age="${weeks} weeks"
        color=$ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG
      fi

      # Colorize and 
      echo "Last Commited $(git_prompt_status) $color$commit_age ago%{$reset_color%}"
    fi
  fi
}

if [[ $USER == "root" ]]; then
  CARETCOLOR="red"
else
  CARETCOLOR="white"
fi

MODE_INDICATOR="%{$fg_bold[yellow]%}❮%{$reset_color%}%{$fg[yellow]%}❮❮%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}✔%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}✚"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}⚡"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✖"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[yellow]%}A»B"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[cyan]%}∆"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[grey]%}¿¿"

# Colors vary depending on time lapsed.
ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$fg[green]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%{$fg[white]%}"
ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$fg[yellow]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$fg[red]%}"


# LS colors, made with http://geoff.greer.fm/lscolors/
export LSCOLORS="exfxcxdxbxegedabagacad"
export LS_COLORS='di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'
export GREP_COLOR='1;33'

