# Day 2 questions (notes closed, timer on)

## Q7a (mock 2) — deploy task after clone+build — 8 min
Pipeline app-pipeline in ci-pipelines has tasks clone, build and a workspace PVC pipeline-workspace-pvc.
Create a Task `deploy` (image bitnami/kubectl:latest) with a workspace `source` and string param
`namespace`, running:  kubectl apply -f $(workspaces.source.path)/deploy.yaml -n $(params.namespace)
Wire deploy into app-pipeline after both clone and build, with namespace=staging, using the shared
workspace. Create a PipelineRun binding shared-workspace to pipeline-workspace-pvc.
Checks: deploy runs after existing tasks · a PipelineRun ran successfully.

## Q7b (mock 1) — conditional deploy — 8 min
Same, but deploy must run after build ONLY WHEN clone's result `target-env` equals staging,
passing that result as the namespace param. (The clone task emits target-env.)
Checks: deploy is conditional · when driven by clone's target-env · runs after build · PipelineRun
succeeded · manifest applied in staging.

## Q-extra — scan gate — 6 min (speed round)
Add Task `scan` (image aquasec/trivy:latest, args: image --exit-code 1 --severity HIGH,CRITICAL nginx:1.27)
between build and deploy in the pipeline. Run it. (It may fail on real CVEs: that IS the gate working.)

## Verify
k get pr -n ci-pipelines           # SUCCEEDED True
tkn pr logs --last -f -n ci-pipelines
k get deploy -n staging
