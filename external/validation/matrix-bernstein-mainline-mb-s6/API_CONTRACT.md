# MB-S6 API Contract

## Source Digest Prerequisite

- `SOURCE_DIGEST.md` recommendation: `USE_EXPLICIT_HYPOTHESIS`.
- The external source supports the largest-eigenvalue trace-exponential route,
  but not a direct proof of the current HighDimProb event subset without
  spectral/Rayleigh and matrix-function eigenvalue machinery.

## Declarations Added

### `TraceExpDominatesQuadraticFormUpperTail`

Kind: definition / explicit hypothesis predicate.

Signature:

```lean
def TraceExpDominatesQuadraticFormUpperTail {Omega : Type*}
    [MeasurableSpace Omega] {n : Nat}
    (Y : RandomMatrix Omega n n) (theta t : Real) : Prop
```

Definition body:

```lean
quadraticFormUpperTailEvent Y t ⊆ traceExpThresholdEvent Y theta t
```

Explicit assumptions:

- None hidden. The predicate itself is the missing event-subset assumption.

### `traceExpDominatesQuadraticFormUpperTailStatement`

Kind: typed statement only (`abbrev` returning `Prop`), not a theorem.

Signature:

```lean
abbrev traceExpDominatesQuadraticFormUpperTailStatement {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    (Y : RandomMatrix Omega n n) (theta t : Real) : Prop
```

Definition body:

```lean
RandomSelfAdjointMatrix P Y ->
  0 <= theta ->
    TraceExpDominatesQuadraticFormUpperTail Y theta t
```

Explicit assumptions:

- Random self-adjointness of `Y`.
- Nonnegative scalar parameter `theta`.
- The conclusion is still the explicit dominance predicate.

## Theorems Added In Construction

- None.

## Theorems Added By Proof Agent

### `quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_traceExpDominates`

Kind: theorem unpacking explicit hypothesis.

Signature:

```lean
theorem quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_traceExpDominates
    {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (Y : RandomMatrix Omega n n) (theta t : Real)
    (hDom : TraceExpDominatesQuadraticFormUpperTail Y theta t) :
    quadraticFormUpperTailEvent Y t ⊆ traceExpThresholdEvent Y theta t
```

### `matrixLaplaceTransformLIntegralDiv_of_traceExpDominatesQuadraticFormUpperTail`

Kind: conditional theorem reusing MB-S5 division-normal bridge.

Signature:

```lean
theorem matrixLaplaceTransformLIntegralDiv_of_traceExpDominatesQuadraticFormUpperTail
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    (Y : RandomMatrix Omega n n) (theta t : Real)
    (hMeas : AEMeasurable
      (fun omega => ENNReal.ofReal (traceExpIntegrand Y theta omega)) P)
    (hDom : TraceExpDominatesQuadraticFormUpperTail Y theta t) :
    P (quadraticFormUpperTailEvent Y t) <=
      matrixLaplaceRHSLIntegralDiv P Y theta t
```

### `matrixLaplaceTransformLIntegral_of_traceExpDominatesQuadraticFormUpperTail`

Kind: conditional theorem reusing MB-S5 product-RHS bridge.

Signature:

```lean
theorem matrixLaplaceTransformLIntegral_of_traceExpDominatesQuadraticFormUpperTail
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} {n : Nat}
    (Y : RandomMatrix Omega n n) (theta t : Real)
    (hMeas : AEMeasurable
      (fun omega => ENNReal.ofReal (traceExpIntegrand Y theta omega)) P)
    (hDom : TraceExpDominatesQuadraticFormUpperTail Y theta t) :
    P (quadraticFormUpperTailEvent Y t) <=
      matrixLaplaceRHSLIntegral P Y theta t
```

## What Remains Unproved

- The source-backed spectral/Rayleigh bridge from
  `quadraticFormUpperTailEvent Y t` into `traceExpThresholdEvent Y theta t`.
- Full `matrixLaplaceTransformStatement`.
- Trace-mgf bound.
- Golden-Thompson and Lieb.
- Matrix Bernstein.

## Proof Agent Contract

The Proof Agent may prove only conditional consequences that expose
`TraceExpDominatesQuadraticFormUpperTail Y theta t` as an explicit hypothesis,
for example:

```lean
theorem quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_traceExpDominates
```

and conditional Laplace consequences obtained by reusing the MB-S5 theorem.

The Proof Agent must not prove a direct spectral dominance theorem unless it
first finds exact Mathlib API support and the source-backed proof compiles.

## Example/Judge Contract

Add focused checks and small examples for:

- `TraceExpDominatesQuadraticFormUpperTail`
- `traceExpDominatesQuadraticFormUpperTailStatement`
- `quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_traceExpDominates`
- `matrixLaplaceTransformLIntegralDiv_of_traceExpDominatesQuadraticFormUpperTail`
- `matrixLaplaceTransformLIntegral_of_traceExpDominatesQuadraticFormUpperTail`

Examples must pass explicit dominance hypotheses as ordinary variables.

## Construction Commands

- `lake build HighDimProb.RandomMatrix.Laplace`: pass
- `python scripts/judge_policy_check.py`: pass
