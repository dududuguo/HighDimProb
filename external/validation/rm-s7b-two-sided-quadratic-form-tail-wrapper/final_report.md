# RM-S7B Final Report

Status: DONE

Working directory:

```text
C:\Users\11388\reserach\HighDimProb
```

## Scope

Added the smallest available bridge for reusing the optimized one-sided
quadratic-form Matrix Bernstein theorem on both `A` and pointwise `-A`.

## Declarations

Added:

- `quadraticFormLowerTailEvent_subset_quadraticFormUpperTailEvent_neg`
- `matrixBernsteinTwoSidedQuadraticFormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives`

Reused:

- `twoSidedQuadraticFormTailEvent`
- `quadraticFormUpperTailEvent`
- `quadraticFormLowerTailEvent`
- `randomMatrixSum`
- `matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives`
- `measure_union_le`

## Explicit Sign Assumptions

Variance-proxy, radius, integrability, independence, CFC, and Tropp primitive
assumptions remain explicit for both the original family and the pointwise
negated family.

## Command Status

- `lake env lean external/validation/rm-s7b-two-sided-quadratic-form-tail-wrapper/RM_S7B_TwoSidedQuadraticFormTailProbe.lean`: exit 0.
- `lake build HighDimProb.RandomMatrix.Spectral HighDimProb.RandomMatrix.ConcentrationStatements`: exit 0.
- `lake env lean HighDimProbTest/RandomMatrixSpectralAPI.lean`: exit 0.
- `lake env lean HighDimProbTest/RandomMatrixConcentrationAPI.lean`: exit 0.
- `lake env lean HighDimProbJudge/RandomMatrix/SpectralUse.lean`: exit 0.
- `lake env lean HighDimProbJudge/RandomMatrix/MatrixBernsteinUse.lean`: exit 0.
- `lake env lean HighDimProbJudge/RandomMatrix/StatementUse.lean`: exit 0.
- `lake build`: exit 0.
- `lake test`: exit 0.
- `lake build HighDimProbJudge`: exit 0.
- `python scripts/judge_policy_check.py`: exit 0.
- `git diff --check`: exit 0; warning only for pre-existing
  `docs/visualizations/lake_import_graph.html` CRLF normalization.
- `rg "sorry|admit|axiom|unsafe" HighDimProb HighDimProbTest HighDimProbJudge`: no matches.
- `rg ":= True" HighDimProb HighDimProbTest HighDimProbJudge docs`: no matches.

## Docs Updated

- `docs/Status.md`
- `docs/TermMap.md`
- `docs/TestPlan.md`

## FSM State Log

- `READY -> ACTIVE`: read mandatory governance docs, FSM docs, prior RM-S7/RM-S7A
  artifacts, and source references.
- `ACTIVE -> IMPLEMENTED`: added minimal event bridge and conditional two-sided
  quadratic-form wrapper.
- `IMPLEMENTED -> VALIDATING`: updated tests, judge checks, docs, and validation
  artifacts.
- `VALIDATING -> COMPLETE`: all required validation commands passed.

## Unrelated Dirty Files

- `docs/visualizations/lake_import_graph.html` was already dirty and was not
  edited for RM-S7B.

## Blockers

None for RM-S7B. The theorem remains conditional because the current API still
requires sign-specific variance-proxy, integrability, independence, CFC, and
Tropp assumptions.

## Next Safe Task

`RM-S7C-self-adjoint-operator-norm-tail-bridge`
