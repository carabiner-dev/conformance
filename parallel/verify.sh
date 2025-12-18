#!/usr/bin/env bash

source conformance/common.sh

# This test executes 1000 evaluations on a binary to test ampel's parallel 
# evaluation engine.

echo ">> 1000 Evaluations: Serially"
command time -f " > 1000 Evaluations Serially: %E" -ao time.txt -- $AMPEL_TEST_BINARY verify conformance/parallel/sourcetool \
	-a conformance/parallel/sourcetool.intoto.jsonl \
	-p conformance/parallel/1000-evaluations.ampel.json \
    --workers=1 > /dev/null
echo ""

command echo ">> 1000 Evaluations: 100 Parallel Workers"
command time -f " > 1000 Evaluations 100 Workers: %E" -ao time.txt -- $AMPEL_TEST_BINARY verify conformance/parallel/sourcetool \
	-a conformance/parallel/sourcetool.intoto.jsonl \
	-p conformance/parallel/1000-evaluations.ampel.json \
    --workers=100 > /dev/null
echo ""
