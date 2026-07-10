#!/usr/bin/env bash

set -euo pipefail

source conformance/common.sh

SUBJECT="conformance/osv-cel/target.txt"
ATTESTATION="conformance/osv-cel/trivy.intoto.json"

echo "  ▸ Test: osv CEL plugin over an internal:vulnreport OSV predicate"
# ampel verify exits non-zero when the policy does not PASS, so a failing
# policy makes this script fail under `set -e`.
$AMPEL_TEST_BINARY verify "$SUBJECT" \
    -a "$ATTESTATION" \
    -p conformance/osv-cel/policy-osv-cel.json
