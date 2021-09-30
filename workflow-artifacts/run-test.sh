#!/bin/bash

set -ea

if test -f /kubeconfig/envs; then
  . /kubeconfig/envs;
fi

LOCUST_ENDPOINT="$1"
LOCUST_PORT="${2-$(kubectl --kubeconfig /kubeconfig/config get svc -n akamas-demo -l app=ak-loadgenerator -o jsonpath='{ $.items[0].spec.ports[?(@.name=="web-ui")].nodePort}')}"

curl -X POST -d 'user_count=100' -d 'spawn_rate=3' -d 'host=http://ak-frontend:80' http://"$LOCUST_ENDPOINT":"$LOCUST_PORT"/swarm
