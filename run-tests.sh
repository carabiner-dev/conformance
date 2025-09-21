#!/usr/bin/env bash

TMP_DIR=$(mktemp -d /tmp/conformance.XXXXXX )

# Build ampel from the current source
go build  -o "${TMP_DIR}/ampel" ./cmd/ampel

AMPEL_TEST_BINARY="${TMP_DIR}/ampel"
export AMPEL_TEST_BINARY


"$AMPEL_TEST_BINARY" version
echo 

for f in conformance/*/verify.sh; do
    echo "🔴🟡🟢 RUNNING TEST $f"
	 "$f"
    echo 
done
