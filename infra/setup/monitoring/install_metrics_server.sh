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
NAMESPACE="sre-challenge-monitoring"
RELEASE_NAME="metrics-server"
CHART_REPO="https://kubernetes-sigs.github.io/metrics-server/"
CHART_NAME="metrics-server/metrics-server"
CHART_VERSION="3.12.2"

NODE_SELECTOR_KEY="sre-chaos-poc/node-pool"
NODE_SELECTOR_VALUE="platform"

# Add the Metrics Server Helm repository if not already added
helm repo add metrics-server "${CHART_REPO}" > /dev/null 2>&1  || echo "Metrics Server repo already added."

# Update the Helm repo to ensure we have the latest charts
helm repo update > /dev/null 2>&1

# Install or upgrade Metrics Server with the specified chart version
helm upgrade --install "${RELEASE_NAME}" "${CHART_NAME}" \
    --namespace "${NAMESPACE}" \
    --create-namespace \
    --version "${CHART_VERSION}" \
    --set nodeSelector."${NODE_SELECTOR_KEY}"="${NODE_SELECTOR_VALUE}" \
    --set args[0]=--kubelet-insecure-tls

if [ $? -eq 0 ]; then
    echo "Metrics Server '${RELEASE_NAME}' (version ${CHART_VERSION}) successfully installed/upgraded in namespace '${NAMESPACE}'."
else
    echo "Failed to install/upgrade Metrics Server (version ${CHART_VERSION})."
    exit 1
fi