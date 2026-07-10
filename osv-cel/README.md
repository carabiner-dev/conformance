# osv CEL plugin conformance test

Exercises the `osv` CEL evaluator plugin (`pkg/evaluator/plugins/osv`) end-to-end
through `ampel verify`. A single tenet drives several of the plugin's helper
functions against a real OSV predicate.

## What it tests

The policy declares the `internal:vulnreport` transformer, which normalizes the
attached Trivy report into an OSV results predicate
(`https://ossf.github.io/osv-schema/results@v1`). The tenet then filters that
predicate type and evaluates CEL that uses the `osv.*` functions:

| Function            | What the tenet asserts                                        |
|---------------------|---------------------------------------------------------------|
| `osv.vulns`         | The flattened `results -> packages -> vulnerabilities` list has 2 entries |
| `osv.ids`           | `CVE-2025-21613` is among the reported ids                     |
| `osv.matchesID`     | A vulnerability matches `CVE-2025-21613`                       |
| `osv.cvss`          | That vulnerability scores `>= 9.0` (CRITICAL, parsed from its CVSS vector) |
| `osv.isFixed`       | That vulnerability has a fixed version (`5.13.0`)             |
| `osv.forEcosystem`  | Every `Go` vulnerability is fixed                             |

The check passes only when all of these hold for the transformed data, so a
regression in the transformer output or in any of the exercised plugin
functions makes the tenet FAIL and the test exits non-zero.

## Note on `matchesID`

In this fixture the Trivy `VulnerabilityID` (`CVE-2025-21613`) becomes the OSV
vulnerability's **primary** `id`, so `osv.matchesID(v, 'CVE-2025-21613')` matches
on the id directly. `matchesID` is alias-aware (it also matches values listed in
a vulnerability's `aliases`), which is what makes it robust when a scanner emits
a GHSA as the primary id and the CVE only as an alias.

## Note on argument shape

The `osv.*` document-level functions are given the whole predicate
(`predicates[0]`). The plugin unwraps ampel's CEL predicate wrapper to its OSV
`data` internally, so `osv.vulns(predicates[0])` and `osv.vulns(predicates[0].data)`
are equivalent.

## Fixtures

- `target.txt` — small text file used as the in-toto subject.
- `trivy.intoto.json` — bare in-toto v1 statement wrapping a Trivy report with
  two CVEs against `github.com/go-git/go-git/v5` (`CVE-2025-21613` CRITICAL and
  `CVE-2025-21614` HIGH), each fixed in `5.13.0` and carrying a CVSS v3 vector.
- `policy-osv-cel.json` — the policy described above.

## Running

From the ampel checkout root:

```sh
./conformance/osv-cel/verify.sh
```

`ampel verify` must exit `0` with a PASS result.
