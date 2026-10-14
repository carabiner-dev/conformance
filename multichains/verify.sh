#!/usr/bin/env bash

set -euo pipefail

source conformance/common.sh

# Run chained PolicySet multiple times to check consistency
# of computed attestations and results ordering

echo "🚜 Running Chained PolicySet Tests"

 $AMPEL_TEST_BINARY verify sha1:da990aef1d18ef93500bac636429f5802aa2a644 \
 	-c jsonl:conformance/multichains/attestations.jsonl \
	-c jsonl:conformance/multichains/signed_bundle.intoto.jsonl \
	-p conformance/multichains/osps-baseline-chains.compiled.policy.json \
	--exit-code=false --format=attestation \
		| jq '.predicate.results[] | "\(.policy.id) \(.status)" ' \
		| tr -d '\r' \
		| sha256sum - \
		| grep c60a5ec4438acef81c395ac185d84e65c9bf163de6ddd00d5d68cad41e1dad3a
