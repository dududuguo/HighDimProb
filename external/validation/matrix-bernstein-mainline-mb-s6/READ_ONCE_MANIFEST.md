# MB-S6 Read-Once Manifest

## Lease

- Active lease while producing this file: `LEASE_SNAPSHOT`.
- Snapshot files were read once during Phase 0.
- Later agents must rely on this manifest plus `SOURCE_DIGEST.md` and
  `API_CONTRACT.md`, and read only their leased files or compiler error
  locations.

## Current Relevant Source Signatures

Source: `HighDimProb/RandomMatrix/Laplace.lean`.

```lean
def matrixLaplaceRHS {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : Measure Omega) (Y : RandomMatrix Omega n n) (theta t : Real) :
    ENNReal
```

```lean
def matrixLaplaceRHSLIntegral {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : Measure Omega) (Y : RandomMatrix Omega n n) (theta t : Real) :
    ENNReal
```

```lean
def traceExpThresholdEvent {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (Y : RandomMatrix Omega n n) (theta t : Real) : Set Omega
```

Definition body:

```lean
{omega | ENNReal.ofReal (Real.exp (theta * t)) <=
  ENNReal.ofReal (traceExpIntegrand Y theta omega)}
```

```lean
def matrixLaplaceRHSLIntegralDiv {Omega : Type*} [MeasurableSpace Omega]
    {n : Nat} (P : Measure Omega) (Y : RandomMatrix Omega n n)
    (theta t : Real) : ENNReal
```

Definition body:

```lean
traceExpMomentLIntegral P Y theta / ENNReal.ofReal (Real.exp (theta * t))
```

```lean
theorem matrixLaplaceRHSLIntegralDiv_eq_matrixLaplaceRHSLIntegral
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    (Y : RandomMatrix Omega n n) (theta t : Real) :
    matrixLaplaceRHSLIntegralDiv P Y theta t =
      matrixLaplaceRHSLIntegral P Y theta t
```

```lean
theorem traceExpThresholdEvent_lintegral_bound {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    (Y : RandomMatrix Omega n n) (theta t : Real)
    (hMeas : AEMeasurable
      (fun omega => ENNReal.ofReal (traceExpIntegrand Y theta omega)) P) :
    P (traceExpThresholdEvent Y theta t) <=
      matrixLaplaceRHSLIntegral P Y theta t
```

```lean
theorem matrixLaplaceTransformLIntegralDiv_of_traceExpThreshold_subset
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    (Y : RandomMatrix Omega n n) (theta t : Real)
    (hMeas : AEMeasurable
      (fun omega => ENNReal.ofReal (traceExpIntegrand Y theta omega)) P)
    (hSubset :
      quadraticFormUpperTailEvent Y t subset traceExpThresholdEvent Y theta t) :
    P (quadraticFormUpperTailEvent Y t) <=
      matrixLaplaceRHSLIntegralDiv P Y theta t
```

```lean
theorem matrixLaplaceTransformLIntegral_of_traceExpThreshold_subset
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    (Y : RandomMatrix Omega n n) (theta t : Real)
    (hMeas : AEMeasurable
      (fun omega => ENNReal.ofReal (traceExpIntegrand Y theta omega)) P)
    (hSubset :
      quadraticFormUpperTailEvent Y t subset traceExpThresholdEvent Y theta t) :
    P (quadraticFormUpperTailEvent Y t) <=
      matrixLaplaceRHSLIntegral P Y theta t
```

Existing typed targets:

```lean
abbrev matrixLaplaceTransformStatement {Omega : Type*} [MeasurableSpace Omega]
    {n : Nat} (P : Measure Omega) (Y : RandomMatrix Omega n n)
    (theta t : Real) : Prop
```

```lean
abbrev matrixLaplaceTransformLIntegralStatement {Omega : Type*}
    [MeasurableSpace Omega] {n : Nat} (P : Measure Omega)
    (Y : RandomMatrix Omega n n) (theta t : Real) : Prop
```

## Current Relevant Spectral/Event Signatures

Source: `HighDimProb/RandomMatrix/Spectral.lean`.

```lean
def QuadraticFormUpperBound {n : Nat} (A : Matrix (Fin n) (Fin n) Real)
    (t : Real) : Prop :=
  forall x : Fin n -> Real, IsUnitVector x -> matrixQuadraticForm A x <= t
```

```lean
def quadraticFormUpperTailEvent {Omega : Type*} [MeasurableSpace Omega]
    {n : Nat} (A : RandomMatrix Omega n n) (t : Real) : Set Omega :=
  {omega | exists x : Fin n -> Real,
    IsUnitVector x /\ t <= matrixQuadraticForm (A omega) x}
```

Unproved typed spectral targets:

```lean
abbrev lambdaMax_le_iff_quadraticForm_le_statement {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (hA : IsSelfAdjointMatrix A) (t : Real) : Prop
```

```lean
abbrev selfAdjointOperatorNormTailViaQuadraticFormStatement {Omega : Type*}
    [MeasurableSpace Omega] {n : Nat} (A : RandomMatrix Omega n n)
    (t : Real) : Prop
```

## Current Relevant Trace-Exp Signatures

Source: `HighDimProb/RandomMatrix/TraceExp.lean`.

```lean
def traceExpIntegrand {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (Y : RandomMatrix Omega n n) (theta : Real) : RealRandomVariable Omega
```

Definition body:

```lean
fun omega => traceMatrixExp (SMul.smul theta (Y omega))
```

```lean
def traceExpMomentLIntegral {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : Measure Omega) (Y : RandomMatrix Omega n n) (theta : Real) : ENNReal
```

```lean
theorem matrixExp_posSemidef_of_selfAdjoint {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real} (hA : IsSelfAdjointMatrix A) :
    Matrix.PosSemidef (matrixExp A)
```

```lean
theorem traceMatrixExp_nonneg_of_selfAdjoint {n : Nat}
    {A : Matrix (Fin n) (Fin n) Real} (hA : IsSelfAdjointMatrix A) :
    0 <= traceMatrixExp A
```

## Current Coverage Files

Source: `HighDimProbTest/RandomMatrixLaplaceAPI.lean`.

- Checks and examples exist for MB-S5 declarations:
  `traceExpThresholdEvent`, `matrixLaplaceRHSLIntegralDiv`,
  `matrixLaplaceRHSLIntegralDiv_eq_matrixLaplaceRHSLIntegral`,
  `traceExpThresholdEvent_lintegral_bound`,
  `matrixLaplaceTransformLIntegralDiv_of_traceExpThreshold_subset`, and
  `matrixLaplaceTransformLIntegral_of_traceExpThreshold_subset`.

Source: `HighDimProbJudge/RandomMatrix/LaplaceUse.lean`.

- Downstream-style checks and examples exist for the same MB-S5 declarations.

## Prior Validation Facts

Source: `external/validation/matrix-bernstein-mainline-mb-s5/final_report.md`.

- MB-S5 proved only conditional Markov/Laplace bridge theorems.
- Full `matrixLaplaceTransformStatement` remains unproved.
- Blocker: missing pointwise event-subset bridge from
  `quadraticFormUpperTailEvent Y t` into
  `traceExpThresholdEvent Y theta t`.
- Trace-mgf, Golden-Thompson, Lieb, full matrix Laplace, and Matrix Bernstein
  remain unproved.

Source: `external/validation/matrix-bernstein-mainline-mb-s5/mathlib_laplace_survey.md`.

- Mathlib Markov API used by MB-S5:
  `MeasureTheory.meas_ge_le_lintegral_div`.
- MB-S5 did not find a proof of the pointwise event-subset bridge.

## Phase 0 Command Notes

- Codebase memory search found `quadraticFormUpperTailEvent` at
  `HighDimProb/RandomMatrix/Spectral.lean`.
- Targeted file slices were read once for:
  - `HighDimProb/RandomMatrix/Laplace.lean`;
  - `HighDimProb/RandomMatrix/Spectral.lean`;
  - `HighDimProb/RandomMatrix/TraceExp.lean`;
  - `HighDimProbTest/RandomMatrixLaplaceAPI.lean`;
  - `HighDimProbJudge/RandomMatrix/LaplaceUse.lean`;
  - MB-S5 validation reports.

## Next Safe Task

- Run Source-Book Agent over `external/` source materials and produce
  `SOURCE_DIGEST.md`.
