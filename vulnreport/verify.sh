#!/usr/bin/env bash

set -euo pipefail

source conformance/common.sh

SUBJECT="conformance/vulnreport/target.txt"
ATTESTATION="conformance/vulnreport/trivy.intoto.json"

echo "  ▸ Test: vulnreport transformer default output (OSV)"
$AMPEL_TEST_BINARY verify "$SUBJECT" \
    -a "$ATTESTATION" \
    -p conformance/vulnreport/policy-osv.json

echo "  ▸ Test: vulnreport transformer configured output=vulnreport (vulns/v0.2)"
$AMPEL_TEST_BINARY verify "$SUBJECT" \
    -a "$ATTESTATION" \
    -p conformance/vulnreport/policy-vulnreport.json
