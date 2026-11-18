#!/bin/bash
# Day 3: Crossplane v2 + provider-kubernetes + function-patch-and-transform. ~5 min. Safe to re-run.
set -u
command -v helm >/dev/null || curl -sL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm repo add crossplane-stable https://charts.crossplane.io/stable >/dev/null 2>&1; helm repo update >/dev/null
helm upgrade --install crossplane crossplane-stable/crossplane -n crossplane-system --create-namespace --wait --timeout 5m

echo "== packages (provider + function)"
kubectl apply -f 01-packages.yaml
for i in $(seq 1 40); do
  P=$(kubectl get provider.pkg.crossplane.io provider-kubernetes -o jsonpath='{.status.conditions[?(@.type=="Healthy")].status}' 2>/dev/null)
  F=$(kubectl get function.pkg.crossplane.io function-patch-and-transform -o jsonpath='{.status.conditions[?(@.type=="Healthy")].status}' 2>/dev/null)
  [ "$P" = "True" ] && [ "$F" = "True" ] && break
  echo "  waiting... provider=$P function=$F ($i/40)"; sleep 10
done

echo "== provider config + RBAC (only possible after provider is healthy)"
kubectl apply -f 01b-providerconfig.yaml
SA=$(kubectl -n crossplane-system get sa -o name | grep provider-kubernetes | head -1 | sed 's|serviceaccount/||')
kubectl create clusterrolebinding provider-kubernetes-admin --clusterrole=cluster-admin --serviceaccount=crossplane-system:$SA 2>/dev/null || true

echo "== XRD + composition + namespace"
kubectl apply -f 02-xrd.yaml
kubectl wait xrd webapps.platform.example.com --for=condition=Established --timeout=120s
kubectl apply -f 03-webapp-composition.yaml
kubectl create ns crossplane-apps 2>/dev/null || true
grep -q "alias k=" ~/.bashrc || echo "alias k=kubectl" >> ~/.bashrc

echo; kubectl get providers,functions,clusterproviderconfig,xrd,compositions
echo "READY. Run: cat README.md"
