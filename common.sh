#!/usr/bin/env bash

if [[ -z "${AMPEL_TEST_BINARY+set}" ]]; then
  AMPEL_TEST_BINARY="go run ./cmd/ampel"
fi
