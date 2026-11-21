# Day 6 — Argo Rollouts + OTel env (60 min)

    cd cnpe_practice && git pull && cd day6 && bash 00-install.sh && source ~/.bashrc

## Dialect card
| Rollout field | Meaning |
|---|---|
| spec.workloadRef {apiVersion: apps/v1, kind: Deployment, name: X} | adopt an existing Deployment's pod template (then scale the Deployment to 0) |
| strategy.blueGreen {activeService, previewService, autoPromotionEnabled: false} | two services, manual gate |
| strategy.canary.steps [- setWeight: N, - pause: {} or {duration: 30s}] | "steps" plural; pause {} = wait for promote |
| strategy.canary.canaryService / stableService | needed only with trafficRouting |
| strategy.canary.trafficRouting.istio.virtualServices [- name: vs, routes: [primary]] | mock 2 shape (list form) |
| kubectl argo rollouts get rollout X -n ns --watch / promote / abort / undo / set image X ctr=img | the CLI you need |
OTel = `kubectl set env deploy/X -n ns KEY=value KEY2=value`. Nothing else. `--list` to verify.

| Min | Do |
|---|---|
| 0-5 | install; read the card |
| 5-20 | REP 1 copy: `cp 02-demo-rollout-partial.yaml demo-rollout.yaml`, `cat solutions/q16.yaml` side by side, type the missing part, apply. `k scale deploy demo-app -n progressive --replicas=0`. `kubectl argo rollouts get rollout demo-rollout -n progressive`. Set image to :green, get --watch (Paused), promote, watch it finish. Then Q13 by copy: `cat solutions/q13.sh`, run it, `--list` |
| 20-25 | break |
| 25-35 | REP 2 Q16 from the question, timer 6. Reset: `k delete rollout demo-rollout -n progressive; k scale deploy demo-app -n progressive --replicas=2; cp 02-demo-rollout-partial.yaml demo-rollout.yaml`. diff solutions/q16.yaml |
| 35-45 | REP 3 Q16c runnable canary, timer 5, then promote through the pause. Then Q13b from the question, timer 3 (find the collector svc first) |
| 45-55 | Q16b Istio canary, writing only, timer 6. diff solutions/q16b.yaml |
| 55-60 | 3 lines |

Gotchas: `steps` not `step`; `pause: {}` is indefinite -> needs `promote`; with workloadRef you MUST scale the
Deployment to 0 or you get double pods; Rollout status "Paused" is the expected state at a pause step;
`set image` needs the container NAME (demo); exam Q16 is graded on the YAML, not on a completed promotion.
