#!/bin/bash

set -e

CLUSTER_IP="$1"

cd akamas/workflows 2>/dev/null || cd kubernetes-online-boutique/akamas/workflow || { echo "Run the script inside or one level above the kubernetes-online-boutique folder"; exit 1; }

sed -i "s/CLUSTER_IP/$CLUSTER_IP/g" workflow.yaml

akamas create workflow workflow.yaml