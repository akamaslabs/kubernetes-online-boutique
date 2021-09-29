#!/bin/bash

set -ea

if test -f /kubeconfig/envs; then
  . /kubeconfig/envs;
fi

kubectl apply -f boutique.yaml --kubeconfig /kubeconfig/config
