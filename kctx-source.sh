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
    kubeconfig=$(basename $f)
    ns=":default"
  fi
  if [ -f "/tmp/${TERM_SESSION_ID}-namespace" ]; then
    f=$(cat "/tmp/${TERM_SESSION_ID}-namespace")
    ns=":$(basename $f)"
  fi
  [ ! -z "$kubeconfig" ] && printf "\e[32;40m${kubeconfig}${ns}\e[m"
}

kubectl_cmd() {
  ns="default"
  if [ -f "/tmp/${TERM_SESSION_ID}-namespace" ]; then
    ns=$(cat "/tmp/${TERM_SESSION_ID}-namespace")
  fi
  
  if [ -f "/tmp/${TERM_SESSION_ID}-kubeconfig" ]; then
    kubeconfig=$(cat "/tmp/${TERM_SESSION_ID}-kubeconfig")
    kubectl --kubeconfig=${kubeconfig} -n ${ns} ${@}
  else
    kubectl -n ${ns} ${@}
  fi
}

alias kctx="${BASEDIR}/kctx "
alias kubectl=kubectl_cmd
