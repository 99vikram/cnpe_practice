#!/bin/bash
set -e
kubectl create ns argo --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argo -f https://github.com/argoproj/argo-workflows/releases/latest/download/quick-start-minimal.yaml
V=$(curl -s https://api.github.com/repos/argoproj/argo-workflows/releases/latest | grep tag_name | cut -d '"' -f4)
curl -sLO "https://github.com/argoproj/argo-workflows/releases/download/${V}/argo-linux-amd64.gz"
gunzip -f argo-linux-amd64.gz && chmod +x argo-linux-amd64 && mv argo-linux-amd64 /usr/local/bin/argo
kubectl -n argo wait --for=condition=Available deploy --all --timeout=240s
kubectl create ns self-service --dry-run=client -o yaml | kubectl apply -f -
kubectl create rolebinding wf-deploy --clusterrole=edit --serviceaccount=argo:default -n self-service
echo 'alias k=kubectl' >> ~/.bashrc
echo "READY: $(argo version --short)"
