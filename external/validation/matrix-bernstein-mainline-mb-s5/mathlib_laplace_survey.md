# MB-S5 Mathlib / Laplace Survey

## Recommendation

`PROVE_CONDITIONAL_LINTEGRAL_MARKOV`

## Scope

- Survey only covers the Markov/Laplace bridge around existing
  `traceExpIntegrand`, `traceExpMomentLIntegral`,
  `quadraticFormUpperTailEvent`, and `matrixLaplaceRHSLIntegral`.
- It does not prove or claim full matrix Laplace, trace-mgf,
  Golden-Thompson, Lieb, or Matrix Bernstein.

## Mathlib Markov API

Primary theorem:

```lean
MeasureTheory.meas_ge_le_lintegral_div
```

Usable shape confirmed by scratch probe:

```lean
MeasureTheory.meas_ge_le_lintegral_div hMeas
  (ENNReal.ofReal_ne_zero_iff.mpr (Real.exp_pos (theta * t)))
  ENNReal.ofReal_ne_top
```

The threshold is
`ENNReal.ofReal (Real.exp (theta * t))`, so it is nonzero for all real
`theta` and `t` because `Real.exp_pos`.

## HighDimProb Scalar Pattern

`HighDimProb/Concentration/Markov.lean` proves
`markov_inequality_nonneg` and `markov_inequality_ae_nonneg` by:

1. building `AEMeasurable (fun omega => ENNReal.ofReal (X omega)) P`;
2. applying `MeasureTheory.meas_ge_le_lintegral_div`;
3. proving threshold nonzero/non-top;
4. identifying or subsetting the event;
5. converting the RHS only when extra real-integrability/nonnegativity facts
   are available.

`HighDimProb/Concentration/Hoeffding.lean` and
`HighDimProb/Concentration/Bernstein.lean` use the same Chernoff pattern:
define an ENNReal exponential integrand, apply lintegral Markov, then use an
event-subset proof and ENNReal exponential algebra.

## Existing Matrix APIs

Current definitions:

```lean
matrixLaplaceRHS
matrixLaplaceRHSLIntegral
traceExpIntegrand
traceExpMomentLIntegral
quadraticFormUpperTailEvent
```

The lintegral RHS is:

```lean
matrixLaplaceRHSLIntegral P Y theta t =
  ENNReal.ofReal (Real.exp (-(theta * t))) *
    traceExpMomentLIntegral P Y theta
```

A direct Markov theorem naturally gives division normal form:

```lean
traceExpMomentLIntegral P Y theta /
  ENNReal.ofReal (Real.exp (theta * t))
```

Scratch probe confirmed the division RHS equals the existing product RHS using:

```lean
div_eq_mul_inv
ENNReal.ofReal_inv_of_pos
Real.exp_neg
mul_comm
```

## Missing Event-Subset Bridge

The full matrix Laplace statement remains blocked by the missing pointwise
spectral/trace comparison:

```lean
quadraticFormUpperTailEvent Y t ⊆ traceExpThresholdEvent Y theta t
```

This cannot be derived from current assumptions without additional spectral
dominance / Rayleigh / trace-exp machinery. It must remain an explicit
hypothesis for MB-S5 conditional theorems.

## Checked Scratch Probe

File:

```text
external/validation/matrix-bernstein-mainline-mb-s5/MB_S5_MarkovProbe.lean
```

Command:

```bash
lake env lean external/validation/matrix-bernstein-mainline-mb-s5/MB_S5_MarkovProbe.lean
```

Result: pass.

The scratch probe checked:

- threshold event definition;
- division RHS definition;
- threshold-event lintegral Markov bound;
- conditional quadratic-form bridge assuming the event subset;
- division RHS equals existing product RHS.

## Formalizer Target

Safe additions to `HighDimProb/RandomMatrix/Laplace.lean`:

- `traceExpThresholdEvent`
- `matrixLaplaceRHSLIntegralDiv`
- `matrixLaplaceRHSLIntegralDiv_eq_matrixLaplaceRHSLIntegral`
- `traceExpThresholdEvent_lintegral_bound`
- `matrixLaplaceTransformLIntegralDiv_of_traceExpThreshold_subset`
- `matrixLaplaceTransformLIntegral_of_traceExpThreshold_subset`

Required public coverage:

- `HighDimProbTest/RandomMatrixLaplaceAPI.lean`
- `HighDimProbJudge/RandomMatrix/LaplaceUse.lean`

## Blockers

- None for the conditional lintegral Markov bridge.
- Full `matrixLaplaceTransformStatement` remains blocked by the missing
  event-subset bridge and trace-mgf/spectral infrastructure.
