#!/bin/bash
# Day 4: same Crossplane setup as Day 3 (reuses ../day3 files). CRDs need nothing installed.
set -e
cd ../day3 && bash 00-install-crossplane.sh && cd ../day4
kubectl create ns platform-apis 2>/dev/null || true
echo "READY. Run: cat README.md"
