# Day 1 questions (read ONLY the question, solve with notes closed)

## Q4 (mock 1) — exit handler — 8 min
A Workflow file ci-workflow.yaml exists with two sequential steps: compile and package.
Add an exit handler: a new template `report-step` (image alpine:3.20) that executes
`echo 'Publishing pipeline status report...'`, wired via `onExit` so it runs whenever the
workflow finishes, regardless of success or failure. Submit the Workflow.
Checks: submitted and succeeded · declares onExit · exit-handler template defined.

## Q5 (mock 1) — WorkflowTemplate with params — 8 min
In namespace argo create WorkflowTemplate `deploy-template` accepting four parameters
app-name, target-namespace, replicas, image; its template runs bitnami/kubectl:latest to
create a Deployment from those parameters. Invoke it (--from) with
app-name=portal target-namespace=self-service replicas=3 image=nginx:1.27.
(self-service namespace exists; the Argo SA can create Deployments there.)
Checks: template created · declares the 4 params · a Workflow from it succeeded ·
Deployment has 3 replicas · uses nginx:1.27.

## Q4b (mock 2) — third sequential step — 6 min (speed round alternative)
Same ci-workflow.yaml. Add a third step `notify` (template notify-step, alpine:3.20)
after the last step that executes `echo 'Pipeline completed successfully. Notifying stakeholders...'`.
Submit.

## Q5b (mock 2) — DAG from scratch — 8 min (speed round alternative)
Create release-workflow.yaml, generateName release-pipeline-, namespace argo, a DAG with
four tasks on alpine:3.20: lint (no deps, prints "lint completed"); unit-test and
security-scan (after lint); publish (after both). Each prints "<name> completed". Submit.

## Verify (that's all)
k get wf -n argo            # STATUS Succeeded
argo logs @latest -n argo   # only if Failed
k get deploy -n self-service
