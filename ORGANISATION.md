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
- `HighDimProb/Vector.lean`: finite-dimensional random-vector infrastructure.
- `HighDimProb/Geometry.lean`: nets, metric entropy, covering/packing statements, and Gaussian-width vocabulary.
- `HighDimProb/RandomMatrix.lean`: random-matrix aggregate over its subdirectory.
- `HighDimProb/Process.lean`: random-process and empirical-process vocabulary.
- `HighDimProb/Statements.lean`: typed theorem statement specifications and theorem-atlas bridge modules.
- `HighDimProb/Tactic.lean`: lightweight project automation.
- `HighDimProb/Experimental.lean`: experimental aggregate over v0.2+ branches.

Logical branch aggregates are introduced before any physical file migration. Existing leaf files should move only in a focused migration stage after APIs stabilize.

## Experimental Random Matrix Structure

- `HighDimProb/RandomMatrix.lean`: aggregate module.
- `HighDimProb/RandomMatrix/Basic.lean`: random matrix representation and entries.
- `HighDimProb/RandomMatrix/RowsCols.lean`: row and column random-vector views.
- `HighDimProb/RandomMatrix/Action.lean`: deterministic matrix-vector actions.
- `HighDimProb/RandomMatrix/Norms.lean`: Frobenius and entrywise norm vocabulary.
- `HighDimProb/RandomMatrix/Assumptions.lean`: entrywise and rowwise assumption predicates.
- `HighDimProb/RandomMatrix/SampleCovariance.lean`: Gram and sample covariance vocabulary.
- `HighDimProb/RandomMatrix/QuadraticForm.lean`: quadratic and bilinear forms.
- `HighDimProb/RandomMatrix/OperatorNorm.lean`: experimental L2 operator-norm wrapper.

## Tests

Tests live under `HighDimProbTest/`.

- Stable modules require public import or focused stable API tests.
- Experimental modules require experimental import or focused experimental API tests.
- Proof pilots require proof-focused `#check` test files.

## Documentation

- `docs/Status.md`: current stage and next safe task.
- `docs/Workflow.md`: mandatory contribution workflow.
- `docs/StageChecklist.md`: per-stage checklist.
- `docs/TermMap.md`: concept-to-Lean map.
- `docs/TheoremAtlas.md`: theorem/status registry.
- `docs/TestPlan.md`: import and API regression policy.
- `docs/Automation.md`: automation and simp policy.
- `docs/Roadmap.md`: staged project roadmap.
- `docs/ModuleTree.md`: root-to-branch module layout and migration policy.

## Promotion Policy

No module is promoted from experimental to stable without:

- API tests,
- documentation updates,
- `docs/Status.md` update,
- stable root import audit,
- confirmation that the module does not expose unresolved scaffolding as stable API.
