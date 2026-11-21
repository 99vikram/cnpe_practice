# Day 6 questions

## Q16 (mock 1) — blue/green via workloadRef — 6 min
Argo Rollouts is installed. In progressive: Deployment demo-app, Services demo-active and demo-preview exist.
Complete demo-rollout.yaml (cp 02-demo-rollout-partial.yaml demo-rollout.yaml) so that it references the
existing demo-app Deployment via workloadRef, uses the blueGreen strategy with demo-active as active and
demo-preview as preview, and auto-promotion disabled. Apply it.
Then: scale the Deployment to 0 (the Rollout owns the pods now), change the image to argoproj/rollouts-demo:green
via `kubectl argo rollouts set image demo-rollout demo=argoproj/rollouts-demo:green -n progressive`,
watch it pause, then promote.
Checks: applied · workloadRef · active service · preview service · autoPromotionEnabled false.

## Q16b (mock 2) — canary with Istio traffic routing — 6 min, WRITING ONLY (no Istio here)
Same partial file. Add workloadRef, trafficRouting using Istio VirtualService demo-vs route primary,
canaryService demo-canary, stableService demo-stable, and steps: 20% then pause 30s, 50% then pause 30s,
then 100%. Write it, then diff solutions/q16b.yaml. (Applying fails without Istio CRDs; that's expected.)

## Q16c — plain canary, runnable — 5 min
Same partial file. workloadRef + canary steps setWeight 25, pause {}, setWeight 50, pause 60s, setWeight 100.
No services, no trafficRouting. Apply, set image to :green, `kubectl argo rollouts get rollout demo-rollout
-n progressive --watch`, promote through the indefinite pause.

## Q13 (mock 1) — OTel resource attrs + sampler — 3 min
checkout-svc in tracing already exports OTLP. Add OTEL_RESOURCE_ATTRIBUTES=service.version=2.1,deployment.environment=production
and head sampling parentbased_traceidratio with arg 0.25. Don't remove existing OTLP vars.
Checks: attrs set · sampler set · arg 0.25 · existing vars intact.

## Q13b (mock 2) — OTel wiring from scratch — 3 min
notification-svc in tracing isn't sending traces. Set OTEL_SERVICE_NAME=notification-svc, and
OTEL_EXPORTER_OTLP_ENDPOINT + OTEL_TRACES_EXPORTER to match the cluster (find the collector service).
Checks: service name · endpoint points at the collector · exporter otlp.

## Verify
kubectl argo rollouts get rollout demo-rollout -n progressive     # Status, strategy, revisions
k get rollout -n progressive ; k get rs -n progressive
k set env deploy/checkout-svc -n tracing --list ; k get svc -n tracing
