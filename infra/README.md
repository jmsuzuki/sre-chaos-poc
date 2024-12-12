# sre-chaos-poc - infra

### Assumptions
1. project is being run from silicon mac

### Pre-Requisites
1. kind 0.25.0 is installed
2. jq 1.7 is installed
3. The app docker image is built and available locally. To build this image, goto the app dir and follow the readme. 

### Cluster Base Installation Steps
1. run the install script located in the infra directory.  (this can be done from the repo root)
2. access the cluster! (the welcome script output / welcome message has instructions on running kubectl get namespaces)

```bash
# from repo root
./infra/install.sh
```

### Loading the node-app docker image into the kind cluster
run the script from app/scripts to build and load the image into kind!
```bash
./app/scripts/docker/build-and-load-image-into-kind.sh
```

### Cluster App Installation Steps
1. run the install-app script located in the infra directory.  (this can be done from the repo root)
2. get the info and health endpoints via browser for verification

```bash
# from repo root
./infra/install-app.sh
curl --request GET -sL \
     --url 'http://localhost:8080/api/v1/info'
```

### Destroying the Cluster
1. run the destroy script located in the infra directory. (this can be done from the repo root)

```bash
# from repo root
./infra/destroy.sh
```