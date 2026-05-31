# Scalar Implication Graph

This graph records only proved scalar concentration implications. It does not
define canonical `SubGaussian` or `SubExponential` predicates.

The Lean collection point for fixed-scale tail/Orlicz arrows is
`HighDimProb.Concentration.Implications`. Moment pilot results live in
`HighDimProb.Concentration.MomentImplications`. Reusable layer-cake and
exponential-tail calculus helpers are available through
`HighDimProb.Concentration.LayerCake`.

## SubGaussian

- `Psi2Bound -> SubGaussianTail`: proven by `subGaussianTail_of_psi2Bound`.
- `SubGaussianTail -> Psi2Bound`: proven by `psi2Bound_of_subGaussianTail` with scale `K -> 2 * K`.
- `Psi2Bound K -> absMomentNat q=2`: proven by `absMomentNat_two_le_of_psi2Bound` with bound `K^2`.
- `SubGaussianTail K -> absMomentNat q=2`: proven by `absMomentNat_two_le_of_subGaussianTail` with bound `(2*K)^2`.
- `Psi2Bound K -> absMomentNat q` for all natural `q`: proven by `absMomentNat_le_of_psi2Bound` with crude bound `2 * exp(1/4) * K^q * q!`.
- `SubGaussianTail K -> absMomentNat q` for all natural `q`: proven by `absMomentNat_le_of_subGaussianTail` with scale loss `K -> 2*K` and the same factorial constant.
- `finiteAbsMomentNat q -> MemLp q` for `q != 0`: proven by `memLp_of_finiteAbsMomentNat`, with measurability explicit.
- `absMomentNat q <= B -> realLpNorm q <= B^(1/q)` for `q != 0`: proven by `realLpNorm_nat_le_of_absMomentNat_le_ennreal` and its real-bound wrapper.
- `Psi2Bound K -> realLpNorm q <= 8*K*q` for natural `q >= 1`: proven by `realLpNorm_nat_le_linear_of_psi2Bound` from the factorial bound and `q! <= q^q`.
- `SubGaussianTail K -> realLpNorm q <= 16*K*q` for natural `q >= 1`: proven by `realLpNorm_nat_le_linear_of_subGaussianTail` using the existing `K -> 2*K` scale loss.
- Deterministic `x^q <= (2*sqrt q)^q * exp(x^2/4)` for `x >= 0`, `q >= 1`: proven by `pow_le_two_sqrt_mul_exp_sq`.
- `Psi2Bound K -> absMomentNat q <= (4*K*sqrt q)^q` for natural `q >= 1`: proven by `absMomentNat_le_sqrt_growth_of_psi2Bound`.
- `Psi2Bound K -> realLpNorm q <= 4*K*sqrt q` for natural `q >= 1`: proven by `realLpNorm_nat_le_sqrt_of_psi2Bound`.
- `SubGaussianTail K -> realLpNorm q <= 8*K*sqrt q` for natural `q >= 1`: proven by `realLpNorm_nat_le_sqrt_of_subGaussianTail`.
- `Psi2Bound K -> SubGaussianMomentNat K`: proven by `subGaussianMomentNat_of_psi2Bound` with factorial growth.
- `SubGaussianTail K -> SubGaussianMomentNat (2*K)`: proven by `subGaussianMomentNat_of_subGaussianTail`.
- `Psi2Bound K -> SubGaussianMomentNatSqrt (4*K)`: proven by `subGaussianMomentNatSqrt_of_psi2Bound`.
- `SubGaussianTail K -> SubGaussianMomentNatSqrt (8*K)`: proven by `subGaussianMomentNatSqrt_of_subGaussianTail`.
- Sharp natural-exponent moment formulation links: typed targets `powLeSqrtGrowthMulExpSqStatement`, `sqrtMomentGrowthOfPsi2Statement`, and `sqrtMomentGrowthOfSubGaussianTailStatement` are discharged by theorem wrappers; the real-exponent `SubGaussianMoment` connector remains TODO because it quantifies over all finite `ENNReal` exponents.
- MGF formulation links: TODO.
- Finite-gauge/norm formulation links: TODO.

## SubExponential

- `Psi1Bound -> SubExponentialTail`: proven by `subExponentialTail_of_psi1Bound`.
- `SubExponentialTail -> Psi1Bound`: proven by `psi1Bound_of_subExponentialTail` with scale `K -> 3 * K`.
- `Psi1Bound K -> absMomentNat q=1`: proven by `absMomentNat_one_le_of_psi1Bound` with bound `K`.
- `SubExponentialTail K -> absMomentNat q=1`: proven by `absMomentNat_one_le_of_subExponentialTail` with bound `3*K`.
- Full moment formulation links: TODO for all natural exponents and the real-`Lp` `SubExponentialMoment` predicate.
- MGF formulation links: TODO.
- Finite-gauge/norm formulation links: TODO.

## Policy

- Keep formulation-specific predicates until all major links are proved.
- Record constant losses in theorem names or documentation.
- Do not promote a canonical predicate from this graph without proof coverage,
  tests, and a status update.
