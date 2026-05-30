# Theorem Atlas

Stage 1S records theorem/result families from the reference notes as a dependency map. Entries are not Lean proofs. A typed Lean `Prop` specification may exist only when the required objects already compile.

Unproved book results are documentation entries or typed `Prop` specifications. They are never Lean `theorem` or `lemma` declarations. The only allowed status values are:

- `raw`
- `informal`
- `typed-prop`
- `blocked`
- `proven`

## tail-event measurability statement
- Book heading: `尾分布`
- Informal statement: measurable real random variables have measurable upper, lower, and absolute tail events.
- Target Lean statement: `tailEventMeasurabilityStatement`
- Required objects: `IsRealRandomVariable`, `upperTailEvent`, `lowerTailEvent`, `absTailEvent`.
- Required definitions: Stage 1A real-valued random variables and tail events.
- Required bridge lemmas: `measurableSet_upperTailEvent`, `measurableSet_lowerTailEvent`, `measurableSet_absTailEvent`.
- Status: proven
- Blocker: none.
- Target module: `HighDimProb/Tail.lean`, `HighDimProb/BookStatements.lean`
- Priority: v0.1

## law/distribution map statement
- Book heading: probability distribution/law vocabulary
- Informal statement: the law of a random variable is Mathlib's pushforward measure.
- Target Lean statement: `lawMapApplyStatement`, `realLawMapApplyStatement`
- Required objects: `law`, `realLaw`, `Measure.map`.
- Required definitions: Stage 1A law/distribution wrappers.
- Required bridge lemmas: none for the specification itself.
- Status: typed-prop
- Blocker: proof wrapper around `Measure.map_apply` remains an object-layer TODO.
- Target module: `HighDimProb/BookStatements.lean`
- Priority: v0.1

## expectation alias statement
- Book heading: expectation vocabulary
- Informal statement: `expect P X` is the raw Mathlib integral of `X` against `P`.
- Target Lean statement: `expectAliasStatement`
- Required objects: `expect`, integral notation.
- Required definitions: Stage 1A expectation wrapper.
- Required bridge lemmas: none for the specification itself.
- Status: typed-prop
- Blocker: integrability-aware expectation statements are deferred.
- Target module: `HighDimProb/BookStatements.lean`
- Priority: v0.1

## tail probability wrapper statement
- Book heading: `尾分布`
- Informal statement: tail probability wrappers are direct measure applications to tail events.
- Target Lean statement: `tailProbabilityWrapperStatement`
- Required objects: `upperTailProb`, `lowerTailProb`, `absTailProb`.
- Required definitions: Stage 1A tail probability wrappers.
- Required bridge lemmas: none for the specification itself.
- Status: typed-prop
- Blocker: no blocker for the specification.
- Target module: `HighDimProb/BookStatements.lean`
- Priority: v0.1

## upper-tail probability monotonicity
- Book heading: tail distribution / concentration prerequisites
- Informal statement: increasing the upper-tail threshold can only decrease the upper-tail probability.
- Target Lean statement: `upperTailProb_antitone`
- Required objects: `upperTailEvent`, `upperTailProb`, `RealRandomVariable`, `Measure`.
- Required definitions: Stage 1A tail event and tail probability wrappers.
- Required bridge lemmas: Mathlib `measure_mono`; the set inclusion follows by transitivity of `<=` on `Real`.
- Status: proven
- Blocker: none.
- Target module: `HighDimProb/Tail.lean`
- Priority: v0.1 proof pilot

## lower-tail probability monotonicity
- Book heading: tail distribution / concentration prerequisites
- Informal statement: increasing the lower-tail threshold can only increase the lower-tail probability.
- Target Lean statement: `lowerTailProb_monotone`
- Required objects: `lowerTailEvent`, `lowerTailProb`, `RealRandomVariable`, `Measure`.
- Required definitions: Stage 1A tail event and tail probability wrappers.
- Required bridge lemmas: Mathlib `measure_mono`; the set inclusion follows by transitivity of `<=` on `Real`.
- Status: proven
- Blocker: none.
- Target module: `HighDimProb/Tail.lean`
- Priority: v0.1 proof pilot

## absolute-tail probability monotonicity
- Book heading: tail distribution / concentration prerequisites
- Informal statement: increasing the absolute-tail threshold can only decrease the absolute-tail probability.
- Target Lean statement: `absTailProb_antitone`
- Required objects: `absTailEvent`, `absTailProb`, `RealRandomVariable`, `Measure`.
- Required definitions: Stage 1A tail event and tail probability wrappers.
- Required bridge lemmas: Mathlib `measure_mono`; the set inclusion follows by transitivity of `<=` on `Real`.
- Status: proven
- Blocker: none.
- Target module: `HighDimProb/Tail.lean`
- Priority: v0.1 proof pilot

## tail integral identity for expectation
- Book heading: `尾分布`, expectation/tail vocabulary
- Informal statement: nonnegative expectations or moments can be represented by integrating tail probabilities.
- Target Lean statement: blocked until a precise nonnegative/integrable formulation is chosen.
- Required objects: `Measure`, `IsProbabilityMeasure`, `RealRandomVariable`, `expect`, tail probabilities.
- Required definitions: nonnegative random-variable predicate or integrable real random variable.
- Required bridge lemmas: tail-event measurability, integral/layer-cake bridge.
- Status: blocked
- Blocker: requires integration design beyond Stage 1A.
- Target module: `HighDimProb/Moment.lean`
- Priority: v0.2

## Markov inequality
- Book heading: `集中不等式`, classical probability inequalities
- Informal statement: for a nonnegative random variable, the probability of exceeding a threshold is bounded by expectation divided by the threshold.
- Target Lean statement: `markov_inequality_nonneg`; user-facing alias `markov_inequality`
- Required objects: `Measure`, `RealRandomVariable`, `expect`, `upperTailProb`, `IntegrableRealRandomVariable`.
- Required definitions: pointwise nonnegative real random variable hypothesis and positive threshold.
- Required bridge lemmas: `lintegral_ofReal_eq_ofReal_expect`, Mathlib `MeasureTheory.meas_ge_le_lintegral_div`.
- Status: proven
- Blocker: none for the pointwise nonnegative integrable formulation. A reusable a.e.-nonnegative formulation remains future API work.
- API cleanup status: Stage G1B adds the short alias and keeps the lintegral-to-real-expectation bridge explicit.
- Target module: `HighDimProb/Concentration/Markov.lean`
- Priority: scalar concentration proof spine

## Chebyshev inequality
- Book heading: `集中不等式`, classical probability inequalities
- Informal statement: deviations from the mean are controlled by variance.
- Target Lean statement: `chebyshev_inequality`; probability-facing wrapper `chebyshev_inequality_prob`
- Required objects: `absTailProb`, `centered`, `variance`, `MemLpRealRandomVariable`.
- Required definitions: finite second moment through `MemLpRealRandomVariable P X 2`.
- Required bridge lemmas: Mathlib `ProbabilityTheory.meas_ge_le_variance_div_sq`.
- Status: proven
- Blocker: none for the finite-measure `L^2` formulation. Centered-variable and variance vocabulary now lives in scalar leaf modules rather than the vector-heavy covariance module.
- API cleanup status: Stage G1B adds the `[IsProbabilityMeasure P]` wrapper and removes the direct `HighDimProb.Covariance` import from Chebyshev.
- Target module: `HighDimProb/Concentration/Chebyshev.lean`
- Priority: scalar concentration proof spine

## psi2 Orlicz bound implies subGaussian tail
- Book heading: `次高斯性质`, `次高斯范数`, Orlicz characterization
- Informal statement: if the exponential-square Orlicz bound holds at scale `K`, then the absolute tail has Gaussian decay with the same scale and constant `2`.
- Target Lean statement: `subGaussianTail_of_psi2Bound`
- Required objects: `Psi2Bound`, `SubGaussianTail`, `absTailProb`, `IsRealRandomVariable`, `IsProbabilityMeasure`.
- Required definitions: ψ₂ bound via shifted exponential `lintegral`, two-sided absolute-tail predicate, positive scale.
- Required bridge lemmas: `lintegral_exp_sq_div_le_two_of_psi2Bound`, Mathlib `MeasureTheory.meas_ge_le_lintegral_div`, exponential monotonicity, square monotonicity, `ENNReal.ofReal` division bridge.
- Status: proven
- Blocker: none for the probability-measure/measurable-variable formulation. The full equivalence theorem and gauge/norm formulations remain future work.
- Target module: `HighDimProb/Concentration/OrliczToTail.lean`
- Priority: scalar concentration proof spine

## psi1 Orlicz bound implies subExponential tail
- Book heading: `次指数性质`, `次指数范数`, Orlicz characterization
- Informal statement: if the exponential-linear Orlicz bound holds at scale `K`, then the absolute tail has exponential decay with the same scale and constant `2`.
- Target Lean statement: `subExponentialTail_of_psi1Bound`
- Required objects: `Psi1Bound`, `SubExponentialTail`, `absTailProb`, `IsRealRandomVariable`, `IsProbabilityMeasure`.
- Required definitions: ψ₁ bound via shifted exponential `lintegral`, two-sided absolute-tail predicate, positive scale.
- Required bridge lemmas: `lintegral_exp_abs_div_le_two_of_psi1Bound`, Mathlib `MeasureTheory.meas_ge_le_lintegral_div`, exponential monotonicity, `ENNReal.ofReal` division bridge.
- Status: proven
- Blocker: none for the probability-measure/measurable-variable formulation. The full equivalence theorem and gauge/norm formulations remain future work.
- Target module: `HighDimProb/Concentration/OrliczToTail.lean`
- Priority: scalar concentration proof spine

## subGaussian tail implies psi2 Orlicz bound
- Book heading: subGaussian Orlicz characterization
- Informal statement: a two-sided subGaussian tail bound at scale `K` should imply a shifted exponential-square Orlicz bound at scale `2 * K`.
- Target Lean statement: `psi2Bound_of_subGaussianTail`.
- Required objects: `SubGaussianTail`, `Psi2Bound`, `absTailProb`, `IsRealRandomVariable`, `IsProbabilityMeasure`.
- Required definitions: shifted `Psi2Bound` lintegral, absolute-tail probability, positive scale from the tail predicate.
- Required bridge lemmas: `lintegral_exp_quarter_sub_one_le_of_exp_tail`, `lintegral_exp_sq_div_four_sub_one_le_of_subGaussianTail`, Mathlib layer-cake formula, and Mathlib improper integral evaluation for exponential decay.
- Status: proven
- Blocker: none for the fixed-scale `2 * K` formulation with explicit measurability.
- Target module: `HighDimProb/Concentration/TailToOrlicz.lean`
- Priority: scalar concentration proof spine

## subExponential tail implies psi1 Orlicz bound
- Book heading: subExponential Orlicz characterization
- Informal statement: a two-sided subExponential tail bound at scale `K` should imply a shifted exponential-linear Orlicz bound at scale `3 * K`.
- Target Lean statement: `psi1Bound_of_subExponentialTail`.
- Required objects: `SubExponentialTail`, `Psi1Bound`, `absTailProb`, `IsRealRandomVariable`, `IsProbabilityMeasure`.
- Required definitions: shifted `Psi1Bound` lintegral, absolute-tail probability, positive scale from the tail predicate.
- Required bridge lemmas: `lintegral_exp_third_sub_one_le_of_exp_tail`, `lintegral_exp_abs_div_three_sub_one_le_of_subExponentialTail`, Mathlib layer-cake formula, and Mathlib improper integral evaluation for exponential decay.
- Status: proven
- Blocker: none for the fixed-scale `3 * K` formulation with explicit measurability.
- Target module: `HighDimProb/Concentration/TailToOrlicz.lean`
- Priority: scalar concentration proof spine

## Jensen inequality
- Book heading: `经典不等式`
- Informal statement: convex functions move outside expectations in the standard direction.
- Target Lean statement: HighDimProb usage examples around Mathlib Jensen inequalities.
- Required objects: `expect`, convex functions, integrability.
- Required definitions: integrable real/vector random-variable vocabulary.
- Required bridge lemmas: expectation alias and Mathlib integral Jensen statement.
- Status: informal
- Blocker: no HighDimProb integrability wrapper yet.
- Target module: `HighDimProb/Expectation.lean`
- Priority: v0.2

## Holder inequality
- Book heading: `经典不等式`
- Informal statement: products are bounded by conjugate `L^p` norms.
- Target Lean statement: wrapper or examples around Mathlib Holder/mean inequality APIs.
- Required objects: `MemLp`, `eLpNorm`, real random variables.
- Required definitions: Lp wrapper layer.
- Required bridge lemmas: product measurability and Lp norm notation.
- Status: informal
- Blocker: Stage 1A intentionally avoids Lp exponent abstraction.
- Target module: `HighDimProb/Lp.lean`
- Priority: v0.2

## Minkowski inequality
- Book heading: `经典不等式`
- Informal statement: `L^p` seminorms satisfy a triangle inequality.
- Target Lean statement: wrapper or examples around Mathlib Minkowski/eLpNorm APIs.
- Required objects: `MemLp`, `eLpNorm`, addition of random variables.
- Required definitions: Lp wrapper layer.
- Required bridge lemmas: sum measurability and Lp norm notation.
- Status: informal
- Blocker: Stage 1A intentionally avoids Lp exponent abstraction.
- Target module: `HighDimProb/Lp.lean`
- Priority: v0.2

## subGaussian definition equivalences
- Book heading: `次高斯性质`, `次高斯随机变量`, `次高斯范数`
- Informal statement: tail, moment, MGF, and Orlicz characterizations of subGaussian variables are equivalent up to constants.
- Target Lean statement: blocked until a precise equivalence statement and constants are selected.
- Required objects: real random variables, tail probabilities, moments, Mathlib MGF predicate, ψ₂ Orlicz control.
- Required definitions: `SubGaussianTail`, `SubGaussianMoment`, `CenteredSubGaussianMGF`, `SubGaussianOrlicz`, `HasSubGaussianOrlicz`; Stage G1C proves the ψ₂-to-tail direction.
- Required bridge lemmas: expectation of exponentials, tail/moment integration.
- Status: blocked
- Blocker: fixed-scale `Psi2Bound -> SubGaussianTail` and `SubGaussianTail -> Psi2Bound (2*K)` are proven, but moment/MGF connections, finite-gauge variants, gauge/norm objects, and canonical predicate choice remain future work.
- Target module: `HighDimProb/SubGaussian.lean`
- Priority: v0.3

## subExponential definition equivalences
- Book heading: `次指数性质`, `次指数随机变量`, `次指数范数`
- Informal statement: tail, moment, MGF, and Orlicz characterizations of subExponential variables are equivalent up to constants.
- Target Lean statement: blocked until a precise equivalence statement and constants are selected.
- Required objects: real random variables, tail probabilities, moments, exponential moments, ψ₁ Orlicz control.
- Required definitions: `SubExponentialTail`, `SubExponentialMoment`, `CenteredSubExponentialMGF`, `SubExponentialOrlicz`, `HasSubExponentialOrlicz`; Stage G1C proves the ψ₁-to-tail direction and Stage S2 proves the fixed-scale tail-to-ψ₁ direction.
- Required bridge lemmas: expectation of exponentials, tail/moment integration.
- Status: blocked
- Blocker: fixed-scale `Psi1Bound -> SubExponentialTail` and `SubExponentialTail -> Psi1Bound (3*K)` are proven, but moment/MGF connections, finite-gauge variants, gauge/norm objects, and canonical predicate choice remain future work.
- Target module: `HighDimProb/SubExponential.lean`
- Priority: v0.3

## bounded random variable is subGaussian
- Book heading: `次高斯分布的例子`
- Informal statement: bounded real-valued random variables are subGaussian with scale controlled by the bound.
- Target Lean statement: blocked until the target formulation is selected.
- Required objects: boundedness, real random variables, subGaussian predicate forms.
- Required definitions: bounded-a.s. predicate or pointwise bounded predicate.
- Required bridge lemmas: boundedness to tail/MGF/Orlicz criterion.
- Status: blocked
- Blocker: subGaussian formulation predicates exist, but boundedness vocabulary and theorem proof are deferred.
- Target module: `HighDimProb/SubGaussian.lean`
- Priority: v0.3

## centered subGaussian mgf characterization
- Book heading: `中心化`, `次高斯性质`
- Informal statement: a centered subGaussian variable has Gaussian-type MGF bounds, and conversely under suitable constants.
- Target Lean statement: blocked until centeredness and constants are settled.
- Required objects: `Centered`, `expect`, exponential function, `CenteredSubGaussianMGF`.
- Required definitions: centeredness vocabulary and MGF-bound predicate.
- Required bridge lemmas: centering and exponential integrability.
- Status: blocked
- Blocker: MGF predicate exists via Mathlib wrapper, but centeredness is still experimental and no theorem is assigned.
- Target module: `HighDimProb/SubGaussian.lean`
- Priority: v0.3

## centered subExponential mgf characterization
- Book heading: `次指数性质`, `中心化`
- Informal statement: a centered subExponential variable admits local quadratic MGF control, and conversely under suitable constants.
- Target Lean statement: blocked until centeredness and constants are settled.
- Required objects: `Centered`, `expect`, exponential function, `CenteredSubExponentialMGF`.
- Required definitions: centeredness vocabulary and local-MGF-bound predicate.
- Required bridge lemmas: centering and exponential integrability.
- Status: blocked
- Blocker: local MGF predicate exists, but centeredness is still experimental and no theorem is assigned.
- Target module: `HighDimProb/SubExponential.lean`
- Priority: v0.3

## subGaussian square is subExponential
- Book heading: `次指数分布与次高斯分布的关系`
- Informal statement: the square of a subGaussian random variable is subExponential.
- Target Lean statement: blocked until the target formulations and square/product random-variable API are selected.
- Required objects: subGaussian variables, subExponential variables, square random variable.
- Required definitions: subGaussian and subExponential predicate forms.
- Required bridge lemmas: square measurability and Orlicz/MGF estimates.
- Status: blocked
- Blocker: predicate forms exist, but product/square random-variable and equivalence theorem work is deferred.
- Target module: `HighDimProb/SubExponential.lean`
- Priority: v0.3

## product of subGaussian variables is subExponential
- Book heading: `次指数分布与次高斯分布的关系`
- Informal statement: the product of two subGaussian random variables is subExponential.
- Target Lean statement: blocked until both predicate layers and multiplication API are stable.
- Required objects: subGaussian variables, subExponential variables, product random variable.
- Required definitions: subGaussian and subExponential predicate forms.
- Required bridge lemmas: product measurability and Orlicz/MGF estimates.
- Status: blocked
- Blocker: predicate forms exist, but product random-variable and equivalence theorem work is deferred.
- Target module: `HighDimProb/SubExponential.lean`
- Priority: v0.3

## Bernstein inequality
- Book heading: `伯恩斯坦不等式`
- Informal statement: sums of independent centered subExponential variables satisfy Bernstein-type tail bounds.
- Target Lean statement: blocked until independence, sums, centeredness, and a target subExponential formulation are stable.
- Required objects: finite families of random variables, independence, centeredness, subExponential predicate.
- Required definitions: finite-sum random-variable API.
- Required bridge lemmas: independence and sum measurability bridges.
- Status: blocked
- Blocker: subExponential predicate forms exist, but the theorem is beyond the object layer.
- Target module: `HighDimProb/SubExponential.lean`
- Priority: v0.3

## Hoeffding inequality
- Book heading: `霍夫丁不等式`, `广义霍夫丁不等式一`, `广义霍夫丁不等式二`
- Informal statement: sums of independent bounded or subGaussian centered variables have Gaussian-type tails.
- Target Lean statement: blocked until finite sums and the target subGaussian formulation are selected.
- Required objects: finite families, independence, boundedness, centeredness, subGaussian predicate forms.
- Required definitions: finite-sum random-variable API.
- Required bridge lemmas: sum measurability and variance/scale bookkeeping.
- Status: blocked
- Blocker: concentration inequalities are forbidden before theorem layer.
- Target module: `HighDimProb/SubGaussian.lean`
- Priority: v0.3

## high-dimensional subGaussian vector characterizations
- Book heading: `高维次高斯分布`, `次高斯范数`
- Informal statement: a random vector is subGaussian when all one-dimensional marginals are subGaussian; the usual norm is a supremum over unit directions.
- Target Lean statement: blocked until scalar equivalence theorems, ψ₂ gauges/norms, and unit-sphere vocabulary are available.
- Required objects: `RandomVector`, `marginal`, `directionNorm`, scalar subGaussian predicate forms.
- Required definitions: Stage 4D predicate forms `SubGaussianVectorOrlicz`, `HasSubGaussianVectorOrlicz`, `SubGaussianVectorTail`, `SubGaussianVectorMoment`, and `CenteredSubGaussianVectorMGF` exist.
- Required bridge lemmas: scalar subGaussian equivalences, scaling of marginals, all-direction/unit-sphere equivalence.
- Status: blocked
- Blocker: Stage 4D only provides object-level predicate forms and does not define ψ₂ vector norms or prove equivalences.
- Target module: `HighDimProb/SubGaussianVector.lean`
- Priority: v0.2

## centered vector iff coordinatewise centered
- Book heading: `高维空间的协方差矩阵`, `各向同性`
- Informal statement: vector centeredness is exactly coordinatewise scalar centeredness.
- Target Lean statement: `centeredVector_iff_forall_centered_coord`
- Required objects: `RandomVector`, `coord`, `Centered`, `CenteredVector`.
- Required bridge lemmas: none beyond definitional unfolding.
- Status: proven
- Blocker: none.
- Target module: `HighDimProb/Covariance.lean`
- Priority: v0.2 proof pilot

## centered random variable has mean zero
- Book heading: `高维空间的协方差矩阵`, `中心化`
- Informal statement: if a real random variable is integrable, then subtracting its mean produces a centered random variable.
- Target Lean statement: `centered_centered`
- Required objects: `expect`, `mean`, `centered`, `Centered`, `IntegrableRealRandomVariable`, probability measure convention.
- Required bridge lemmas: Mathlib `integral_sub`, `integrable_const`, `integral_const`, and `[IsProbabilityMeasure P]` mass-one simplification.
- Status: proven
- Blocker: none.
- Target module: `HighDimProb/Covariance.lean`
- Priority: v0.2 proof pilot

## isotropic second-moment matrix iff entrywise formulation
- Book heading: `各向同性`
- Informal statement: the matrix identity `E[XXᵀ] = I` is equivalent to the coordinate identities `E[X_i X_j] = δᵢⱼ`.
- Target Lean statement: `isotropicSecondMomentMatrix_iff_isotropicSecondMoment`
- Required objects: `RandomVector`, `secondMomentMatrixEntry`, `secondMomentMatrix`, `IsotropicSecondMoment`, `IsotropicSecondMomentMatrix`.
- Required bridge lemmas: Mathlib `Matrix.ext` and `Matrix.one_apply`.
- Status: proven
- Blocker: none.
- Target module: `HighDimProb/Isotropic.lean`
- Priority: v0.2 proof pilot

## random vector isotropic characterizations
- Book heading: `各向同性`
- Informal statement: isotropicity is characterized by identity covariance and by second moments of one-dimensional marginals.
- Target Lean statement: blocked until integrability assumptions and exact equivalence directions are selected.
- Required objects: `RandomVector`, `coord`, `linearForm`, `CenteredVector`, `covarianceMatrix`, `secondMomentMatrix`, expectation.
- Required definitions: Stage 4A random-vector object layer, Stage 4B covariance vocabulary, Stage 4C predicate forms, and the Stage P2 matrix/entrywise second-moment bridge exist.
- Required bridge lemmas: coordinate covariance and inner-product moment identities.
- Status: blocked
- Blocker: equivalence proofs need covariance/second-moment algebra, finite-sum expansion of `linearForm`, and integrability or finite-second-moment hypotheses.
- Target module: `HighDimProb/Isotropic.lean`
- Priority: v0.2

## covariance identity
- Book heading: `高维空间的协方差矩阵`, `随机过程的协方差`
- Informal statement: covariance can be expressed as a centered second moment and has standard bilinear identities.
- Target Lean statement: blocked until integrability assumptions and exact theorem shape are selected.
- Required objects: `RandomVector`, `coord`, `mean`, `secondMoment`, `covariance`, `secondMomentMatrix`, `covarianceMatrix`.
- Required definitions: scalar and random-vector covariance vocabulary exists; process covariance remains future work.
- Required bridge lemmas: algebra of Bochner integrals.
- Status: blocked
- Blocker: integrability and finite-second-moment assumptions are not yet part of the covariance API.
- Target module: `HighDimProb/Covariance.lean`
- Priority: v0.2

## maximal separated set is an epsilon-net
- Book heading: `分离集与网`
- Informal statement: a maximal epsilon-separated subset of `K` is an epsilon-net for `K`.
- Target Lean statement: `isInternalEpsilonNet_of_maximalEpsilonSeparatedIn`
- Required objects: `MaximalEpsilonSeparatedIn`, `IsEpsilonSeparated`, `IsEpsilonNet`, `IsInternalEpsilonNet`, `Set.Subset`.
- Required definitions: Stage 5A net and separated-set vocabulary plus Stage P1 single-point maximality predicate.
- Required bridge lemmas: Mathlib `Metric.isSeparated_insert_of_notMem` and the definitional wrappers `epsilonRadius` / `epsilonERadius`.
- Status: proven
- Blocker: none.
- Target module: `HighDimProb/Nets.lean`
- Priority: v0.2

## covering number upper bound from an epsilon-net
- Book heading: `覆盖数`
- Informal statement: any internal epsilon-net bounds the covering number by its cardinality.
- Target Lean statement: `epsilonNetCoveringNumberStatement`
- Required objects: `IsEpsilonNet`, `coveringNumber`, `Set.encard`.
- Required definitions: Stage 5A Mathlib-backed covering number vocabulary.
- Required bridge lemmas: Mathlib `Metric.IsCover.coveringNumber_le_encard` through the HighDimProb real-radius wrapper.
- Status: typed-prop
- Blocker: proof deferred; real-radius bridge lemmas are not added in Stage 5B.
- Target module: `HighDimProb/MetricEntropyStatements.lean`
- Priority: v0.2

## covering-packing inequalities
- Book heading: `覆盖数与填充数`
- Informal statement: packing and covering numbers bound each other at related radii: `P(K, 2 eps) <= N(K, eps) <= P(K, eps)`.
- Target Lean statement: `packingCoveringInequalityStatement`
- Required objects: `IsEpsilonNet`, `IsEpsilonSeparated`, `coveringNumber`, `externalCoveringNumber`, `packingNumber`.
- Required definitions: Stage 5A Mathlib-backed metric entropy vocabulary exists.
- Required bridge lemmas: Mathlib `Metric.packingNumber_two_mul_le_externalCoveringNumber`, `Metric.externalCoveringNumber_le_coveringNumber`, `Metric.coveringNumber_le_packingNumber`, and real-radius conversion lemmas.
- Status: typed-prop
- Blocker: proof deferred; the statement typechecks, but no theorem wrapper is added in Stage 5B.
- Target module: `HighDimProb/MetricEntropyStatements.lean`
- Priority: v0.2

## Euclidean ball covering number bounds
- Book heading: `欧几里得球的覆盖数`
- Informal statement: covering numbers of Euclidean balls are bounded above and below by standard volume-scale estimates.
- Target Lean statement: blocked until Euclidean ball, finite-dimensional volume, and finite/infinite cardinal conventions are selected.
- Required objects: Euclidean balls, `coveringNumber`, volume or cardinal estimates.
- Required definitions: Euclidean-space bridge and finite-dimensional volume vocabulary.
- Required bridge lemmas: volume comparison for balls and conversion from volume bounds to covering numbers.
- Status: blocked
- Blocker: Euclidean geometry and volume bridge layer are not active.
- Target module: `HighDimProb/MetricEntropy.lean`
- Priority: v0.3

## Hamming cube covering and packing bounds
- Book heading: `汉明立方体的覆盖数和填充数`
- Informal statement: covering and packing estimates for the Hamming cube depend on a chosen finite cube representation and Hamming metric.
- Target Lean statement: blocked until the Hamming cube and Hamming metric object layer is selected.
- Required objects: finite binary cube, Hamming distance, covering and packing numbers.
- Required definitions: Hamming cube representation and metric-space instance.
- Required bridge lemmas: counting bounds for Hamming balls and separated subsets.
- Status: blocked
- Blocker: no Hamming cube metric vocabulary exists in HighDimProb.
- Target module: `HighDimProb/MetricEntropy.lean`
- Priority: v0.3

## epsilon-net and operator norm bound
- Book heading: `$\\varepsilon$-网与算子范数`
- Informal statement: operator norm over a sphere can be controlled using an epsilon-net.
- Target Lean statement: `epsilonNetOperatorNormStatement`.
- Required objects: epsilon nets, matrices, operator norm, unit sphere.
- Required definitions: Stage 5A Mathlib-backed net predicate `IsEpsilonNet` exists; Stage 6A random matrix entries and actions exist; Stage 6B adds `operatorNorm`.
- Required bridge lemmas: finite net approximation, unit-sphere cover bridge, Matrix-to-linear-map/L2 operator-norm bridge, and `operatorNorm` comparison lemmas.
- Status: typed-prop
- Blocker: proof bridge lemmas are not active yet; the typed statement uses the existing function-space unit sphere and Mathlib L2 matrix norm convention.
- Target module: `HighDimProb/RandomMatrix/Statements.lean`
- Priority: v0.3

## metric entropy as log covering number
- Book heading: `度量熵`
- Informal statement: metric entropy is represented as the logarithm of the covering number.
- Target Lean statement: blocked; `metricEntropyLogCoveringStatement` is not added.
- Required objects: `coveringNumber`, real logarithm, finite-cover or infinity convention.
- Required definitions: real-valued metric entropy wrapper.
- Required bridge lemmas: conversion from Mathlib `ℕ∞` covering numbers to a finite real count before applying `Real.log`.
- Status: blocked
- Blocker: no convention yet for `Real.log` of `ℕ∞` values or infinite covering numbers.
- Target module: `HighDimProb/MetricEntropy.lean`
- Priority: v0.2

## metric entropy coding interpretation
- Book heading: `度量熵`
- Informal statement: logarithms of covering numbers quantify coding complexity up to radius changes.
- Target Lean statement: blocked until a real-valued metric entropy convention and coding vocabulary are selected.
- Required objects: `coveringNumber`, possible finite-cover hypothesis, real logarithm, coding/bit-count vocabulary.
- Required definitions: Stage 5A exposes Mathlib `ℕ∞` covering numbers; `metricEntropy` real-log wrapper is deferred.
- Required bridge lemmas: finite/infinite count handling, base-change for logarithms, and coding interpretation lemmas.
- Status: blocked
- Blocker: no real-log covering-number convention and no coding vocabulary exist yet.
- Target module: `HighDimProb/MetricEntropy.lean`
- Priority: v0.3

## Dudley integral dependency on covering numbers
- Book heading: `Dudley积分不等式`
- Informal statement: Dudley-type bounds depend on integrals of square roots of logarithmic covering numbers.
- Target Lean statement: blocked until random-process, entropy-integral, and real-valued metric entropy vocabulary are active.
- Required objects: random processes, subGaussian increments, `coveringNumber`, entropy integral, real logarithm.
- Required definitions: process supremum, entropy integral, and real-valued metric entropy convention.
- Required bridge lemmas: measurability of process suprema, entropy integral estimates, and covering-number monotonicity.
- Status: blocked
- Blocker: random process theorem vocabulary, Gaussian-width/generic-chaining vocabulary, and metric entropy real-log convention are not active.
- Target module: `HighDimProb/RandomProcess.lean`
- Priority: v1.0

## subGaussian random matrix norm bound
- Book heading: `带有次高斯元素矩阵的范数`, `次高斯矩阵的双侧界`
- Informal statement: random matrices with independent subGaussian entries or rows have high-probability operator norm/singular value bounds.
- Target Lean statement: blocked until random matrix independence and high-probability assumption vocabulary exist.
- Required objects: `RandomMatrix`, `matrixEntry`, `rowVector`, `matVec`, `operatorNorm`, independence, subGaussian predicates.
- Required definitions: Stage 6A matrix-valued random-variable predicates, row/column views, action vocabulary, and entry/row subGaussian predicates exist; Stage 6B adds `operatorNorm`.
- Required bridge lemmas: operator norm bridge lemmas, independent entries or rows, entry/row measurability, and net-to-operator-norm bounds.
- Status: blocked
- Blocker: independence predicates and operator-norm proof bridges are deferred; theorem is beyond object layer.
- Target module: future `HighDimProb/RandomMatrix/Statements.lean`
- Priority: v0.3

## sample covariance concentration
- Book heading: `协方差估计`, `一般协方差估计`
- Informal statement: the empirical or sample covariance matrix of independent subGaussian samples concentrates around the population covariance.
- Target Lean statement: blocked until independence, centered/empirical covariance conventions, and operator-norm theorem bridges exist.
- Required objects: `RandomMatrix`, row samples, `sampleCovariance`, covariance matrix, `operatorNorm`, row subGaussian/isotropic assumptions.
- Required definitions: Stage 6A row and assumption predicates exist; Stage 6B adds `sampleCovariance`, `gramMatrix`, and `operatorNorm`.
- Required bridge lemmas: matrix multiplication/scaling convention, row independence, expectation/covariance bridge, and operator-norm bridge lemmas.
- Status: blocked
- Blocker: row independence, centered/empirical covariance conventions, and operator-norm proof bridges are deferred.
- Target module: future `HighDimProb/RandomMatrix/Statements.lean`
- Priority: v0.3

## Hanson-Wright inequality
- Book heading: `Hanson-Wright不等式`
- Informal statement: quadratic forms of independent centered subGaussian vectors concentrate around their mean.
- Target Lean statement: blocked until independence-coordinate and centered-vector assumption vocabulary is available.
- Required objects: `RandomVector`, deterministic or random matrices, `quadraticForm`, subGaussian coordinates, Frobenius/operator norms.
- Required definitions: Stage 4A random-vector object layer exists; Stage 6A random matrix and Frobenius vocabulary exist; Stage 6B adds `quadraticForm`, `bilinearForm`, and `operatorNorm`.
- Required bridge lemmas: independence assumptions, quadratic-form moment/MGF estimates, and Frobenius/operator-norm bridge lemmas.
- Status: blocked
- Blocker: independence assumptions and analytic concentration infrastructure are missing.
- Target module: future `HighDimProb/RandomMatrix/Statements.lean`
- Priority: v0.3

## Johnson-Lindenstrauss lemma
- Book heading: `Johnson-Lindenstrauss引理`, `Johnson-Lindenstrauss嵌入`
- Informal statement: suitable random projections preserve pairwise distances with high probability.
- Target Lean statement: blocked until random projection and metric embedding vocabulary exists.
- Required objects: `RandomMatrix`, `matVec`, `operatorNorm`, finite sets, Euclidean distances, probability events.
- Required definitions: Stage 6A matrix-vector action exists; Stage 6B adds `operatorNorm`; random projection model and distortion predicate remain future work.
- Required bridge lemmas: fixed-vector concentration, norm preservation predicate, operator-norm/action bridge lemmas, and random projection scaling convention.
- Status: blocked
- Blocker: random projection vocabulary and concentration layers are not ready.
- Target module: future `HighDimProb/RandomMatrix/Statements.lean`
- Priority: v0.3

## covariance estimation
- Book heading: `协方差估计`, `一般协方差估计`, `低维分布的协方差估计`
- Informal statement: empirical covariance of subGaussian samples approximates the population covariance with high probability.
- Target Lean statement: blocked until empirical covariance conventions, independence, and concentration APIs exist.
- Required objects: `RandomVector`, `RandomMatrix`, samples, covariance matrices, `sampleCovariance`, matrix norms.
- Required definitions: Stage 6A random matrix rows exist; Stage 6B adds uncentered `sampleCovariance` and `operatorNorm`.
- Required bridge lemmas: sample independence, sample covariance algebra, centered/empirical covariance convention, and matrix concentration.
- Status: blocked
- Blocker: independence, centered/empirical covariance, and concentration infrastructure are not ready.
- Target module: future `HighDimProb/RandomMatrix/Statements.lean`
- Priority: v0.3

## matrix Bernstein inequality
- Book heading: `矩阵伯恩斯坦不等式`, `矩阵不等式`
- Informal statement: sums of independent centered random matrices with bounded operator norm satisfy Bernstein-type spectral tail bounds.
- Target Lean statement: blocked until symmetric/random matrix sums, operator norm, variance proxy, and matrix independence APIs exist.
- Required objects: random matrices, symmetric matrix predicate, centered matrix variables, `operatorNorm`, variance proxy, independence.
- Required definitions: Stage 6A random matrix object layer exists; Stage 6B adds `operatorNorm`; no symmetric random matrix or matrix-sum assumption layer exists yet.
- Required bridge lemmas: matrix-valued measurability, operator-norm bridge lemmas, independence of matrix-valued variables, and self-adjoint dilation if rectangular variants are used.
- Status: blocked
- Blocker: theorem is beyond the object layer and requires symmetric/random-matrix-sum, operator-norm bridge, and independence infrastructure.
- Target module: future `HighDimProb/RandomMatrix/Statements.lean`
- Priority: v0.4

## matrix deviation inequality
- Book heading: `一般协方差估计`, random matrix deviation estimates
- Informal statement: empirical matrix deviations such as `sampleCovariance A - Sigma` are controlled in operator norm under sampling and moment assumptions.
- Target Lean statement: blocked until centered empirical covariance, matrix subtraction/norm events, independence, and concentration APIs exist.
- Required objects: `sampleCovariance`, `operatorNorm`, covariance matrices, random matrix rows, row assumptions.
- Required definitions: Stage 6B adds uncentered sample covariance and operator-norm vocabulary.
- Required bridge lemmas: sample covariance algebra, centered/empirical covariance convention, operator-norm measurability, row independence, and matrix concentration.
- Status: blocked
- Blocker: object vocabulary exists only at the uncentered level; theorem dependencies remain future work.
- Target module: future `HighDimProb/RandomMatrix/Statements.lean`
- Priority: v0.4

## generic chaining / Dudley inequality
- Book heading: `Dudley积分不等式`, `通用链界`
- Informal statement: expected suprema of subGaussian processes are controlled by entropy integrals or chaining functionals.
- Target Lean statement: blocked until random-process, metric entropy, and Gaussian-width vocabulary are stable.
- Required objects: random processes, subGaussian increments, covering numbers, gamma2 functional.
- Required definitions: admissible sequences, entropy integral, process supremum.
- Required bridge lemmas: measurability of suprema and entropy estimates.
- Status: blocked
- Blocker: random process and metric entropy layers need object-level work.
- Target module: `HighDimProb/RandomProcess.lean`
- Priority: v1.0

## empirical process bounds
- Book heading: `经验过程`, `经验过程与VC维数`, `一致大数定律`
- Informal statement: uniform deviations of empirical averages are controlled by VC dimension, entropy, or chaining bounds.
- Target Lean statement: blocked until empirical measure/process objects and complexity notions exist.
- Required objects: samples, empirical measures, function classes, supremum deviations.
- Required definitions: empirical measure and VC dimension vocabulary.
- Required bridge lemmas: symmetrization and measurability of suprema.
- Status: blocked
- Blocker: empirical process object layer is not stable.
- Target module: `HighDimProb/EmpiricalProcess.lean`
- Priority: v1.0

## signal recovery via M* bound
- Book heading: `M*界`, `基于M*界的信号恢复`, `逃逸定理`
- Informal statement: random measurements recover structured signals with error controlled by geometric width terms.
- Target Lean statement: blocked until random matrices, convex geometry, Gaussian width, and optimization vocabulary exist.
- Required objects: random matrices, kernels, Gaussian width, convex sets, recovery maps.
- Required definitions: measurement model, recovery objective, feasible set.
- Required bridge lemmas: M* bound and escape theorem.
- Status: blocked
- Blocker: late theorem layer with missing optimization infrastructure.
- Target module: `HighDimProb/SignalRecovery.lean`
- Priority: v1.0

## a.e.-nonnegative Markov inequality
- Book heading: scalar concentration foundations
- Informal statement: if a real random variable is integrable and nonnegative almost everywhere, then its upper tail is bounded by its expectation divided by a positive threshold.
- Target Lean statement: `markov_inequality_ae_nonneg`
- Required objects: `upperTailProb`, `expect`, `IntegrableRealRandomVariable`, `Filter.Eventually`, `ae`.
- Required definitions: Stage G1A/G1B concentration branch and Stage S3 a.e. lintegral-expectation bridge.
- Required bridge lemmas: `lintegral_ofReal_eq_ofReal_expect_ae_nonneg`, Mathlib `MeasureTheory.meas_ge_le_lintegral_div`.
- Status: proven
- Blocker: none.
- Target module: `HighDimProb/Concentration/Markov.lean`
- Priority: small proof battery

## scalar variance nonnegativity
- Book heading: scalar variance and Chebyshev prerequisites
- Informal statement: scalar variance is nonnegative.
- Target Lean statement: `variance_nonneg`
- Required objects: `variance`, `RealRandomVariable`, `Measure`.
- Required definitions: scalar variance wrapper around Mathlib variance.
- Required bridge lemmas: Mathlib `ProbabilityTheory.variance_nonneg`.
- Status: proven
- Blocker: none.
- Target module: `HighDimProb/Scalar/Variance.lean`
- Priority: small proof battery

## centered variance invariance
- Book heading: scalar variance and centered random variables
- Informal statement: subtracting the mean from a measurable scalar random variable preserves its variance.
- Target Lean statement: `variance_centered_eq_variance`
- Required objects: `centered`, `variance`, `IsRealRandomVariable`, `IsProbabilityMeasure`.
- Required definitions: scalar centering and variance leaves.
- Required bridge lemmas: Mathlib `ProbabilityTheory.variance_sub_const`.
- Status: proven
- Blocker: none.
- Target module: `HighDimProb/Scalar/Variance.lean`
- Priority: small proof battery

## explicit epsilon-net bounds covering number
- Book heading: covering numbers and nets
- Informal statement: an explicit epsilon-net bounds the corresponding covering number by the cardinality of its centers.
- Target Lean statement: `externalCoveringNumber_le_encard_of_isEpsilonNet`, `externalCoveringNumber_le_card_of_isEpsilonNet`, `coveringNumber_le_encard_of_isInternalEpsilonNet`, `coveringNumber_le_card_of_isInternalEpsilonNet`
- Required objects: `IsEpsilonNet`, `IsInternalEpsilonNet`, `externalCoveringNumber`, `coveringNumber`, `Set.encard`, `Set.ncard`.
- Required definitions: Stage 5A Mathlib-backed nets and metric entropy wrappers.
- Required bridge lemmas: Mathlib `Metric.IsCover.externalCoveringNumber_le_encard`, `Metric.IsCover.coveringNumber_le_encard`, and finite-cardinality coercion through `Set.Finite.cast_ncard_eq`.
- Status: proven
- Blocker: none.
- Target module: `HighDimProb/MetricEntropy.lean`
- Priority: small proof battery

## isotropic covariance implies centered vector
- Book heading: isotropic random vectors
- Informal statement: covariance-form isotropicity includes vector centeredness.
- Target Lean statement: `IsotropicCovariance.centeredVector`
- Required objects: `IsotropicCovariance`, `CenteredVector`.
- Required definitions: covariance-form isotropic predicate.
- Required bridge lemmas: none; this is the first projection of the predicate.
- Status: proven
- Blocker: none.
- Target module: `HighDimProb/Isotropic.lean`
- Priority: small proof battery

## Frobenius square nonnegativity
- Book heading: random matrix norm vocabulary
- Informal statement: the squared Frobenius norm random variable is nonnegative pointwise.
- Target Lean statement: `frobeniusSq_nonneg`
- Required objects: `RandomMatrix`, `frobeniusSq`.
- Required definitions: explicit finite-sum Frobenius-square vocabulary.
- Required bridge lemmas: Mathlib/Lean finite-sum nonnegativity and `sq_nonneg`.
- Status: proven
- Blocker: none.
- Target module: `HighDimProb/RandomMatrix/Norms.lean`
- Priority: small proof battery

## sample covariance diagonal nonnegativity
- Book heading: sample covariance vocabulary
- Informal statement: diagonal entries of the uncentered sample covariance matrix are nonnegative, including the empty-row case.
- Target Lean statement: `sampleCovarianceEntry_diag_nonneg`
- Required objects: `RandomMatrix`, `sampleCovarianceEntry`, `gramMatrixEntry`.
- Required definitions: row-as-samples uncentered sample covariance.
- Required bridge lemmas: finite-sum nonnegativity, `sq_nonneg`, and nonnegativity of `(1 / (m : Real))`.
- Status: proven
- Blocker: none.
- Target module: `HighDimProb/RandomMatrix/SampleCovariance.lean`
- Priority: small proof battery

## sample covariance quadratic form nonnegativity
- Book heading: sample covariance and PSD prerequisites
- Informal statement: the quadratic form of the uncentered sample covariance matrix should be nonnegative.
- Target Lean statement: `quadraticForm_sampleCovariance_nonneg`
- Required objects: `sampleCovariance`, `quadraticForm`, finite sums.
- Required definitions: sample covariance and quadratic form vocabulary.
- Required bridge lemmas: a finite-sum algebra identity rewriting `x^T ((1/m) A^T A) x` as `(1/m) * sum k, (sum i, A k i * x i)^2`.
- Status: blocked
- Blocker: the needed reindexing/distributivity bridge between the explicit double-sum quadratic form and row-dot-square form is not implemented.
- Target module: future `HighDimProb/RandomMatrix/SampleCovarianceTheorems.lean` or `HighDimProb/RandomMatrix/QuadraticForm.lean`
- Priority: Stage RM2
