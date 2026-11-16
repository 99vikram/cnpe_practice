#!/bin/bash
# Day 2: Tekton Pipelines + tkn (killercoda Kubernetes playground). ~3 min.
set -e
kubectl apply --server-side -f https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
echo "waiting for tekton..."
kubectl -n tekton-pipelines wait --for=condition=Available deploy --all --timeout=240s
V=$(curl -s https://api.github.com/repos/tektoncd/cli/releases/latest | grep tag_name | cut -d '"' -f4 | tr -d v)
curl -sL "https://github.com/tektoncd/cli/releases/download/v${V}/tkn_${V}_Linux_x86_64.tar.gz" | sudo tar xz -C /usr/local/bin tkn
# exam-like fixtures for Q7: namespace, PVC, pipeline with clone+build, target namespace + RBAC
kubectl create ns ci-pipelines 2>/dev/null || true
kubectl create ns staging 2>/dev/null || true
kubectl create rolebinding ci-deploy --clusterrole=edit --serviceaccount=ci-pipelines:default -n staging 2>/dev/null || true
kubectl apply -f 01-fixtures.yaml
grep -q "alias k=" ~/.bashrc || echo "alias k=kubectl" >> ~/.bashrc
echo; tkn version; kubectl get pvc -n ci-pipelines
echo "READY (PVC Pending is normal until first run). Run: cat README.md"
