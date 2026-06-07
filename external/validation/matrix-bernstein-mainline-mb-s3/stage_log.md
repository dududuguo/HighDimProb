# Matrix Bernstein Mainline MB-S3 Stage Log

## MB-S3.0 - Preflight

Status: complete.

Current trace-exp layer:

- `matrixExp`: wrapper around Mathlib `NormedSpace.exp`.
- `matrixTrace`: wrapper around `Matrix.trace`.
- `traceMatrixExp`: trace of `matrixExp`.
- `isSelfAdjointMatrix_matrixExp`: proved using `Matrix.IsHermitian.exp`.
- `traceExpMoment`: raw real expectation of `traceMatrixExp (theta • Y omega)`.
- `traceExpMomentLIntegral`: lintegral of `ENNReal.ofReal` of the same integrand.
- `traceMatrixExp_nonneg_of_selfAdjoint_statement`: typed target only before MB-S3.
- `traceExpMoment_nonneg_statement`: typed target only before MB-S3.
- `traceExpMomentLIntegral_eq_ofReal_statement`: typed target only before MB-S3.

Dependent Laplace layer:

- `matrixLaplaceTransformStatement`: real trace-exp typed target.
- `matrixLaplaceTransformLIntegralStatement`: lintegral typed target.
- `matrixChernoffFromTraceExpLIntegralStatement`: lintegral Chernoff typed target.
- `selfAdjointOperatorNormLaplaceLIntegralStatement`: lintegral two-sided typed target.

Initial blocker expected:

- Need Mathlib route from self-adjoint matrix exponential to nonnegative trace.

Gate result:

- `lake build`: passed.
- `lake test`: passed.
- `lake build HighDimProbJudge`: passed.
- `python scripts/judge_policy_check.py`: passed.
- `git diff --check`: passed with pre-existing CRLF normalization warnings.

## MB-S3.1 - Mathlib trace-exp positivity survey

Status: complete.

Findings:

- `Matrix.IsHermitian.exp` proves matrix exponential preserves Hermitian /
  self-adjoint structure.
- `Matrix.PosSemidef.trace_nonneg` proves trace nonnegativity for Mathlib PSD
  matrices.
- `MeasureTheory.ofReal_integral_eq_lintegral_ofReal` is the right bridge
  between real integrals and `lintegral` of `ENNReal.ofReal`.
- CFC has `IsSelfAdjoint.exp_nonneg`, but it requires a compatible
  `StarOrderedRing` order. That order is not available directly for
  `Matrix (Fin n) (Fin n) Real`.

Decision:

- Prove downstream bridge lemmas that use explicit PSD/nonnegativity
  hypotheses.
- Keep the self-adjoint `exp(A)` PSD bridge as a meaningful typed target.

## MB-S3.2 - Deterministic trace-exp nonnegativity

Status: partial.

Proved:

- `matrixTrace_nonneg_of_posSemidef`
- `traceMatrixExp_nonneg_of_matrixExp_posSemidef`

Typed target retained:

- `matrixExp_posSemidef_of_selfAdjoint_statement`
- `traceMatrixExp_nonneg_of_selfAdjoint_statement`

Blocker:

- Need a bridge from self-adjoint real matrices to Mathlib PSD of
  `NormedSpace.exp A`, likely through matrix-to-linear-map/CFC order or a
  direct Hermitian spectral theorem route.

## MB-S3.3 - Trace-exp moment nonnegativity

Status: partial.

Proved:

- `traceExpIntegrand`
- `traceExpMoment_nonneg_of_nonneg`
- `traceExpMomentLIntegral_nonneg`

Typed target retained:

- `traceExpMoment_nonneg_statement`, which still depends on the self-adjoint
  deterministic nonnegativity bridge.

## MB-S3.4 - Real expectation / lintegral bridge

Status: proven under explicit assumptions.

Proved:

- `traceExpMomentLIntegral_eq_ofReal_traceExpMoment`

Assumptions:

- `IntegrableRealRandomVariable P (traceExpIntegrand Y theta)`
- `forall omega, 0 <= traceExpIntegrand Y theta omega`

## MB-S3.5 - Matrix Laplace statement update

Status: statement layer unchanged, prerequisites strengthened.

The existing real and lintegral Laplace typed targets now have a proved
real/lintegral trace-exp bridge available under explicit assumptions. No matrix
Laplace theorem was attempted.

## MB-S3.6 - Judge / memory / FSM update

Status: complete.

- `HighDimProbTest/RandomMatrixTraceExpAPI.lean` now checks every new
  trace-exp declaration.
- `HighDimProbJudge/RandomMatrix/TraceExpUse.lean` now checks every new public
  trace-exp declaration and includes application-style examples for the
  moment nonnegativity and real/lintegral bridge.
- Validation artifacts record the Mathlib blocker and next proof stage.
