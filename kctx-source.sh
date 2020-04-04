#!/bin/bash
#****************************************************************#
# Create Date: 2020-04-04 15:08
#********************************* ******************************#

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

kube_symbol() {
  symbol=""
  if [ -f "/tmp/${TERM_SESSION_ID}-kubeconfig" ]; then
    # fast
    symbol="$(${BASEDIR}/kube-symbol.sh)"
    # slow
    # symbol=$(/Users/qiulin.nql/scripts/kctx/show-png.sh "/Users/qiulin.nql/scripts/kctx/k8s-logo.png" )
  fi
  [ ! -z "$symbol" ] && printf "\033[44;37m ${symbol} \033[0m"
}

kube_ctx() {
  kubeconfig=""
  ns=""
  if [ -f "/tmp/${TERM_SESSION_ID}-kubeconfig" ]; then
    f=$(cat "/tmp/${TERM_SESSION_ID}-kubeconfig")
    if [ ! -z "${f}" ]; then
      if [ -f "${f}" ]; then
        kubeconfig=$(basename $f)
        ns="default"
      fi
    fi
  fi

  if [ -f "/tmp/${TERM_SESSION_ID}-namespace" ]; then
    _ns=$(cat "/tmp/${TERM_SESSION_ID}-namespace")
    if [ ! -z "${_ns}" ]; then
      ns="${_ns}"
    fi
  fi
  [ ! -z "$kubeconfig" ] && printf "\e[32;40m${kubeconfig}\e[m:\e[37;33m${ns}\e[m"
}

kubectl_cmd() {
  local args=""
  if [ -f "/tmp/${TERM_SESSION_ID}-namespace" ]; then
    ns=$(cat "/tmp/${TERM_SESSION_ID}-namespace")
    if [ -z "${ns}" ]; then
      ns="default"
    fi
    args="${args} --namespace=${ns} "
  fi
  
  if [ -f "/tmp/${TERM_SESSION_ID}-kubeconfig" ]; then
    kubeconfig=$(cat "/tmp/${TERM_SESSION_ID}-kubeconfig")
    if [ ! -z "${kubeconfig}" ]; then
      if [ -f "${kubeconfig}" ]; then
        args="${args} --kubeconfig=${kubeconfig} "
      fi
    fi
  fi

  kubectl ${args} ${@}
}

helm_cmd() {
  local args=""
  if [ -f "/tmp/${TERM_SESSION_ID}-namespace" ]; then
    ns=$(cat "/tmp/${TERM_SESSION_ID}-namespace")
    if [ -z "${ns}" ]; then
      ns="default"
    fi
    args="${args} --namespace=${ns} "
  fi

  if [ -f "/tmp/${TERM_SESSION_ID}-kubeconfig" ]; then
    kubeconfig=$(cat "/tmp/${TERM_SESSION_ID}-kubeconfig")
    if [ ! -z "${kubeconfig}" ]; then
      if [ -f "${kubeconfig}" ]; then
        args="${args} --kubeconfig=${kubeconfig} "
      fi
    fi
  fi

  kubectl ${args} ${@}
}

alias kctx="${BASEDIR}/kctx "
alias kcontext="${BASEDIR}/kctx "
alias kubectl=kubectl_cmd
alias helm=helm_cmd

