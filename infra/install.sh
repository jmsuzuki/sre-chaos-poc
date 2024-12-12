#!/bin/bash

# Get the absolute path of the script
SCRIPT_PATH=$(realpath "$0")

# Get the parent directory of the script
PARENT_DIR=$(dirname "$SCRIPT_PATH")

### Install Cluster
bash -c ${PARENT_DIR}/setup/cluster/create_cluster.sh
bash -c ${PARENT_DIR}/setup/cluster/create_namespace.sh
bash -c ${PARENT_DIR}/setup/ingress/install_nginx_ingress.sh
bash -c ${PARENT_DIR}/setup/monitoring/install_metrics_server.sh
bash -c ${PARENT_DIR}/setup/monitoring/install_prom_stack.sh
bash -c ${PARENT_DIR}/setup/thirdparty/install_redis.sh
bash -c ${PARENT_DIR}/setup/welcome.sh