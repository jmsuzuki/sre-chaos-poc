#!/bin/bash

# Get the absolute path of the script
SCRIPT_PATH=$(realpath "$0")

# Get the parent directory of the script
PARENT_DIR=$(dirname "$SCRIPT_PATH")

### Install Cluster
bash -c ${PARENT_DIR}/setup/cluster/destroy_cluster.sh
echo "The cluster has been successfully destroyed."