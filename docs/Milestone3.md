# Milestone 3: Scalar SubGaussian Proof Spine Closeout

Milestone 3 closes the earlier scalar subGaussian spine as a coherent
experimental milestone. It does not claim full subGaussian equivalence and did
not start reverse MGF, Hoeffding, or Bernstein. Later scalar concentration
families are closed in `docs/Milestone-ScalarConcentration.md`.

## Scalar Concentration Branch Status

The concentration branch now contains reusable scalar foundations:

- Markov inequality: `markov_inequality_nonneg`, `markov_inequality`.
- Chebyshev inequality: `chebyshev_inequality`, `chebyshev_inequality_prob`.
- Finite union bound: `measure_biUnion_le`.
- Orlicz/tail bridges: `subGaussianTail_of_psi2Bound`,
  `psi2Bound_of_subGaussianTail`, `subExponentialTail_of_psi1Bound`,
  `psi1Bound_of_subExponentialTail`.
- Natural moment/Lp bridges: `absMomentNat`, `finiteAbsMomentNat`,
  `memLp_of_finiteAbsMomentNat`, `realLpNorm_nat_le_of_absMomentNat_le`.
- Sharp natural subGaussian moment interface:
  `SubGaussianMomentNatSqrt`.
- MGF forward branch: `CenteredSubGaussianMGFLIntegral` and the
  MGF-to-tail/Orlicz/moment composition theorems.

## Proven SubGaussian Graph

| From | To | Scale | Theorem |
|---|---|---:|---|
| `Psi2Bound K` | `SubGaussianTail K` | `K` | `subGaussianTail_of_psi2Bound` |
| `SubGaussianTail K` | `Psi2Bound (2*K)` | `2*K` | `psi2Bound_of_subGaussianTail` |
| `Psi2Bound K` | `realLpNorm <= 4*K*sqrt(q)` | `4*K` | `realLpNorm_nat_le_sqrt_of_psi2Bound` |
| `SubGaussianTail K` | `realLpNorm <= 8*K*sqrt(q)` | `8*K` | `realLpNorm_nat_le_sqrt_of_subGaussianTail` |
| `Psi2Bound K` | `SubGaussianMomentNatSqrt (4*K)` | `4*K` | `subGaussianMomentNatSqrt_of_psi2Bound` |
| `SubGaussianTail K` | `SubGaussianMomentNatSqrt (8*K)` | `8*K` | `subGaussianMomentNatSqrt_of_subGaussianTail` |
| `CenteredSubGaussianMGF K` | one-sided Chernoff tails | `4*K^2` denominator | `upperTailProb_le_exp_neg_sq_of_centeredSubGaussianMGF`, `lowerTailProb_le_exp_neg_sq_of_centeredSubGaussianMGF` |
| `CenteredSubGaussianMGF K` | `SubGaussianTail (2*K)` | `2*K` | `subGaussianTail_of_centeredSubGaussianMGF` |
| `CenteredSubGaussianMGF K` | `Psi2Bound (4*K)` | `4*K` | `psi2Bound_of_centeredSubGaussianMGF` |
| `CenteredSubGaussianMGF K` | `SubGaussianMomentNatSqrt (16*K)` | `16*K` | `subGaussianMomentNatSqrt_of_centeredSubGaussianMGF` |

## Proven SubExponential Graph

| From | To | Scale | Theorem |
|---|---|---:|---|
| `Psi1Bound K` | `SubExponentialTail K` | `K` | `subExponentialTail_of_psi1Bound` |
| `SubExponentialTail K` | `Psi1Bound (3*K)` | `3*K` | `psi1Bound_of_subExponentialTail` |
| `Psi1Bound K` | first absolute moment bound | `K` | `absMomentNat_one_le_of_psi1Bound` |
| `SubExponentialTail K` | first absolute moment bound | `3*K` | `absMomentNat_one_le_of_subExponentialTail` |

## Test Coverage

- `HighDimProbTest/ConcentrationImplicationsAPI.lean` checks the aggregate
  implication import.
- `HighDimProbTest/MomentImplicationsAPI.lean` checks natural moment, Lp, and
  sharp sqrt-growth APIs.
- `HighDimProbTest/MGFImplicationsAPI.lean` checks the lintegral MGF predicate,
  one-sided Chernoff bounds, two-sided tail bridge, and composed corollaries.
- Branch and experimental import tests check the new public names remain
  discoverable through aggregate imports.

## Remaining Blockers

- Reverse/source MGF bridge:
  `SubGaussianTail` / `Psi2Bound` / moment control to
  `CenteredSubGaussianMGF`.
- Full `SubGaussianMoment` bridge over all finite `ENNReal` exponents is
  resolved by Stage M-real-1.
- SubExponential local-MGF/source implication branches. Fixed-scale
  subExponential moment links are resolved by Stage M-real-2.
- Canonical `SubGaussian` / `SubExponential` predicates remain deferred until
  the reverse/source links and equivalence-package choices are proved.
- Later Hoeffding, Bernstein, and independent-sum concentration work is now
  tracked in `docs/Milestone-ScalarConcentration.md`; remaining blockers here
  are the reverse/source MGF and local-MGF/source links.

## Next Deep Route

The real-exponent `SubGaussianMoment` and `SubExponentialMoment` bridges are
resolved by Stages M-real-1 and M-real-2. The next major branch should be chosen
separately from this subGaussian spine closeout.
