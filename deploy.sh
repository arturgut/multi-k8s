#!/bin/sh

# Build images 
docker build -t mrsouliner/multi-client:latest -t mrsouliner/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t mrsouliner/multi-server:latest -t mrsouliner/multi-server:$SHA -f ./server/Dockerfile ./server 
docker build -t mrsouliner/multi-worker:latest -t mrsouliner/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# Push to registry with tag latest
docker push mrsouliner/multi-client:latest
docker push mrsouliner/multi-server:latest
docker push mrsouliner/multi-worker:latest

# Push to registry with tag SHA of current commit 
docker push mrsouliner/multi-client:$SHA
docker push mrsouliner/multi-server:$SHA
docker push mrsouliner/multi-worker:$SHA

# Apply in Kuberenetes 
kubectl apply -f k8s 

# Set images
kubectl set image deployments/server-deployment server=mrsouliner/multi-server:$SHA
kubectl set image deployments/client-deployment client=mrsouliner/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=mrsouliner/multi-worker:$SHA
