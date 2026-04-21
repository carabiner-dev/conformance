#!/usr/bin/env bash

set -euo pipefail

source conformance/common.sh

SUBJECT="conformance/sourcetool/sourcetool-v0.6.3-linux-amd64"
ATTESTATIONS="conformance/sourcetool/sourcetool-v0.6.3.intoto.jsonl"

echo "  ▸ Test: ContextVal resolution forms (value, default, provider override, expression, two-phase snapshot)"
# default_overridden  — provider override wins over default
# value_beats_provider — policy-burned value wins over provider override
$AMPEL_TEST_BINARY verify "$SUBJECT" \
    -c jsonl:"$ATTESTATIONS" \
    -p conformance/context-values/context-values.json \
    -x "default_overridden:over" \
    -x "value_beats_provider:ignored"
