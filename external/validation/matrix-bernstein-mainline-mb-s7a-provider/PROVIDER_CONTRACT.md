# MB-S7A-provider Contract

## FSM Path
- QUEUED
- API_SURVEYING
- PROVIDER_CONTRACTING

## Existing HighDimProb Signatures
- SpectralUpperBound:
  `HighDimProb.SpectralUpperBound {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ) (L : ℝ) : Prop`
- RayleighUpperBound:
  `HighDimProb.RayleighUpperBound {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ) (L : ℝ) : Prop`
- lambdaMaxOrdered:
  `HighDimProb.lambdaMaxOrdered {n : ℕ} (A : Matrix (Fin (n + 1)) (Fin (n + 1)) ℝ) (hA : IsSelfAdjointMatrix A) : ℝ`
- lambdaMaxOrdered_eq_eigenvalues₀_zero:
  `HighDimProb.lambdaMaxOrdered_eq_eigenvalues₀_zero {n : ℕ} (A : Matrix (Fin (n + 1)) (Fin (n + 1)) ℝ) (hA : IsSelfAdjointMatrix A) : lambdaMaxOrdered A hA = Matrix.IsHermitian.eigenvalues₀ hA 0`
- lambdaMaxOrdered_is_greatest_eigenvalue:
  `HighDimProb.lambdaMaxOrdered_is_greatest_eigenvalue {n : ℕ} (A : Matrix (Fin (n + 1)) (Fin (n + 1)) ℝ) (hA : IsSelfAdjointMatrix A) : lambdaMaxOrdered_is_greatest_eigenvalue_statement A hA`
- LambdaMaxOrderedPSDUpperBound:
  `HighDimProb.LambdaMaxOrderedPSDUpperBound {n : ℕ} (A : Matrix (Fin (n + 1)) (Fin (n + 1)) ℝ) (hA : IsSelfAdjointMatrix A) : Prop`
- relevant generic bridge declarations:
  - `rayleighUpperBound_of_spectralUpperBound`
  - `quadraticFormUpperTailEvent_subset_scalarUpperTailEvent_of_rayleighUpperBound`
  - `quadraticFormUpperTailEvent_subset_matrixUpperBoundTailEvent_of_rayleighUpperBound`
  - `quadraticFormUpperTailEvent_subset_matrixUpperBoundTailEvent_of_spectralUpperBound`

## Mathlib APIs Found
- name: `Matrix.IsHermitian.eigenvalues₀`
  exact #check result: `Matrix.IsHermitian.eigenvalues₀ ... (hA : A.IsHermitian) : Fin (Fintype.card n) → ℝ`
  import: `Mathlib.Analysis.Matrix.Spectrum`
  role: ordered Hermitian eigenvalue endpoint.
  confidence: high
- name: `Matrix.IsHermitian.eigenvalues₀_antitone`
  exact #check result: `Matrix.IsHermitian.eigenvalues₀_antitone ... (hA : A.IsHermitian) : Antitone hA.eigenvalues₀`
  import: `Mathlib.Analysis.Matrix.Spectrum`
  role: proves every ordered eigenvalue is bounded by endpoint `0`.
  confidence: high
- name: `Matrix.IsHermitian.eigenvalues`
  exact #check result: `Matrix.IsHermitian.eigenvalues ... (hA : A.IsHermitian) : n → ℝ`
  import: `Mathlib.Analysis.Matrix.Spectrum`
  role: spectrum theorem is stated through this reindexed eigenvalue function.
  confidence: high
- name: `Matrix.IsHermitian.spectrum_real_eq_range_eigenvalues`
  exact #check result: `Matrix.IsHermitian.spectrum_real_eq_range_eigenvalues ... (hA : A.IsHermitian) : spectrum ℝ A = Set.range hA.eigenvalues`
  import: `Mathlib.Analysis.Matrix.Spectrum`
  role: reduces real spectral upper bound to all `hA.eigenvalues i`.
  confidence: high
- name: `le_algebraMap_of_spectrum_le`
  exact #check result: `le_algebraMap_of_spectrum_le ... (h : ∀ x ∈ spectrum R a, x ≤ r) (ha : p a := by cfc_tac) : a ≤ algebraMap R A r`
  import: `Mathlib.Analysis.CStarAlgebra.ContinuousFunctionalCalculus.Unital` via `Mathlib.Analysis.Matrix.Order`
  role: turns a spectral upper bound into a CFC/matrix-order upper bound.
  confidence: high
- name: `Matrix.le_iff`
  exact #check result: `Matrix.le_iff : A ≤ B ↔ (B - A).PosSemidef`
  import: `Mathlib.Analysis.Matrix.Order`
  role: converts matrix order to `SpectralUpperBound`.
  confidence: high
- name: `Algebra.algebraMap_eq_smul_one`
  exact #check result: `Algebra.algebraMap_eq_smul_one (r : R) : algebraMap R A r = r • 1`
  import: core algebra API
  role: simplifies `algebraMap ℝ Matrix λ` to `λ • 1`.
  confidence: high
- name: `Matrix.IsHermitian.isSelfAdjoint`
  exact #check result: `Matrix.IsHermitian.isSelfAdjoint : A.IsHermitian → IsSelfAdjoint A`
  import: matrix/CFC imports
  role: supplies the CFC predicate required by `le_algebraMap_of_spectrum_le`.
  confidence: high

## Proposed Provider Route
Choose exactly one:
- PROVIDER_DIRECT_READY

## Proposed Declarations
- name: `lambdaMaxOrdered_spectralUpperBound`
  kind: theorem
  exact proposed signature:
  ```lean
  theorem lambdaMaxOrdered_spectralUpperBound
      {n : Nat} {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
      (hA : IsSelfAdjointMatrix A) :
      SpectralUpperBound A (lambdaMaxOrdered A hA)
  ```
  APIs needed: `le_algebraMap_of_spectrum_le`, `spectrum_real_eq_range_eigenvalues`, `eigenvalues₀_antitone`, `Matrix.le_iff`, `Algebra.algebraMap_eq_smul_one`.
  source support: Mathlib matrix CFC order and ordered Hermitian eigenvalue API.
  proof feasibility: high; scratch proof compiles.
- name: `lambdaMaxOrderedPSDUpperBound`
  kind: theorem
  exact proposed signature:
  ```lean
  theorem lambdaMaxOrderedPSDUpperBound
      {n : Nat} {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
      (hA : IsSelfAdjointMatrix A) :
      LambdaMaxOrderedPSDUpperBound A hA
  ```
  APIs needed: `lambdaMaxOrdered_spectralUpperBound`.
  source support: `LambdaMaxOrderedPSDUpperBound` is definitionally the provider predicate.
  proof feasibility: high.
- name: `lambdaMaxOrdered_rayleighUpperBound`
  kind: theorem
  exact proposed signature:
  ```lean
  theorem lambdaMaxOrdered_rayleighUpperBound
      {n : Nat} {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
      (hA : IsSelfAdjointMatrix A) :
      matrixQuadraticForm_le_lambdaMaxOrdered_statement A hA
  ```
  APIs needed: `rayleighUpperBound_of_spectralUpperBound`, `lambdaMaxOrdered_spectralUpperBound`.
  source support: existing semantic bridge.
  proof feasibility: high.

## Recommended Next Agent
- Dispatch provider proof.

## Commands
- `lake env lean external/validation/matrix-bernstein-mainline-mb-s7a-provider/MB_S7A_ProviderProbe.lean`: passed.
- `lake build HighDimProb.RandomMatrix.Spectral`: passed.
- `python scripts/judge_policy_check.py`: passed.
- `git diff --check`: passed with existing CRLF normalization warnings.

## Exactly One Next Safe Task
- Prove `lambdaMaxOrdered_spectralUpperBound` in `HighDimProb/RandomMatrix/Spectral.lean`.
