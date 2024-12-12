#!/bin/bash

# Get the absolute path of the script
SCRIPT_PATH=$(realpath "${0}")

# Get the parent directory of the script
PARENT_DIR=$(dirname "${SCRIPT_PATH}")
INFRA_DIR=$(dirname $(dirname "${PARENT_DIR}"))

# Define the cluster name
CLUSTER_NAME="sre-chaos-poc"
NAMESPACE="sre-challenge"

# Reference another file in the same directory
CLUSTER_CONFIG_YAML="${PARENT_DIR}/cluster.yaml"
CLUSTER_KUBECONFIG="${INFRA_DIR}/sre-chaos-poc.kubeconfig"


# Create the cluster
if kind get clusters | grep -q "^${CLUSTER_NAME}$"; then
    echo "Cluster '${CLUSTER_NAME}' already exists."
else
    echo "Cluster '${CLUSTER_NAME}' does not exist. Creating it now..."

    kind create cluster --config "${CLUSTER_CONFIG_YAML}"

    if [ $? -eq 0 ]; then
        echo "Cluster '${CLUSTER_NAME}' created successfully."
    else
        echo "Failed to create the cluster '${CLUSTER_NAME}'."
        exit 1
    fi
fi

# Get the kubeconfig
kind get kubeconfig --name sre-chaos-poc > "${CLUSTER_KUBECONFIG}"

# Verify cluster is running
kubectl --kubeconfig ${CLUSTER_KUBECONFIG} get ns > /dev/null 2>&1 || CLUSTER_ERROR="true"
kubectl --kubeconfig ${CLUSTER_KUBECONFIG} get pods -A > /dev/null 2>&1 || CLUSTER_ERROR="true"

if [ "${CLUSTER_ERROR}" == "true" ]; then
  echo "Cluster '${CLUSTER_NAME}' failed to initialize."
  exit 1
fi