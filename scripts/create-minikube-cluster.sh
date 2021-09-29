#!/bin/bash

set -e

echo "Setting up docker for Minikube"
sudo chown -R "$USER":"$USER" ~/.docker/

#HOST_IP=$(dig +short myip.opendns.com @resolver1.opendns.com)
minikube start --cpus=4 --memory=4g --ports=30900:30900,30899:30899,30800:30800,8443:8443 #--apiserver-ips="$HOST_IP"

cp ~/.minikube/profiles/minikube/client.crt /akamas-config/
cp ~/.minikube/profiles/minikube/client.key /akamas-config/
cp ~/.minikube/ca.crt /akamas-config/
cp ~/.kube/config /akamas-config/

sed -i -r "s/certificate-authority:.*/certificate-authority: \/kubeconfig\/ca\.crt/g" /akamas-config/config
sed -i -r 's/client-certificate:.*/client-certificate: \/kubeconfig\/client\.crt/g' /akamas-config/config
sed -i -r 's/client-key:.*/client-key: \/kubeconfig\/client\.key/g' /akamas-config/config
sed -i -r "s/server:.*/server: https:\/\/$HOST_IP:8443/g" /akamas-config/config

kubectl label node minikube akamas/node=akamas
kubectl config set-context --current --namespace=akamas-demo

echo "Cluster created"