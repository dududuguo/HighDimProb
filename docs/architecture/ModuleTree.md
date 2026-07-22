# Module Tree

## Root Modules

- `HighDimProb`: stable root API for reviewed scalar probability infrastructure and typed statement specifications.
- `HighDimProb.RandomMatrix`: supported finite-dimensional base API outside the conservative root import.
- `HighDimProb.RandomMatrix.Concentration`: public downstream facade for documented matrix-concentration APIs.
- `HighDimProb.RandomMatrix.Provider`: internal/expert maintenance facade with analysis, conditioning, and concentration sublayers.
- `HighDimProb.Experimental`: aggregate API for v0.2+ high-dimensional and scaffold modules.
- `HighDimProbTest`: root test module for import and API regression checks.

## Stable Root API

`import HighDimProb` imports:

- `HighDimProb.Init`
- `HighDimProb.Scalar`
- `HighDimProb.Statements`

The stable root is intentionally narrow. It should expose the v0.1 scalar probability object layer and reviewed statement specifications only.

The documentation build is broader than the stable import root. The
`HighDimProb` Lake library uses these doc roots:

- `HighDimProb`
- `HighDimProb.Experimental`
- `HighDimProb.Examples`
- `HighDimProb.RandomMatrix.Provider`

These roots document the experimental API directory, provider maintenance
imports, and public examples without making `import HighDimProb` import
experimental declarations. The public concentration facade remains a separate
focused build target (`lake build HighDimProb.RandomMatrix.Concentration`), not
an additional `lean_lib HighDimProb` root.

## Broad Opt-In Aggregate

`import HighDimProb.Experimental` imports:

- `HighDimProb.Vector`
- `HighDimProb.Geometry`
- `HighDimProb.Concentration`
- `HighDimProb.RandomMatrix`
- `HighDimProb.LimitTheorems`
- `HighDimProb.Process`
- `HighDimProb.SignalRecovery`
- `HighDimProb.Tactic`

This aggregate combines mature and experimental branches for development
convenience. Membership does not determine support status. In particular,
`HighDimProb.RandomMatrix` has a supported finite-dimensional base, while
`HighDimProb.RandomMatrix.Concentration` is its ordinary downstream theorem
facade. The `Provider.*` routes remain internal/expert maintenance imports;
neither surface is re-exported by `HighDimProb.Experimental`.

Declarations that still expose proof-route assumptions belong here until their
mathematical boundary is settled. Examples include wrappers under explicit
primitive assumptions, trace-MGF provider assumptions, CFC/Tropp assumptions,
variance-proxy bounds, and operator-norm bridge assumptions.

## Branch Modules

- `HighDimProb.Scalar`: one-dimensional probability infrastructure, including scalar centering and variance leaves.
- `HighDimProb.Concentration`: public focused scalar-concentration facade, including the implication spine, finite maxima, full Dudley consumer, and finite Hanson-Wright endpoint.
- `HighDimProb.Vector`: finite-dimensional random-vector infrastructure.
- `HighDimProb.Geometry`: nets, metric entropy, covering/packing statements, and Gaussian-width vocabulary.
- `HighDimProb.RandomMatrix`: supported finite-dimensional random-matrix base.
- `HighDimProb.RandomMatrix.Concentration`: public downstream facade for trace-MGF, tail, Matrix Bernstein, and sample-covariance APIs.
- `HighDimProb.RandomMatrix.Provider.Analysis`: internal/expert maintenance import for deterministic analytic providers.
- `HighDimProb.RandomMatrix.Provider.Conditioning`: internal/expert maintenance import for conditioning and natural-history providers.
- `HighDimProb.RandomMatrix.Provider.Concentration`: internal/expert maintenance import for trace-MGF, tail, and Matrix Bernstein providers.
- `HighDimProb.LimitTheorems`: experimental weak-law scaffold with sample means, weak-law typed statements, and assumption vocabulary.
- `HighDimProb.Process`: random-process and empirical-process vocabulary.
- `HighDimProb.Statements`: typed theorem statement specifications and theorem-atlas bridge modules.
- `HighDimProb.Tactic`: reserved for lightweight project automation.

## Branch Tree

```text
HighDimProb
- Init (stable)
- Scalar (stable)
- Concentration (public focused facade)
- Vector (experimental)
- Geometry (experimental)
- RandomMatrix (supported finite-dimensional focused branch)
  - Concentration (public downstream facade)
  - Provider (internal/expert maintenance)
    - Analysis
    - Conditioning
    - Concentration
- LimitTheorems (experimental / reserved)
- Process (experimental / reserved)
- Statements (stable for typed specs)
- Tactic (reserved)
- Experimental (experimental aggregate)
```

Active tasks are tracked only in `docs/maintainers/TODO.md`; `docs/archive/LeafPlan.md` is historical. Ownership and promotion rules are tracked in `docs/architecture/BranchRegistry.md`.

Stage V1 adds human/agent-facing diagrams for this tree in
`docs/visualizations/module_tree.mmd`, and the generated Lean import graph in
`docs/visualizations/lake_import_graph.dot`.

## Concentration Import Decision

`HighDimProb.Concentration` is a supported focused import and remains outside
the intentionally small `import HighDimProb` root. Focused-import placement is
an import-cost decision, not an experimental-status marker. Unfinished
extensions remain excluded from the claims of the facade.

## Leaf Declaration Policy

New public declarations should live in the narrowest leaf module that owns their concept. A branch aggregate may import the leaf, but it should not become a dumping ground for declarations.

Each new public declaration needs at least one `#check` or tiny example test. Each new public module needs an import test through the appropriate branch or aggregate API.

## Physical File Migration Policy

Logical aggregate modules are introduced first. Existing flat files are not physically moved in Stage I3 or Stage I4.

The first RandomMatrix provider facades are documented in
[`RandomMatrixArchitecture.md`](RandomMatrixArchitecture.md). Physical folder
migration may happen only after those boundaries stabilize and import tests
show the dependency direction is correct. Migration rounds must preserve old
imports where practical and keep `lake build` and `lake test` passing.
