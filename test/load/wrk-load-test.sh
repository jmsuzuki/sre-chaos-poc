#!/bin/bash

wrk -t4 -c100 -d600s http://localhost:8080/api/v1/info