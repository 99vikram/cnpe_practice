#!/bin/bash
# Day 1: Argo Workflows install (killercoda Kubernetes playground). ~3 min.
set -e
kubectl create ns argo 2>/dev/null || true
kubectl apply --server-side -n argo -f https://github.com/argoproj/argo-workflows/releases/latest/download/quick-start-minimal.yaml
echo "waiting for argo pods..."
kubectl -n argo wait --for=condition=Available deploy --all --timeout=240s
V=$(curl -s https://api.github.com/repos/argoproj/argo-workflows/releases/latest | grep tag_name | cut -d '"' -f4)
curl -sLo /tmp/argo.gz "https://github.com/argoproj/argo-workflows/releases/download/${V}/argo-linux-amd64.gz"
gunzip -f /tmp/argo.gz && chmod +x /tmp/argo && sudo mv /tmp/argo /usr/local/bin/argo
# RBAC for rep 3 (workflow runs kubectl against another namespace)
kubectl create ns self-service 2>/dev/null || true
kubectl create rolebinding wf-deploy --clusterrole=edit --serviceaccount=argo:default -n self-service 2>/dev/null || true
echo "alias k=kubectl" >> ~/.bashrc
echo; argo version --short; echo "READY. Run:  cd day1 && cat README.md"
