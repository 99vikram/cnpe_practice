# Day 1 — Argo Workflows (120 min)

In the killercoda box:
    git clone https://github.com/99vikram/cnpe_practice.git
    cd cnpe_practice/day1 && bash 00-install-argo.sh && source ~/.bashrc

Three tabs only: box, questions.md, this README. Timer visible. Phone elsewhere.
Every rep: when the timer rings, STOP, diff against the reference, write differences on paper.

| Min     | Block            | Do                                                                                          |
|---------|------------------|---------------------------------------------------------------------------------------------|
| 0-5     | install          | script above; `argo version` works                                                          |
| 5-30    | REP 1 copy       | `cat 01-dag.yaml`, read once. `vim dag.yaml` and TYPE it (don't cp). `argo submit dag.yaml -n argo --watch`. If error: read the message, it names the line. `argo get @latest -n argo`. Then `cat solutions/q5.yaml`, type it into `deploy-template.yaml`, `k apply -f deploy-template.yaml`, run it with the `argo submit --from ...` line at the bottom of that file, `k get deploy -n self-service` |
| 30-35   | break            | stand, water, no screen                                                                     |
| 35-55   | REP 2 Q4         | Timer 8. Read Q4 in questions.md. `cp 02-ci-workflow.yaml q4.yaml`, edit, `argo submit q4.yaml -n argo --watch`. `diff q4.yaml solutions/q4.yaml` |
| 55-60   | break            |                                                                                             |
| 60-80   | REP 3 Q5         | Clean first: `rm deploy-template.yaml; k delete wftmpl deploy-template -n argo; k delete deploy portal -n self-service`. Timer 8. Read Q5. Write `deploy-template.yaml` from blank, apply, submit with `-p` params, `k get deploy portal -n self-service`. `diff deploy-template.yaml solutions/q5.yaml` |
| 80-85   | break            |                                                                                             |
| 85-115  | speed round      | Q4b timer 6 (cp 02-ci-workflow.yaml again). Q5b timer 8 (DAG from blank, diff solutions/q5b.yaml). Write both times |
| 115-120 | close            | paper: forget-list, times, one thing to redo tomorrow. Send me those 3 lines                |

Rules: breaks mandatory; stop at 120 even if unfinished; stuck >2 min in rep 2/3 -> peek at ONE
line of the solution, write it on the forget-list, continue. Verify = `k get wf -n argo` (Succeeded).
