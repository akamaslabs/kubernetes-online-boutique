#!/bin/bash

set -e

WORKFLOW_NAME=boutique
CLUSTER_IP="$1"

cd akamas/workflows 2>/dev/null || cd kubernetes-online-boutique/akamas/workflows || { echo "Run the script inside or one level above the kubernetes-online-boutique folder"; exit 1; }

if $(akamas describe workflow "${WORKFLOW_NAME}" > /dev/null); then
  echo "Duplicate workflow found. Cleaning up."
  akamas delete workflow "${WORKFLOW_NAME}"
fi

sed "s/CLUSTER_IP/$CLUSTER_IP/g" workflow.yaml.template > workflow.yaml

akamas create workflow workflow.yaml
