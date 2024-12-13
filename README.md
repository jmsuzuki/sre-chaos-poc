# sre-chaos-poc
This project is intended as a local proof of concept  
for load and chaos testing of a simple api service.

### Assumptions
1. project is being run from silicon mac

### Project Pre-Requisites
1. kind 0.25.0 is installed
2. jq 1.7 is installed
3. node v22.12.0 is installed 
4. wrk is installed 
5. k6 v0.55.0 is installed 
6. docker desktop is running

### Endpoints
The api service has 2 endpoints:  
**/api/v1/info:** cached every 5s  
**/api/v1/health:** cached every 5s while healthy; while unhealthy, this endpoint is refreshed per request until  healthy

### Load Testing
run the test/load project to simulate enough _load_ to spin up 5 node-app workers.
follow test/load/README.md for detailed information on load testing the node-app

### High-Level Setup
1. create kind cluster
2. build and load node-app docker image into kind cluster
3. install node-app into kind cluster
4. port forward to the nginx ingress controller
5. info and health endpoints are now available over localhost:8080

```bash
# from repo root
# setup cluster and deploy node-app
./infra/install.sh
./app/scripts/docker/build-and-load-image-into-kind.sh
./infra/install-app.sh

# make node-app available over localhost:8080 via the nginx ingress controller
kubectl port-forward -n sre-challenge-platform  service/nginx-ingress-nginx-controller 8080:80

# test service
curl http://localhost:8080/api/v1/health

# view metrics in prometheus
kubectl port-forward -n sre-challenge-monitoring   service/prometheus-stack-kube-prom-prometheus 9090:9090

# view dashboard in grafana
kubectl port-forward -n sre-challenge-monitoring   service/prometheus-stack-grafana 8081:80
```
