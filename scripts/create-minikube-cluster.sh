#!/bin/bash

set -e

HOST_IP="$1"

echo "Setting up docker for Minikube"
sudo chown -R "$USER":"$USER" ~/.docker/

minikube start --apiserver-port=8999 --apiserver-ips="$HOST_IP" --cpus=4 --memory=8g --ports=30900:30900,30899:30899,30800:30800,8999:8999 --namespace=akamas-demo

KUBE_FLD=/akamas-config
sudo mkdir -p ${KUBE_FLD} && sudo chown -R "$USER":"$USER" ${KUBE_FLD} && rm -rf ${KUBE_FLD}/*
cp ~/.minikube/profiles/minikube/client.crt ${KUBE_FLD}/
cp ~/.minikube/profiles/minikube/client.key ${KUBE_FLD}/
cp ~/.minikube/ca.crt ${KUBE_FLD}/
cp ~/.kube/config ${KUBE_FLD}/

sed -i -r 's/certificate-authority:.*/certificate-authority: \/kubeconfig\/ca\.crt/g' ${KUBE_FLD}/config
sed -i -r 's/client-certificate:.*/client-certificate: \/kubeconfig\/client\.crt/g' ${KUBE_FLD}/config
sed -i -r 's/client-key:.*/client-key: \/kubeconfig\/client\.key/g' ${KUBE_FLD}/config
sed -i "s/server:.*:\(\.*\)/server: https:\/\/${HOST_IP}:\1/g" ${KUBE_FLD}/config
touch ${KUBE_FLD}/envs

kubectl label node --all akamas/node=akamas

echo "Cluster created"
