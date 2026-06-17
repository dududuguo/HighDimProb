# Code Organisation

HighDimProb uses the root namespace `HighDimProb`.

## Public Import Layers

- Stable root API: `import HighDimProb`
- Experimental API: `import HighDimProb.Experimental`
- Test root: `import HighDimProbTest`

Stable modules expose the Milestone 1 probability object layer. Experimental modules expose partial high-dimensional vocabulary and proof-pilot infrastructure. Do not import experimental modules from the stable root.

## Lean Modules

- `HighDimProb/Init.lean`: shared imports and project conventions, with no mathematical API.
- `HighDimProb.lean`: stable root aggregate.
- `HighDimProb/Experimental.lean`: experimental aggregate.
- `HighDimProb/Tactic.lean`: reserved for lightweight project tactics.
- `HighDimProb/BookStatements.lean` and `HighDimProb/MetricEntropyStatements.lean`: typed `Prop` statement specifications, not proof placeholders.

## Branch Modules

- `HighDimProb/Scalar.lean`: one-dimensional probability infrastructure.
- `HighDimProb/Scalar/Centering.lean`: scalar mean, centeredness, and centering bridge lemmas.
- `HighDimProb/Scalar/Variance.lean`: scalar variance, covariance, and second-moment wrappers.
- `HighDimProb/Concentration.lean`: experimental scalar concentration proof spine.
- `HighDimProb/Vector.lean`: finite-dimensional random-vector infrastructure.
- `HighDimProb/Geometry.lean`: nets, metric entropy, covering/packing statements, and Gaussian-width vocabulary.
- `HighDimProb/RandomMatrix.lean`: experimental random-matrix aggregate over
  its subdirectory.
- `HighDimProb/Process.lean`: random-process and empirical-process vocabulary.
- `HighDimProb/Statements.lean`: typed theorem statement specifications and theorem-atlas bridge modules.
- `HighDimProb/Tactic.lean`: lightweight project automation.
- `HighDimProb/Experimental.lean`: experimental aggregate over v0.2+ branches.

Logical branch aggregates are introduced before any physical file migration. Existing leaf files should move only in a focused migration stage after APIs stabilize.

## Experimental Random Matrix Structure

- `HighDimProb/RandomMatrix.lean`: aggregate module.
- `HighDimProb/RandomMatrix/Basic.lean`: random matrix representation, entries,
  scaling, negation, and rank-one objects.
- `HighDimProb/RandomMatrix/RowsCols.lean`: row and column random-vector views.
- `HighDimProb/RandomMatrix/Action.lean`: deterministic matrix-vector actions.
- `HighDimProb/RandomMatrix/Norms.lean`: Frobenius and entrywise norm vocabulary.
- `HighDimProb/RandomMatrix/Assumptions.lean`: theorem-interface predicates
  and thin adapters.
- `HighDimProb/RandomMatrix/SampleCovariance.lean`: Gram and sample covariance vocabulary.
- `HighDimProb/RandomMatrix/QuadraticForm.lean`: quadratic and bilinear forms.
- `HighDimProb/RandomMatrix/OperatorNorm.lean`: L2 operator-norm wrapper.
- `HighDimProb/RandomMatrix/Spectral.lean`, `TraceExp.lean`, and
  `Laplace.lean`: spectral, trace-exponential, and Laplace vocabulary.
- `HighDimProb/RandomMatrix/VarianceProxy.lean`: variance-proxy matrices and
  norm bounds.
- `HighDimProb/RandomMatrix/ConcentrationStatements.lean`: Matrix Bernstein,
  operator-norm, and sample-covariance statement/wrapper layer.

## Tests

Tests live under `HighDimProbTest/`.

- Stable modules require public import or focused stable API tests.
- Experimental modules require experimental import or focused experimental API tests.
- Proof pilots require proof-focused `#check` test files.

## Documentation

- `docs/Status.md`: current status and active API pointers.
- `docs/Workflow.md`: mandatory contribution workflow.
- `docs/StageChecklist.md`: per-stage checklist.
- `docs/TermMap.md`: compact concept-to-source map.
- `docs/TheoremAtlas.md`: compact theorem-family registry.
- `docs/RandomMatrixAPI.md`: current RandomMatrix / Matrix Bernstein API index.
- `docs/TestPlan.md`: import and API regression policy.
- `docs/Automation.md`: automation and simp policy.
- `docs/Roadmap.md`: staged project roadmap.
- `docs/ModuleTree.md`: root-to-branch module layout and migration policy.
- `docs/BranchRegistry.md`: current branch map and promotion criteria.
- `docs/LeafPlan.md`: planned leaf modules for each branch.
- `docs/PhysicalMigrationPlan.md`: future physical migration order and rules.
- `docs/archive.md`: short archive index only; use git history for exact old
  stage logs.

## Promotion Policy

No module is promoted from experimental to stable without:

- API tests,
- documentation updates,
- `docs/Status.md` update,
- stable root import audit,
- confirmation that the module does not expose unresolved scaffolding as stable API.
