#!/bin/bash

set -ea

if test -f /kubeconfig/envs; then
  . /kubeconfig/envs;
fi

CLUSTER_NAME=$(kubectl --kubeconfig /kubeconfig/config get nodes -o jsonpath='{ $.items[0].status.addresses[?(@.type=="Hostname")].address}')
if [ "$CLUSTER_NAME" == "minikube" ]; then
  CLUSTER_ENDPOINT=localhost
else
  CLUSTER_ENDPOINT=$(kubectl --kubeconfig /kubeconfig/config get nodes -o jsonpath='{ $.items[0].status.addresses[?(@.type=="ExternalIP")].address }')
fi

echo "Checking connection with the cluster on $CLUSTER_ENDPOINT"
if ! ping -c 1 "$CLUSTER_ENDPOINT" &> /dev/null; then
  echo "Cluster does not respond on $CLUSTER_ENDPOINT"
else
  echo "Connection with cluster ok"
fi
