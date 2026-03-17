#!/usr/bin/env bash

set -euo pipefail

source conformance/common.sh

SUBJECT="conformance/sourcetool/sourcetool-v0.6.3-linux-amd64"
ATTESTATIONS="conformance/sourcetool/sourcetool-v0.6.3.intoto.jsonl"

# The exact sigstore identity of the sourcetool attestation signer.
SIGNER_ISSUER="https://token.actions.githubusercontent.com"
SIGNER_IDENTITY="https://github.com/slsa-framework/source-tool/.github/workflows/release.yaml@refs/tags/v0.6.3"
SIGNER_SLUG="sigstore::${SIGNER_ISSUER}::${SIGNER_IDENTITY}"

echo "  ▸ Test: predicate.verification.verified field access"
$AMPEL_TEST_BINARY verify "$SUBJECT" \
    -c jsonl:"$ATTESTATIONS" \
    -p conformance/verification/verification-field-access.json \
    --signer "${SIGNER_SLUG}"

echo "  ▸ Test: predicate.verification.matchesId() with matching identity"
$AMPEL_TEST_BINARY verify "$SUBJECT" \
    -c jsonl:"$ATTESTATIONS" \
    -p conformance/verification/verification-matches-id.json \
    --signer "${SIGNER_SLUG}" \
    -x "identity:${SIGNER_SLUG}"

echo "  ▸ Test: predicate.verification.matchesId() rejects wrong identity"
$AMPEL_TEST_BINARY verify "$SUBJECT" \
    -c jsonl:"$ATTESTATIONS" \
    -p conformance/verification/verification-matches-id-negative.json \
    --signer "${SIGNER_SLUG}"
