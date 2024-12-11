# sre-chaos-poc - infra

### Assumptions
1. project is being run from silicon mac

### Pre-Requisites
1. kind 0.25.0 is installed
2. jq 1.7 is installed
3. The app docker image is built and available locally. To build this image, goto the app dir and follow the readme. 

### Installation Steps
1. run the install script located in the infra directory.  (this can be done from the repo root)
2. access the cluster! (the welcome script output / welcome message has instructions on running kubectl get namespaces)

```bash
# from repo root
./infra/install.sh
```

### To destroy...
1. run the destroy script located in the infra directory. (this can be done from the repo root)

```bash
# from repo root
./infra/install.sh
```