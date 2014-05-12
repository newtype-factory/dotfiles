# フォント特有の記号
BRANCH_MARK=$'\ue0a0'$'\ua0'
LN_MARK=$'\ue0a1'$'\ua0'
KEY_MARK=$'\ue0a2'$'\ua0'
ARROW_MARK=$'\ue0b0'$'\ua0'
ARROW2_MARK=$'\ue0b1'$'\ua0'
RIGHT_ARROW_MARK=$'\ue0b2'
RIGHT_ARROW2_MARK=$'\ue0b3'

CLEAN_MARK='%F{202}'$'\u2600''%f'
DIRTY_MARK='%F{33}'$'\u2602''%f'

UNTRACKED_MARK='%F{226}✭%f'
ADDED_MARK='%F{10}✚%f'
MODIFIED_MARK='%F{165}✹%f'
RENAMED_MARK='%F{2}➜%f'
DELETED_MARK='%F{166}✖%f'

# repository check
function repository_check() {
  local DIR=''
  DIR=$(command git rev-parse --git-dir 2> /dev/null)
  if [ -n "${DIR}" ]; then
    echo true
  else
    echo false
  fi
}

# branch name
function get_branch_name() {
  local NAME=''
  NAME=$(command git symbolic-ref HEAD 2> /dev/null)
  if [ -n "${NAME}" ]; then
    echo ${NAME#refs/heads/}
  fi
}

# dirty check
function git_dirty_check() {
  local STATUS=''
  STATUS=$(command git status -s --ignore-submodules=dirty 2> /dev/null | tail -n1)
  if [ -n "${STATUS}" ]; then
    echo ${DIRTY_MARK}
  else
    echo ${CLEAN_MARK}
  fi
}

# status check
function get_status() {
  local STATUS='' MESSAGE=''
  STATUS=$(command git status -s --porcelain 2> /dev/null)
  if $(echo "${STATUS}" | grep -E '^\?\? ' &> /dev/null); then
    MESSAGE="${UNTRACKED_MARK}${MESSAGE}"
  fi
  if $(echo "${STATUS}" | grep '^\(A\|M\) ' &> /dev/null); then
    MESSAGE="${ADDED_MARK}${MESSAGE}"
  fi
  if $(echo "${STATUS}" | grep '^\( M\|AM\| T\) ' &> /dev/null); then
    MESSAGE="${MODIFIED_MARK}${MESSAGE}"
  fi
  if $(echo "${STATUS}" | grep '^R ' &> /dev/null); then
    MESSAGE="${RENAMED_MARK}${MESSAGE}"
  fi
  if $(echo "${STATUS}" | grep '^\( D\|D\|AD\) ' &> /dev/null); then
    MESSAGE="${DELETED_MARK}${MESSAGE}"
  fi
  if [[ -n ${MESSAGE} ]]; then
    TXT_COLOR=$(get_branch_txt_color ${MESSAGE})
    MESSAGE="%F{${TXT_COLOR}}[%f${MESSAGE}%F{${TXT_COLOR}}]%f"
  fi
  echo $MESSAGE
}

# bg color
function get_branch_bg_color() {
  if [ $# -eq 1 ]; then
    if $(echo "$1" | grep "${UNTRACKED_MARK}" &> /dev/null); then
      echo 1;
    elif $(echo "$1" | grep "${ADDED_MARK}" &> /dev/null); then
      echo 220;
    elif $(echo "$1" | grep "${MODIFIED_MARK}" &> /dev/null); then
      echo 220;
    elif $(echo "$1" | grep "${RENAMED_MARK}" &> /dev/null); then
      echo 220;
    elif $(echo "$1" | grep "${DELETED_MARK}" &> /dev/null); then
      echo 220;
    else
      echo 2;
    fi
  else
    echo 2;
  fi
}

# text color
function get_branch_txt_color() {
  if [ $# -eq 1 ]; then
    if $(echo "$1" | grep "${UNTRACKED_MARK}" &> /dev/null); then
      echo 226;
    elif $(echo "$1" | grep "${ADDED_MARK}" &> /dev/null); then
      echo 160;
    elif $(echo "$1" | grep "${MODIFIED_MARK}" &> /dev/null); then
      echo 160;
    elif $(echo "$1" | grep "${RENAMED_MARK}" &> /dev/null); then
      echo 160;
    elif $(echo "$1" | grep "${DELETED_MARK}" &> /dev/null); then
      echo 160;
    else
      echo 15;
    fi
  else
    echo 15;
  fi
}
