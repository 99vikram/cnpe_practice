# Day 3 questions (notes closed, timer on). Always start from a fresh copy of the composition:
#   cp 03-webapp-composition.yaml webapp-composition.yaml

## Q15b (mock 2) — replicas patch + label — 8 min
Crossplane is installed. XRD webapps.platform.example.com and Composition webapp-composition exist.
webapp-composition.yaml contains the Composition. Add patches in the function-patch-and-transform step so:
 - the Deployment resource's replicas are set from the XR's replicas
 - the Service resource carries the label managed-by: crossplane
Apply the updated Composition, then apply webapp-xr.yaml.
Checks: replicas patched from XR · XR created · Service has the label · Deployment has XR's replica count.

## Q15a (mock 1) — new ConfigMap resource + status patch — 8 min
Extend the function-patch-and-transform step so:
 - a NEW managed resource adds a ConfigMap named webapp-config in the XR's target namespace, whose
   data.image is patched from the XR's spec.image
 - the Service resource patches its manifest name (webapp-svc) back to the XR's status.serviceName
   (ToCompositeFieldPath)
Apply the Composition, then the XR.
Checks: ConfigMap resource defined · status write-back defined · XR created · ConfigMap has image value ·
XR status shows service name.

## Verify
k get webapp -A                                  # SYNCED True  READY True
k get deploy,svc,cm -n crossplane-apps
k get webapp test-app -n crossplane-apps -o jsonpath='{.status.serviceName}'; echo
k describe webapp test-app -n crossplane-apps | tail -25   # when not ready: the message names the resource
k get object.kubernetes.m.crossplane.io -A      # the managed resources (READY/SYNCED)
