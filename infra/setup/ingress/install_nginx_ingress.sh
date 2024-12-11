#!/bin/bash

# Get the absolute path of the script
SCRIPT_PATH=$(realpath "${0}")

# Get the parent directory of the script
PARENT_DIR=$(dirname "${SCRIPT_PATH}")
INFRA_DIR=$(dirname $(dirname "${PARENT_DIR}"))

# Define the cluster name
CLUSTER_NAME="sre-chaos-poc"

# Cluster kubeconfig
CLUSTER_KUBECONFIG="${INFRA_DIR}/sre-chaos-poc.kubeconfig"

# Install vars
NAMESPACE="sre-challenge-platform"
RELEASE_NAME="nginx"
CHART_REPO="https://kubernetes.github.io/ingress-nginx/"
CHART_NAME="ingress-nginx/ingress-nginx"
CHART_VERSION="4.11.3"

NODE_SELECTOR_KEY="sre-chaos-poc/node-pool"
NODE_SELECTOR_VALUE="platform"

# Add the Nginx Ingress Controller Helm repository if not already added
helm repo add metrics-server "${CHART_REPO}" > /dev/null 2>&1  || echo "Nginx Ingress Controller repo already added."

# Update the Helm repo to ensure we have the latest charts
helm repo update > /dev/null 2>&1

# Install or upgrade Nginx Ingress Controller with the specified chart version
helm upgrade --install "${RELEASE_NAME}" "${CHART_NAME}" \
    --namespace "${NAMESPACE}" \
    --create-namespace \
    --version "${CHART_VERSION}" \
    --set controller.nodeSelector."${NODE_SELECTOR_KEY}"="${NODE_SELECTOR_VALUE}"

if [ $? -eq 0 ]; then
    echo "Nginx Ingress Controller '${RELEASE_NAME}' (version ${CHART_VERSION}) successfully installed/upgraded in namespace '${NAMESPACE}'."
else
    echo "Failed to install/upgrade Nginx Ingress Controller (version ${CHART_VERSION})."
    exit 1
fi