#!/usr/bin/env bash

set -euo pipefail

source conformance/common.sh

SUBJECT="conformance/sourcetool/sourcetool-v0.6.3-linux-amd64"
ATTESTATIONS="conformance/sourcetool/sourcetool-v0.6.3.intoto.jsonl"
EXTRA_UNSIGNED="conformance/identity/extra-unsigned.json"

# The exact sigstore identity of the sourcetool attestation signer.
SIGNER_ISSUER="https://token.actions.githubusercontent.com"
SIGNER_IDENTITY="https://github.com/slsa-framework/source-tool/.github/workflows/release.yaml@refs/tags/v0.6.3"
SIGNER_SLUG="sigstore::${SIGNER_ISSUER}::${SIGNER_IDENTITY}"

# Test 1: Policy set with identity passes when all attestations match the signer.
echo "  ▸ Test: policy set identity filter (matching attestations only)"
$AMPEL_TEST_BINARY verify "$SUBJECT" \
    -c jsonl:"$ATTESTATIONS" \
    -p conformance/identity/identity-filter-set.json \
    --signer "${SIGNER_SLUG}"

# Test 2: Policy set with identity passes even when extra unsigned attestations
# are present — non-matching attestations are silently discarded.
echo "  ▸ Test: policy set identity filter (mixed: matching + unsigned attestations)"
$AMPEL_TEST_BINARY verify "$SUBJECT" \
    -c jsonl:"$ATTESTATIONS" \
    -a "$EXTRA_UNSIGNED" \
    -p conformance/identity/identity-filter-set.json \
    --signer "${SIGNER_SLUG}"
