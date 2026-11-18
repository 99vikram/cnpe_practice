# Day 5 — Gatekeeper + Kyverno (120 min)

    cd cnpe_practice && git pull && cd day5 && bash 00-install.sh && source ~/.bashrc

## Dialect card
| | Gatekeeper | Kyverno |
|---|---|---|
| Who writes the rule | template author (Rego) — NOT you | you, in YAML |
| What you write | a Constraint: kind = template's crd.spec.names.kind | ClusterPolicy (cluster) / Policy (ns) |
| apiVersion | constraints.gatekeeper.sh/v1beta1 | kyverno.io/v1 |
| Scope | spec.match.kinds + spec.match.namespaces | rules[].match.any[].resources.kinds + namespaces |
| Inputs | spec.parameters (shape = template schema) | validate.pattern / anyPattern / deny |
| Block vs report | enforcementAction: deny (default) / dryrun / warn | validationFailureAction: Enforce / Audit |
| Verify | k describe <kind> <name> (violations) ; test pods | k get cpol (READY) ; test pods ; k get polr -n ns |
Gatekeeper 3-step: (1) `k get constrainttemplate X -o yaml` -> read names.kind + validation.properties;
(2) write Constraint with match + parameters shaped like those properties; (3) apply test pods.

| Min     | Block            | Do                                                                                          |
|---------|------------------|---------------------------------------------------------------------------------------------|
| 0-6     | install          | script. Read the dialect card while it runs                                                 |
| 6-14    | Day-4 warm-up    | Timer 7, writing only: Workspace CRD from blank into warmup.yaml. diff ../day4/solutions/q10-workspace-crd.yaml. (Dashes! `[]` = dash) |
| 14-35   | REP 1 copy       | Gatekeeper: `k get constrainttemplate k8srequiredlabels -o yaml` and FIND the kind + the labels schema. `cat solutions/q1.yaml`, type into q1.yaml (solution open side by side), apply, `k apply -f 02-test-pods.yaml` -> read the denial message. Kyverno: `cat solutions/q2.yaml`, type into q2.yaml, apply, `k get cpol`, `k apply -f 03-kyverno-test-pods.yaml` -> read the denial |
| 35-40   | break            |                                                                                             |
| 40-55   | REP 2 Q1b        | Reset: `k delete pod --all -n gatekeeper-apps`. Timer 6. Inspect disallowedtags template FIRST, then write block-latest-tag from the question. Test pods. diff solutions/q1b.yaml |
| 55-60   | break            |                                                                                             |
| 60-75   | REP 3 Q2         | Reset: `k delete cpol require-run-as-nonroot; k delete pod --all -n kyverno-secure`. Timer 8. From the question. Test pods. diff solutions/q2.yaml |
| 75-80   | break            |                                                                                             |
| 80-100  | REP 4            | Reset: `k delete k8srequiredlabels require-team-label; k delete pod --all -n gatekeeper-apps`. Q1 from question, timer 6. Then Q2b: open the Kyverno docs page, timer 8, write from the docs example |
| 100-115 | speed round      | Q1b again timer 4; Q2 again timer 5. Write times                                             |
| 115-120 | close            | 3 lines                                                                                     |

Gotchas: Constraint kind is CamelCase from the template (K8sRequiredLabels), the template name is lowercase.
Gatekeeper denial text: `admission webhook "validation.gatekeeper.sh" denied the request: [require-team-label] ...`.
Kyverno booleans in patterns are quoted strings ("true"). Kyverno denial text names policy/rule/message.
If a Constraint "applies" but nothing is denied: wrong namespace in match, or the template CRD was not ready yet
(`k get crd | grep constraints.gatekeeper.sh`).
