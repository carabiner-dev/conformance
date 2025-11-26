#!/usr/bin/env bash

source conformance/common.sh

# This test verifies that the race condition bug with file handles in ghrfs has been fixed.
# It runs the same verification multiple times to detect "file already closed" errors.
# https://github.com/carabiner-dev/ghrfs/commit/156310d70b6ec8a4e72ecde2b6dd0924e45e09c1

success=0
fail=0

echo ">> Race Condition Test: 10 iterations"

for i in {1..10}; do
    echo "  Run $i..."
    output=$($AMPEL_TEST_BINARY verify \
        sha256:b2f66926949aef30bede58144b797b763fed2d00c75a58a246814a5e65acec55 \
        -p 'git+https://github.com/carabiner-dev/demo-slsa-e2e#policies/fritoto-check-artifacts.json' \
        -c release:carabiner-dev/demo-slsa-e2e@v0.1.1 2>&1)

    if echo "$output" | grep -q "file already closed"; then
        fail=$((fail+1))
        echo "    FAILED: Race condition detected"
    else
        success=$((success+1))
        echo "    SUCCESS"
    fi
done

echo ""
echo "========================================="
echo "Results: $success successful, $fail race condition errors"
echo "========================================="

# Exit with error if any race conditions were detected
if [ $fail -gt 0 ]; then
    echo "ERROR: Race condition present!"
    exit 1
fi
