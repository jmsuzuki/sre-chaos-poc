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
RELEASE_NAME="prometheus-stack"
CHART_REPO="https://prometheus-community.github.io/helm-charts"
CHART_NAME="prometheus-community/kube-prometheus-stack"
CHART_VERSION="66.3.1"

NODE_SELECTOR_KEY="sre-chaos-poc/node-pool"
NODE_SELECTOR_VALUE="platform"

# Add the Prometheus Helm repository if not already added
helm repo add prometheus-community "${CHART_REPO}" > /dev/null 2>&1  || echo "Prometheus repo already added."

# Update the Helm repo to ensure we have the latest charts
helm repo update > /dev/null 2>&1

# Install or upgrade the Prometheus stack
helm upgrade --install "${RELEASE_NAME}" "${CHART_NAME}" \
    --namespace "${NAMESPACE}" \
    --create-namespace \
    --version "${CHART_VERSION}" \
    --set prometheus.prometheusSpec.nodeSelector."${NODE_SELECTOR_KEY}"="${NODE_SELECTOR_VALUE}" \
    --set prometheusOperator.nodeSelector."${NODE_SELECTOR_KEY}"="${NODE_SELECTOR_VALUE}" \
    --set alertmanager.alertmanagerSpec.nodeSelector."${NODE_SELECTOR_KEY}"="${NODE_SELECTOR_VALUE}" \
    --set grafana.nodeSelector."${NODE_SELECTOR_KEY}"="${NODE_SELECTOR_VALUE}" \
    --set kube-state-metrics.nodeSelector."${NODE_SELECTOR_KEY}"="${NODE_SELECTOR_VALUE}" \
    --set prometheus-node-exporter.nodeSelector."${NODE_SELECTOR_KEY}"="${NODE_SELECTOR_VALUE}" \
    --set prometheus.prometheusSpec.additionalScrapeConfigs[0].job_name='node-app' \
    --set prometheus.prometheusSpec.additionalScrapeConfigs[0].scrape_interval='5s' \
    --set prometheus.prometheusSpec.additionalScrapeConfigs[0].metrics_path='/metrics' \
    --set prometheus.prometheusSpec.additionalScrapeConfigs[0].static_configs[0].targets[0]='node-app.sre-challenge.svc.cluster.local:9464'

if [ $? -eq 0 ]; then
    echo "Prometheus stack '${RELEASE_NAME}' successfully installed/upgraded in namespace '${NAMESPACE}'."
else
    echo "Failed to install/upgrade Prometheus stack."
    exit 1
fi