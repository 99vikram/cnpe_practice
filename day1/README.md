# Day 1 — Argo Workflows (120 min)

In the killercoda box:
    git clone https://github.com/99vikram/cnpe_practice.git
    cd cnpe_practice/day1 && bash 00-install-argo.sh && source ~/.bashrc

Three tabs only: box, notes PDF (p.7, p.16-17), questions.md. Timer visible. Phone elsewhere.

| Min     | Block                | Do                                                                                   |
|---------|----------------------|--------------------------------------------------------------------------------------|
| 0-5     | install              | script above; `argo version` works                                                   |
| 5-30    | REP 1 copy           | notes p.7 OPEN. `vim dag.yaml`, type the DAG (don't cat 01-dag.yaml). `argo submit dag.yaml -n argo --watch`. `argo get @latest`, `argo logs @latest`. Remove deploy's dependencies, resubmit, see it run early, put it back. Then `cp 02-ci-workflow.yaml ci-workflow.yaml; argo submit ci-workflow.yaml -n argo --watch` |
| 30-35   | break                | stand, water, no screen                                                              |
| 35-60   | REP 2 Q4             | notes CLOSED. Read Q4 in questions.md. Timer 8. `cp 02-ci-workflow.yaml q4.yaml`, edit, submit. Timer rings -> stop, `diff q4.yaml solutions/q4.yaml`, write differences on paper |
| 60-65   | break                |                                                                                      |
| 65-90   | REP 3 Q5             | notes CLOSED. Timer 8. `vim deploy-template.yaml`, `k apply -f`, `argo submit --from workflowtemplate/deploy-template -n argo -p ... --watch`, `k get deploy portal -n self-service`. Compare with solutions/q5.yaml |
| 90-95   | break                |                                                                                      |
| 95-115  | speed round          | `k delete ns self-service; k create ns self-service; k create rolebinding wf-deploy --clusterrole=edit --serviceaccount=argo:default -n self-service`. Q4b timer 6, Q5b timer 8, from blank. Write both times |
| 115-120 | close                | paper: forget-list, times, one thing to redo tomorrow. Send me those 3 lines         |

Rules: breaks are mandatory; stop at 120 even if unfinished; if stuck >2 min in rep 2/3,
peek at the solution for ONE line, write it on the forget-list, continue.
