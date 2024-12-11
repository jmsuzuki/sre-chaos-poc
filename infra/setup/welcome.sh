#!/bin/bash

# Get the absolute path of the script
SCRIPT_PATH=$(realpath "${0}")

# Get the parent directory of the script
PARENT_DIR=$(dirname "${SCRIPT_PATH}")
INFRA_DIR=$(dirname "${PARENT_DIR}")

CLUSTER_KUBECONFIG="${INFRA_DIR}/sre-chaos-poc.kubeconfig"

echo "The SRE Chaos POC cluster is now available for use."
echo ""
echo "check the status of the cluster:"
echo "CLUSTER_KUBECONFIG=${CLUSTER_KUBECONFIG}"
echo 'kubectl --kubeconfig ${CLUSTER_KUBECONFIG} get ns'
echo ""
kubectl --kubeconfig ${CLUSTER_KUBECONFIG} get ns