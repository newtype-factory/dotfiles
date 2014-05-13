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
  local STATUS='' STAGE_COUNT=0 UPDATE_COUNT=0
  STATUS=$(git status -s --porcelain 2> /dev/null)
  STAGE_COUNT=$(echo "${STATUS}" | grep '^\(A\|M\|AM\|MM\) ' | wc -l)
  UPDATE_COUNT=$(echo "${STATUS}" | grep '^\(??\| M\|MM\|AM\| T\|R\| D\|D\|AD\) ' | wc -l)
  echo "[S:${STAGE_COUNT} M:${UPDATE_COUNT}]"
}

# bg color
function get_branch_bg_color() {
  local LIST ARRAY GREEN_COLOR=2 YELLOW_COLOR=220 RED_COLOR=1
  if [ $# -eq 1 ]; then
    LIST=$(echo $1 | sed -e 's/\[S:\([0-9]\+\) M:\([0-9]\+\)\]/\1 \2/')
    ARRAY=${(z)LIST}
    if [ ${ARRAY[1]} -gt 0 ]; then
      echo $YELLOW_COLOR
    elif [ ${ARRAY[2]} -gt 0 ]; then
      echo $RED_COLOR
    else
      echo $GREEN_COLOR
    fi
  else
    echo $GREEN_COLOR
  fi
}

# text color2
function get_branch_txt_color() {
  local LIST ARRAY WHITE_COLOR=15 RED_COLOR=160 YELLOW_COLOR=226
  if [ $# -eq 1 ]; then
    LIST=$(echo $1 | sed -e 's/\[S:\([0-9]\+\) M:\([0-9]\+\)\]/\1 \2/')
    ARRAY=${(z)LIST}
    if [ ${ARRAY[1]} -gt 0 ]; then
      echo $RED_COLOR
    elif [ ${ARRAY[2]} -gt 0 ]; then
      echo $YELLOW_COLOR
    else
      echo $WHITE_COLOR
    fi
  else
    echo $WHITE_COLOR
  fi
}
