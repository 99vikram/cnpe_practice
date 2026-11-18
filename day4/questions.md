# Day 4 questions

## Warm-up: Q15a Crossplane (../day3/questions.md) — timer 8
Reset: k delete webapp test-app -n crossplane-apps; cp ../day3/03-webapp-composition.yaml webapp-composition.yaml; cp ../day3/04-webapp-xr.yaml webapp-xr.yaml
Then diff with ../day3/solutions/q15a.yaml

## Q10b (mock 2) — Environment CRD — 8 min
A sample CR 02-sample-environment.yaml defines an Environment of group platform.example.com/v1.
Create environment-crd.yaml that validates it:
 - group platform.example.com, version v1 (served + storage), scope Namespaced
 - kind Environment, plural environments, short names env, envs
 - spec: provider string (aws|gcp|azure); region string; size string (small|medium|large); autoScale boolean
Apply the CRD, then apply the sample CR.
Checks: CRD created · short names · sample CR applied · provider validated.

## Q10 (mock 1) — Workspace CRD, full UX — 8 min
A sample CR 01-sample-workspace.yaml defines a Workspace of group platform.example.com/v1.
Create workspace-crd.yaml:
 - group platform.example.com, version v1 (served + storage), scope Namespaced
 - kind Workspace, plural workspaces, short name ws, category platform
 - status subresource enabled
 - spec: tier string (development|staging|production); replicas integer min 1 max 10 default 1;
   version string pattern ^[0-9]+\.[0-9]+$; region string; monitoring boolean default false;
   tier and version REQUIRED
 - additionalPrinterColumns showing tier from .spec.tier
Apply the CRD, then the sample CR. Bonus: apply 03-bad-workspace.yaml and read the 3 rejection reasons.
Checks: CRD · short name · category · status subresource · version regex · replicas max · required · CR applied.

## Verify
k get crd | grep platform ; k get ws -n platform-apis (TIER column) ; k get envs -n platform-apis
k apply --dry-run=server -f workspace-crd.yaml        # schema errors before applying
k explain workspace.spec                               # proves the schema landed
