#!/bin/bash

# Get the absolute path of the script
SCRIPT_PATH=$(realpath "${0}")

# Get the parent directory of the script
PARENT_DIR=$(dirname "${SCRIPT_PATH}")
APP_DIR=$(dirname $(dirname "${PARENT_DIR}"))
REPO_ROOT_DIR=$(dirname "${APP_DIR}")

echo "PARENT_DIR: ${PARENT_DIR}"
echo "APP_DIR: ${APP_DIR}"
echo "REPO_ROOT_DIR: ${REPO_ROOT_DIR}"

docker build -t sre-chaos-poc:latest -f ${APP_DIR}/Dockerfile app
kind load docker-image sre-chaos-poc:latest --name sre-chaos-poc