# Day 4 — Crossplane rep 3 + CRDs (120 min)

    cd cnpe_practice && git pull && cd day4 && bash 00-install.sh && source ~/.bashrc

| Min     | Block            | Do                                                                                          |
|---------|------------------|---------------------------------------------------------------------------------------------|
| 0-8     | install          | script. Read "CRD in 4 minutes" (notes p.20) while it runs                                   |
| 8-25    | REP Q15a         | TIMER 8, no exceptions. Reset line in questions.md. New ConfigMap entry + ToComposite patch. Verify cm data + XR status. diff ../day3/solutions/q15a.yaml |
| 25-30   | break            |                                                                                             |
| 30-50   | CRD REP 1 copy   | `cat 01-sample-workspace.yaml` (learn group/kind/fields from the CR). `cat solutions/q10-workspace-crd.yaml`, TYPE into workspace-crd.yaml. `k apply -f workspace-crd.yaml; k apply -f 01-sample-workspace.yaml; k get ws -n platform-apis; k apply -f 03-bad-workspace.yaml` (read the 3 errors) |
| 50-55   | break            |                                                                                             |
| 55-75   | CRD REP 2 Q10b   | `k delete crd workspaces.platform.example.com`. Timer 8. Environment CRD from the question only. Apply CRD + sample. `k get envs`. diff solutions/q10b-environment-crd.yaml |
| 75-80   | break            |                                                                                             |
| 80-100  | CRD REP 3 Q10    | `k delete crd environments.platform.example.com; rm workspace-crd.yaml`. Timer 8. Workspace CRD from the question only (the full one). diff solutions/q10-workspace-crd.yaml |
| 100-115 | speed round      | Crossplane Q15b (../day3/questions.md), timer 6, from a fresh cp                              |
| 115-120 | close            | 3 lines                                                                                     |

CRD work order (4 min target): (1) cat the sample CR -> group/version/kind/field names; (2) names block; (3) one version, served+storage;
(4) schema: type: object at EVERY level, spec.properties from the CR's fields; (5) extras the task lists: shortNames,
categories, subresources.status, additionalPrinterColumns. `k apply --dry-run=server -f crd.yaml` before the CR.
CRD gotchas: metadata.name MUST be <plural>.<group>; `required:` sits beside `properties:` inside spec; `pattern` in single
quotes; printer column needs name/type/jsonPath; `default:` needs a `type:`.
Crossplane forget-list from yesterday: replicas patch toFieldPath ends .spec.replicas; labels go under manifest.metadata;
ToComposite is one more dash in the SAME patches list (direction reversed); ConfigMap `data:` is a sibling of `metadata:`.
