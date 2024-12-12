# sre-chaos-poc - app
This readme details how to run and debug the node-app locally, without k8s.

### Assumptions
1. project is being run from silicon mac

### Pre-Requisites
1. node v22.12.0 is installed
2. docker desktop is running

### Running/Debugging the App Locally
1. run the docker-compose-up.sh script from the script directory to start redis 
2. run the node app

```bash
# from repo root
./app/scripts/docker-compose-ALL-up.sh
node app/src/app.js
```

### Building the Dockerfile and Loading it into Kind
check out the infra/README.md