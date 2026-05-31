# Book Progress

Infrastructure:
- Stage 1T test harness and API regression policy
- Stage 1S theorem atlas initialized
- book theorem groups classified
- no deep theorems proved yet
- Stage 1B tail-event measurability bridge lemmas
- Stage 1C public API boundary: stable root import plus experimental scaffold aggregate
- Stage 1R README workflow and future-work documentation
- Stage 2A Lp and moment vocabulary
- Stage 2B Orlicz / ψ₁ / ψ₂ bound vocabulary
- Stage 3A subGaussian predicate forms
- Stage 3B subExponential predicate forms
- Stage 4A random vector object layer
- Stage 4B covariance and centered random vector vocabulary
- Stage 4C isotropic random vector vocabulary
- Stage 4D high-dimensional subGaussian random vector vocabulary
- Stage 5A metric entropy / nets API alignment
- Stage 5B covering/packing theorem statement layer
- Stage M1 milestone closeout and audit
- Stage P0 public push readiness
- Stage P1 first proof pilot: maximal separated set gives an epsilon net
- Stage P2 second proof pilot: isotropic matrix/entrywise bridge
- Stage P3 third proof pilot: centered vector coordinate bridge
- Stage P4 first analytic/probabilistic proof pilot: centered scalar operation
- Stage P5 tail probability monotonicity proof pilot
- Stage 6A random matrix object layer and folder abstraction
- Stage 6B sample covariance vocabulary and matrix norm bridge audit
- Stage I1 CSLib-inspired infrastructure alignment
- Stage G1A scalar tail concentration foundations
- Stage G1B scalar concentration API cleanup
- Stage G1C Orlicz-to-tail implication pilot
- Stage G1D tail-to-Orlicz reverse implication proof pilot
- Stage G1D-fix layer-cake / tail-integral bridge infrastructure
- Stage G1E Boole inequality / finite union bound proof
- Stage RM2 random matrix finite-sum algebra bridge cleanup
- Stage LLN0-LLN1 weak law scaffold and sample mean vocabulary
- Stage C1 abstraction cleanup after scalar concentration and random-matrix proof spine
- Stage G2C absolute natural moment to Lp bridge
- Stage G2D sharpen subGaussian natural-moment growth
- Stage G2E sharp subGaussian moment tail-integral/Gamma estimate design
- Stage G2E-fix deterministic real inequality proof for sharp moment growth
- Stage G2F sharp natural-exponent moment interface bridge
- Stage G2F-cleanup abstraction and code-trace cleanup
- Milestone Sprint S2 scalar concentration proof spine + random matrix statement layer
- Milestone Sprint S3 small branch proof battery

Processed:
- probability space
- real-valued random variable
- law/distribution
- expectation wrapper
- tail events
- tail probabilities
- tail-event measurability
- Lp norm
- moment
- Orlicz norm vocabulary
- ψ₂ norm vocabulary
- ψ₁ norm vocabulary
- subGaussian random variable definitions
- subExponential random variable definitions
- random vector object layer
- covariance and centered random vector vocabulary
- second moment matrix vocabulary
- isotropic random vector vocabulary
- high-dimensional subGaussian random vector vocabulary
- ε-net vocabulary
- separated set vocabulary
- covering number vocabulary
- packing number vocabulary
- metric entropy vocabulary
- maximal separated set theorem statement
- covering/packing inequality theorem statement
- covering number bound from epsilon-net statement
- theorem atlas and statement layer
- Milestone 1 audit documentation
- public alpha contributor workflow documentation
- Stage 5B statement-layer documentation only
- Stage P1 first proof pilot completed
- Stage P2 second proof pilot completed
- Stage P3 third proof pilot completed
- Stage P4 first analytic/probabilistic proof pilot completed
- Stage P5 tail probability monotonicity proof pilot completed
- Stage 6A random matrix object layer completed
- Stage 6B sample covariance vocabulary completed
- Stage I1 infrastructure alignment completed
- Stage G1A scalar tail concentration foundations completed
- Stage G1B scalar concentration API cleanup completed
- Stage G1C Orlicz-to-tail implication pilot completed
- Stage G1D tail-to-Orlicz reverse implication proof pilot processed as proof-boundary; fixed-scale reverse bridges completed in S2
- Stage G1D-fix layer-cake / tail-integral bridge infrastructure completed
- Stage G1E Boole inequality / finite union bound completed
- Stage RM2 random matrix finite-sum algebra bridge cleanup completed
- Stage LLN0-LLN1 weak law scaffold and sample mean vocabulary completed
- Stage C1 abstraction cleanup completed
- Stage S2.1 tail-to-Orlicz bridge infrastructure completed
- Stage S2.2 scalar implication graph consolidation completed
- Stage S2.3 scalar concentration API hardening completed
- Stage S2.4 random matrix theorem statement layer initialized
- Stage S2.5 missing assumption vocabulary audit completed
- Stage S3.1 tail/concentration small proofs completed
- Stage S3.2 scalar centering/variance small proofs completed
- Stage S3.3 geometry/nets small proofs completed
- Stage S3.4 random vector/isotropic small proofs completed
- Stage S3.5 random matrix small proofs completed
- Stage LLN0-LLN1 limit theorem branch scaffold completed
- Stage C1 concentration layer-cake import boundary, scalar implication graph documentation, random-matrix row-dot helpers, and LLN assumptions vocabulary completed
- Stage G2C absMomentNat-to-realLpNorm bridge completed
- Stage G2D natural moment linear realLpNorm growth completed
- Stage G2E sharp moment proof route design completed
- Stage G2E-fix deterministic inequality and natural sqrt moment growth completed
- Stage G2F sharp natural-exponent moment interface bridge completed
- Stage G2F-cleanup abstraction and code-trace cleanup completed

Scaffold exists, not processed as stable API:
- random process vocabulary
- Gaussian width placeholder vocabulary
- empirical process vocabulary
- signal recovery vocabulary
- limit theorem scaffold and sample mean vocabulary
- limit theorem scalar assumptions vocabulary

Unprocessed:
- random process
- Gaussian width
- empirical process
- signal recovery

Processed as experimental object layer:
- random matrix vocabulary
- random matrix entries
- row and column random vectors
- deterministic matrix-vector actions
- Frobenius norm vocabulary
- entrywise max absolute value vocabulary
- L2 operator norm vocabulary
- Gram and row Gram matrix vocabulary
- sample covariance vocabulary
- quadratic and bilinear form vocabulary
- centered-entry assumptions
- subGaussian entry and row assumptions
- isotropic row assumptions
- row-dot sample covariance algebra helpers
- scalar sample independence/iid assumption wrappers
- scalar absolute natural-moment vocabulary for concentration
- natural absolute-moment to `MemLp` / `realLpNorm` bridge for nonzero natural exponents
- sharp natural-exponent subGaussian moment predicate bridge

Processed at statement-layer level only:
- weak law Chebyshev sample mean bound
- weak law finite-variance convergence in probability
- packing-covering inequalities
- Euclidean ball covering number bounds
- Hamming cube covering/packing bounds
- epsilon-net operator norm bound
- deterministic epsilon-net operator norm typed statement
- metric entropy as log covering number
- metric entropy coding interpretation
- Dudley integral dependency on covering numbers
- random matrix theorem statement layer initialized, with most matrix theorem groups blocked pending assumption vocabulary

Processed with proof:
- subGaussian tail implies psi2 Orlicz bound with scale `2 * K`
- subExponential tail implies psi1 Orlicz bound with scale `3 * K`
- psi2 bound implies a second absolute natural-moment bound
- subGaussian tail implies a second absolute natural-moment bound with scale loss `K -> 2 * K`
- psi2 bound implies all natural absolute moments with a crude factorial constant
- subGaussian tail implies all natural absolute moments with scale loss `K -> 2 * K` and a crude factorial constant
- finite natural absolute moments imply `MemLp` for nonzero natural exponents, with explicit measurability
- natural absolute-moment bounds imply corresponding `realLpNorm` bounds
- ψ₂ and subGaussian-tail bounds imply crude linear-in-`q` `realLpNorm` growth
- sharp natural-exponent `sqrt(q)` moment-growth route proved through a deterministic real inequality
- psi2 and subGaussian-tail bounds imply `SubGaussianMomentNat` with factorial growth
- psi2 and subGaussian-tail bounds imply `SubGaussianMomentNatSqrt` with constants `4` and `8`
- psi1/subExponential bounds imply first absolute natural-moment bounds
- layer-cake bridge for nonnegative real random variables
- exponential-tail to exponential-moment bridge
- maximal separated set is an epsilon-net
- isotropic second-moment matrix iff entrywise formulation
- centered vector iff coordinatewise centered
- centered random variable has mean zero
- upper-tail probability monotonicity
- lower-tail probability monotonicity
- absolute-tail probability monotonicity
- finite union bound / Boole inequality
- sample covariance quadratic-form row-dot-square identity
- row-dot square nonnegativity and scaled row-dot sample-covariance identity
- sample covariance quadratic-form nonnegativity
- Markov inequality for pointwise nonnegative integrable real random variables
- Chebyshev inequality for finite-measure `L^2` real random variables
- Chebyshev probability-measure wrapper
- a.e.-nonnegative Markov inequality
- scalar variance nonnegativity
- centered variance invariance under centering
- explicit epsilon-net covering-number bridges
- covariance-form isotropicity implies centered vector
- Frobenius-square nonnegativity
- sample-covariance diagonal nonnegativity
- ψ₂ Orlicz bound implies subGaussian tail
- ψ₁ Orlicz bound implies subExponential tail

Resolved in Stage RM2:
- `quadraticForm_sampleCovariance_eq_sum_sq` rewrites the explicit double-sum quadratic form of `sampleCovariance A` into `(1 / (m : Real)) * sum k, (sum i, A omega k i * x i)^2`.
- `quadraticForm_sampleCovariance_nonneg` is proven from that bridge without any positive-dimension assumption.

Resolved in Stage LLN0-LLN1:
- `sampleSum`, `sampleMean`, and `sampleMeanCentered` provide finite-sample scalar vocabulary over `Fin n`.
- sample-sum and sample-mean measurability/integrability bridges are proved.
- `weakLawChebyshevBoundStatement` and `weakLawFiniteVarianceStatement` are typed specifications only; WLLN proof dependencies remain documented in `docs/LLNPlan.md`.

Resolved in Stage C1:
- `HighDimProb.Concentration.LayerCake` is the reusable import boundary for existing layer-cake and exponential-tail calculus helpers.
- `HighDimProb.Concentration.Implications` and `docs/ScalarImplicationGraph.md` explicitly record the proved fixed-scale Orlicz/tail implication graph and leave moment/MGF links as TODO.
- `rowDot`, `rowDot_sq_nonneg`, `sum_rowDot_sq_nonneg`, and `quadraticForm_sampleCovariance_eq_scaled_sum_rowDot_sq` provide smaller random-matrix algebra helper names.
- `HighDimProb.LimitTheorems.Assumptions` wraps Mathlib scalar independence, pairwise independence, identical distribution, and iid vocabulary for finite samples and sequences.

Resolved in Stage G2A:
- `absMomentNat` and `finiteAbsMomentNat` provide an `ENNReal` natural absolute-moment normal form for concentration proof pilots.
- `absMomentNat_two_le_of_psi2Bound` proves `Psi2Bound P X K -> absMomentNat P X 2 <= ofReal (K^2)`.
- `absMomentNat_two_le_of_subGaussianTail` proves the tail-to-moment pilot with bound `(2*K)^2`, reusing `psi2Bound_of_subGaussianTail`.
- `subGaussianMomentNatOfSubGaussianTailStatement` records the all-natural-exponent target as a typed statement only; the full real-`Lp` moment-growth theorem remains future work.

Resolved in Stage G2B:
- `abs_pow_le_exp_sq_factorial` provides the deterministic estimate `|x|^q <= exp(1/4) * K^q * q! * exp((|x|/K)^2)`.
- `absMomentNat_le_of_psi2Bound` proves all natural absolute moments under `[IsProbabilityMeasure P]` with bound `2 * exp(1/4) * K^q * q!`.
- `finiteAbsMomentNat_of_psi2Bound`, `absMomentNat_le_of_subGaussianTail`, and `finiteAbsMomentNat_of_subGaussianTail` derive finiteness and the subGaussian-tail variant by reusing the existing implication graph.
- The first proved all-`q` theorem was factorial-growth; Stage G2E-fix now adds the sharp natural-exponent real-`Lp` theorem.

Resolved in Stage G2C:
- `lintegral_enorm_rpow_nat_eq_absMomentNat` identifies the Mathlib `eLpNorm` natural-exponent integrand with the HighDimProb `absMomentNat` normal form.
- `memLp_of_finiteAbsMomentNat` proves the `MemLp` bridge for `q != 0`, with `IsRealRandomVariable P X` kept explicit for `AEStronglyMeasurable`.
- `realLpNorm_nat_le_of_absMomentNat_le_ennreal` and `realLpNorm_nat_le_of_absMomentNat_le` prove quantitative `realLpNorm` bounds from natural absolute-moment bounds.
- `SubGaussianMomentNat`, `subGaussianMomentNat_of_psi2Bound`, and `subGaussianMomentNat_of_subGaussianTail` record the currently proved factorial-growth natural-moment formulation.
- The existing sharp `SubGaussianMoment` predicate is still not proved from tails or ψ₂ bounds because it uses the real `ENNReal` exponent formulation; the natural-exponent `sqrt(q)` theorem is now available.

Resolved in Stage G2D:
- `realLpNorm_nat_le_linear_of_psi2Bound` proves `realLpNorm P X q <= 8 * K * q` for natural `q >= 1`.
- `realLpNorm_nat_le_linear_of_subGaussianTail` proves the tail variant with the existing scale loss, giving constant `16`.
- The normal form remains the factorial estimate plus `(q!)^(1/q) <= q`; this honestly gives linear growth and does not imply the book's sharp `sqrt(q)` growth.

Resolved in Stage G2E:
- `powLeSqrtGrowthMulExpSqStatement` records the deterministic real inequality route with envelope constant `4`.
- `sqrtMomentGrowthOfPsi2Statement` and `sqrtMomentGrowthOfSubGaussianTailStatement` record sharp real-`Lp` targets with constants `8` and `16`.
- Mathlib has layer-cake and Gamma integral formulas, but the reusable Gamma upper-bound or deterministic optimization lemma is still missing.

Resolved in Stage G2E-fix:
- `pow_le_two_sqrt_mul_exp_sq` proves the deterministic envelope with constant `2`, strengthening the earlier constant-`4` typed target.
- `absMomentNat_le_sqrt_growth_of_psi2Bound` proves `absMomentNat P X q <= ((4*K*sqrt q)^q)` for `q >= 1`.
- `realLpNorm_nat_le_sqrt_of_psi2Bound` and `realLpNorm_nat_le_sqrt_of_subGaussianTail` prove constants `4` and `8`.
- `sqrtMomentGrowthOfPsi2` and `sqrtMomentGrowthOfSubGaussianTail` provide compatibility wrappers for the looser typed statement normal forms.

Resolved in Stage G2F:
- `SubGaussianMomentNatSqrt` records the sharp natural-exponent real-`Lp` normal form without changing the existing factorial-growth `SubGaussianMomentNat`.
- `subGaussianMomentNatSqrt_of_psi2Bound` proves `Psi2Bound P X K -> SubGaussianMomentNatSqrt P X (4*K)`.
- `subGaussianMomentNatSqrt_of_subGaussianTail` proves `SubGaussianTail P X K -> SubGaussianMomentNatSqrt P X (8*K)`.
- The full `SubGaussianMoment` bridge remains future work because it quantifies over all finite `ENNReal` exponents, not only natural exponents.

Resolved in Stage G2F-cleanup:
- Concentration implication aggregate documentation now states the ownership boundary: tail/Orlicz arrows in `Implications`, moment arrows in `MomentImplications`.
- Old "typed target" comments for already-proved sharp natural-exponent statements were rewritten as compatibility wrappers.
- Branch and experimental import tests now check `SubGaussianMomentNatSqrt` directly.
