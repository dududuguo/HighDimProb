# Module Tree

## Root Modules

- `HighDimProb`: stable root API for reviewed scalar probability infrastructure and typed statement specifications.
- `HighDimProb.Experimental`: aggregate API for v0.2+ high-dimensional and scaffold modules.
- `HighDimProbTest`: root test module for import and API regression checks.

## Stable Root API

`import HighDimProb` imports:

- `HighDimProb.Init`
- `HighDimProb.Scalar`
- `HighDimProb.Statements`

The stable root is intentionally narrow. It should expose the v0.1 scalar probability object layer and reviewed statement specifications only.

## Experimental API

`import HighDimProb.Experimental` imports:

- `HighDimProb.Vector`
- `HighDimProb.Geometry`
- `HighDimProb.RandomMatrix`
- `HighDimProb.Process`
- `HighDimProb.SignalRecovery`
- `HighDimProb.Tactic`

These modules remain experimental until they pass the promotion checklist: tests, docs, `docs/Status.md` update, and stable-root import audit.

## Branch Modules

- `HighDimProb.Scalar`: one-dimensional probability infrastructure.
- `HighDimProb.Vector`: finite-dimensional random-vector infrastructure.
- `HighDimProb.Geometry`: nets, metric entropy, covering/packing statements, and Gaussian-width vocabulary.
- `HighDimProb.RandomMatrix`: random-matrix object and vocabulary submodules.
- `HighDimProb.Process`: random-process and empirical-process vocabulary.
- `HighDimProb.Statements`: typed theorem statement specifications and theorem-atlas bridge modules.
- `HighDimProb.Tactic`: reserved for lightweight project automation.

## Leaf Declaration Policy

New public declarations should live in the narrowest leaf module that owns their concept. A branch aggregate may import the leaf, but it should not become a dumping ground for declarations.

Each new public declaration needs at least one `#check` or tiny example test. Each new public module needs an import test through the appropriate branch or aggregate API.

## Physical File Migration Policy

Logical aggregate modules are introduced first. Existing flat files are not physically moved in Stage I3.

Physical folder migration may happen later only after APIs stabilize and after import tests show the logical branch boundaries are correct. Migration rounds must preserve names where possible, update imports, and keep `lake build` and `lake test` passing.

