#!/bin/bash

# Get the absolute path of the script
SCRIPT_PATH=$(realpath "$0")

# Get the parent directory of the script
INFRA_DIR=$(dirname "${SCRIPT_PATH}")

### kubeconfig
CLUSTER_KUBECONFIG="${INFRA_DIR}/sre-chaos-poc.kubeconfig"
if [[ ! -f "${CLUSTER_KUBECONFIG}" ]]; then
    echo "The kubeconfig file '${CLUSTER_KUBECONFIG}' does not exist."
    echo "Please run the following script to set up the infrastructure:"
    echo "  > bash -c ${INFRA_DIR}/install.sh"
    exit 1
fi

### Install app infra
kubectl --kubeconfig ${CLUSTER_KUBECONFIG} apply -f ${INFRA_DIR}/setup/app