#!/bin/bash

SYSTEM_NAME="Online Boutique"
PROM_ENDPOINT="${1}"
PROM_PORT="${2-30900}"

if [[ $# -ge 3 ]] || [[ $# -lt 1 ]]; then
  echo "Wrong arguments."
  echo "Usage:"
  echo "  bash install_script.sh PROMETHEUS_HOST PROMETHEUS_PORT"
  exit 0
fi

# Install Kubernetes optimization pack
echo "Installing Kubernetes and Web-Application optimization packs"
akamas install optimization-pack Kubernetes
akamas install -f optimization-pack Web-Application

cd akamas/system 2>/dev/null || cd kubernetes-online-boutique/akamas/system || { echo "Run the script inside or one level above the kubernetes-online-boutique folder"; exit 1; }

if $(akamas describe system "${SYSTEM_NAME}" > /dev/null); then
  echo "Duplicate ${SYSTEM_NAME} system found. Cleaning up."
  akamas delete system "${SYSTEM_NAME}"
fi

# Create the system which will model the Online Boutique inside Akamas
echo "Creating the ${SYSTEM_NAME} system"
akamas create system system.yaml

akamas create component components/ ${SYSTEM_NAME}

# Create the online boutique component with e2e metrics
echo "Adding application component to system"
akamas create component application.yaml "$SYSTEM_NAME"

# Create the telemetry instance for the system
cd ../telemetry || exit 1
echo "Adding Prometheus telemetry provider to system"
sed "s/address:.*/address: $PROM_ENDPOINT/g; s/port:.*/port: $PROM_PORT/g" prom.yaml.template > prom.yaml
akamas create telemetry-instance prom.yaml "$SYSTEM_NAME"

echo "System created correctly"
