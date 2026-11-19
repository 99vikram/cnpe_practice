#!/bin/bash
# Day 5: Gatekeeper + Kyverno (via Helm, reliable) + exam fixtures. ~4 min. Safe to re-run.
set -e
kubectl apply --server-side -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/deploy/gatekeeper.yaml
command -v helm >/dev/null || curl -sL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm repo add kyverno https://kyverno.github.io/kyverno/ >/dev/null 2>&1 || true; helm repo update >/dev/null
helm upgrade --install kyverno kyverno/kyverno -n kyverno --create-namespace --wait --timeout 6m
echo "waiting for gatekeeper..."
kubectl -n gatekeeper-system wait --for=condition=Available deploy --all --timeout=300s
kubectl create ns gatekeeper-apps 2>/dev/null || true
kubectl create ns kyverno-secure 2>/dev/null || true
kubectl apply -f 01-templates.yaml
sleep 10; kubectl get constrainttemplates; kubectl get pods -n kyverno
grep -q "alias k=" ~/.bashrc || echo "alias k=kubectl" >> ~/.bashrc
echo "READY. Run: cat README.md"
