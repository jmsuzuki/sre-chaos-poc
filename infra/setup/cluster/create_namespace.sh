#!/bin/bash

# Get the absolute path of the script
SCRIPT_PATH=$(realpath "${0}")

# Get the parent directory of the script
PARENT_DIR=$(dirname "${SCRIPT_PATH}")
INFRA_DIR=$(dirname $(dirname "${PARENT_DIR}"))

NAMESPACE="sre-challenge"

# Reference another file in the same directory
CLUSTER_KUBECONFIG="${INFRA_DIR}/sre-chaos-poc.kubeconfig"


# exit if namespace exist
if kubectl --kubeconfig ${CLUSTER_KUBECONFIG} get ns -o json | jq -e ".items[] | select(.metadata.name == \"${NAMESPACE}\")" > /dev/null; then
    echo "Namespace '${NAMESPACE}' already exists."
    exit 0
fi

# create sre-challenge namespace
echo "Namespace '${NAMESPACE}' does not exist. Creating it now..."
kubectl --kubeconfig ${CLUSTER_KUBECONFIG} create namespace "${NAMESPACE}"
if [ $? -eq 0 ]; then
    echo "Namespace '${NAMESPACE}' created successfully."
else
    echo "Failed to create namespace '${NAMESPACE}'."
    exit 1
fi