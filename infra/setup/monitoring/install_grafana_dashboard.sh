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

echo "Installing Grafana Dashboard for the Node App."
echo "kubectl --kubeconfig ${CLUSTER_KUBECONFIG} apply -f ${PARENT_DIR}/grafana_dashboard.yaml"
kubectl --kubeconfig ${CLUSTER_KUBECONFIG} create ns sre-challenge-monitoring || NAMESPACE_EXISTS=1
kubectl --kubeconfig ${CLUSTER_KUBECONFIG} apply -f ${PARENT_DIR}/grafana_dashboard.yaml
if [ $? -eq 0 ]; then
    echo "Grafana Dashboard successfully installed/upgraded in namespace '${NAMESPACE}'."
else
    echo "Failed to install/upgrade the Grafana Dashboard."
    exit 1
fi