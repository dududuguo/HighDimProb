# RM-S7 Operator-Norm Tail Contract Final Report

Status: `DONE_WITH_CONCERNS`

Classification: `SPECTRAL_RAYLEIGH_BRIDGE_REQUIRED`

## APIs Checked

- `matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives`
- `sampleCovariance_quadraticForm_tail_optimized_under_explicit_variance_proxy`
- `matrixBernsteinTraceMGFWithBernsteinCoeff_under_primitives`
- `quadraticFormUpperTailEvent`
- `quadraticFormLowerTailEvent`
- `twoSidedQuadraticFormTailEvent`
- `lambdaMax`
- `lambdaMaxOrdered`
- `lambdaMaxUpperTailEvent`
- `lambdaMaxOrderedUpperTailEvent`
- `lambdaMaxOrdered_spectralUpperBound`
- `lambdaMaxOrderedPSDUpperBound`
- `lambdaMaxOrdered_rayleighUpperBound`
- `matrixQuadraticForm_le_lambdaMax_statement`
- `matrixQuadraticForm_le_lambdaMaxOrdered_statement`
- `quadraticFormUpperTailEvent_subset_lambdaMaxUpperTailEvent_of_matrixQuadraticForm_le_lambdaMax`
- `quadraticFormUpperTailEvent_subset_lambdaMaxOrderedUpperTailEvent_of_matrixQuadraticForm_le_lambdaMaxOrdered`
- `SelfAdjointOperatorNormTailEvent`
- `selfAdjointOperatorNormTailViaQuadraticFormStatement`
- `operatorNorm_eq_max_abs_lambda_statement`

## Contract Finding

The existing optimized theorem bounds the explicit unit-sphere
quadratic-form upper-tail event. The repository has a proved ordered endpoint
Rayleigh upper-bound provider, but it does not yet have the reverse event
bridge that puts the lambda-max upper-tail event inside the explicit
quadratic-form upper-tail event.

Operator-norm reduction is also not yet proved. It is recorded by the typed
target `selfAdjointOperatorNormTailViaQuadraticFormStatement`.

Finite nets are not the smallest missing step for this route.

## Candidate Next Theorem

```lean
theorem lambdaMaxOrderedUpperTailEvent_subset_quadraticFormUpperTailEvent
    {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (A : RandomMatrix Omega (n + 1) (n + 1))
    (t : Real)
    (hA : forall omega, IsSelfAdjointMatrix (A omega)) :
    lambdaMaxOrderedUpperTailEvent A hA t <=
      quadraticFormUpperTailEvent A t := by
  ...
```

## Blockers

- Reverse lambda-max to quadratic-form event subset is not present.
- Operator-norm to two-sided quadratic-form event subset is typed only.
- Legacy `operatorNorm_eq_max_abs_lambda_statement` is typed only.

## FSM State Log

- `EXTRACTING`: Read source references and isolated the Matrix Bernstein
  lambda-max/operator-norm route.
- `REUSE_SOURCE_VALIDATING`: Searched current HighDimProb API, tests, judge
  files, docs, and Mathlib-visible bridge names.
- `TRANSLATING`: Created validation-only probe and contract artifacts.
- `COMPILING`: Focused Lean probe and relevant module builds passed.
- `REVIEWING`: Contract reviewed against source route and current API
  directionality.
- `VERIFYING`: Required build, test, judge, policy, diff, and token audits ran.
- `INTEGRATING`: Integrated only validation artifacts under the allowed
  external validation path.

## Command Status

- `lake env lean external/validation/rm-s7-operator-norm-tail-contract/RM_S7_OperatorNormTailProbe.lean`
  - exit status: 0
  - evidence: probe printed checked signatures and completed without errors.
- `lake build HighDimProb.RandomMatrix.Spectral`
  - exit status: 0
  - evidence: `Build completed successfully (3045 jobs).`
- `lake build HighDimProb.RandomMatrix.Laplace`
  - exit status: 0
  - evidence: `Build completed successfully (3050 jobs).`
- `lake build HighDimProb.RandomMatrix.ConcentrationStatements`
  - exit status: 0
  - evidence: `Build completed successfully (3061 jobs).`
- `lake build`
  - exit status: 0
  - evidence: `Build completed successfully (2873 jobs).`
- `lake test`
  - exit status: 0
  - evidence: command completed successfully after replaying/building tests.
- `lake build HighDimProbJudge`
  - exit status: 0
  - evidence: `Build completed successfully (3654 jobs).`
- `python scripts/judge_policy_check.py`
  - exit status: 0
  - evidence: `judge policy check passed`.
- `git diff --check`
  - exit status: 0
  - evidence: whitespace check passed; Git reported a line-ending warning for
    pre-existing `docs/visualizations/lake_import_graph.html`.
- `rg "sorry|admit|axiom|unsafe" HighDimProb HighDimProbTest HighDimProbJudge`
  - exit status: 1
  - evidence: no matches. For `rg`, exit 1 means no matches were found.
- `rg ":= True" HighDimProb HighDimProbTest HighDimProbJudge docs`
  - exit status: 1
  - evidence: no matches. For `rg`, exit 1 means no matches were found.

## Repository State

- `pwd`: `C:\Users\11388\reserach\HighDimProb`
- Final `pwd`: `C:\Users\11388\reserach\HighDimProb`
- Final `git status --short`: ` M docs/visualizations/lake_import_graph.html`
- Unrelated dirty file: `docs/visualizations/lake_import_graph.html`
- Validation artifact directory is ignored in this checkout:
  `git status --short --ignored external/validation/rm-s7-operator-norm-tail-contract`
  reports `!! external/validation/rm-s7-operator-norm-tail-contract/`.

## Files Changed

- `external/validation/rm-s7-operator-norm-tail-contract/READ_ONCE_MANIFEST.md`
- `external/validation/rm-s7-operator-norm-tail-contract/RM_S7_OperatorNormTailProbe.lean`
- `external/validation/rm-s7-operator-norm-tail-contract/OPERATOR_NORM_TAIL_CONTRACT.md`
- `external/validation/rm-s7-operator-norm-tail-contract/final_report.md`

## Next Safe Task

Prove the ordered lambda-max reverse event bridge into the existing explicit
unit-vector quadratic-form upper-tail event.
