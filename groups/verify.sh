#!/usr/bin/env bash

source conformance/common.sh

# This test performs a simple evaluation reading a remote policy

$AMPEL_TEST_BINARY verify conformance/sourcetool/sourcetool-v0.6.3-linux-amd64 \
	-c jsonl:conformance/sourcetool/sourcetool-v0.6.3.intoto.jsonl \
	-p 'conformance/groups/group.json' \
	-x "builderId:https://github.com/slsa-framework/source-tool/.github/workflows/release.yaml" 


$AMPEL_TEST_BINARY verify conformance/sourcetool/sourcetool-v0.6.3-linux-amd64 \
	-c jsonl:conformance/sourcetool/sourcetool-v0.6.3.intoto.jsonl \
	-p 'conformance/groups/group-context.json' \
