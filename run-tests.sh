#!/usr/bin/env bash

set -e
test_output=""

erro_handler() {
  echo 'Last test crapped out 💩'
  echo "Test output"
  echo "${test_output}"
  echo
}

trap 'erro_handler' ERR

TMP_DIR=$(mktemp -d /tmp/conformance.XXXXXX )

# Build ampel from the current source
go build  -o "${TMP_DIR}/ampel" ./cmd/ampel

AMPEL_TEST_BINARY="${TMP_DIR}/ampel"
export AMPEL_TEST_BINARY


"$AMPEL_TEST_BINARY" version
echo 

for f in conformance/*/verify.sh; do
    echo "🔴🟡🟢 RUNNING TEST $f"
	test_output=$("$f")
done

echo "All tests OK! 🥳🥳🥳"
