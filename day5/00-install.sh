#!/bin/bash
# Day 5: Gatekeeper + Kyverno + exam fixtures. ~4 min.
set -e
kubectl apply --server-side -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/deploy/gatekeeper.yaml
kubectl create -f https://github.com/kyverno/kyverno/releases/latest/download/install.yaml 2>/dev/null || \
kubectl apply --server-side -f https://github.com/kyverno/kyverno/releases/latest/download/install.yaml
echo "waiting for gatekeeper + kyverno..."
kubectl -n gatekeeper-system wait --for=condition=Available deploy --all --timeout=300s
kubectl -n kyverno wait --for=condition=Available deploy --all --timeout=300s
kubectl create ns gatekeeper-apps 2>/dev/null || true
kubectl create ns kyverno-secure 2>/dev/null || true
kubectl apply -f 01-templates.yaml           # the ConstraintTemplates "already exist" in the exam
sleep 10; kubectl get constrainttemplates
grep -q "alias k=" ~/.bashrc || echo "alias k=kubectl" >> ~/.bashrc
echo "READY. Run: cat README.md"
