# The MIT License
# SPDX short identifier: MIT

# Further resources on the MIT License
# Copyright 2017 Denis Gladkikh (https://www.outcoldman.com/en/archive/2017/07/19/dbhist/)

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

################################################################################

# To use it, just source the file `source dbhist.sh`
# Verified that works with Bash 3/4

# Configuration
#   DBHISTORY=true - use false to disable
#   DBHISTORYFILE=$HOME/.dbhist - location of dbhist file
#
# To make it work I keep next configuration for bash, the only important is the
# time format, to make it unixtime
#
#   HISTSIZE=$HOME/.bash_history
#   HISTFILESIZE=1000
#   HISTSIZE=1000
#   HISTTIMEFORMAT="%s "
#   HISTCONTROL=ignorespace:erasedups
#
# More details in https://www.outcoldman.com/en/archive/2017/07/19/dbhist/
# Or use after you sourced this file
#  dbhist --help

################################################################################

if ${DBHISTORY:-true}; then

# Kind of session ID, allows to see only commands executed in this terminal session
__dbhist_salt="${RANDOM}"
# This allows us to verify existence of .dbhist file only once
__dbhist_initialized=false
# Keep the previous folder, this how we keep the PWD for commands like `cd ...`
__dbhist_oldpwd="${OLDPWD}"

# Get location of .dbhist file, default location is under `$HOME/.dbhist`
__dbhist_file() {
  echo "${DBHISTORYFILE:-$HOME/.dbhist}"
}

# Execute command on sqlite with .dbhist file
__dbhist_sqlite() {
  sqlite3 "$(__dbhist_file)"
}

# Initialize dbhist file, create table
__db_hist_init() {
  if [[ ! -f "$(__dbhist_file)" ]]; then
    local __sql='CREATE TABLE history (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  hist_id INTEGER,
  cmd TEXT,
  epoch INTEGER,
  ppid INTEGER,
  pwd TEXT,
  salt INTEGER
);'
    echo "${__sql}" | __dbhist_sqlite
  fi
}

# Execute it with bash PROMPT
__db_hist_prompt() {
  if ! ${__dbhist_initialized}; then
    __db_hist_init
    __dbhist_initialized=true
    return
  fi

  if [[ -n "${COMP_LINE}" ]]; then
    return
  fi

  local __formated_history=
  local __num=
  local __epoch=
  local __pwd="${PWD}"
  if [[ "${OLDPWD}" !=  "${__dbhist_oldpwd}" ]]; then
    __pwd="${OLDPWD}"
    __dbhist_oldpwd="${OLDPWD}"
  fi
  #   521 1492964870 history 1
  __formated_history="$(history 1 | sed -E 's/[[:space:]]+([[:digit:]]+)[[:space:]]+([[:digit:]]+)[[:space:]](.+)/\1@\2@\3/')"
  __num="$(echo "${__formated_history}" | sed -E 's/([^@]+)@([^@]+)@(.+)/\1/')"
  __epoch="$(echo "${__formated_history}" | sed -E 's/([^@]+)@([^@]+)@(.+)/\2/')"
  __command="$(echo "${__formated_history}" | sed -E 's/([^@]+)@([^@]+)@(.+)/\3/')"
  __dbhist_sqlite <<-END
INSERT INTO history(hist_id, epoch, cmd, ppid, pwd, salt)
VALUES("${__num}", "${__epoch}", "${__command//\"/""}", ${PPID}, "${__pwd//\"/""}", ${__dbhist_salt});
END

}

# Use
#   dbhist --help
# To learn the tool
dbhist() {
  local __limit=100
  local __all=false
  local __self=false
  local __starts=false
  local __verbose=false
  local __query=''
  local __location=''
  local __pwd=false
  while ! [[ $# -eq 0 || -z "${1}" ]]; do
    case "${1}" in
      (--shell)
        __dbhist_sqlite
        return
      ;;
      (--help)
        cat<<END
Usage:
  dbhist [options] [query]
Options:
  --limit {number}
    number of latest commands to show. Defaults to 100.
  --all
    include history of all sessions. Not only current.
  --self
    include history about dbhist
  --starts
    match only commands starts with query
  --verbose
    verbose output (shows sql)
  --here
    reduce search only for current pwd
  --under
    reduce search only for current and under pwd
  --pwd
    show working directory of cmd
  --shell
    access to shell
END
        return
      ;;
      (--limit)
        shift
        __limit="${1:?option require value}"
        if ! [[ "${__limit}" =~ ^[0-9]+$ ]]; then
         2>&1 echo "Limit should be a number"
         return 1
        fi
      ;;
      (--all)
        __all=true
      ;;
      (--self)
        __self=true
      ;;
      (--starts)
        __starts=true
      ;;
      (--verbose)
        __verbose=true
      ;;
      (--here)
        if [[ -n "${__location}" ]]; then
          2>&1 echo "Specifier for pwd already set"
          return 1
        fi
        __location="here"
      ;;
      (--under)
        if [[ -n "${__location}" ]]; then
          2>&1 echo "Specifier for pwd already set"
          return 1
        fi
        __location="under"
      ;;
      (--pwd)
        __pwd=true
      ;;
      (-*)
        2>&1 echo "Unknown option ${1}"
        return 1
      ;;
      (*)
        if [[ -n "${__query}" ]]; then
          2>&1 echo "Cannot specify more than one query"
          return 1
        fi
        __query="${1:?requires value}"
      ;;
    esac
    shift
  done
  __pwd_q=''
  if ${__pwd}; then
    __pwd_q='pwd || " > " ||'
  fi
  local __sql="
  SELECT
    substr('      '||max(id),-6) ||
    ' | ' ||
    datetime(max(epoch), 'unixepoch', 'localtime') ||
    ' | ' ||
    substr('      '||count(*),-6) ||
    ' | ' ||
    ${__pwd_q}
    cmd
  FROM history
  WHERE 1 "
  if ! ${__all}; then
    __sql+="AND (salt=${__dbhist_salt} AND ppid=${PPID}) "
  fi
  if ! ${__self}; then
    __sql+="AND (cmd != 'dbhist' AND cmd NOT LIKE 'dbhist %') "
  fi
  if [[ -n "${__query}" ]]; then
    __query=${__query//\"/""}
    if ! ${__starts} && [[ "${__query}" != %* ]]; then
      __query="%${__query}"
    fi
    if [[ "${__query}" != *% ]]; then
      __query+="%"
    fi
    __sql+="AND cmd LIKE \"${__query}\" ESCAPE '\' "
  fi
  __pwd_l="${PWD//\"/""}"
  case "${__location}" in
    (here)
      __sql+="AND (pwd == \"${__pwd_l}\") "
    ;;
    (under)
      __pwd_l="${__pwd_l//%/\%}"
      __pwd_l="${__pwd_l//_/\_}"
      __sql+="AND (pwd LIKE \"${__pwd_l}%\" ESCAPE '\') "
    ;;
  esac
  __sql+="GROUP BY cmd "
  if ${__pwd}; then
    __sql+=", pwd "
  fi
  __sql+="ORDER BY max(id) DESC LIMIT ${__limit} ;"
  if ${__verbose}; then
    echo "database:"
    __dbhist_file
    echo "sql:"
    echo "${__sql}"
  fi
  echo "${__sql}" | __dbhist_sqlite
}

# Inject __db_hist_prompt in `PROMPT_COMMAND`
if ! [[ "${PROMPT_COMMAND}" =~ .*__db_hist_prompt.* ]]; then
  PROMPT_COMMAND="__db_hist_prompt${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
fi

fi
