#!/bin/bash
# Day 6: Argo Rollouts + kubectl plugin + fixtures (Deployment, services, a "tracing" app). ~3 min.
set -e
kubectl create ns argo-rollouts 2>/dev/null || true
kubectl apply --server-side -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml
curl -sLo /tmp/kar https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-linux-amd64
chmod +x /tmp/kar && sudo mv /tmp/kar /usr/local/bin/kubectl-argo-rollouts
kubectl -n argo-rollouts wait --for=condition=Available deploy --all --timeout=300s
kubectl create ns progressive 2>/dev/null || true
kubectl create ns tracing 2>/dev/null || true
kubectl apply -f 01-fixtures.yaml
grep -q "alias k=" ~/.bashrc || echo "alias k=kubectl" >> ~/.bashrc
kubectl argo rollouts version; kubectl get deploy,svc -n progressive
echo "READY. Run: cat README.md"
