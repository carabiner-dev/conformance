#!/usr/bin/env bash

# This test executes 1000 evaluations on a binary to test ampel's parallel 
# evaluation engine.

go run ./cmd/ampel verify conformance/parallel/sourcetool \
	-a conformance/parallel/sourcetool.intoto.jsonl \
	-p conformance/parallel/1000-evaluations.ampel.json
