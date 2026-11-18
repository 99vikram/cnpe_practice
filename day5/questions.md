# Day 5 questions. Before every timer: read the forget-list out loud.

## Q1 (mock 1) — Gatekeeper team label — 6 min
A ConstraintTemplate k8srequiredlabels exists. Inspect it. Using it, create a Constraint
require-team-label requiring every Pod in gatekeeper-apps to carry a `team` label whose value is one of
platform, payments, data. Apply 02-test-pods.yaml to verify: pod-blocked rejected, pod-allowed admitted.
Checks: Constraint of the right kind · requires key team · correct namespace · value restricted.

## Q1b (mock 2) — Gatekeeper disallowed tag — 6 min
A ConstraintTemplate disallowedtags exists. Create Constraint block-latest-tag that blocks the `latest`
image tag on Pods in gatekeeper-apps. Apply 02-test-pods.yaml to verify.
Checks: right kind · latest in blocked tags · correct namespace.

## Q2 (mock 1) — Kyverno non-root — 8 min
Create Kyverno ClusterPolicy require-run-as-nonroot validating Pods in kyverno-secure and blocking any
Pod unless it runs as a non-root user. Enforce (reject), not audit.
Verify: apply 03-kyverno-test-pods.yaml -> pod-root rejected, pod-nonroot created.
Checks: policy created · enforces · validates runAsNonRoot · correct namespace.

## Q2b (mock 2) — Kyverno keyless signature — 8 min (docs allowed: kyverno.io -> Policies -> verifyImages)
ClusterPolicy verify-signed-images: for Pods in kyverno-secure, images matching ghcr.io/kyverno/* must be
signed, keyless, type SigstoreBundle, rekor https://rekor.sigstore.dev, issuer
https://token.actions.githubusercontent.com, subject https://github.com/kyverno/kyverno/.github/workflows/*.
Enforce. (No runnable test here; grading is on the YAML fields.)
Checks: policy created · attestor type · issuer · enforce.

## Verify
k get constrainttemplate X -o jsonpath='{.spec.crd.spec.validation}' | python3 -m json.tool   # the form to fill
k get k8srequiredlabels,disallowedtags -A ; k describe k8srequiredlabels require-team-label      # violations
k get cpol                                            # READY True
k get pods -n gatekeeper-apps ; k get pods -n kyverno-secure
