# RM-S7A Lambda-Max Tail Bridge Final Report

Status: `DONE`

Classification: `PROVED_LAMBDA_MAX_ORDERED_TAIL_BRIDGE`

## Theorem Proved

- `lambdaMaxOrderedUpperTailEvent_subset_quadraticFormUpperTailEvent`

The bridge reduces `lambdaMaxOrderedUpperTailEvent A hA t` to
`quadraticFormUpperTailEvent A t` for random matrices indexed by
`Fin (n + 1)`, using only the existing pointwise self-adjointness witness
`hA`.

## APIs Reused

- HighDimProb: `lambdaMaxOrdered`, `lambdaMaxOrderedUpperTailEvent`,
  `quadraticFormUpperTailEvent`, `matrixUpperBoundTailEvent`,
  `matrixQuadraticForm`, `isUnitVector_of_norm_toLp_eq_one`
- Mathlib-visible: `Matrix.IsHermitian.eigenvectorBasis`,
  `Matrix.IsHermitian.eigenvalues_eq`, `OrthonormalBasis.norm_eq_one`,
  `Fintype.equivOfCardEq`

## Remaining Missing Bridge

- `selfAdjointOperatorNormTailViaQuadraticFormStatement` remains typed only.
  This is the exact remaining spectral bridge for the operator-norm route:
  self-adjoint operator-norm upper tail to the two-sided quadratic-form event.

## Docs Updated

- `docs/Status.md`
- `docs/TermMap.md`
- `docs/TestPlan.md`

## FSM State Log

- `EXTRACTING`: Read governance, source references, and prior RM-S7 artifacts.
- `REUSE_SOURCE_VALIDATING`: Used codebase-memory first for HighDimProb API
  discovery; searched Mathlib-visible Hermitian eigenvector APIs.
- `TRANSLATING`: Added the minimal public bridge and validation probe.
- `COMPILING`: Focused module/test/judge/probe checks passed.
- `REVIEWING`: Verified direction, assumptions, and source fidelity.
- `VERIFYING`: Full validation commands ran in the required order.
- `INTEGRATING`: Required docs and validation artifacts updated.

## Command Status

- `lake build HighDimProb.RandomMatrix.Spectral`
  - exit status: 0
  - evidence: `Build completed successfully (3045 jobs).`
- `lake env lean HighDimProbTest/RandomMatrixSpectralAPI.lean`
  - exit status: 0
  - evidence: focused spectral API file elaborated.
- `lake env lean HighDimProbJudge/RandomMatrix/SpectralUse.lean`
  - exit status: 0
  - evidence: focused spectral judge file elaborated.
- `lake env lean external/validation/rm-s7a-lambda-max-tail-bridge/RM_S7A_LambdaMaxTailBridgeProbe.lean`
  - exit status: 0
  - evidence: validation probe checked the public bridge.
- `lake build`
  - exit status: 0
  - evidence: `Build completed successfully (2873 jobs).`
- `lake test`
  - exit status: 0
  - evidence: `Built HighDimProbTest`.
- `lake build HighDimProbJudge`
  - exit status: 0
  - evidence: `Build completed successfully (3654 jobs).`
- `python scripts/judge_policy_check.py`
  - exit status: 0
  - evidence: `judge policy check passed`.
- `git diff --check`
  - exit status: 0
  - evidence: whitespace check passed; Git repeated a line-ending warning for
    the unrelated dirty `docs/visualizations/lake_import_graph.html`.
- `rg "sorry|admit|axiom|unsafe" HighDimProb HighDimProbTest HighDimProbJudge`
  - exit status: 1
  - evidence: no matches. For `rg`, exit 1 means no matches were found.
- `rg ":= True" HighDimProb HighDimProbTest HighDimProbJudge docs`
  - exit status: 1
  - evidence: no matches. For `rg`, exit 1 means no matches were found.

## Repository State

- `pwd`: `C:\Users\11388\reserach\HighDimProb`
- Final `git status --short`:

```text
 M HighDimProb/RandomMatrix/Spectral.lean
 M HighDimProbJudge/RandomMatrix/SpectralUse.lean
 M HighDimProbTest/RandomMatrixSpectralAPI.lean
 M docs/Status.md
 M docs/TermMap.md
 M docs/TestPlan.md
 M docs/visualizations/lake_import_graph.html
```

- Validation artifact directory is ignored in this checkout:
  `!! external/validation/rm-s7a-lambda-max-tail-bridge/`.

## Files Changed

- `HighDimProb/RandomMatrix/Spectral.lean`
- `HighDimProbTest/RandomMatrixSpectralAPI.lean`
- `HighDimProbJudge/RandomMatrix/SpectralUse.lean`
- `docs/Status.md`
- `docs/TermMap.md`
- `docs/TestPlan.md`
- `external/validation/rm-s7a-lambda-max-tail-bridge/READ_ONCE_MANIFEST.md`
- `external/validation/rm-s7a-lambda-max-tail-bridge/RM_S7A_LambdaMaxTailBridgeProbe.lean`
- `external/validation/rm-s7a-lambda-max-tail-bridge/LAMBDA_MAX_TAIL_BRIDGE_REPORT.md`
- `external/validation/rm-s7a-lambda-max-tail-bridge/final_report.md`

## Unrelated Dirty Files

- `docs/visualizations/lake_import_graph.html` was dirty before this step and
  was not touched.

## Next Safe Task

`RM-S7B-self-adjoint-operator-norm-tail-bridge`
