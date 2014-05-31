# Attractive theme
# This theme is inspired by "agonster theme"

# main prompt settings
PROMPT='
$(_date_and_time) $(_user_host)${_current_dir} $(git_prompt_info) $(_ruby_version)
${_return_status}$(_prompt_sign)'

RPROMPT='$(_vi_status)%{$(echotc UP 1)%} \
    $(_git_time_since_commit) %{$(echotc DO 1)%}'


function _date_and_time() {
  # Display date and time.
  # Example: "2014.05.31 15:25:53"
  date "+‹%Y.%m.%d %H:%M:%S›"
}

function _prompt_sign() {
  if [[ $USER == "root" ]]; then
    # Display caret sign, "#", when root user is logged in.
    # Example: "#"
    echo "${FONT_BOLD}%{$fg[red]%}# %{$reset_color%}"
  else 
    # Display caret sign, "$", when non-root user is logged in.
    # Example: "$"
    echo "${FONT_BOLD}%{$fg[green]%}$ %{$reset_color%}"
  fi
}

function _user_host() {
  local _me=''

  if [[ -n $SSH_CONNECTION || -n $SSH_CLIENT || -n $SSH2_CLIENT ]]; then
    # Display username and computer name, when we're on SSH
    # Example: "melvkim@osx"
    _me="%n@%m"
  else 
    # Display username only, when we're not on SSH
    # Example: "melvkim"
    _me="%n"
  fi

  if [[ ${USER} == 'root' ]]; then
    # Colorize caret sign, "$", in red, when root user is logged in.
    echo "%{$fg[red]%}${_me}%{$reset_color%}:"
  elif [[ -n ${_me} ]]; then
    # Colorize caret sign, "$", in red, when non-user is logged in.
    echo "%{$fg[green]%}${_me}%{$reset_color%}:"
  fi
}

function _vi_status() {
  if {echo $fpath | grep -q "plugins/vi-mode"}; then
    
    # Display vim mode
    # NOTE: not fully tested. Use it with your own discretion.
    echo "$(vi_mode_prompt_info)"
  fi
}


function _ruby_version() {
  if {echo $fpath | grep -q "plugins/rvm"};
    then
    
    # Display ruby version info
    # NOTE: not fully tested. Use it with your own discretion.
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

      # Colorize and display commit age.
      echo "Last Committed $(git_prompt_status) $color$commit_age ago%{$reset_color%}"
    fi
  fi
}

# Set environment variables
local _current_dir="%{$fg[blue]%}%3~%{$reset_color%} "
local _return_status="%{$fg[red]%}%(?..!)%{$reset_color%}"
export GREP_COLOR='1;33'

# Color settings
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
  eval FONT_$color='%{$fg[${(L)color}]%}'
done
eval FONT_NO_COLOR="%{$terminfo[sgr0]%}"
eval FONT_BOLD="%{$terminfo[bold]%}"

if [[ $USER == "root" ]]; then
  CARETCOLOR="red"
else
  CARETCOLOR="white"
fi

# Git settings (status theme)
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

# Git settings (status symbols)
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}✔%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}✚%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}⚡%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✖%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[yellow]%}A»B%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[cyan]%}∆%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[grey]%}¿¿%{$reset_color%}"

# Colorize  git-time-since-commit, depending on its age.
ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$fg[green]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%{$fg[white]%}"
ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$fg[yellow]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$fg[red]%}"
