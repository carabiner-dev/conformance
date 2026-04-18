# vulnreport transformer conformance test

Exercises the `internal:vulnreport` transformer end-to-end through `ampel verify`,
covering both output modes selected by the policy-supplied config.

## What it tests

The vulnreport transformer normalizes a Trivy vulnerability report into a
common predicate format. It supports two output formats, selected via the
`config.output` field on the transformer entry in the policy:

| `config.output`             | Emitted predicate type                          |
|-----------------------------|-------------------------------------------------|
| (unset, default) / `osv`    | `https://ossf.github.io/osv-schema/results@v1.6.7` |
| `vulnreport`                | `https://in-toto.io/attestation/vulns/v0.2`     |

Both branches must produce a predicate whose marshaled `data` is consumable
by CEL tenets — i.e. real JSON bytes, the right predicate type, and the
expected findings preserved through the conversion.

## Fixtures

- `target.txt` — small text file used as the in-toto subject.
- `trivy.intoto.json` — bare in-toto v1 statement wrapping a hand-crafted
  Trivy report containing two CVEs against `github.com/go-git/go-git/v5`
  (`CVE-2025-21613` CRITICAL and `CVE-2025-21614` HIGH), each with CVSS v3
  scores and PURL identifiers. The report is small enough to read but rich
  enough to exercise CVSS, package metadata and PURL handling on both paths.

## Policies

- `policy-osv.json` — declares `internal:vulnreport` with no config (default
  `osv` output). Tenet filters predicates of type
  `https://ossf.github.io/osv-schema/results@v1.6.7` and asserts that
  `CVE-2025-21613` is present in `predicates[0].data.results[].packages[].vulnerabilities[]`.

- `policy-vulnreport.json` — declares `internal:vulnreport` with
  `config.output = "vulnreport"`. Tenet filters predicates of type
  `https://in-toto.io/attestation/vulns/v0.2` and asserts that the
  Scanner URI is `https://trivy.dev`, that at least two findings are
  present, and that `CVE-2025-21613` is among them.

## Running

From the ampel checkout root (where `conformance/` is symlinked to this repo):

```sh
./conformance/run-tests.sh
```

Or this test only:

```sh
AMPEL_TEST_BINARY=$(go build -o /tmp/ampel ./cmd/ampel && echo /tmp/ampel) \
  ./conformance/vulnreport/verify.sh
```

Both invocations of `ampel verify` must exit `0` with a PASS result.
