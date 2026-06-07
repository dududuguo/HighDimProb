# MB-S7.1 API Contract

## FSM Path
- `QUEUED -> API_SURVEYING -> API_CONTRACTING -> VERIFYING -> API_READY`

## Source Inputs
- `SOURCE_DIGEST.md`: MB-S7.0 identifies the direct dominance step as source-backed by the matrix Bernstein Laplace proof spine, Rayleigh quotient control, and spectral trace-exponential dominance.
- `source_lookup_log.md`: source lookup focused on Vershynin-style matrix Bernstein MGF reduction and random matrix spectral facts.
- external source statements used:
  - `external/theory-roadmap/sources/High-Dimensional_Probability.md`: matrix Bernstein proof reduces the largest-eigenvalue tail through trace exponential.
  - `external/theory-roadmap/sources/High-Dimensional_Probability.md`: self-adjoint operator norm / quadratic form and eigenvalue facts.
  - `external/theory-roadmap/sources/Topics_in_Random_Matrix_Theory.md`: Rayleigh formula, spectral theorem, and Courant-Fischer/min-max references.
- source statements not yet formalizable:
  - A direct HighDimProb theorem connecting explicit `matrixQuadraticForm` and `IsUnitVector` to Mathlib's Rayleigh/eigenvalue APIs.
  - A direct HighDimProb theorem proving `traceMatrixExp (theta • A)` dominates `Real.exp (theta * matrixQuadraticForm A x)` for unit `x`, self-adjoint `A`, and `0 <= theta`.

## Existing Lean Signatures

### Laplace
- `TraceExpDominatesQuadraticFormUpperTail.{u_1} {Omega : Type u_1} [MeasurableSpace Omega] {n : ℕ} (Y : RandomMatrix Omega n n) (theta t : ℝ) : Prop`
- `traceExpDominatesQuadraticFormUpperTailStatement.{u_1} {Omega : Type u_1} [MeasurableSpace Omega] {P : Measure Omega} {n : ℕ} (Y : RandomMatrix Omega n n) (theta t : ℝ) : Prop`
- `quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_traceExpDominates.{u_1} {Omega : Type u_1} [MeasurableSpace Omega] {n : ℕ} (Y : RandomMatrix Omega n n) (theta t : ℝ) (hDom : TraceExpDominatesQuadraticFormUpperTail Y theta t) : quadraticFormUpperTailEvent Y t ⊆ traceExpThresholdEvent Y theta t`
- `matrixLaplaceTransformLIntegralDiv_of_traceExpDominatesQuadraticFormUpperTail.{u_1} {Omega : Type u_1} [MeasurableSpace Omega] {P : Measure Omega} {n : ℕ} (Y : RandomMatrix Omega n n) (theta t : ℝ) (hMeas : AEMeasurable (fun omega => ENNReal.ofReal (traceExpIntegrand Y theta omega)) P) (hDom : TraceExpDominatesQuadraticFormUpperTail Y theta t) : P (quadraticFormUpperTailEvent Y t) ≤ matrixLaplaceRHSLIntegralDiv P Y theta t`
- `matrixLaplaceTransformLIntegral_of_traceExpDominatesQuadraticFormUpperTail.{u_1} {Omega : Type u_1} [MeasurableSpace Omega] {P : Measure Omega} {n : ℕ} (Y : RandomMatrix Omega n n) (theta t : ℝ) (hMeas : AEMeasurable (fun omega => ENNReal.ofReal (traceExpIntegrand Y theta omega)) P) (hDom : TraceExpDominatesQuadraticFormUpperTail Y theta t) : P (quadraticFormUpperTailEvent Y t) ≤ matrixLaplaceRHSLIntegral P Y theta t`
- `traceExpThresholdEvent.{u_1} {Omega : Type u_1} [MeasurableSpace Omega] {n : ℕ} (Y : RandomMatrix Omega n n) (theta t : ℝ) : Set Omega`
- `matrixLaplaceRHSLIntegral.{u_1} {Omega : Type u_1} [MeasurableSpace Omega] {n : ℕ} (P : Measure Omega) (Y : RandomMatrix Omega n n) (theta t : ℝ) : ENNReal`
- `matrixLaplaceRHSLIntegralDiv.{u_1} {Omega : Type u_1} [MeasurableSpace Omega] {n : ℕ} (P : Measure Omega) (Y : RandomMatrix Omega n n) (theta t : ℝ) : ENNReal`

### Spectral
- `quadraticFormUpperTailEvent.{u_1} {Omega : Type u_1} [MeasurableSpace Omega] {n : ℕ} (A : RandomMatrix Omega n n) (t : ℝ) : Set Omega`
- `matrixQuadraticForm {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ) (x : Fin n → ℝ) : ℝ`
- `IsUnitVector {n : ℕ} (x : Fin n → ℝ) : Prop`
- `lambdaMax {n : ℕ} (A : Matrix (Fin (n + 1)) (Fin (n + 1)) ℝ) (hA : IsSelfAdjointMatrix A) : ℝ`
- `lambdaMin {n : ℕ} (A : Matrix (Fin (n + 1)) (Fin (n + 1)) ℝ) (hA : IsSelfAdjointMatrix A) : ℝ`
- `LambdaMaxBound {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ) (t : ℝ) : Prop`
- `lambdaMax_is_greatest_eigenvalue_statement {n : ℕ} (A : Matrix (Fin (n + 1)) (Fin (n + 1)) ℝ) (hA : IsSelfAdjointMatrix A) : Prop`
- `lambdaMax_le_iff_quadraticForm_le_statement {n : ℕ} (A : Matrix (Fin (n + 1)) (Fin (n + 1)) ℝ) (hA : IsSelfAdjointMatrix A) (t : ℝ) : Prop`
- `operatorNorm_eq_max_abs_lambda_statement {n : ℕ} (A : Matrix (Fin (n + 1)) (Fin (n + 1)) ℝ) (hA : IsSelfAdjointMatrix A) : Prop`

### TraceExp
- `matrixExp_posSemidef_of_selfAdjoint {n : ℕ} {A : Matrix (Fin n) (Fin n) ℝ} (hA : IsSelfAdjointMatrix A) : (matrixExp A).PosSemidef`
- `traceMatrixExp_nonneg_of_selfAdjoint {n : ℕ} {A : Matrix (Fin n) (Fin n) ℝ} (hA : IsSelfAdjointMatrix A) : 0 ≤ traceMatrixExp A`
- `traceExpIntegrand.{u_1} {Omega : Type u_1} [MeasurableSpace Omega] {n : ℕ} (Y : RandomMatrix Omega n n) (theta : ℝ) : RealRandomVariable Omega`
- `traceExpIntegrand_nonneg_of_randomSelfAdjoint.{u_1} {Omega : Type u_1} [MeasurableSpace Omega] {P : Measure Omega} {n : ℕ} {Y : RandomMatrix Omega n n} (theta : ℝ) (hY : RandomSelfAdjointMatrix P Y) (omega : Omega) : 0 ≤ traceExpIntegrand Y theta omega`
- `traceExpMoment_nonneg_of_randomSelfAdjoint.{u_1} {Omega : Type u_1} [MeasurableSpace Omega] {P : Measure Omega} {n : ℕ} (Y : RandomMatrix Omega n n) (theta : ℝ) (hY : RandomSelfAdjointMatrix P Y) : 0 ≤ traceExpMoment P Y theta`

### SelfAdjoint
- `IsSelfAdjointMatrix {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ) : Prop`
- `RandomSelfAdjointMatrix.{u_1} {Omega : Type u_1} [MeasurableSpace Omega] {n : ℕ} (_P : Measure Omega) (A : RandomMatrix Omega n n) : Prop`
- `isSelfAdjointMatrix_smul {n : ℕ} (c : ℝ) {A : Matrix (Fin n) (Fin n) ℝ} (hA : IsSelfAdjointMatrix A) : IsSelfAdjointMatrix (c • A)`
- `randomSelfAdjointMatrix_smul.{u_1} {Omega : Type u_1} [MeasurableSpace Omega] {P : Measure Omega} {n : ℕ} (c : ℝ) {A : RandomMatrix Omega n n} (hA : RandomSelfAdjointMatrix P A) : RandomSelfAdjointMatrix P fun omega => c • A omega`

## Mathlib APIs Found
- name: `ContinuousLinearMap.rayleighQuotient`
  - exact `#check` result: `{𝕜 : Type u_1} [RCLike 𝕜] {E : Type u_2} [NormedAddCommGroup E] [InnerProductSpace 𝕜 E] (T : E →L[𝕜] E) (x : E) : ℝ`
  - file/import needed: `Mathlib.Analysis.InnerProductSpace.Rayleigh`
  - role in proof route: possible Rayleigh bridge for self-adjoint operators.
  - confidence: medium
- name: `ContinuousLinearMap.iSup_rayleigh_eq_iSup_rayleigh_sphere`
  - exact `#check` result: `{𝕜 : Type u_1} [RCLike 𝕜] {E : Type u_2} [NormedAddCommGroup E] [InnerProductSpace 𝕜 E] (T : E →L[𝕜] E) {r : ℝ} (hr : 0 < r) : ⨆ x, T.rayleighQuotient ↑x = ⨆ x, T.rayleighQuotient ↑x`
  - file/import needed: `Mathlib.Analysis.InnerProductSpace.Rayleigh`
  - role in proof route: sphere normalization for Rayleigh quotients.
  - confidence: medium
- name: `ContinuousLinearMap.norm_eq_iSup_rayleighQuotient`
  - exact `#check` result: `{𝕜 : Type u_1} [RCLike 𝕜] {E : Type u_2} [NormedAddCommGroup E] [InnerProductSpace 𝕜 E] (T : E →L[𝕜] E) (hT : (↑T).IsSymmetric) : ‖T‖ = ⨆ x, |T.rayleighQuotient x|`
  - file/import needed: `Mathlib.Analysis.InnerProductSpace.Rayleigh`
  - role in proof route: possible operator-norm/Rayleigh bridge, not directly top-eigenvalue dominance.
  - confidence: medium
- name: `Matrix.IsHermitian.trace_eq_sum_eigenvalues`
  - exact `#check` result: `{𝕜 : Type u_1} [RCLike 𝕜] {n : Type u_2} [Fintype n] {A : Matrix n n 𝕜} [DecidableEq n] (hA : A.IsHermitian) : A.trace = ∑ i, ↑(hA.eigenvalues i)`
  - file/import needed: `Mathlib.Analysis.Matrix.Spectrum`
  - role in proof route: trace/eigenvalue expansion for Hermitian matrices.
  - confidence: high
- name: `Matrix.IsHermitian.posSemidef_iff_eigenvalues_nonneg`
  - exact `#check` result: `{n : Type u_2} {𝕜 : Type u_3} [Fintype n] [RCLike 𝕜] {A : Matrix n n 𝕜} [DecidableEq n] (hA : A.IsHermitian) : A.PosSemidef ↔ 0 ≤ hA.eigenvalues`
  - file/import needed: `Mathlib.Analysis.Matrix.PosDef`
  - role in proof route: PSD/eigenvalue nonnegativity bridge.
  - confidence: high
- name: `Matrix.PosSemidef.eigenvalues_nonneg`
  - exact `#check` result: `{n : Type u_2} {𝕜 : Type u_3} [Fintype n] [RCLike 𝕜] {A : Matrix n n 𝕜} [DecidableEq n] (hA : A.PosSemidef) (i : n) : 0 ≤ hA.1.eigenvalues i`
  - file/import needed: `Mathlib.Analysis.Matrix.PosDef`
  - role in proof route: eigenvalue nonnegativity for `matrixExp A` after MB-S4 PSD theorem.
  - confidence: high
- name: `Matrix.PosSemidef.trace_nonneg`
  - exact `#check` result: `{n : Type u_2} {R : Type u_3} [Ring R] [PartialOrder R] [StarRing R] [Fintype n] [AddLeftMono R] {A : Matrix n n R} (hA : A.PosSemidef) : 0 ≤ A.trace`
  - file/import needed: `Mathlib.Analysis.Matrix.Order` or `Mathlib.LinearAlgebra.Matrix.PosDef`
  - role in proof route: nonnegativity of trace for PSD matrices.
  - confidence: high
- name: `Matrix.nonneg_iff_posSemidef`
  - exact `#check` result: `{𝕜 : Type u_1} {n : Type u_2} [RCLike 𝕜] {A : Matrix n n 𝕜} : 0 ≤ A ↔ A.PosSemidef`
  - file/import needed: `Mathlib.Analysis.Matrix.Order`
  - role in proof route: convert Loewner-order nonnegativity to `Matrix.PosSemidef`.
  - confidence: high
- name: `IsSelfAdjoint.exp_nonneg`
  - exact `#check` result: `{A : Type u_1} [NormedRing A] [StarRing A] [NormedAlgebra ℝ A] [ContinuousFunctionalCalculus ℝ A IsSelfAdjoint] [PartialOrder A] [StarOrderedRing A] {a : A} (ha : IsSelfAdjoint a) : 0 ≤ NormedSpace.exp a`
  - file/import needed: `Mathlib.Analysis.SpecialFunctions.ContinuousFunctionalCalculus.ExpLog.Basic`
  - role in proof route: already used locally to prove `matrixExp_posSemidef_of_selfAdjoint`.
  - confidence: high

## HighDimProb APIs Found
- name: `TraceExpDominatesQuadraticFormUpperTail`
  - exact signature: `{Omega} [MeasurableSpace Omega] {n} (Y : RandomMatrix Omega n n) (theta t : ℝ) : Prop`
  - role in proof route: target wrapper for the MB-S6 explicit dominance hypothesis.
  - status: def
- name: `quadraticFormUpperTailEvent`
  - exact signature: `{Omega} [MeasurableSpace Omega] {n} (A : RandomMatrix Omega n n) (t : ℝ) : Set Omega`
  - role in proof route: source event to be sent into `traceExpThresholdEvent`.
  - status: def
- name: `traceExpThresholdEvent`
  - exact signature: `{Omega} [MeasurableSpace Omega] {n} (Y : RandomMatrix Omega n n) (theta t : ℝ) : Set Omega`
  - role in proof route: target event for trace-exponential threshold.
  - status: def
- name: `matrixExp_posSemidef_of_selfAdjoint`
  - exact signature: `{n} {A : Matrix (Fin n) (Fin n) ℝ} (hA : IsSelfAdjointMatrix A) : (matrixExp A).PosSemidef`
  - role in proof route: deterministic trace-exp positivity prerequisite.
  - status: theorem
- name: `traceMatrixExp_nonneg_of_selfAdjoint`
  - exact signature: `{n} {A : Matrix (Fin n) (Fin n) ℝ} (hA : IsSelfAdjointMatrix A) : 0 ≤ traceMatrixExp A`
  - role in proof route: nonnegativity only; not enough for dominance by itself.
  - status: theorem
- name: `lambdaMax_le_iff_quadraticForm_le_statement`
  - exact signature: `{n} (A : Matrix (Fin (n + 1)) (Fin (n + 1)) ℝ) (hA : IsSelfAdjointMatrix A) (t : ℝ) : Prop`
  - role in proof route: records the missing Rayleigh bridge.
  - status: typed statement
- name: `lambdaMax_is_greatest_eigenvalue_statement`
  - exact signature: `{n} (A : Matrix (Fin (n + 1)) (Fin (n + 1)) ℝ) (hA : IsSelfAdjointMatrix A) : Prop`
  - role in proof route: records the missing ordered-eigenvalue bridge.
  - status: typed statement

## Proposed Direct Dominance Theorem Signature

Primary candidate after spectral bridges:

```lean
theorem traceExpDominatesQuadraticFormUpperTail_of_randomSelfAdjoint
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {n : Nat} (Y : RandomMatrix Omega n n) (theta t : Real)
    (hY : RandomSelfAdjointMatrix P Y)
    (hTheta : 0 <= theta) :
    TraceExpDominatesQuadraticFormUpperTail Y theta t
```

Fallback candidate if the direct spectral dominance remains unavailable:

```lean
theorem traceExpDominatesQuadraticFormUpperTail_of_pointwise_traceExp_bound
    {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (Y : RandomMatrix Omega n n) (theta t : Real)
    (hPoint :
      forall omega x,
        IsUnitVector x ->
          t <= matrixQuadraticForm (Y omega) x ->
            ENNReal.ofReal (Real.exp (theta * t)) <=
              ENNReal.ofReal (traceExpIntegrand Y theta omega)) :
    TraceExpDominatesQuadraticFormUpperTail Y theta t
```

The fallback is directly aligned with the existing set-subset definition, but it exposes the hard spectral dominance as a pointwise assumption rather than hiding it.

## Required Bridge Lemmas

- name: `matrixQuadraticForm_le_lambdaMax_of_isSelfAdjoint`
  - proposed signature:
    ```lean
    theorem matrixQuadraticForm_le_lambdaMax_of_isSelfAdjoint
        {n : Nat} {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
        (hA : IsSelfAdjointMatrix A) (x : Fin (n + 1) -> Real)
        (hx : IsUnitVector x) :
        matrixQuadraticForm A x <= lambdaMax A hA
    ```
  - source support: Rayleigh quotient / min-max facts from MB-S7.0 source digest.
  - Mathlib/HighDimProb APIs needed: `ContinuousLinearMap.rayleighQuotient`, ordered Hermitian eigenvalues, conversion between `matrixQuadraticForm` and Mathlib Rayleigh quotient.
  - status: needs new bridge
- name: `traceMatrixExp_ge_exp_lambdaMax_of_selfAdjoint`
  - proposed signature:
    ```lean
    theorem traceMatrixExp_ge_exp_lambdaMax_of_selfAdjoint
        {n : Nat} {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
        (hA : IsSelfAdjointMatrix A) :
        Real.exp (lambdaMax A hA) <= traceMatrixExp A
    ```
  - source support: trace-exponential dominates top exponential eigenvalue in matrix Laplace proof.
  - Mathlib/HighDimProb APIs needed: `Matrix.IsHermitian.trace_eq_sum_eigenvalues`, `Matrix.PosSemidef.eigenvalues_nonneg`, spectral mapping for `matrixExp`, ordered eigenvalue bridge.
  - status: needs new bridge
- name: `traceExpIntegrand_ge_exp_theta_quadraticForm_of_selfAdjoint`
  - proposed signature:
    ```lean
    theorem traceExpIntegrand_ge_exp_theta_quadraticForm_of_selfAdjoint
        {n : Nat} {A : Matrix (Fin n) (Fin n) Real}
        (theta : Real) (hTheta : 0 <= theta)
        (hA : IsSelfAdjointMatrix A) (x : Fin n -> Real)
        (hx : IsUnitVector x) :
        Real.exp (theta * matrixQuadraticForm A x) <=
          traceMatrixExp (theta • A)
    ```
  - source support: combines Rayleigh with trace-exponential spectral dominance.
  - Mathlib/HighDimProb APIs needed: previous two bridges plus scalar monotonicity of `Real.exp`.
  - status: needs new bridge
- name: `traceExpDominatesQuadraticFormUpperTail_of_pointwise_traceExp_bound`
  - proposed signature: listed as fallback candidate above.
  - source support: set-theoretic unpacking of current MB-S6 dominance wrapper.
  - Mathlib/HighDimProb APIs needed: only current definitions and `ENNReal.ofReal` monotonicity if proved from real bounds.
  - status: directly provable now
- name: `quadraticFormUpperTailEvent_empty_of_zero_dim`
  - proposed signature:
    ```lean
    theorem quadraticFormUpperTailEvent_empty_of_zero_dim
        {Omega : Type*} [MeasurableSpace Omega]
        (Y : RandomMatrix Omega 0 0) (t : Real) :
        quadraticFormUpperTailEvent Y t = Set.empty
    ```
  - source support: no unit vector exists in zero-dimensional Euclidean space.
  - Mathlib/HighDimProb APIs needed: `IsUnitVector` definition and finite sum/norm contradiction.
  - status: needs new bridge if the final theorem remains dimension-polymorphic over `n`.

## Proof Feasibility Classification

`CONTRACT_BRIDGE_SPLIT_REQUIRED`

The final dominance theorem is mathematically source-backed and the current MB-S6 wrapper is well shaped, but the proof should not be attempted as one theorem. The required Rayleigh/eigenvalue/trace-exponential spectral dominance bridges are currently statement-only or absent in HighDimProb.

## Recommended Next Agent

Dispatch MB-S7A Spectral Bridge Agent.

## Commands Run

- `lake env lean external/validation/matrix-bernstein-mainline-mb-s7/MB_S7_APIProbe.lean`: passed
- `lake build HighDimProb.RandomMatrix.Laplace`: passed
- `lake build HighDimProb.RandomMatrix.Spectral`: passed
- `python scripts/judge_policy_check.py`: passed
- `git diff --check`: passed, with existing CRLF normalization warnings on untouched root Lean files

## Blockers

- No proved conversion from HighDimProb `matrixQuadraticForm` / `IsUnitVector` to Mathlib `ContinuousLinearMap.rayleighQuotient`.
- No proved HighDimProb theorem that `lambdaMax` is the largest Hermitian eigenvalue in the wrapper's ordering.
- No proved theorem that `traceMatrixExp A` dominates `Real.exp (lambdaMax A hA)` for self-adjoint `A`.
- The existing `lambdaMax` wrapper is only for nonempty `Fin (n + 1)`, while `quadraticFormUpperTailEvent` is dimension-polymorphic over `Fin n`; the zero-dimensional case needs an explicit reduction or a separate theorem shape.

## Exactly One Next Safe Task

Stage MB-S7A Spectral Bridge Agent: prove or type-split the bridge from HighDimProb explicit unit-vector quadratic forms to Mathlib Rayleigh/eigenvalue upper-bound APIs for self-adjoint matrices.
