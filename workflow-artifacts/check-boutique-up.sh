#!/bin/bash

set -ea

if test -f /kubeconfig/envs; then
  . /kubeconfig/envs;
fi

declare -a services=(emailservice checkoutservice shippingservice paymentservice redis-cart
 adservice frontend recommendationservice cartservice productcatalogservice currencyservice)

for service in "${services[@]}"; do
  echo "Describe service ak-$service"
  kubectl describe pod ak-"$service" -n akamas-demo --kubeconfig /kubeconfig/config
  echo "Checking rollout status for service ak-$service"
  kubectl rollout status --timeout=5m -n akamas-demo deployment ak-"$service" --kubeconfig /kubeconfig/config
done
