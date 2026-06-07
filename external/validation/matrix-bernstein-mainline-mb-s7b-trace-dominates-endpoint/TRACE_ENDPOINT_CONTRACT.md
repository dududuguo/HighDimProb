# MB-S7B-trace-dominates-endpoint Contract

## FSM Path
- QUEUED
- SOURCE_READING
- IMPORT_AUDITING
- API_SURVEYING
- TRACE_ENDPOINT_CONTRACTING

## Placement Decision
- theorem can live in: `HighDimProb/RandomMatrix/Spectral.lean`
- reason: the proof only needs `lambdaMaxOrdered`, Hermitian eigenvalues, PSD eigenvalue nonnegativity, and `Matrix.trace`.
- cycle risks: `matrixTrace` is defined in `TraceExp.lean`, which already imports `Spectral.lean`; a `matrixTrace` theorem in `Spectral.lean` would create an import cycle. The provider stage can unfold `matrixTrace` through the pure `Matrix.trace` theorem.

## Existing HighDimProb Signatures
- lambdaMaxOrdered:
  `HighDimProb.lambdaMaxOrdered {n : ℕ} (A : Matrix (Fin (n + 1)) (Fin (n + 1)) ℝ) (hA : IsSelfAdjointMatrix A) : ℝ`
- lambdaMaxOrdered_eq_eigenvalues₀_zero:
  `HighDimProb.lambdaMaxOrdered_eq_eigenvalues₀_zero {n : ℕ} (A : Matrix (Fin (n + 1)) (Fin (n + 1)) ℝ) (hA : IsSelfAdjointMatrix A) : lambdaMaxOrdered A hA = Matrix.IsHermitian.eigenvalues₀ hA 0`
- lambdaMaxOrdered_is_greatest_eigenvalue:
  `HighDimProb.lambdaMaxOrdered_is_greatest_eigenvalue {n : ℕ} (A : Matrix (Fin (n + 1)) (Fin (n + 1)) ℝ) (hA : IsSelfAdjointMatrix A) : lambdaMaxOrdered_is_greatest_eigenvalue_statement A hA`
- matrixTrace:
  `HighDimProb.matrixTrace {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ) : ℝ`
- Matrix.trace wrapper:
  `HighDimProb.matrixTrace_apply {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ) : matrixTrace A = A.trace`
- relevant declarations:
  `matrixTrace_nonneg_of_posSemidef`, `matrixExp_posSemidef_of_selfAdjoint`, `traceMatrixExp`, `lambdaMaxOrdered_matrixExp`.

## Mathlib APIs Found
- name: `Matrix.IsHermitian.trace_eq_sum_eigenvalues`
  exact `#check` result: `Matrix.IsHermitian.trace_eq_sum_eigenvalues ... (hA : A.IsHermitian) : A.trace = ∑ i, ↑(hA.eigenvalues i)`
  import: `Mathlib.Analysis.Matrix.Spectrum`
  role: rewrites trace as the finite sum of Hermitian eigenvalues.
  confidence: high
- name: `Matrix.PosSemidef.eigenvalues_nonneg`
  exact `#check` result: `Matrix.PosSemidef.eigenvalues_nonneg ... (hA : A.PosSemidef) (i : n) : 0 ≤ ... .eigenvalues i`
  import: `Mathlib.Analysis.Matrix.Spectrum`
  role: gives nonnegativity of every Hermitian eigenvalue under PSD.
  confidence: high
- name: `Matrix.IsHermitian.eigenvalues`
  exact `#check` result: `Matrix.IsHermitian.eigenvalues ... (hA : A.IsHermitian) : n → ℝ`
  import: `Mathlib.Analysis.Matrix.Spectrum`
  role: unordered/reindexed eigenvalue family used by trace sum.
  confidence: high
- name: `Matrix.IsHermitian.eigenvalues₀`
  exact `#check` result: `Matrix.IsHermitian.eigenvalues₀ ... (hA : A.IsHermitian) : Fin (Fintype.card n) → ℝ`
  import: `Mathlib.Analysis.Matrix.Spectrum`
  role: ordered eigenvalue family used by `lambdaMaxOrdered`.
  confidence: high
- name: `Fintype.equivOfCardEq`
  exact `#check` result: `Fintype.equivOfCardEq ... (h : Fintype.card α = Fintype.card β) : α ≃ β`
  import: transitive Mathlib import
  role: bridge from ordered eigenvalue endpoint to the trace-sum eigenvalue indexing.
  confidence: high
- name: `Finset.single_le_sum`
  exact `#check` result: `Finset.single_le_sum ... (hf : ∀ i ∈ s, 0 ≤ f i) {a : ι} (h : a ∈ s) : f a ≤ ∑ x ∈ s, f x`
  import: transitive Mathlib import
  role: bounds one nonnegative eigenvalue by the full eigenvalue sum.
  confidence: high

## Proposed Theorem
- name: `lambdaMaxOrdered_le_trace_of_posSemidef`
- exact proposed signature:
  ```lean
  theorem lambdaMaxOrdered_le_trace_of_posSemidef
      {n : Nat} {B : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
      (hB : IsSelfAdjointMatrix B)
      (hPSD : Matrix.PosSemidef B) :
      lambdaMaxOrdered B hB <= Matrix.trace B := by
    ...
  ```
- source support: existing `lambdaMaxOrdered` definition and Mathlib Hermitian trace/eigenvalue APIs.
- APIs needed: `trace_eq_sum_eigenvalues`, `eigenvalues_nonneg`, `single_le_sum`, `Fintype.equivOfCardEq`.
- proof feasibility: directly proved in scratch by a sum split.

## Route Classification
- TRACE_ENDPOINT_SUM_SPLIT_REQUIRED

## Recommended Next Agent
- Dispatch trace endpoint proof agent

## Commands
- `lake env lean external/validation/matrix-bernstein-mainline-mb-s7b-trace-dominates-endpoint/MB_S7B_TraceEndpointProbe.lean`: passed.
- `lake build HighDimProb.RandomMatrix.Spectral`: passed.
- `lake build HighDimProb.RandomMatrix.TraceExp`: passed.
- `python scripts/judge_policy_check.py`: passed.
- `git diff --check`: passed with pre-existing CRLF normalization warnings.

## Exactly One Next Safe Task
- Prove `lambdaMaxOrdered_le_trace_of_posSemidef` in `HighDimProb/RandomMatrix/Spectral.lean`.

