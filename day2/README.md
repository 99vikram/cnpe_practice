# Day 2 — Tekton (120 min)

    cd cnpe_practice && git pull && cd day2 && bash 00-install-tekton.sh && source ~/.bashrc

| Min     | Block            | Do                                                                                          |
|---------|------------------|---------------------------------------------------------------------------------------------|
| 0-5     | install          | script above                                                                                |
| 5-15    | Day-1 warm-up    | Timer 8. `cat ../day1/questions.md` Q5. Argo isn't installed today, so only WRITE deploy-template.yaml from blank, then `diff` with ../day1/solutions/q5.yaml. Forget-list |
| 15-40   | REP 1 copy       | `cat 01-fixtures.yaml` (this is "what already exists": read how clone writes a result and deploy.yaml). `cat solutions/deploy-task.yaml`, TYPE it into deploy-task.yaml, `k apply -f`. `k edit pipeline app-pipeline -n ci-pipelines` and type the deploy entry from `cat solutions/pipeline-q7a.yaml`. Run: `tkn pipeline start app-pipeline -n ci-pipelines --workspace name=shared-workspace,claimName=pipeline-workspace-pvc --showlog`. `k get pr -n ci-pipelines`; `k get deploy -n staging` |
| 40-45   | break            |                                                                                             |
| 45-65   | REP 2 Q7a        | Reset: `k delete task deploy -n ci-pipelines; k apply -f 01-fixtures.yaml; k delete deploy app -n staging`. Timer 8. From question only. diff against solutions |
| 65-70   | break            |                                                                                             |
| 70-90   | REP 3 Q7b        | Reset as above. Timer 8. Add `when` + result param (see Q7b). diff solutions/pipeline-q7b.yaml. Then edit clone to write `prod` instead of staging (`k edit task clone`), run again, confirm deploy is SKIPPED |
| 90-95   | break            |                                                                                             |
| 95-115  | speed round      | Reset. Q7a again from blank, timer 7. Then Q-extra timer 6 if time. Write times              |
| 115-120 | close            | 3 lines on paper, send them                                                                 |

If the PVC never binds (no default StorageClass in the box): run with `--workspace name=shared-workspace,emptyDir=""` instead. The exam cluster has a working PVC.
Verify = `k get pr -n ci-pipelines` SUCCEEDED True. Debug = `tkn pr logs --last -n ci-pipelines`.
