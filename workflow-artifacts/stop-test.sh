#!/bin/bash

set -ea

if test -f /kubeconfig/envs; then
  . /kubeconfig/envs;
fi

LOCUST_ENDPOINT="$1"
LOCUST_PORT="${2-$(kubectl --kubeconfig /kubeconfig/config get svc -n akamas-demo -l app=ak-loadgenerator -o jsonpath='{ $.items[0].spec.ports[?(@.name=="web-ui")].nodePort}')}"

# stop test
curl http://"$LOCUST_ENDPOINT":"$LOCUST_PORT"/stop

# reset stats
curl http://"$LOCUST_ENDPOINT":"$LOCUST_PORT"/stats/reset
