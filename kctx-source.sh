#!/bin/bash
#****************************************************************#
# Create Date: 2020-04-04 15:08
#********************************* ******************************#

BASEDIR=$(dirname "$0")

kube_ctx() {
  # symbol=""
  kubeconfig=""
  ns=""
  if [ -f "/tmp/${TERM_SESSION_ID}-kubeconfig" ]; then
    f=$(cat "/tmp/${TERM_SESSION_ID}-kubeconfig")
    if [ ! -z "${f}" ]; then
      if [ -f "${f}" ]; then
        _kubeconfig=$(basename $f)
        kubeconfig=$_kubeconfig[8,-1]
        ns="default"
        # symbol="$(${BASEDIR}/kube-symbol.sh)"
      fi
    fi
  fi

  if [ -f "/tmp/${TERM_SESSION_ID}-namespace" ]; then
    _ns=$(cat "/tmp/${TERM_SESSION_ID}-namespace")
    if [ ! -z "${_ns}" ]; then
      ns="${_ns}"
    fi
  fi
  # [ ! -z "$kubeconfig" ] && printf "\e[32;40m${kubeconfig}\e[m:\e[37;33m${ns}\e[m"
  [ ! -z "$kubeconfig" ] && echo -n "${kubeconfig}:${ns}"
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

  helm ${args} ${@}
}

alias kctx="${BASEDIR}/kctx "
alias kcontext="${BASEDIR}/kctx "
alias kubectl=kubectl_cmd
alias helm=helm_cmd

