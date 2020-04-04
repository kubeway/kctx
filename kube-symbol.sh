#!/bin/bash

# Determine our shell
if [ "${ZSH_VERSION-}" ]; then
  KUBE_PS1_SHELL="zsh"
elif [ "${BASH_VERSION-}" ]; then
  KUBE_PS1_SHELL="bash"
fi

_kube_ps1_symbol() {
  [[ "${KUBE_PS1_SYMBOL_ENABLE}" == false ]] && return

  case "${KUBE_PS1_SHELL}" in
    bash)
      if ((BASH_VERSINFO[0] >= 4)) && [[ $'\u2388' != "\\u2388" ]]; then
        KUBE_PS1_SYMBOL="${KUBE_PS1_SYMBOL_DEFAULT}"
        # KUBE_PS1_SYMBOL=$'\u2388 '
        KUBE_PS1_SYMBOL_IMG=$'\u2638'
      else
        KUBE_PS1_SYMBOL=$'\xE2\x8E\x88'
        KUBE_PS1_SYMBOL_IMG=$'\xE2\x98\xB8'
      fi
      ;;
    zsh)
      KUBE_PS1_SYMBOL="${KUBE_PS1_SYMBOL_DEFAULT}"
      KUBE_PS1_SYMBOL_IMG="\u2638";;
    *)
      KUBE_PS1_SYMBOL="k8s"
  esac

  if [[ "${KUBE_PS1_SYMBOL_USE_IMG}" == true ]]; then
    KUBE_PS1_SYMBOL="${KUBE_PS1_SYMBOL_IMG}"
  fi

  echo "${KUBE_PS1_SYMBOL}"
}

KUBE_PS1_SYMBOL_COLOR="${KUBE_PS1_SYMBOL_COLOR-blue}"
_kube_ps1_color_fg() {
  local KUBE_PS1_FG_CODE
  case "${1}" in
    black) KUBE_PS1_FG_CODE=0;;
    red) KUBE_PS1_FG_CODE=1;;
    green) KUBE_PS1_FG_CODE=2;;
    yellow) KUBE_PS1_FG_CODE=3;;
    blue) KUBE_PS1_FG_CODE=4;;
    magenta) KUBE_PS1_FG_CODE=5;;
    cyan) KUBE_PS1_FG_CODE=6;;
    white) KUBE_PS1_FG_CODE=7;;
    # 256
    [0-9]|[1-9][0-9]|[1][0-9][0-9]|[2][0-4][0-9]|[2][5][0-6]) KUBE_PS1_FG_CODE="${1}";;
    *) KUBE_PS1_FG_CODE=default
  esac

  if [[ "${KUBE_PS1_FG_CODE}" == "default" ]]; then
    KUBE_PS1_FG_CODE="${_KUBE_PS1_DEFAULT_FG}"
    return
  elif [[ "${KUBE_PS1_SHELL}" == "zsh" ]]; then
    KUBE_PS1_FG_CODE="%F{$KUBE_PS1_FG_CODE}"
  elif [[ "${KUBE_PS1_SHELL}" == "bash" ]]; then
    if tput setaf 1 &> /dev/null; then
      KUBE_PS1_FG_CODE="$(tput setaf ${KUBE_PS1_FG_CODE})"
    elif [[ $KUBE_PS1_FG_CODE -ge 0 ]] && [[ $KUBE_PS1_FG_CODE -le 256 ]]; then
      KUBE_PS1_FG_CODE="\033[38;5;${KUBE_PS1_FG_CODE}m"
    else
      KUBE_PS1_FG_CODE="${_KUBE_PS1_DEFAULT_FG}"
    fi
  fi
  echo ${_KUBE_PS1_OPEN_ESC}${KUBE_PS1_FG_CODE}${_KUBE_PS1_CLOSE_ESC}
}

_kube_ps1_init() {
  [[ -f "${KUBE_PS1_DISABLE_PATH}" ]] && KUBE_PS1_ENABLED=off

  case "${KUBE_PS1_SHELL}" in
    "zsh")
      _KUBE_PS1_OPEN_ESC="%{"
      _KUBE_PS1_CLOSE_ESC="%}"
      _KUBE_PS1_DEFAULT_BG="%k"
      _KUBE_PS1_DEFAULT_FG="%f"
      setopt PROMPT_SUBST
      autoload -U add-zsh-hook
      add-zsh-hook precmd _kube_ps1_update_cache
      zmodload -F zsh/stat b:zstat
      zmodload zsh/datetime
      ;;
    "bash")
      _KUBE_PS1_OPEN_ESC=$'\001'
      _KUBE_PS1_CLOSE_ESC=$'\002'
      _KUBE_PS1_DEFAULT_BG=$'\033[49m'
      _KUBE_PS1_DEFAULT_FG=$'\033[39m'
      [[ $PROMPT_COMMAND =~ _kube_ps1_update_cache ]] || PROMPT_COMMAND="_kube_ps1_update_cache;${PROMPT_COMMAND:-:}"
      ;;
  esac
}

KUBE_PS1_SYMBOL_ENABLE=true
KUBE_PS1_SYMBOL_USE_IMG=true
kube_ps1() {
   # local KUBE_PS1_RESET_COLOR="${_KUBE_PS1_OPEN_ESC}${_KUBE_PS1_DEFAULT_FG}${_KUBE_PS1_CLOSE_ESC}"
   #KUBE_PS1="$(_kube_ps1_color_fg $KUBE_PS1_SYMBOL_COLOR)$(_kube_ps1_symbol)${KUBE_PS1_RESET_COLOR}"
   KUBE_PS1="$(_kube_ps1_symbol)"
   echo "${KUBE_PS1}"
}

_kube_ps1_symbol
