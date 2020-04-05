#!/bin/bash
#****************************************************************#
# Create Date: 2020-04-04 15:08
#********************************* ******************************#

BASEDIR=$(dirname "$0")

##################### set kube context tmp file path #####################
SAVE_BASE_DIR="/tmp/"
KUBECONFIG_FILE_PATH="${SAVE_BASE_DIR}/${TERM_SESSION_ID}"
NAMESPACE_FILE_PATH="${SAVE_BASE_DIR}/${TERM_SESSION_ID}"
if [ ! -z "${TMUX_PANE}" ]; then
  KUBECONFIG_FILE_PATH="${KUBECONFIG_FILE_PATH}-${TMUX_PANE}"
  NAMESPACE_FILE_PATH="${NAMESPACE_FILE_PATH}-${TMUX_PANE}"
fi
KUBECONFIG_FILE_PATH="${KUBECONFIG_FILE_PATH}-kubeconfig"
NAMESPACE_FILE_PATH="${NAMESPACE_FILE_PATH}-namespace"

##################### Functions #####################
SAVE_BASE_DIR="/tmp/"
kube_ctx() {
  # symbol=""
  kubeconfig=""
  ns=""
  if [ -f "${KUBECONFIG_FILE_PATH}" ]; then
    f=$(cat "${KUBECONFIG_FILE_PATH}")
    if [ ! -z "${f}" ]; then
      if [ -f "${f}" ]; then
        _kubeconfig=$(basename $f)
        kubeconfig=$_kubeconfig[8,-1]
        ns="default"
        # symbol="$(${BASEDIR}/kube-symbol.sh)"
      fi
    fi
  fi

  if [ -f "${NAMESPACE_FILE_PATH}" ]; then
    _ns=$(cat "${NAMESPACE_FILE_PATH}")
    if [ ! -z "${_ns}" ]; then
      ns="${_ns}"
    fi
  fi
  # [ ! -z "$kubeconfig" ] && printf "\e[32;40m${kubeconfig}\e[m:\e[37;33m${ns}\e[m"
  [ ! -z "$kubeconfig" ] && echo -n "${kubeconfig}:${ns}"
}

kubectl_cmd() {
  local args=""
  
  if [ -f "${KUBECONFIG_FILE_PATH}" ]; then
    kubeconfig=$(cat "${KUBECONFIG_FILE_PATH}")
    if [ ! -z "${kubeconfig}" ]; then
      if [ -f "${kubeconfig}" ]; then
        args="${args} --kubeconfig=${kubeconfig} "
      fi
    fi
  fi

  if [ -f "${NAMESPACE_FILE_PATH}" ]; then
    ns=$(cat "${NAMESPACE_FILE_PATH}")
    if [ -z "${ns}" ]; then
      ns="default"
    fi
    args="${args} -n ${ns} "
  fi

  kubectl $(echo ${args}) ${@}
}

helm_cmd() {
  local args=""
  if [ -f "${KUBECONFIG_FILE_PATH}" ]; then
    kubeconfig=$(cat "${KUBECONFIG_FILE_PATH}")
    if [ ! -z "${kubeconfig}" ]; then
      if [ -f "${kubeconfig}" ]; then
        args="${args} --kubeconfig=${kubeconfig} "
      fi
    fi
  fi

  if [ -f "${NAMESPACE_FILE_PATH}" ]; then
    ns=$(cat "${NAMESPACE_FILE_PATH}")
    if [ -z "${ns}" ]; then
      ns="default"
    fi
    args="${args} --namespace=${ns} "
  fi


  helm $(echo ${args}) ${@}
}

alias kctx="${BASEDIR}/kctx "
alias kcontext="${BASEDIR}/kctx "
alias kubectl=kubectl_cmd
alias helm=helm_cmd

