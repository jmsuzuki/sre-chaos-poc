# sre-chaos-poc - load testing
A couple scripts have been set up to make load testing the node-app easy.  
Before starting a load test, it is recommended to pull up the grafana dashboard so that you can view metrics during the test.  

Node-App-Grafana-Dashboard.png has been provided as a living example of what the dashboard should look like during a load test.  
Node-App-Grafana-Dashboard.png details the following:
1. no load at beginning of test
2. load during the load test
3. hpa scaled the node-app to handle the load
4. average response times spiked and balanced out as the node-app scaled up
5. node-app scaled down after load test ended

### Assumptions
1. project is being run from silicon mac

### Pre-Requisites
1. wrk is installed
2. k6 v0.55.0 is installed
3. kind cluster is running with the app installed

### Load testing with k6
1. run the k6-load-test.js file.
```bash
# from repo root
k6 run test/load/k6-load-test.js
```

### Load testing with wrk
1. run the wrk-load-test.sh file.
```bash
# from repo root
./test/load/load-test.sh
```

### 5 minute load test w/o chaos cron running
From a cold cluster...
```bash
» wrk -t4 -c100 -d300s http://localhost:8080/api/v1/info

Running 5m test @ http://localhost:8080/api/v1/info
  4 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    25.85ms   12.61ms 226.65ms   75.57%
    Req/Sec     0.99k   193.20     1.73k    73.93%
  1181508 requests in 5.00m, 347.04MB read
Requests/sec:   3937.95
Transfer/sec:      1.16MB
```

### 5 minute load test w/ chaos cron running
From a warm cluster... 5 node-app pods running as a result of the previous test.  
Notice how 15 requests timed out and 1 request was not okay.  
This is clearly due to the chaos cron that was running in the background.
```bash
» wrk -t4 -c100 -d300s http://localhost:8080/api/v1/info

Running 5m test @ http://localhost:8080/api/v1/info
  4 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    26.43ms   12.89ms 272.70ms   75.46%
    Req/Sec     0.96k   174.92     1.50k    72.12%
  1152237 requests in 5.00m, 338.44MB read
  Socket errors: connect 0, read 0, write 0, timeout 15
  Non-2xx or 3xx responses: 1
Requests/sec:   3839.55
Transfer/sec:      1.13MB
```