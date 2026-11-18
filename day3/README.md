# Day 3 — Crossplane (120 min)

    cd cnpe_practice && git pull && cd day3 && bash 00-install-crossplane.sh && source ~/.bashrc

## Crossplane dialect card (read before anything)
| Word            | Means                                                       | kubectl                         |
|-----------------|-------------------------------------------------------------|---------------------------------|
| XRD             | the API users see (kind WebApp, its spec fields)            | k get xrd                       |
| Composition     | the recipe: list of `resources`, each = `base` + `patches`  | k get compositions              |
| XR              | one instance a user creates (kind WebApp, name test-app)    | k get webapp -A                 |
| Object          | provider-kubernetes wrapper: "create this K8s manifest"     | k get object.kubernetes.m.crossplane.io -A |
| FromComposite   | XR.spec.X  ->  resource field (`spec.forProvider.manifest...`)|                                |
| ToComposite     | resource field  ->  XR.status.Y                             |                                 |
Paths: fromFieldPath on a FromComposite patch is relative to the XR (spec.image). toFieldPath is relative
to the managed resource, so for an Object it ALWAYS starts with spec.forProvider.manifest.

| Min     | Block            | Do                                                                                          |
|---------|------------------|---------------------------------------------------------------------------------------------|
| 0-8     | install          | script (slow: image pulls). While waiting, read the dialect card and `cat 02-xrd.yaml`       |
| 8-15    | Day-2 warm-up    | Timer 7. Write Tekton deploy Task + the `when` pipeline entry from blank into warmup.yaml. Compare with ../day2/solutions. No cluster needed |
| 15-40   | REP 1 look       | NO WRITING. `cat 03-webapp-composition.yaml` slowly: find the 2 resources, their base, their patches. `k apply -f 04-webapp-xr.yaml`. Then `k get webapp -A` (wait for SYNCED/READY True), `k get object.kubernetes.m.crossplane.io -A`, `k get deploy,svc -n crossplane-apps`, `k describe webapp test-app -n crossplane-apps` (read the Conditions at the bottom). Break it on purpose: `k edit webapp test-app -n crossplane-apps`, change image to nginx:1.28, then `k get deploy webapp -n crossplane-apps -o jsonpath='{.spec.template.spec.containers[0].image}'` and watch it change. That is the whole product |
| 40-45   | break            |                                                                                             |
| 45-65   | REP 2 Q15b       | Reset: `k delete webapp test-app -n crossplane-apps; cp 03-webapp-composition.yaml webapp-composition.yaml; cp 04-webapp-xr.yaml webapp-xr.yaml`. Timer 8. READ Q15b twice (two small edits to EXISTING resources, no new resource). Edit, `k apply -f` both, verify. `diff webapp-composition.yaml solutions/q15b-full.yaml` |
| 65-70   | break            |                                                                                             |
| 70-95   | REP 3 Q15a       | Same reset. Timer 8. Q15a: NEW resource entry (copy the service entry, replace everything under manifest: with a real ConfigMap = metadata + data) + ToComposite patch on service. Verify ConfigMap data + XR status. `diff webapp-composition.yaml solutions/q15a-full.yaml` |
| 95-100  | break            |                                                                                             |
| 100-115 | speed round      | Reset. Q15b again, timer 6. Write time                                                      |
| 115-120 | close            | 3 lines on paper                                                                            |

Gotchas you WILL hit: APPEND to an existing `patches:` list (same indentation as the dash above it);
the new resource entry sits under `resources:` at the same indent as `- name: service`;
`k describe webapp` -> Status.Conditions message names exactly which resource or patch is wrong;
ConfigMap data values must be strings (image is already a string, fine);
status.serviceName must exist in the XRD status schema (it does here; in the exam check with `k get xrd X -o yaml`).
If the XR stays SYNCED=False: `k get object.kubernetes.m.crossplane.io -A` then describe the one not READY.
