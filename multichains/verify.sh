#!/usr/bin/env bash

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
		| sha256sum - \
		| grep 83acaf3484659ca323cecfc4fab99c4dc14811a293f7239e584724fb9bdca7a5 
