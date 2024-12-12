#!/bin/bash

# Get the absolute path of the script
SCRIPT_PATH=$(realpath "${0}")

# Get the parent directory of the script
PARENT_DIR=$(dirname "${SCRIPT_PATH}")
INFRA_DIR=$(dirname $(dirname "${PARENT_DIR}"))

# Define the cluster name and namespace
CLUSTER_NAME="sre-chaos-poc"
NAMESPACE="sre-challenge"

# Cluster kind config and kubeconfig
CLUSTER_CONFIG_YAML="${PARENT_DIR}/cluster.yaml"
CLUSTER_KUBECONFIG="${INFRA_DIR}/sre-chaos-poc.kubeconfig"

# Verify cluster exists
if ! kind get clusters | grep -q "^${CLUSTER_NAME}$"; then
    echo "Cluster '${CLUSTER_NAME}' has already been destroyed."
    exit 0
fi

kind delete cluster --name "${CLUSTER_NAME}"

# Verify cluster is no longer running
CLUSTER_ERROR="false"
kubectl --kubeconfig ${CLUSTER_KUBECONFIG} get ns > /dev/null 2>&1 || CLUSTER_ERROR="true"
kubectl --kubeconfig ${CLUSTER_KUBECONFIG} get pods -A > /dev/null 2>&1 || CLUSTER_ERROR="true"

if [ "${CLUSTER_ERROR}" == "false" ]; then
  echo "Cluster '${CLUSTER_NAME}' is still running!"
  exit 1
fi