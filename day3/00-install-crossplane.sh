#!/bin/bash
# Day 3: Crossplane v2 + provider-kubernetes + function-patch-and-transform. ~5 min.
set -e
command -v helm >/dev/null || curl -sL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm repo add crossplane-stable https://charts.crossplane.io/stable >/dev/null; helm repo update >/dev/null
helm upgrade --install crossplane crossplane-stable/crossplane -n crossplane-system --create-namespace --wait --timeout 5m
kubectl apply -f 01-platform.yaml          # Provider + Function + ClusterProviderConfig
echo "waiting for provider + function (image pulls, 2-3 min)..."
kubectl wait provider.pkg.crossplane.io/provider-kubernetes --for=condition=Healthy --timeout=400s
kubectl wait function.pkg.crossplane.io/function-patch-and-transform --for=condition=Healthy --timeout=400s
# let the provider create ConfigMaps/Deployments/Services anywhere (practice only)
SA=$(kubectl -n crossplane-system get sa -o name | grep provider-kubernetes | head -1 | sed 's|serviceaccount/||')
kubectl create clusterrolebinding provider-kubernetes-admin --clusterrole=cluster-admin --serviceaccount=crossplane-system:$SA 2>/dev/null || true
kubectl apply -f 02-xrd.yaml && sleep 5 && kubectl apply -f 03-webapp-composition.yaml
kubectl create ns crossplane-apps 2>/dev/null || true
grep -q "alias k=" ~/.bashrc || echo "alias k=kubectl" >> ~/.bashrc
echo; kubectl get providers,functions,xrd,compositions
echo "READY. Run: cat README.md"
