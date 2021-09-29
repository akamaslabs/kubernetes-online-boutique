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

cd akamas/system 2>/dev/null || cd kubernetes/akamas/system || { echo "Run the script inside or one level above the kubernetes folder"; exit 1; }

# Create the system which will model the Online Boutique inside Akamas
echo "Creating the Online Boutique system"
akamas create system system.yaml

# Create the components for the Pods of the Online Boutiques
declare -a services=(emailservice checkoutservice shippingservice paymentservice rediscart
 adservice frontend recommendationservice cartservice productcatalogservice currencyservice)

for service in "${services[@]}"; do
  echo "Adding component $service to system"
  akamas create component "$service".yaml "$SYSTEM_NAME"
done

# Create the online boutique component with e2e metrics
echo "Adding application component to system"
akamas create component application.yaml "$SYSTEM_NAME"

# Create the telemetry instance for the system
cd ../telemetry || exit 1
echo "Adding Prometheus telemetry provider to system"
sed -i -r "s/address:.*/address: $PROM_ENDPOINT/g" prom.yaml
sed -i -r "s/port:.*/port: $PROM_PORT/g" prom.yaml
akamas create telemetry-instance prom.yaml "$SYSTEM_NAME"

echo "System created correctly"