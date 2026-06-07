# MB-S4 Blackboard

## Current Target Theorem

```lean
theorem matrixExp_posSemidef_of_selfAdjoint {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real}
    (hA : IsSelfAdjointMatrix A) :
    Matrix.PosSemidef (matrixExp A)
```

## Allowed Branches

- `agent/mb-s4-survey`: survey only.
- `agent/mb-s4-basic`: basic self-adjoint API only.
- `agent/mb-s4-proof`: PSD bridge proof only.

## Allowed Files Per Branch

- `agent/mb-s4-survey`: may write only validation reports under
  `external/validation/matrix-bernstein-mainline-mb-s4/`.
- `agent/mb-s4-basic`: may edit only
  `HighDimProb/RandomMatrix/SelfAdjoint.lean`, focused tests, and focused judge
  files for the basic bridge.
- `agent/mb-s4-proof`: may edit only
  `HighDimProb/RandomMatrix/TraceExp.lean`, focused tests, and focused judge
  files for the PSD bridge.
- Manager/integrator: may update this blackboard, validation reports, and final
  status after checks.

## Forbidden Tasks

- No scalar concentration work.
- No full Matrix Bernstein proof.
- No Golden-Thompson or Lieb work.
- No `sorry`, `admit`, `axiom`, or `unsafe`.
- No theorem-like declarations with `:= True`.
- No fake theorem or placeholder proof.
- Do not confuse Mathlib `Matrix.PosSemidef` with HighDimProb `IsPSDMatrix`.
- No global docs/status edits before proof/test merge decision.

## Current Blockers

- No current focused blocker for the single PSD bridge.
- Full repository checks passed after the focused TraceExp source, test, and
  judge targets passed.
- If full checks fail outside MB-S4 TraceExp/SelfAdjoint surfaces, workers must
  write a blocker note under this validation directory and leave unrelated
  Lean files untouched.

## Latest Survey Result

- Mathlib has the direct bridge:
  `IsSelfAdjoint.exp_nonneg` proves `0 <= NormedSpace.exp A` under the CFC/order
  instances.
- `Mathlib.Analysis.Matrix.Order` provides the matrix order bridge
  `Matrix.LE.le.posSemidef` and `Matrix.nonneg_iff_posSemidef`.
- `Mathlib.Analysis.Normed.Algebra.MatrixExponential` already provides
  `Matrix.IsHermitian.exp` for the existing basic self-adjoint bridge.
- The standalone proof checked with imports:
  `Mathlib.Analysis.Normed.Algebra.MatrixExponential`,
  `Mathlib.Analysis.Matrix.Order`, and
  `Mathlib.Analysis.SpecialFunctions.ContinuousFunctionalCalculus.ExpLog.Basic`.

## Latest Proof Result

The concrete HighDimProb theorem is now present in
`HighDimProb/RandomMatrix/TraceExp.lean`:

```lean
open scoped MatrixOrder
open scoped Matrix.Norms.Operator

theorem matrixExp_posSemidef_of_selfAdjoint {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real}
    (hA : IsSelfAdjointMatrix A) :
    Matrix.PosSemidef (matrixExp A) := by
  exact Matrix.nonneg_iff_posSemidef.mp (by
    simpa [matrixExp] using IsSelfAdjoint.exp_nonneg hA.isSelfAdjoint)
```

Focused checks passed:

- `lake build HighDimProb.RandomMatrix.TraceExp`
- `lake build HighDimProbTest.RandomMatrixTraceExpAPI`
- `lake build HighDimProbJudge.RandomMatrix.TraceExpUse`

Earlier `square` fallback API checks are out of scope for MB-S4 because the
single direct PSD bridge is proven; no worker should expose or depend on the
private square fallback.

## Merge Decision

- Survey result: accepted for merge into validation report.
- Basic bridge: already present as `isSelfAdjointMatrix_matrixExp`; no basic
  branch edits planned unless checks expose an API issue.
- Proof branch: accepted at focused-target level for
  `matrixExp_posSemidef_of_selfAdjoint`, plus trace nonnegativity bridge.
- Tests/judge: focused TraceExp API and judge targets pass.
- Full merge: accepted for MB-S4. Required checks passed:
  `lake build`, `lake test`, `lake build HighDimProbJudge`,
  `python scripts/judge_policy_check.py`, and `git diff --check` with CRLF
  normalization warnings only.

## Worker Dispatch

- `agent/mb-s4-survey`: no further action unless asked to audit
  `mathlib_survey.md` against current Mathlib names.
- `agent/mb-s4-basic`: no source edits unless full checks expose a regression
  in `HighDimProb/RandomMatrix/SelfAdjoint.lean`.
- `agent/mb-s4-proof`: no further action needed unless assigned to review the
  final report. Do not broaden theorem scope and do not modify files outside
  the allowed list.
