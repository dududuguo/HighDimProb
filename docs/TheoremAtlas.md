# Theorem Atlas

Stage 1S records theorem/result families from the reference notes as a dependency map. Entries are not Lean proofs. A typed Lean `Prop` specification may exist only when the required objects already compile.

Unproved book results are documentation entries or typed `Prop` specifications. They are never Lean `theorem` or `lemma` declarations. The only allowed status values are:

- `raw`
- `informal`
- `typed-prop`
- `blocked`
- `proven`

## Current RandomMatrix Status

MB-S9 has proved the bounded Matrix Bernstein trace-MGF theorem under explicit
primitive assumptions:

```lean
matrixBernsteinTraceMGFWithBernsteinCoeff_under_primitives
```

This is a proved theorem, not a proof of all underlying typed primitives. The
finite-family Tropp/Lieb interface
`troppMasterTraceMGFFiniteFamily_statement` now has a narrow `Fin m` provider,
`troppMasterTraceMGFFiniteFamily_of_conditionalSteps`, from explicit
conditional-step/state data. The arbitrary finite-index provider and the
Bernstein CFC primitive `bernsteinMatrixExp_le_quadratic_statement` remain
open. Golden-Thompson and the full Matrix Bernstein tail theorem also remain
unproved.

MB-S9 trace-MGF-to-Laplace/tail contract now adds conditional theorem and
statement APIs connecting bounded Bernstein lintegral trace-MGF bounds to the
existing Laplace/tail layer without claiming the missing real-to-lintegral,
Tropp/Lieb, CFC, or Matrix Bernstein proofs.

RM-S5D proves the conditional sample-covariance quadratic-form tail wrapper
`sampleCovariance_quadraticForm_tail_optimized_under_explicit_variance_proxy`
under explicit variance-proxy and Matrix Bernstein primitive assumptions, with
`sampleCovarianceCenteredRankOneRadius`, `sampleCovarianceTailTheta`, and
`sampleCovarianceQuadraticFormTailRHS` as the core named tail helpers. It does
not prove unconditional sample-covariance concentration or an
operator-norm Matrix Bernstein theorem.
RM-S5E adds the example-layer wrapper
`sampleCovariance_quadraticForm_tail_usage`; the current example wrapper uses
the bounded-row theorem and no longer asks for the positive-side
`MatrixVarianceProxyNormBound`.
RM-VP proves crude variance-proxy control from pointwise operator-norm bounds
and specializes it to centered rank-one and sample-covariance row rank-one
families.
RM-S7E/RM-S7F prove the sample-covariance operator-norm event bridge
`sampleCovariance_selfAdjointOperatorNormTailEvent_subset_centeredRowRankOneSum`
and the conditional operator-norm tail wrapper
`sampleCovariance_selfAdjointOperatorNorm_tail_optimized_under_explicit_variance_proxy`.
These keep the general self-adjoint operator-norm spectral bridge assumption
and all analytic primitive assumptions explicit.
RM-ON-S4/RM-ON-S5 prove the matching nonempty Matrix Bernstein and
sample-covariance operator-norm wrappers for `Fin (n + 1)` square dimensions,
supplying `selfAdjointOperatorNormTailViaQuadraticFormStatement_nonempty`
internally while keeping variance proxy, Tropp/CFC, independence, and
integrability assumptions explicit. RM-ON-S6/RM-ON-S7 validate the example,
test, and judge surfaces. RM-ON-S8 synchronizes this documentation and adds no
new theorem claim.

RM-S6 adds the deterministic rank-one kernel/nullspace API
`rankOneMatrixSum`, `rankOneMatrix_quadraticForm_eq_inner_sq`,
`rankOneMatrix_mulVec_eq_zero_iff_inner_eq_zero`, and
`rankOneSum_mulVec_eq_zero_of_forall_inner_eq_zero`. These expose rank-one
quadratic-form, kernel, and finite-sum kernel-membership facts for kernel/NTK,
random-feature, and covariance examples without adding a general nullspace
theory.

Done: `RM-negative-family-adapters` adds named negative-family adapters and a
lighter sample-covariance operator-norm wrapper.

Next safe task:
`RM-TROPP-S11-conditional-step-assumption-bundle-contract`.

## Milestone 3 scalar implication closeout

This audit separates proved theorem families from typed statements and blocked
future directions.

| Family | Status | Main declarations |
|---|---|---|
| `Psi2Bound -> SubGaussianTail` | proven | `subGaussianTail_of_psi2Bound` |
| `SubGaussianTail -> Psi2Bound` | proven | `psi2Bound_of_subGaussianTail` |
| natural-exponent subGaussian `sqrt(q)` growth | proven | `realLpNorm_nat_le_sqrt_of_psi2Bound`, `realLpNorm_nat_le_sqrt_of_subGaussianTail`, `SubGaussianMomentNatSqrt` |
| `CenteredSubGaussianMGF -> one-sided Chernoff tails` | proven | `upperTailProb_le_exp_neg_sq_of_centeredSubGaussianMGF`, `lowerTailProb_le_exp_neg_sq_of_centeredSubGaussianMGF` |
| `CenteredSubGaussianMGF -> SubGaussianTail/Psi2Bound/SubGaussianMomentNatSqrt` | proven | `subGaussianTail_of_centeredSubGaussianMGF`, `psi2Bound_of_centeredSubGaussianMGF`, `subGaussianMomentNatSqrt_of_centeredSubGaussianMGF` |
| `Psi1Bound <-> SubExponentialTail` with scale loss in reverse | proven | `subExponentialTail_of_psi1Bound`, `psi1Bound_of_subExponentialTail` |
| subExponential finite-sum MGF and Bernstein infrastructure | proven | `centeredSubExponentialMGF_sum_mgf_bound_of_iIndepFun_maxScale`, `centeredSubExponentialMGFLIntegral_sum_mgf_bound_of_iIndepFun_maxScale`, `centeredSubExponentialMGFLIntegral_weighted_sum_mgf_bound_of_iIndepFun_maxScale`, `bernstein_sum_subExponential`, `bernstein_weighted_sum_subExponential` |
| scalar concentration theorem-family closeout | proven | `docs/ScalarConcentrationMilestone.md`, `HighDimProbTest.ScalarConcentrationMilestoneAPI` |
| scalar concentration branch final closure | proven | `docs/ConcentrationLeafAudit.md`, `docs/ScalarConcentrationTheoremIndex.md`, `docs/ConcentrationTestCoverage.md`, `docs/Milestone-ScalarConcentration.md` |
| raw-predicate scalar Bernstein statement variants | typed-prop | `bernstein_subExponential_sum_statement`, `bernstein_subExponential_weighted_sum_statement` |
| sharp natural-exponent statement wrappers | proven | `sqrtMomentGrowthOfPsi2`, `sqrtMomentGrowthOfSubGaussianTail` |
| full real-exponent `SubGaussianMoment` bridge | proven | `realLpNorm_le_natCeil_of_realExponent`, `sqrt_natCeil_toReal_le_two_sqrt`, `realLpNorm_le_sqrt_of_psi2Bound`, `realLpNorm_le_sqrt_of_subGaussianTail`, `subGaussianMoment_of_psi2Bound`, `subGaussianMoment_of_subGaussianTail` |
| full real-exponent `SubExponentialMoment` bridge | proven | `abs_pow_le_exp_linear_factorial`, `absMomentNat_le_of_psi1Bound`, `realLpNorm_le_linear_of_psi1Bound`, `realLpNorm_le_linear_of_subExponentialTail`, `subExponentialMoment_of_psi1Bound`, `subExponentialMoment_of_subExponentialTail` |
| reverse/source MGF implication | blocked | future reverse MGF bridge |
| canonical `SubGaussian` / `SubExponential` equivalence package | blocked | requires reverse/source MGF links, finite-gauge variants, and formulation choice |

## Rademacher subGaussian MGF
- Book heading: Rademacher variables / bounded random variable MGF / Hoeffding prerequisites
- Informal statement: a symmetric Rademacher random variable has centered subGaussian MGF control.
- Target Lean statement: `centeredSubGaussianMGF_rademacher`
- Required objects: `PMF.bernoulli`, `rademacherMeasure`, `rademacher`, `CenteredSubGaussianMGF`.
- Required definitions: canonical Bool Rademacher variable and its probability measure.
- Required bridge lemmas: Mathlib `ProbabilityTheory.hasSubgaussianMGF_of_mem_Icc_of_integral_eq_zero`, `PMF.integral_eq_sum`, and the pointwise interval lemma `rademacher_mem_Icc`.
- Status: proven
- Constant: MGF scale `1`; tail corollary `subGaussianTail_rademacher` has scale `2` by the existing MGF-to-tail bridge.
- Blocker: none for the one-sign atom; weighted finite-sum tails are now handled in `HighDimProb.Concentration.RademacherSums`.
- Target module: `HighDimProb/Distributions/Rademacher.lean`
- Priority: experimental concentration infrastructure

## Rademacher / Hoeffding branch readiness
- Book heading: Rademacher variables / Hoeffding prerequisites
- Informal statement: the one-sign Rademacher atom is ready; the next theorem work needs finite product signs and weighted-sum MGF infrastructure.
- Target Lean statement: none in Stage H0; this is a roadmap and API audit stage.
- Required objects already proved: `rademacherPMF`, `rademacherMeasure`, `rademacher`, `centeredSubGaussianMGF_rademacher`, `subGaussianTail_rademacher`.
- Planned dependencies: finite product measure on `Fin n -> Bool`, coordinate independence, product/MGF factorization, and finite-sum exponential algebra.
- Status: informal
- Blocker: none for the readiness audit; the finite family, weighted MGF, and positive-square-sum Hoeffding tail are now implemented.
- Plan document: `docs/RademacherPlan.md`
- Priority: active deep-proof direction

## Finite product Rademacher family
- Book heading: Rademacher variables / Hoeffding prerequisites
- Informal statement: the coordinate signs on `Fin n -> Bool` under the product Rademacher measure are measurable, mean-zero, bounded in `[-1, 1]`, and independent.
- Target Lean statements: `rademacherVectorMeasure`, `rademacherVectorPMF`, `rademacherCoord`, `rademacherVector`, `isRealRandomVariable_rademacherCoord`, `integral_rademacherCoord`, `iIndepFun_rademacherCoord`.
- Required objects: `Measure.pi`, `Measure.toPMF`, `Measure.toPMF_toMeasure`, `measurePreserving_eval`, `ProbabilityTheory.iIndepFun_pi`.
- Required definitions: canonical one-sign `rademacherMeasure` and `rademacher`.
- Required bridge lemmas: `rademacher_mem_Icc`, `integral_rademacher`, Mathlib product-measure coordinate projection.
- Status: proven
- Constant: coordinate values remain in `[-1, 1]`; each coordinate has mean `0`.
- Blocker: none for the finite product family itself.
- Target module: `HighDimProb/Distributions/RademacherFamily.lean`
- Priority: active H2 branch infrastructure

## Weighted finite Rademacher sum MGF
- Book heading: Rademacher variables / Hoeffding prerequisites
- Informal statement: a finite weighted sum of independent Rademacher signs is centered subGaussian with variance proxy `sum_i a_i^2`.
- Target Lean statements: `weightedRademacherSum`, `isRealRandomVariable_weightedRademacherSum`, `hasSubgaussianMGF_weightedRademacherSum`, `centeredSubGaussianMGF_weightedRademacherSum`.
- Required objects: `rademacherVectorMeasure`, `rademacherCoord`, `iIndepFun_rademacherCoord`, `CenteredSubGaussianMGF`, Mathlib `ProbabilityTheory.HasSubgaussianMGF`.
- Required bridge lemmas: `hasSubgaussianMGF_rademacherCoord`, `iIndepFun_weightedRademacherTerms`, `hasSubgaussianMGF_weightedRademacherTerm`, Mathlib `ProbabilityTheory.HasSubgaussianMGF.sum_of_iIndepFun`.
- Status: proven
- Constant: exact Mathlib MGF proxy `sum_i a_i^2`; HighDimProb scale `sqrt (sum_i a_i^2)` under the explicit assumption `0 < sum_i a_i^2`.
- Blocker: the all-zero-weight vector cannot satisfy the current `CenteredSubGaussianMGF` predicate at scale `0` because that predicate requires a strictly positive scale; zero-sum helper theorems now cover the degenerate random variable directly.
- Target module: `HighDimProb/Concentration/RademacherSums.lean`
- Priority: active H2 branch infrastructure

## Finite Rademacher Hoeffding tail
- Book heading: Rademacher variables / Hoeffding inequality
- Informal statement: a finite weighted sum of independent Rademacher signs has two-sided Gaussian tail decay with variance proxy `sum_i a_i^2`.
- Target Lean statements: `subGaussianTail_weightedRademacherSum`, `hoeffding_rademacher_sum`.
- Required objects: `weightedRademacherSum`, `centeredSubGaussianMGF_weightedRademacherSum`, `subGaussianTail_of_centeredSubGaussianMGF`, `SubGaussianTail`, `absTailProb`.
- Required bridge lemmas: existing MGF-to-tail implication and `Real.sq_sqrt` denominator normalization.
- Status: proven
- Constant: tail scale `2 * sqrt (sum_i a_i^2)`; explicit bound `2 * exp (-(t^2 / (4 * sum_i a_i^2)))`.
- Blocker: unrestricted exact-scale `SubGaussianTail` statement remains a zero-scale predicate issue when `sum_i a_i^2 = 0`; separate zero-tail helper theorems are proven.
- Target module: `HighDimProb/Concentration/RademacherSums.lean`
- Priority: active H3 branch theorem

## Weighted Rademacher zero-weight cleanup
- Book heading: Rademacher variables / Hoeffding edge cases
- Informal statement: if all weights vanish, or equivalently the finite sum of squared weights is zero, the weighted Rademacher sum is the zero random variable and its strictly positive absolute tails have probability zero.
- Target Lean statements: `weightedRademacherSum_eq_zero_of_forall_eq_zero`, `weightedRademacherSum_eq_zero_of_sum_sq_eq_zero`, `absTailProb_weightedRademacherSum_eq_zero_of_forall_eq_zero_of_pos`, `absTailProb_weightedRademacherSum_eq_zero_of_sum_sq_eq_zero_of_pos`, `hoeffding_rademacher_sum_of_pos_variance`.
- Required objects: `weightedRademacherSum`, `absTailProb`, `Finset.sum_eq_zero_iff_of_nonneg`, `sq_eq_zero_iff`.
- Status: proven
- Constant: zero-tail theorem applies only for `0 < t`; the positive-variance Hoeffding denominator remains `4 * sum_i a_i^2`.
- Sharpness note: constants are inherited from the current MGF-to-tail bridge and are not claimed optimal.
- Blocker: exact `SubGaussianTail` or `CenteredSubGaussianMGF` at scale `0` remains impossible with the current positive-scale predicates.
- Target module: `HighDimProb/Concentration/RademacherSums.lean`
- Priority: H2-cleanup

## Independent finite subGaussian sum MGF
- Book heading: subGaussian sums / Hoeffding prerequisites
- Informal statement: a finite sum of independent centered subGaussian real variables is centered subGaussian with variance proxy equal to the sum of the individual variance proxies.
- Target Lean statements: `centeredSubGaussianMGF_sum_of_iIndepFun_of_pos`, `centeredSubGaussianMGF_weighted_sum_of_iIndepFun_of_pos`, `subGaussianTail_sum_of_iIndepFun_of_pos`, `subGaussianTail_weighted_sum_of_iIndepFun_of_pos`.
- Required objects: `CenteredSubGaussianMGF`, `SubGaussianTail`, `ProbabilityTheory.iIndepFun`, finite sums, deterministic scalar weights.
- Required bridge lemmas: `hasSubgaussianMGF_finset_sum_of_iIndepFun`, `iIndepFun_weighted_of_iIndepFun`, `hasSubgaussianMGF_weighted_of_centeredSubGaussianMGF`, Mathlib `ProbabilityTheory.HasSubgaussianMGF.sum_of_iIndepFun`, and `ProbabilityTheory.HasSubgaussianMGF.const_mul`.
- Status: proven
- Constant: unweighted MGF scale `sqrt (sum_i K_i^2)` under `0 < sum_i K_i^2`; weighted MGF scale `sqrt (sum_i (a_i*K_i)^2)` under `0 < sum_i (a_i*K_i)^2`; tail scale doubles by the existing MGF-to-tail bridge.
- Blocker: exact zero-scale predicate wrappers remain unavailable because `CenteredSubGaussianMGF` and `SubGaussianTail` require positive scales; zero-scale cases should be handled by separate direct lemmas when needed.
- Target module: `HighDimProb/Concentration/SubGaussianSums.lean`
- Priority: Stage H5

## Bounded Hoeffding theorem
- Book heading: Hoeffding inequality for bounded variables
- Informal statement: a centered real variable bounded a.e. in `[a,b]` is centered subGaussian, a finite independent centered family satisfies conservative and sharp two-sided Hoeffding tails, a finite independent non-centered bounded family satisfies the sharp classical/Wikipedia bound around `E[sum_i X_i]`, and deterministic weighted versions satisfy the sharp denominator `sum_i c_i^2 * (b_i-a_i)^2`.
- Target Lean statements: `centeredSubGaussianMGF_of_ae_mem_Icc_of_centered`, `centeredSubGaussianMGF_of_forall_mem_Icc_of_centered`, `centeredSubGaussianMGF_sum_of_iIndepFun_bounded_centered`, `subGaussianTail_sum_of_iIndepFun_bounded_centered`, `hoeffding_sum_bounded_centered`, `upperTailProb_le_exp_neg_two_mul_sq_div_of_mgf_eighth`, `lowerTailProb_le_exp_neg_two_mul_sq_div_of_mgf_eighth`, `absTailProb_le_two_mul_exp_neg_two_mul_sq_div_of_mgf_eighth`, `hoeffding_sum_bounded_centered_sharp`, `expect_finset_sum`, `iIndepFun_centered_of_iIndepFun`, `ae_mem_Icc_centered_of_ae_mem_Icc`, `sum_centered_eq_sum_sub_expect_sum`, `hoeffding_sum_bounded`, `sum_weighted_centered_eq_weighted_sum_sub_expect_weighted_sum`, `hoeffding_weighted_sum_bounded_centered_sharp`, `hoeffding_weighted_sum_bounded`.
- Required objects: `Centered`, `CenteredSubGaussianMGF`, `SubGaussianTail`, `ProbabilityTheory.iIndepFun`, `Set.Icc`, `IntegrableRealRandomVariable`, `expect`, finite sums, `absTailProb`.
- Required bridge lemmas: Mathlib `ProbabilityTheory.hasSubgaussianMGF_of_mem_Icc_of_integral_eq_zero`, Stage H5 `centeredSubGaussianMGF_sum_of_iIndepFun_of_pos`, Stage H5 `subGaussianTail_sum_of_iIndepFun_of_pos`, the Hoeffding-specific eighth-MGF Chernoff helpers, `MeasureTheory.integral_finset_sum`, `ProbabilityTheory.iIndepFun.comp`, and denominator normalization by `Real.sq_sqrt` plus finite-sum algebra.
- Status: proven
- Constant: one-variable MGF scale `(b-a)/2`; finite MGF scale `sqrt (sum_i ((b_i-a_i)/2)^2)`; the existing generic MGF-to-`SubGaussianTail` path gives the conservative explicit exponent `-(t^2 / sum_i (b_i-a_i)^2)`, while the sharp Hoeffding-specific Chernoff path gives `-(2*t^2 / sum_i (b_i-a_i)^2)` for centered, non-centered, weighted centered, and weighted non-centered sums. The weighted denominator is `sum_i c_i^2 * (b_i-a_i)^2`.
- Blocker: none for the finite centered, non-centered, weighted centered, and weighted non-centered theorems under visible positive denominator assumptions; the non-centered theorems keep integrability explicit for expectation linearity.
- Target module: `HighDimProb/Concentration/Hoeffding.lean`
- Priority: Stage H6, Stage H6-sharp, Stage H7, and Stage H8 complete

## Hoeffding branch milestone closeout
- Book heading: Hoeffding inequality for bounded variables
- Informal statement: the finite unweighted Hoeffding theorem family is documented, tested, and exposed through the concentration aggregates as a coherent experimental milestone.
- Target Lean statement: none; this is a milestone/import/API audit.
- Required objects: Rademacher atom, weighted Rademacher sum specialization, independent finite subGaussian sums, centered bounded Hoeffding, non-centered classical Hoeffding, and deterministic weighted bounded Hoeffding.
- Status: proven
- Constants: recorded in `docs/HoeffdingMilestone.md`; `hoeffding_sum_bounded_centered` remains the conservative `2 exp(-t^2/V)` theorem, while `hoeffding_sum_bounded_centered_sharp`, `hoeffding_sum_bounded`, `hoeffding_weighted_sum_bounded_centered_sharp`, and `hoeffding_weighted_sum_bounded` use the classical `2 exp(-2*t^2/V)` exponent with the appropriate unweighted or weighted denominator.
- Blocker: none for the completed bounded Hoeffding milestone. Zero-width cleanup and one-sided forms remain future refinements.
- Target module: documentation plus existing Hoeffding and implication aggregate leaves.
- Priority: Stage H8 complete; Stage H9 should close out the full Hoeffding branch.

## Rademacher / Hoeffding branch closeout
- Book heading: Rademacher variables / Hoeffding prerequisites
- Informal statement: the finite Rademacher concentration branch is documented, tested, and exposed through experimental aggregates.
- Target Lean statement: none; this is a milestone/import audit.
- Required objects: canonical atom, finite product family, weighted sum MGF theorem, weighted tail theorem, and explicit Hoeffding theorem.
- Status: proven documentation milestone
- Constants: recorded in `docs/RademacherMilestone.md`.
- Blocker: all-zero exact-scale predicate wrapper remains a future predicate-design cleanup; direct zero-sum and zero-tail helper theorems are proven.
- Target module: documentation plus existing Rademacher leaves.
- Priority: H4 closeout

## tail-event measurability statement
- Book heading: tail-event measurability statement
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
- Book heading: tail probability wrapper statement
- Informal statement: tail probability wrappers are direct measure applications to tail events.
- Target Lean statement: `tailProbabilityWrapperStatement`
- Required objects: `upperTailProb`, `lowerTailProb`, `absTailProb`.
- Required definitions: Stage 1A tail probability wrappers.
- Required bridge lemmas: none for the specification itself.
- Status: typed-prop
- Blocker: no blocker for the specification.
- Target module: `HighDimProb/BookStatements.lean`
- Priority: v0.1

## finite union bound / Boole inequality
- Book heading: Probability and Measure, finite subadditivity / Boole's inequality
- Informal statement: for a finite family of events, the measure of their union is at most the sum of their measures.
- Target Lean statement: `measure_biUnion_le`
- Required objects: `Measure`, `Event`, `Finset`, finite indexed unions.
- Required definitions: Stage 1A probability-space and event vocabulary.
- Required bridge lemmas: Mathlib `MeasureTheory.measure_biUnion_finset_le`.
- Status: proven
- Blocker: none. The theorem is stated for arbitrary measures and does not require event measurability.
- Target module: `HighDimProb/ProbabilitySpace.lean`
- Priority: stable probability infrastructure

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
- Book heading: tail integral identity for expectation
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
- Book heading: Markov inequality
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
- Book heading: Chebyshev inequality
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

## weak law Chebyshev sample mean bound
- Book heading: weak law of large numbers via Chebyshev
- Informal statement: the deviation probability of a finite sample mean is bounded by a variance-over-sample-size term.
- Target Lean statement: `weakLawChebyshevBoundStatement`
- Required objects: `sampleMean`, `sampleMeanCentered`, `absTailProb`, `mean`, `variance`, `MemLpRealRandomVariable`.
- Required definitions: Stage LLN0-LLN1 sample mean vocabulary.
- Required bridge lemmas: future expectation-of-sum, variance-of-sum, and covariance-zero/independence bridges.
- Status: typed-prop
- Blocker: scalar independence/iid vocabulary now exists in `LimitTheorems.Assumptions`, but variance-of-sum, square-integrability, and mean-of-sample-mean bridges are not implemented.
- Target module: `HighDimProb/LimitTheorems/WeakLaw.lean`
- Priority: LLN scaffold

## weak law finite-variance convergence in probability
- Book heading: weak law of large numbers
- Informal statement: finite-variance sample means converge in probability to the common mean.
- Target Lean statement: `weakLawFiniteVarianceStatement`
- Required objects: `sampleMean`, sequence of finite samples, Mathlib `TendstoInMeasure`.
- Required definitions: Stage LLN0-LLN1 limit-theorem branch scaffold.
- Required bridge lemmas: Chebyshev sample mean bound tending to zero, plus the blockers listed above.
- Status: typed-prop
- Blocker: Stage C1 adds scalar independence/iid wrappers, but HighDimProb still lacks variance-of-sum/sample-mean bridge lemmas and a probability-convergence alias/proof layer.
- Target module: `HighDimProb/LimitTheorems/WeakLaw.lean`
- Priority: LLN scaffold

## psi2 Orlicz bound implies subGaussian tail
- Book heading: psi2 Orlicz bound implies subGaussian tail
- Informal statement: if the exponential-square Orlicz bound holds at scale `K`, then the absolute tail has Gaussian decay with the same scale and constant `2`.
- Target Lean statement: `subGaussianTail_of_psi2Bound`
- Required objects: `Psi2Bound`, `SubGaussianTail`, `absTailProb`, `IsRealRandomVariable`, `IsProbabilityMeasure`.
- Required definitions: psi2 bound via shifted exponential `lintegral`, two-sided absolute-tail predicate, positive scale.
- Required bridge lemmas: `lintegral_exp_sq_div_le_two_of_psi2Bound`, Mathlib `MeasureTheory.meas_ge_le_lintegral_div`, exponential monotonicity, square monotonicity, `ENNReal.ofReal` division bridge.
- Status: proven
- Blocker: none for the probability-measure/measurable-variable formulation. The full equivalence theorem and gauge/norm formulations remain future work.
- Target module: `HighDimProb/Concentration/OrliczToTail.lean`
- Priority: scalar concentration proof spine

## psi1 Orlicz bound implies subExponential tail
- Book heading: psi1 Orlicz bound implies subExponential tail
- Informal statement: if the exponential-linear Orlicz bound holds at scale `K`, then the absolute tail has exponential decay with the same scale and constant `2`.
- Target Lean statement: `subExponentialTail_of_psi1Bound`
- Required objects: `Psi1Bound`, `SubExponentialTail`, `absTailProb`, `IsRealRandomVariable`, `IsProbabilityMeasure`.
- Required definitions: psi1 bound via shifted exponential `lintegral`, two-sided absolute-tail predicate, positive scale.
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
- Required bridge lemmas: `lintegral_exp_quarter_sub_one_le_of_exp_tail`, `lintegral_exp_sq_div_four_sub_one_le_of_subGaussianTail`, Mathlib layer-cake formula, and Mathlib improper integral evaluation for exponential decay; Stage C1 exposes the generic helpers through `HighDimProb.Concentration.LayerCake`.
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
- Required bridge lemmas: `lintegral_exp_third_sub_one_le_of_exp_tail`, `lintegral_exp_abs_div_three_sub_one_le_of_subExponentialTail`, Mathlib layer-cake formula, and Mathlib improper integral evaluation for exponential decay; Stage C1 exposes the generic helpers through `HighDimProb.Concentration.LayerCake`.
- Status: proven
- Blocker: none for the fixed-scale `3 * K` formulation with explicit measurability.
- Target module: `HighDimProb/Concentration/TailToOrlicz.lean`
- Priority: scalar concentration proof spine

## subGaussian tail implies second absolute natural moment
- Book heading: subGaussian moment characterization
- Informal statement: a two-sided subGaussian tail bound at scale `K` controls the second absolute moment, with the current fixed-scale proof giving constant `(2*K)^2`.
- Target Lean statement: `absMomentNat_two_le_of_subGaussianTail`; finiteness corollary `finiteAbsMomentNat_two_of_subGaussianTail`.
- Required objects: `SubGaussianTail`, `Psi2Bound`, `absMomentNat`, `finiteAbsMomentNat`, `IsRealRandomVariable`, `IsProbabilityMeasure`.
- Required definitions: natural absolute moment as `lintegral` of `ENNReal.ofReal (|X|^q)`.
- Required bridge lemmas: `psi2Bound_of_subGaussianTail`, `absMomentNat_two_le_of_psi2Bound`, `Real.add_one_le_exp`, `lintegral_mono`, `lintegral_const_mul'`, and `ENNReal.ofReal_mul`.
- Status: proven
- Blocker: none for the natural exponent `q = 2`; Stage G2E-fix now proves the natural-exponent `sqrt(q)` real-`Lp` growth bridge.
- Target module: `HighDimProb/Concentration/MomentImplications.lean`
- Priority: Stage G2A scalar concentration proof spine

## subGaussian tail implies all-natural moment growth
- Book heading: subGaussian moment characterization
- Informal statement: a two-sided subGaussian tail bound controls all natural absolute moments. The current theorem proves a crude factorial-growth absolute-moment bound, and the sharp natural-exponent real-`Lp` / predicate bridge is proved separately.
- Target Lean statement: `absMomentNat_le_of_subGaussianTail`; finiteness corollary `finiteAbsMomentNat_of_subGaussianTail`; sharp natural-exponent targets `absMomentNat_le_sqrt_growth_of_psi2Bound`, `realLpNorm_nat_le_sqrt_of_psi2Bound`, `realLpNorm_nat_le_sqrt_of_subGaussianTail`, `SubGaussianMomentNatSqrt`, `subGaussianMomentNatSqrt_of_psi2Bound`, `subGaussianMomentNatSqrt_of_subGaussianTail`, `sqrtMomentGrowthOfPsi2`, `sqrtMomentGrowthOfSubGaussianTail`, and the full finite-`ENNReal` bridges `subGaussianMoment_of_psi2Bound` / `subGaussianMoment_of_subGaussianTail`.
- Required objects: `SubGaussianTail`, `Psi2Bound`, `absMomentNat`, `finiteAbsMomentNat`, `IsRealRandomVariable`, `IsProbabilityMeasure`.
- Required definitions: natural absolute moment normal form and explicit constant convention.
- Required bridge lemmas: `abs_pow_le_exp_sq_factorial`, `absMomentNat_le_of_psi2Bound`, `psi2Bound_of_subGaussianTail`, `lintegral_exp_sq_div_le_two_of_psi2Bound`, Mathlib `Real.pow_div_factorial_le_exp`, and the deterministic helpers `pow_le_two_sqrt_mul_exp_sq`, `pow_le_two_mul_scale_sqrt_mul_exp_sq_div`, and `powLeSqrtGrowthMulExpSq`.
- Status: proven for factorial growth, natural-exponent sharp `sqrt(q)` real-Lp growth, the sharp natural-exponent predicate wrapper, and the full finite-`ENNReal` `SubGaussianMoment` bridge.
- Constant: factorial bound `absMomentNat P X q <= ENNReal.ofReal (Real.exp (1/4) * (2*K)^q * q!) * 2`; sharp bounds `absMomentNat P X q <= ENNReal.ofReal ((4*K*sqrt q)^q)`, `realLpNorm <= 4*K*sqrt q` from `Psi2Bound`, `realLpNorm <= 8*K*sqrt q` from `SubGaussianTail`, natural predicate scales `SubGaussianMomentNatSqrt (4*K)` / `SubGaussianMomentNatSqrt (8*K)`, and full `SubGaussianMoment` scales `8*K` / `16*K`.
- Blocker: none for natural exponents `q >= 1` or full finite `p : ENNReal` moment growth from `Psi2Bound`/`SubGaussianTail`.
- Target module: `HighDimProb/Concentration/MomentImplications.lean`
- Priority: Stage G2B

## absolute natural moment to Lp bridge
- Book heading: absolute natural moment to Lp bridge
- Informal statement: for a nonzero natural exponent `q`, finiteness or a bound on `E |X|^q` yields the corresponding Mathlib `L^q` membership and extended `L^q` seminorm bound.
- Target Lean statement: `memLp_of_finiteAbsMomentNat`; quantitative wrappers `realLpNorm_nat_le_of_absMomentNat_le_ennreal` and `realLpNorm_nat_le_of_absMomentNat_le`; linear-growth wrappers `realLpNorm_nat_le_linear_of_psi2Bound` and `realLpNorm_nat_le_linear_of_subGaussianTail`; sqrt-growth wrappers `realLpNorm_nat_le_sqrt_of_psi2Bound`, `realLpNorm_nat_le_sqrt_of_subGaussianTail`, `realLpNorm_le_sqrt_of_psi2Bound`, and `realLpNorm_le_sqrt_of_subGaussianTail`; natural predicate wrappers `SubGaussianMomentNat`, `SubGaussianMomentNatSqrt`, `subGaussianMomentNat_of_psi2Bound`, `subGaussianMomentNat_of_subGaussianTail`, `subGaussianMomentNatSqrt_of_psi2Bound`, `subGaussianMomentNatSqrt_of_subGaussianTail`, `subGaussianMoment_of_psi2Bound`, and `subGaussianMoment_of_subGaussianTail`.
- Required objects: `absMomentNat`, `finiteAbsMomentNat`, `MemLpRealRandomVariable`, `realLpNorm`, `IsRealRandomVariable`, `Psi2Bound`, `SubGaussianTail`.
- Required definitions: natural absolute moment normal form as a `lintegral`; Mathlib `ENNReal` exponent convention for `MemLp` and `eLpNorm`.
- Required bridge lemmas: `lintegral_enorm_rpow_nat_eq_absMomentNat`, Mathlib `eLpNorm_lt_top_iff_lintegral_rpow_enorm_lt_top`, `eLpNorm_eq_lintegral_rpow_enorm_toReal`, `eLpNorm_le_eLpNorm_of_exponent_le`, `ENNReal.rpow_natCast`, `ENNReal.ofReal_pow`, `ENNReal.ofReal_toReal`, `ENNReal.toReal_mono`, `ENNReal.rpow_le_rpow`, `Nat.ceil`, `Nat.le_ceil`, `Nat.ceil_lt_add_one`, `Nat.factorial_le_pow`, `Real.sqrt_le_sqrt`, `Real.sqrt_mul`, `Real.rpow_le_rpow`, `Real.mul_rpow`, and `Real.exp_one_lt_three`.
- Status: proven
- Constant/formulation: `realLpNorm P X (q : ENNReal) <= B^(1/q)` in `ENNReal` form, plus a real-bound corollary with right side `ENNReal.ofReal (B^(1/q))`; the factorial bound yields linear constants `8`/`16`; the deterministic envelope yields natural sqrt constants `4` for `Psi2Bound` and `8` for `SubGaussianTail`; the finite-`ENNReal` bridge uses ceiling monotonicity and yields `SubGaussianMoment` scales `8*K` and `16*K`.
- Blocker: no blocker for natural exponents `q != 0` or finite real/`ENNReal` subGaussian moment growth from `Psi2Bound`/`SubGaussianTail`.
- Target module: `HighDimProb/Concentration/MomentImplications.lean`
- Priority: Stage G2C

## subExponential natural and real moment bridge
- Book heading: subExponential moment characterization
- Informal statement: psi1 Orlicz control gives linear moment growth, and subExponential tail control gives the same after the existing tail-to-psi1 scale loss.
- Target Lean statement: `abs_pow_le_exp_linear_factorial`; natural absolute-moment wrappers `absMomentNat_le_of_psi1Bound` and `absMomentNat_le_of_subExponentialTail`; natural real-Lp wrappers `realLpNorm_nat_le_linear_of_psi1Bound` and `realLpNorm_nat_le_linear_of_subExponentialTail`; finite-`ENNReal` wrappers `realLpNorm_le_linear_of_psi1Bound`, `realLpNorm_le_linear_of_subExponentialTail`, `subExponentialMoment_of_psi1Bound`, and `subExponentialMoment_of_subExponentialTail`.
- Required objects: `Psi1Bound`, `SubExponentialTail`, `SubExponentialMoment`, `absMomentNat`, `realLpNorm`, `IsRealRandomVariable`, `IsProbabilityMeasure`.
- Required bridge lemmas: Mathlib `Real.pow_div_factorial_le_exp`, `Nat.factorial_le_pow`, `Real.rpow_le_rpow`, `Real.mul_rpow`, Mathlib Lp exponent monotonicity, `ENNReal.toReal_mono`, `Nat.ceil`, `Nat.ceil_lt_add_one`, and the existing `lintegral_exp_abs_div_le_two_of_psi1Bound` / `psi1Bound_of_subExponentialTail`.
- Status: proven
- Constant/formulation: `Psi1Bound P X K` gives `absMomentNat <= 2*K^q*q!`, `realLpNorm_q <= 8*K*q`, finite-exponent `realLpNorm_p <= 16*K*p.toReal`, and `SubExponentialMoment P X (16*K)`. `SubExponentialTail P X K` first becomes `Psi1Bound P X (3*K)`, giving natural real-Lp constant `24*K*q`, finite-exponent constant `48*K*p.toReal`, and `SubExponentialMoment P X (48*K)`.
- Blocker: none for all natural `q >= 1` or finite `p : ENNReal` under psi1/tail hypotheses. Reverse MGF/source-formulation links remain future work.
- Target module: `HighDimProb/Concentration/MomentImplications.lean`
- Priority: Stage M-real-2

## deterministic power-exponential envelope
- Book heading: subGaussian moment characterization
- Informal statement: for `x >= 0` and natural `q >= 1`, powers are dominated by a Gaussian exponential envelope, `x^q <= (C*sqrt q)^q * exp(x^2/4)`.
- Target Lean statement: `pow_le_two_sqrt_mul_exp_sq`; constant-`4` wrapper `pow_le_four_sqrt_mul_exp_sq`; typed-target wrapper `powLeSqrtGrowthMulExpSq`.
- Required objects: real logarithm, exponential, square root, natural powers.
- Required definitions: small helper branch `HighDimProb.Analysis.RealInequalities`.
- Required bridge lemmas: `log_le_sq_of_nonneg`, `pow_le_exp_nat_mul_sq`, Mathlib `Real.log_le_self`, `Real.log_le_iff_le_exp`, `Real.log_pow`, `Real.exp_le_exp`, and `Real.sq_sqrt`.
- Status: proven
- Constant/formulation: proved with constant `2`, which implies the earlier constant-`4` target.
- Blocker: none for natural exponents; finite-`ENNReal` moment variants are now
  handled downstream by `MomentImplications`, not by this deterministic helper.
- Target module: `HighDimProb/Analysis/RealInequalities.lean`
- Priority: Stage G2E-fix

## Jensen inequality
- Book heading: Jensen inequality
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
- Book heading: Holder inequality
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
- Book heading: Minkowski inequality
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
- Book heading: subGaussian definition equivalences
- Informal statement: tail, moment, MGF, and Orlicz characterizations of subGaussian variables are equivalent up to constants.
- Target Lean statement: blocked until a precise equivalence statement and constants are selected.
- Required objects: real random variables, tail probabilities, moments, Mathlib MGF predicate, psi2 Orlicz control.
- Required definitions: `SubGaussianTail`, `SubGaussianMoment`, `CenteredSubGaussianMGF`, `SubGaussianOrlicz`, `HasSubGaussianOrlicz`; fixed-scale tail/Orlicz, natural moment, and MGF-to-tail directions now have proved bridges.
- Required bridge lemmas: expectation of exponentials, tail/moment integration.
- Status: blocked
- Blocker: fixed-scale `Psi2Bound -> SubGaussianTail`, `SubGaussianTail -> Psi2Bound (2*K)`, all-natural factorial moment bounds, natural moment-to-`realLpNorm` bridges, natural-exponent sharp `sqrt(q)` growth, `SubGaussianMomentNatSqrt` bridges, full finite-`ENNReal` `SubGaussianMoment` bridges, and `CenteredSubGaussianMGF -> SubGaussianTail/Psi2Bound/SubGaussianMomentNatSqrt` are proven. Reverse MGF connections, finite-gauge variants, gauge/norm objects, and canonical predicate choice remain future work.
- Target module: `HighDimProb/SubGaussian.lean`
- Priority: v0.3

## subExponential definition equivalences
- Book heading: subExponential definition equivalences
- Informal statement: tail, moment, MGF, and Orlicz characterizations of subExponential variables are equivalent up to constants.
- Target Lean statement: blocked until a precise equivalence statement and constants are selected.
- Required objects: real random variables, tail probabilities, moments, exponential moments, psi1 Orlicz control.
- Required definitions: `SubExponentialTail`, `SubExponentialMoment`, `CenteredSubExponentialMGF`, `SubExponentialOrlicz`, `HasSubExponentialOrlicz`; fixed-scale tail/Orlicz and the full finite-`ENNReal` moment bridge now have proved connectors.
- Required bridge lemmas: expectation of exponentials, tail/moment integration.
- Status: blocked
- Blocker: fixed-scale `Psi1Bound -> SubExponentialTail`, `SubExponentialTail -> Psi1Bound (3*K)`, all-natural factorial moment bounds, natural real-Lp growth, and full finite-`ENNReal` `SubExponentialMoment` bridges are proven. MGF/source connections, finite-gauge variants, gauge/norm objects, and canonical predicate choice remain future work.
- Target module: `HighDimProb/SubExponential.lean`
- Priority: v0.3

## bounded random variable is subGaussian
- Book heading: bounded random variable is subGaussian
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
- Book heading: centered subGaussian mgf characterization
- Informal statement: a centered subGaussian variable has Gaussian-type MGF bounds, and conversely under suitable constants.
- Target Lean statement: forward implication theorem family is proved for the existing MGF predicate; reverse/centering equivalence remains blocked.
- Required objects: `Centered`, `expect`, exponential function, `CenteredSubGaussianMGF`.
- Required definitions: centeredness vocabulary and MGF-bound predicate.
- Required bridge lemmas: `CenteredSubGaussianMGFLIntegral`, lintegral Markov, absolute-tail union bridge, and existing tail-to-Orlicz / moment composition.
- Status: proven for the forward MGF-to-tail direction; blocked for reverse characterization.
- Blocker: `CenteredSubGaussianMGF -> SubGaussianTail (2*K)`,
  `Psi2Bound (4*K)`, and `SubGaussianMomentNatSqrt (16*K)` are proved; the
  full `SubGaussianMoment (32*K)` route is available by composing
  `psi2Bound_of_centeredSubGaussianMGF` with
  `subGaussianMoment_of_psi2Bound`, though no direct wrapper is exposed. The
  converse direction and an independent proof that a centered variable satisfies
  the MGF predicate from other formulations are not proved.
- Target module: `HighDimProb/Concentration/MGF.lean`
- Priority: v0.3

## centered subExponential mgf characterization
- Book heading: centered subExponential mgf characterization
- Informal statement: a centered subExponential variable admits local quadratic MGF control, composes under independent finite sums, and conversely under suitable constants.
- Target Lean statement: Stage B1 adds `CenteredSubExponentialMGFLIntegral`, the conservative finite-sum MGF theorem family `centeredSubExponentialMGF_sum_mgf_bound_of_iIndepFun` / `centeredSubExponentialMGF_sum_of_iIndepFun_of_pos`, and Stage B1-fix proves the normalized raw and lintegral finite-sum bounds `centeredSubExponentialMGF_sum_mgf_bound_of_iIndepFun_maxScale` and `centeredSubExponentialMGFLIntegral_sum_mgf_bound_of_iIndepFun_maxScale`.
- Required objects: `Centered`, `expect`, exponential function, `CenteredSubExponentialMGF`.
- Required definitions: centeredness vocabulary, local-MGF-bound predicate, and proof-friendly lintegral predicate.
- Required bridge lemmas: finite MGF product over `ProbabilityTheory.iIndepFun`, local-domain comparison through `maxScale`, and the lintegral-to-raw MGF bridge.
- Status: proven
- Proven local pieces: raw expectation-level finite sums, reusable `maxScale` / `varianceProxy` vocabulary, lintegral finite-sum MGF from the stronger lintegral predicate, and local lintegral Chernoff tails.
- Blocker: the raw predicate still does not imply the stronger lintegral predicate; the proved full Bernstein theorem sources the lintegral predicate, while a future raw-to-lintegral bridge would support raw-predicate variants.
- Target module: `HighDimProb/Concentration/SubExponentialSums.lean`
- Priority: v0.3

## subGaussian square is subExponential
- Book heading: subGaussian square is subExponential
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
- Book heading: product of subGaussian variables is subExponential
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
- Book heading: Bernstein inequality
- Informal statement: sums of independent centered subExponential variables satisfy Bernstein-type tail bounds.
- Target Lean statement: Stage B2 proves the finite-sum lintegral-predicate theorem `bernstein_sum_subExponential`. Stage B3 proves the deterministic weighted theorem `bernstein_weighted_sum_subExponential`. Raw-predicate statement targets remain `bernstein_subExponential_sum_statement` and `bernstein_subExponential_weighted_sum_statement`.
- Required objects: finite families of random variables, independence, centeredness, subExponential predicate.
- Required definitions: finite-sum MGF vocabulary, `varianceProxy K = sum_i K_i^2`, `maxScale K`, weighted proxies `weightedVarianceProxy c K` and `weightedMaxScale c K`, max-scale domains, and `subExponentialBernsteinRate`.
- Required bridge lemmas: independent finite MGF product, lintegral finite-sum bridges, weighted scalar-multiple MGF bounds, small-regime Chernoff optimization, large-regime endpoint optimization, and min-form comparison.
- Status: proven
- Proven local pieces: local one-variable lintegral Chernoff, finite-sum quadratic small-deviation bound under `0 <= t` and `t <= 2 * varianceProxy K / maxScale K`, large-regime one-/two-sided bounds under `2 * varianceProxy K / maxScale K <= t`, the full unweighted min-form theorem with constant `1/4`, and the deterministic weighted min-form theorem with the same constant.
- Planning label: Stage B3 complete
- Blocker: raw-predicate Bernstein variants remain future work; the scalar lintegral-predicate min-form theorems have no current blocker.
- Target module: `HighDimProb/Concentration/Bernstein.lean`
- Priority: v0.3

## scalar concentration theorem family closeout
- Book heading: scalar concentration inequalities
- Informal statement: Markov/Chebyshev/Boole, scalar subGaussian/subExponential implication arrows, Rademacher/Hoeffding families, scalar Bernstein, and weighted scalar Bernstein are documented and import-tested as one experimental concentration milestone.
- Target Lean statement: no new theorem; Stage SC-closeout adds `HighDimProbTest.ScalarConcentrationMilestoneAPI` as a direct `import HighDimProb.Concentration` audit, Stage SC-final adds the leaf/theorem/test/milestone documentation closure, and Stage SC-final-update refreshes the closeout after the full moment bridges.
- Required objects: existing scalar concentration theorem families.
- Required definitions: existing tail probability, Orlicz, moment, MGF, finite-sum, max-scale, and variance-proxy vocabulary.
- Required bridge lemmas: none new; this stage audits existing imports and tests.
- Status: proven
- Proven local pieces: the milestone document `docs/ScalarConcentrationMilestone.md` records theorem-family tables, constants, import paths, conservative versus sharp theorem names, and remaining TODOs. Stage SC-final adds `docs/ConcentrationLeafAudit.md`, `docs/ScalarConcentrationTheoremIndex.md`, `docs/ConcentrationTestCoverage.md`, and `docs/Milestone-ScalarConcentration.md`; Stage SC-final-update records the full subGaussian and subExponential finite-`ENNReal` moment bridges in those closeout docs.
- Blocker: raw-predicate Bernstein variants, full equivalence packages, and
  matrix/random-process concentration remain future work. The real-exponent
  subGaussian and subExponential moment links are proved.
- Target module: documentation plus `HighDimProbTest/ScalarConcentrationMilestoneAPI.lean`.
- Priority: Stage SC-final-update complete.

## Hoeffding inequality
- Book heading: Hoeffding inequality
- Informal statement: sums of independent bounded variables have Gaussian-type tails around their expectation. The finite weighted Rademacher specialization, the finite unweighted bounded centered theorem, the finite unweighted non-centered Wikipedia-form theorem, and deterministic weighted bounded centered/non-centered theorems are now proven separately.
- Target Lean statement: `hoeffding_sum_bounded`; weighted API uses `hoeffding_weighted_sum_bounded`; sharp centered APIs are `hoeffding_sum_bounded_centered_sharp` and `hoeffding_weighted_sum_bounded_centered_sharp`; conservative centered API remains `hoeffding_sum_bounded_centered`; weighted Rademacher specialization uses `hoeffding_rademacher_sum`.
- Required objects: finite families, independence, interval boundedness, centeredness/centering, integrability for finite expectation linearity, subGaussian MGF and tail predicate forms.
- Required definitions: finite-sum random-variable API, bounded-centered MGF source wrapper, scalar centering API, and `expect` finite-sum bridge.
- Required bridge lemmas: Mathlib bounded centered MGF theorem, Stage H5 independent finite-sum MGF/tail layer, the local eighth-MGF Chernoff optimization, finite-sum denominator normalization, `MeasureTheory.integral_finset_sum`, and `ProbabilityTheory.iIndepFun.comp`.
- Status: proven for finite unweighted bounded centered sums with both conservative and sharp constants, for finite unweighted bounded non-centered sums with the sharp Wikipedia constant around `E[sum_i X_i]`, for deterministic weighted bounded centered and non-centered sums, and for weighted finite Rademacher sums.
- Blocker: exact scale-0 predicate wrappers remain unavailable; this does not block the weighted theorem because it assumes a positive total denominator.
- Target module: `HighDimProb/Concentration/Hoeffding.lean`
- Priority: Stage H8 complete; Stage H9 should close out the Hoeffding branch.

## Weighted bounded Hoeffding theorem
- Book heading: Weighted bounded Hoeffding theorem
- Informal statement: deterministic weighted sums of independent bounded variables satisfy the classical bounded Hoeffding denominator `sum_i c_i^2 * (b_i-a_i)^2`.
- Target Lean statements: `hoeffding_weighted_sum_bounded_centered_sharp`, `hoeffding_weighted_sum_bounded`.
- Required objects: Stage H5 weighted finite-sum MGF closure, Stage H6 bounded centered MGF source wrapper, Stage H6-sharp eighth-MGF Chernoff helpers, and Stage H7 centering infrastructure for the non-centered form.
- Status: proven
- Constant: exponent `-2*t^2 / (sum_i c_i^2 * (b_i-a_i)^2)`; arbitrary real weights are handled through squared weighted half-widths, including negative and zero weights under the positive total denominator assumption.
- Blocker: none for the centered or non-centered weighted theorem.
- Target module: `HighDimProb/Concentration/Hoeffding.lean`
- Priority: Stage H8 complete.

## high-dimensional subGaussian vector characterizations
- Book heading: high-dimensional subGaussian vector characterizations
- Informal statement: a random vector is subGaussian when all one-dimensional marginals are subGaussian; the usual norm is a supremum over unit directions.
- Target Lean statement: blocked until scalar equivalence theorems, psi2 gauges/norms, and unit-sphere vocabulary are available.
- Required objects: `RandomVector`, `marginal`, `directionNorm`, scalar subGaussian predicate forms.
- Required definitions: Stage 4D predicate forms `SubGaussianVectorOrlicz`, `HasSubGaussianVectorOrlicz`, `SubGaussianVectorTail`, `SubGaussianVectorMoment`, and `CenteredSubGaussianVectorMGF` exist.
- Required bridge lemmas: scalar subGaussian equivalences, scaling of marginals, all-direction/unit-sphere equivalence.
- Status: blocked
- Blocker: Stage 4D only provides object-level predicate forms and does not define psi2 vector norms or prove equivalences.
- Target module: `HighDimProb/SubGaussianVector.lean`
- Priority: v0.2

## centered vector iff coordinatewise centered
- Book heading: centered vector iff coordinatewise centered
- Informal statement: vector centeredness is exactly coordinatewise scalar centeredness.
- Target Lean statement: `centeredVector_iff_forall_centered_coord`
- Required objects: `RandomVector`, `coord`, `Centered`, `CenteredVector`.
- Required bridge lemmas: none beyond definitional unfolding.
- Status: proven
- Blocker: none.
- Target module: `HighDimProb/Covariance.lean`
- Priority: v0.2 proof pilot

## centered random variable has mean zero
- Book heading: centered random variable has mean zero
- Informal statement: if a real random variable is integrable, then subtracting its mean produces a centered random variable.
- Target Lean statement: `centered_centered`
- Required objects: `expect`, `mean`, `centered`, `Centered`, `IntegrableRealRandomVariable`, probability measure convention.
- Required bridge lemmas: Mathlib `integral_sub`, `integrable_const`, `integral_const`, and `[IsProbabilityMeasure P]` mass-one simplification.
- Status: proven
- Blocker: none.
- Target module: `HighDimProb/Covariance.lean`
- Priority: v0.2 proof pilot

## isotropic second-moment matrix iff entrywise formulation
- Book heading: isotropic second-moment matrix iff entrywise formulation
- Informal statement: the matrix identity `E[XX?] = I` is equivalent to the coordinate identities `E[X_i X_j] = delta_ij`.
- Target Lean statement: `isotropicSecondMomentMatrix_iff_isotropicSecondMoment`
- Required objects: `RandomVector`, `secondMomentMatrixEntry`, `secondMomentMatrix`, `IsotropicSecondMoment`, `IsotropicSecondMomentMatrix`.
- Required bridge lemmas: Mathlib `Matrix.ext` and `Matrix.one_apply`.
- Status: proven
- Blocker: none.
- Target module: `HighDimProb/Isotropic.lean`
- Priority: v0.2 proof pilot

## random vector isotropic characterizations
- Book heading: random vector isotropic characterizations
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
- Book heading: covariance identity
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
- Book heading: maximal separated set is an epsilon-net
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
- Book heading: covering number upper bound from an epsilon-net
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
- Book heading: covering-packing inequalities
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
- Book heading: Euclidean ball covering number bounds
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
- Book heading: Hamming cube covering and packing bounds
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
- Book heading: epsilon-net and operator norm bound
- Informal statement: operator norm over a sphere can be controlled using an epsilon-net.
- Target Lean statement: `epsilonNetOperatorNormStatement`.
- Required objects: epsilon nets, matrices, operator norm, unit sphere.
- Required definitions: Stage 5A Mathlib-backed net predicate `IsEpsilonNet` exists; Stage 6A random matrix entries and actions exist; Stage 6B adds `operatorNorm`; Stage MC2 adds explicit `IsUnitVector`, `matVecSqNorm`, and `OperatorNormBoundSq` vocabulary; Stage MC2-fix proves the finite-sum L2 norm bridges and both `OperatorNormBoundSq` / `deterministicOperatorNorm` comparison directions.
- Required bridge lemmas: finite net approximation, unit-sphere cover bridge, and a theorem-level net-to-operator-norm reduction using the proved MC2-fix operator-norm bridges.
- Status: typed-prop
- Blocker: finite net approximation and unit-sphere cover arguments remain future work; the exact Mathlib L2 operator-norm comparison and measurability bridges are no longer blockers.
- Target module: `HighDimProb/RandomMatrix/Statements.lean`
- Priority: v0.3

## operator-norm and unit-sphere bridge layer
- Book heading: operator-norm prerequisites for random matrix concentration
- Informal statement: before proving matrix norm concentration, expose unit vectors, explicit matrix-vector squared norms, squared operator-norm bound predicates, typed targets for the exact Mathlib L2 operator-norm bridge, and proved comparison/measurability bridges.
- Target Lean declarations: `vectorSqNorm`, `IsUnitVector`, `unitSphere`, `vectorSqNorm_eq_norm_sq_toLp`, `norm_sq_toLp_eq_vectorSqNorm`, `norm_toLp_eq_one_of_isUnitVector`, `isUnitVector_of_norm_toLp_eq_one`, `matVecSqNorm`, `randomMatVecSqNorm`, `matVecSqNorm_eq_norm_sq_toLp_mulVec`, `norm_sq_toLp_mulVec_eq_matVecSqNorm`, `OperatorNormBoundSq`, `RandomOperatorNormBoundSq`, `operatorNorm_le_of_operatorNormBoundSqStatement`, `operatorNormBoundSq_of_operatorNorm_leStatement`, `operatorNormMeasurabilityStatement`, `operatorNorm_le_of_operatorNormBoundSq`, `operatorNormBoundSq_of_operatorNorm_le`, `instOpensMeasurableSpaceMatrixL2Operator`, `isRealRandomVariable_operatorNorm`.
- Required objects: `RandomMatrix`, `matVec`, Mathlib scoped L2 matrix norm, finite sums over `Fin`.
- Required definitions: Stage MC2 adds `HighDimProb.RandomMatrix.UnitSphere` and extends `HighDimProb.RandomMatrix.OperatorNorm`; Stage MC2-fix adds the Mathlib L2 bridges.
- Required bridge lemmas: MC2-fix reuses finite-dimensional Euclidean norm-square identities, `Matrix.l2_opNorm_mulVec`, `ContinuousLinearMap.opNorm_le_of_unit_norm`, and `measurable_norm`.
- Status: proven bridge plus retained typed `Prop` statement targets
- Blocker: no blocker for the two explicit operator-norm comparison directions or operator-norm measurability. Sample-covariance/unit-sphere concentration reductions remain separate future theorem work.
- Target module: `HighDimProb/RandomMatrix/OperatorNorm.lean`
- Priority: Stage MC2

## matrix concentration assumption vocabulary
- Book heading: matrix Bernstein, matrix Hoeffding, matrix Chernoff, covariance estimation prerequisites
- Informal statement: future matrix concentration theorem statements require explicit symmetry/self-adjointness, PSD/order, matrix expectation, matrix-valued independence, operator-norm bound, and variance-proxy assumptions.
- Target Lean declarations: `IsSymmetricMatrix`, `IsSelfAdjointMatrix`, `RandomSelfAdjointMatrix`, `IsPSDMatrix`, `RandomPSDMatrix`, `MatrixLE`, `matrixExpect`, `centeredRandomMatrix`, `CenteredRandomSelfAdjointMatrices`, `IndependentRandomMatrices`, `BoundedOperatorNorm`, `MatrixVarianceProxy`, `MatrixVarianceProxyBound`.
- Required objects: `RandomMatrix`, `operatorNorm`, `sampleCovariance`, finite matrix sums, Mathlib matrix predicates and independence.
- Required definitions: Stage MC1 adds the vocabulary in `SelfAdjoint`, `MatrixOrder`, `Expectation`, and `ConcentrationStatements`.
- Required bridge lemmas: future proof stages still need matrix Laplace transform infrastructure and theorem-specific spectral/eigenvalue reductions; the exact operator-norm comparison and measurability bridges are proved in Stage MC2-fix, and the PSD variance-proxy algebra is proved in MB-S1.
- Status: implemented vocabulary
- Blocker: no matrix concentration theorem is attempted or proved in MC1.
- Target module: `HighDimProb/RandomMatrix/ConcentrationStatements.lean`
- Priority: Stage MC1

## metric entropy as log covering number
- Book heading: metric entropy as log covering number
- Informal statement: metric entropy is represented as the logarithm of the covering number.
- Target Lean statement: blocked; `metricEntropyLogCoveringStatement` is not added.
- Required objects: `coveringNumber`, real logarithm, finite-cover or infinity convention.
- Required definitions: real-valued metric entropy wrapper.
- Required bridge lemmas: conversion from Mathlib `ENNReal` covering numbers to a finite real count before applying `Real.log`.
- Status: blocked
- Blocker: no convention yet for `Real.log` of `ENNReal` values or infinite covering numbers.
- Target module: `HighDimProb/MetricEntropy.lean`
- Priority: v0.2

## metric entropy coding interpretation
- Book heading: metric entropy coding interpretation
- Informal statement: logarithms of covering numbers quantify coding complexity up to radius changes.
- Target Lean statement: blocked until a real-valued metric entropy convention and coding vocabulary are selected.
- Required objects: `coveringNumber`, possible finite-cover hypothesis, real logarithm, coding/bit-count vocabulary.
- Required definitions: Stage 5A exposes Mathlib `ENNReal` covering numbers; `metricEntropy` real-log wrapper is deferred.
- Required bridge lemmas: finite/infinite count handling, base-change for logarithms, and coding interpretation lemmas.
- Status: blocked
- Blocker: no real-log covering-number convention and no coding vocabulary exist yet.
- Target module: `HighDimProb/MetricEntropy.lean`
- Priority: v0.3

## Dudley integral dependency on covering numbers
- Book heading: Dudley integral dependency on covering numbers
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
- Book heading: subGaussian random matrix norm bound
- Informal statement: random matrices with independent subGaussian entries or rows have high-probability operator norm/singular value bounds.
- Target Lean statement: blocked until independent-entry/independent-row vocabulary and operator-norm theorem bridges exist.
- Required objects: `RandomMatrix`, `matrixEntry`, `rowVector`, `matVec`, `operatorNorm`, independence, subGaussian predicates.
- Required definitions: Stage 6A matrix-valued random-variable predicates, row/column views, action vocabulary, and entry/row subGaussian predicates exist; Stage 6B adds `operatorNorm`.
- Required bridge lemmas: independent entries or rows, entry/row measurability, net-to-operator-norm bounds, and probabilistic concentration inputs; MC2-fix supplies the basic operator-norm comparison bridge.
- Status: blocked
- Blocker: Stage MC1 adds matrix-valued independence, but independent-entry/independent-row sampling assumptions, net arguments, and concentration inputs are still deferred; theorem is beyond object layer.
- Target module: future `HighDimProb/RandomMatrix/Statements.lean`
- Priority: v0.3

## sample covariance concentration
- Book heading: sample covariance concentration
- Informal statement: the empirical or sample covariance matrix of independent subGaussian samples concentrates around the population covariance.
- Target Lean statements: `covarianceEstimationStatement`, `sampleCovarianceOperatorNormStatement`.
- Required objects: `RandomMatrix`, row samples, `sampleCovariance`, covariance matrix, `operatorNorm`, row subGaussian/isotropic assumptions.
- Required definitions: Stage 6A row and assumption predicates exist; Stage 6B adds `sampleCovariance`, `gramMatrix`, and `operatorNorm`; Stage MC1 adds matrix expectation/order vocabulary and typed covariance-estimation statement targets; Stage MC2 adds `sampleCovarianceQuadraticFormDeviation` and the unit-sphere reduction statement target.
- Required bridge lemmas: matrix multiplication/scaling convention, row independence, expectation/covariance bridge, sample-covariance/unit-sphere reduction, and matrix concentration.
- Status: typed-prop
- Blocker: row independence, centered/empirical covariance conventions, the sample-covariance unit-sphere reduction theorem, and matrix concentration proofs are deferred.
- Target module: `HighDimProb/RandomMatrix/ConcentrationStatements.lean`
- Priority: v0.3

## Hanson-Wright inequality
- Book heading: Hanson-Wright inequality
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
- Book heading: Johnson-Lindenstrauss lemma
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
- Book heading: covariance estimation
- Informal statement: empirical covariance of subGaussian samples approximates the population covariance with high probability.
- Target Lean statement: `covarianceEstimationStatement`.
- Required objects: `RandomVector`, `RandomMatrix`, samples, covariance matrices, `sampleCovariance`, matrix norms.
- Required definitions: Stage 6A random matrix rows exist; Stage 6B adds uncentered `sampleCovariance` and `operatorNorm`; Stage MC1 adds matrix order/expectation vocabulary and a typed covariance-estimation target.
- Required bridge lemmas: sample independence, sample covariance algebra, centered/empirical covariance convention, and matrix concentration.
- Status: typed-prop
- Blocker: independence, centered/empirical covariance, sample-covariance/unit-sphere reduction, and matrix concentration proofs are not ready.
- Target module: `HighDimProb/RandomMatrix/ConcentrationStatements.lean`
- Priority: v0.3

## matrix Bernstein inequality
- Book heading: matrix Bernstein inequality
- Informal statement: sums of independent centered random matrices with bounded operator norm satisfy Bernstein-type spectral tail bounds.
- Target Lean statement: `matrixBernsteinStatement`.
- Required objects: random matrices, self-adjoint matrix predicates, centered matrix variables, `operatorNorm`, finite random-matrix sums, matrix square/second moments, variance proxy, independence.
- Required definitions: Stage 6A random matrix object layer exists; Stage 6B adds `operatorNorm`; Stage MC1 adds self-adjoint, matrix order, matrix expectation, and typed statement vocabulary; Stage MC2/MC2-fix adds explicit unit-vector/operator-norm bridges and operator-norm measurability; Stage MC3 adds `randomMatrixSum`, `IndependentSelfAdjointRandomMatrices`, `CenteredSelfAdjointRandomMatrixFamily`, `PointwiseOperatorNormBound`, `matrixSecondMoment`, `matrixVarianceProxy`, and `matrixVarianceProxyNorm`; Stage MC4-cleanup adds `IntegrableRandomMatrix`; MB-S1 adds the PSD square/second-moment/variance-proxy proof layer and refines the additive-form `matrixBernsteinSelfAdjointStatement`.
- Required bridge lemmas: matrix-valued measurability, independence of matrix-valued variables, self-adjoint finite-sum algebra, matrix square measurability, matrix Laplace-transform infrastructure, spectral/operator-norm tail reductions, and self-adjoint dilation if rectangular variants are used. MC2-fix supplies the basic operator-norm comparison and measurability bridges; MC3 supplies random-matrix sum and variance-proxy infrastructure; MC4-cleanup removes meaningless Laplace/trace `True` declarations and keeps those as documentation-only TODOs; MB-S1 supplies PSD variance-proxy algebra.
- Status: typed-prop
- Blocker: theorem proof is beyond MB-S1 and MC5.4. The additive statement remains an operator-norm tail target and still requires spectral/operator-norm tail reductions, a proof of the typed matrix Laplace-transform target, trace/exponential-moment inequalities, and likely a final decision between pointwise and a.e. norm-bounded assumptions. PSD variance-proxy algebra is no longer a blocker.
- Target module: `HighDimProb/RandomMatrix/ConcentrationStatements.lean`
- Priority: v0.4

## matrix deviation inequality
- Book heading: matrix deviation inequality
- Informal statement: empirical matrix deviations such as `sampleCovariance A - Sigma` are controlled in operator norm under sampling and moment assumptions.
- Target Lean statement: `sampleCovarianceOperatorNormStatement` is available as a generic typed target; `sampleCovarianceOperatorNormViaUnitSphereStatement` records the unit-vector reduction route as a typed target; sharper deviation statements remain future work.
- Required objects: `sampleCovariance`, `operatorNorm`, covariance matrices, random matrix rows, row assumptions.
- Required definitions: Stage 6B adds uncentered sample covariance and operator-norm vocabulary; Stage MC1 adds `sampleCovarianceMinusIdentity` and generic sample-covariance operator-norm tail syntax; Stage MC2 adds quadratic-form deviation vocabulary for unit vectors.
- Required bridge lemmas: sample covariance algebra, centered/empirical covariance convention, sample-covariance/unit-sphere reduction, row independence, and matrix concentration.
- Status: partial typed-prop
- Blocker: centered empirical covariance conventions, row independence, sample-covariance/unit-sphere reduction, and matrix concentration proofs remain future work.
- Target module: `HighDimProb/RandomMatrix/ConcentrationStatements.lean`
- Priority: v0.4

## generic chaining / Dudley inequality
- Book heading: generic chaining / Dudley inequality
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
- Book heading: empirical process bounds
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
- Book heading: signal recovery via M* bound
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
- Target Lean statements: `quadraticForm_sampleCovariance_eq_sum_sq`, `quadraticForm_sampleCovariance_nonneg`
- Required objects: `sampleCovariance`, `quadraticForm`, finite sums.
- Required definitions: sample covariance and quadratic form vocabulary.
- Required bridge lemmas: finite-sum distributivity/reindexing using `Finset.mul_sum`, `Finset.sum_mul`, and `Finset.sum_comm`.
- Status: proven
- Blocker: none. Stage RM2 proves the row-dot-square normal form `(1 / (m : Real)) * sum k, (sum i, A omega k i * x i)^2` and derives nonnegativity without assuming `0 < m`.
- Target module: `HighDimProb/RandomMatrix/Algebra.lean`
- Priority: Stage RM2

## sample covariance row rank-one sum bridge
- Book heading: sample covariance and Matrix Bernstein prerequisites
- Informal statement: the uncentered sample covariance should be the normalized
  finite sum of row rank-one random matrices.
- Target Lean statements: `sampleCovarianceRowRankOneSum`,
  `normalizedSampleCovarianceRowRankOneSum`,
  `sampleCovariance_eq_normalized_rowRankOne_sum`
- Required objects: `sampleCovariance`, `rowVector`, `rankOneRandomMatrixFamily`,
  and `randomMatrixSum`.
- Required definitions: named row rank-one finite-sum objects.
- Required bridge lemmas: finite matrix extensionality and entrywise unfolding
  of row rank-one random matrices.
- Status: proven
- Blocker: none for the algebraic representation. This does not prove sample
  covariance concentration or Matrix Bernstein assumptions.
- Target module: `HighDimProb/RandomMatrix/Algebra.lean`
- Priority: RM-S5A

## centered sample covariance row rank-one sum bridge
- Book heading: sample covariance and Matrix Bernstein prerequisites
- Informal statement: the centered sample covariance deviation should be the
  normalized finite sum of centered row rank-one random matrices.
- Target Lean statements: `centeredSampleCovarianceRowRankOneSum`,
  `normalizedCenteredSampleCovarianceRowRankOneSum`,
  `sampleCovariance_deviation_eq_normalized_centered_rowRankOne_sum`
- Required objects: `centeredRandomMatrix`, `sampleCovariance`, `rowVector`,
  `centeredRankOneRandomMatrixFamily`, `randomMatrixSum`, and
  `IntegrableRandomMatrix`.
- Required definitions: named centered row rank-one finite-sum objects.
- Required bridge lemmas: finite-sum linearity of integrals, entrywise matrix
  expectation unfolding, and finite matrix extensionality.
- Status: proven
- Blocker: none for the algebraic centered representation. This does not prove
  row independence, variance-proxy bounds, sample covariance concentration, or
  Matrix Bernstein tails.
- Target module: `HighDimProb/RandomMatrix/Algebra.lean`
- Priority: RM-S5B

## sample covariance quadratic-form Matrix Bernstein tail wrapper
- Book heading: sample covariance and Matrix Bernstein prerequisites
- Informal statement: under explicit row measurability, coordinate `MemLp 2`,
  row squared-norm, row independence, centered square/exponential/trace
  integrability, scalar variance-proxy, Tropp, and CFC primitive assumptions,
  the centered sample covariance satisfies the optimized one-sided
  quadratic-form Matrix Bernstein tail bound.
- Target Lean statement:
  `sampleCovariance_quadraticForm_tail_optimized_under_explicit_variance_proxy`
- Required objects: `centeredRandomMatrix`, `sampleCovariance`,
  `centeredSampleCovarianceRowRankOneFamily`,
  `centeredSampleCovarianceRowRankOneSum`, `MatrixVarianceProxyNormBound`, and
  `matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives`.
- Required definitions: S5A/S5B named sample-covariance row rank-one sum
  objects, `sampleCovarianceCenteredRankOneRadius`,
  `sampleCovarianceTailTheta`, `sampleCovarianceQuadraticFormTailRHS`, and
  S3/S4 centered rank-one adapters.
- Required bridge lemmas: sample covariance centered-sum equality and
  quadratic-form scalar multiplication for the `(1 / m)` normalization.
- Status: proven conditional wrapper
- Blocker: none for the wrapper with explicit assumptions. Unconditional
  variance-proxy control, Tropp/Lieb, Bernstein CFC, Golden-Thompson, and
  unconditional lambda-max/operator-norm Matrix Bernstein tails remain
  unproved.
- Target module: `HighDimProb/RandomMatrix/ConcentrationStatements.lean`
- Priority: RM-S5D

## sample covariance quadratic-form tail usage wrapper
- Book heading: sample covariance and Matrix Bernstein usage examples
- Informal statement: example-level sample covariance tail code should call the
  S5D theorem through a named assumptions bundle and the core scalar RHS rather
  than manually composing the centered sample-covariance bridge and optimized
  Matrix Bernstein wrapper.
- Target Lean statement: `sampleCovariance_quadraticForm_tail_usage`
- Required objects: `SampleCovarianceTailAssumptions`,
  core `sampleCovarianceQuadraticFormTailRHS`,
  `sampleCovariance_quadraticForm_tail_optimized_under_explicit_variance_proxy`.
- Required definitions: S5D sample-covariance tail wrapper and the S5A/S5B
  row-rank-one sum bridges it uses internally.
- Required bridge lemmas: none beyond S5D; this is an example-layer wrapper.
- Status: example API
- Blocker: Tropp/Lieb, Bernstein CFC, Golden-Thompson, and unconditional
  lambda-max/operator-norm Matrix Bernstein tails remain explicit or unproved.
- Target module: `HighDimProb/Examples/RandomMatrix/SampleCovarianceTailUsage.lean`
- Status note: RM-S5E complete.

## nonempty self-adjoint operator-norm Matrix Bernstein wrapper
- Book heading: Matrix Bernstein inequality / operator-norm tail route
- Informal statement: for nonempty square dimensions, the self-adjoint
  operator-norm Matrix Bernstein wrapper no longer requires users to pass
  `selfAdjointOperatorNormTailViaQuadraticFormStatement (randomMatrixSum A) t`
  explicitly; the theorem supplies the S3 nonempty bridge internally.
- Target Lean statement:
  `matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_nonempty_under_primitives`
- Required objects: `randomMatrixSum`, `SelfAdjointOperatorNormTailEvent`,
  `matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives`,
  and `selfAdjointOperatorNormTailViaQuadraticFormStatement_nonempty`.
- Required bridge lemmas:
  `selfAdjointOperatorNormTailViaQuadraticFormStatement_nonempty`.
- Status: proven nonempty wrapper under explicit primitive assumptions
- Blocker: sharp variance control, Tropp/Lieb, Bernstein CFC,
  Golden-Thompson, full Matrix Bernstein, and sample-covariance concentration
  remain unproved. The arbitrary positive-threshold operator-norm route is
  proved separately and is the supported arbitrary-dimensional route.
- Target module: `HighDimProb/RandomMatrix/ConcentrationStatements.lean`
- Test modules: `HighDimProbTest/RandomMatrixConcentrationAPI.lean`
- Judge modules: `HighDimProbJudge/RandomMatrix/MatrixBernsteinUse.lean` and
  `HighDimProbJudge/RandomMatrix/StatementUse.lean`
- Status note: RM-ON-S4 complete.

## sample covariance operator-norm Matrix Bernstein tail wrapper
- Book heading: sample covariance and Matrix Bernstein prerequisites
- Informal statement: under explicit row measurability, coordinate `MemLp 2`,
  row squared-norm, row independence, centered square/exponential/trace
  integrability, bounded-row crude variance-proxy control, Tropp, and CFC, the
  centered sample covariance satisfies the nonempty and arbitrary
  positive-threshold two-sided operator-norm tail bounds without an explicit
  spectral-bridge assumption.
- Target Lean statements:
  `sampleCovariance_selfAdjointOperatorNormTailEvent_subset_centeredRowRankOneSum`
  and
  `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_under_explicit_variance_proxy`,
  `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_nonempty_under_explicit_variance_proxy`,
  `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_explicit_variance_proxy`,
  `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound`,
  `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound_with_neg_adapters`
- Required objects: `SelfAdjointOperatorNormTailEvent`,
  `centeredRandomMatrix`, `sampleCovariance`,
  `centeredSampleCovarianceRowRankOneSum`,
  `matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives`,
  `matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_nonempty_under_primitives`,
  `matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_arbitrary_of_pos_under_primitives`,
  `selfAdjointOperatorNormTailViaQuadraticFormStatement`, and
  `selfAdjointOperatorNormTailViaQuadraticFormStatement_nonempty`,
  `selfAdjointOperatorNormTailViaQuadraticFormStatement_of_pos`.
- Required bridge lemmas: sample covariance centered-sum equality and the
  proved S7E operator-norm event bridge.
- Status: proven retained conditional wrapper, proven nonempty wrapper,
  proven arbitrary positive-threshold wrapper, and proven bounded-row crude
  variance-proxy wrappers, including the adapter-based version that derives
  negative centeredness, independence, entrywise integrability, and pointwise
  operator-norm bounds.
- Blocker: sharp variance control, Tropp/Lieb, Bernstein CFC,
  Golden-Thompson, full Matrix Bernstein, and unconditional sample-covariance
  concentration remain unproved. The original arbitrary `0 <= t` spectral
  bridge is false at `Fin 0`, `t = 0`.
- Target module: `HighDimProb/RandomMatrix/ConcentrationStatements.lean`
- Test modules: `HighDimProbTest/RandomMatrixConcentrationAPI.lean` and
  `HighDimProbTest/ExamplesAPI.lean`
- Judge module: `HighDimProbJudge/RandomMatrix/MatrixBernsteinUse.lean`
- Repository next safe task: RM-TROPP-S11-conditional-step-assumption-bundle-contract.

## sample covariance variance-proxy control
- Book heading: sample covariance and Matrix Bernstein prerequisites
- Informal statement: pointwise operator-norm control should produce a reusable
  crude `MatrixVarianceProxyNormBound`, then specialize to centered rank-one
  and sample-covariance row rank-one summands.
- Target Lean statements:
  `MatrixVarianceProxyNormBound_of_pointwiseOperatorNormBound`,
  `MatrixVarianceProxyNormBound_centeredRankOneRandomMatrixFamily_of_sqNorm_bound`,
  `MatrixVarianceProxyNormBound_centeredSampleCovarianceRowRankOneFamily_of_rowSqNorm_bound`,
  `sampleCovariance_quadraticForm_tail_optimized_under_rowSqNorm_bound`,
  and
  `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound`,
  plus the adapter-based
  `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound_with_neg_adapters`.
- Required objects: `MatrixVarianceProxyNormBound`,
  `MatrixVarianceProxyUpperBound`, `matrixVarianceProxy`,
  `matrixVarianceProxyNorm`,
  `centeredSampleCovarianceRowRankOneFamily`,
  `centeredRankOneRandomMatrix_centeredSelfAdjoint_of_memLp_two`,
  `PointwiseOperatorNormBound_centeredRankOneRandomMatrix_of_sqNorm_bound`,
  and `isPSD_matrixVarianceProxy_of_selfAdjoint`.
- Required definitions: S5D/S5E sample-covariance tail wrapper surfaces and
  S3/S4 centered rank-one adapters.
- Required bridge lemmas: deterministic norm submultiplicativity, norm of
  matrix expectation bounded by the integral of pointwise norms, and finite
  sum norm bounds.
- Status: proven crude theorem family; sharp fourth-moment variance control is
  not proved.
- Blocker: none for crude bounded-row variance-proxy control. Sharp
  moment-optimal control remains future work.
- Target module: `HighDimProb/RandomMatrix/VarianceProxy.lean`,
  `HighDimProb/RandomMatrix/Assumptions.lean`, and
  `HighDimProb/RandomMatrix/ConcentrationStatements.lean`.
- Status note: RM-VP complete.
- Repository next safe task:
  RM-TROPP-S11-conditional-step-assumption-bundle-contract.

## sample covariance PSD bridge
- Book heading: sample covariance and PSD prerequisites
- Informal statement: the uncentered sample covariance matrix is symmetric and positive semidefinite in the explicit HighDimProb quadratic-form sense.
- Target Lean statements: `isSymmetricMatrix_sampleCovariance`, `isPSD_sampleCovariance`, `randomPSDMatrix_sampleCovariance`
- Required objects: `sampleCovariance`, `matrixQuadraticForm`, `IsPSDMatrix`, finite sums.
- Required definitions: Stage MC1 adds explicit symmetry/PSD vocabulary and reuses the Stage RM2 quadratic-form nonnegativity bridge.
- Required bridge lemmas: `quadraticForm_sampleCovariance_nonneg` and finite-sum commutativity for symmetry.
- Status: proven structural bridge
- Blocker: none for uncentered sample covariance. Gram/row-Gram PSD wrappers and covariance-matrix PSD remain future work.
- Target module: `HighDimProb/RandomMatrix/MatrixOrder.lean`
- Priority: Stage MC1

## Matrix Bernstein Theorem (MC4-cleanup)

- Book heading: Matrix Bernstein inequality (Tropp 5.4)
- Informal statement: for independent centered self-adjoint random matrices with
  uniform norm bound `R` and variance proxy `sigma^2`, the operator norm of the sum
  satisfies a subGaussian+subExponential tail bound with dimension factor `2n`.
- Target Lean statement: `matrixBernsteinStatement` (min-form) and
  `matrixBernsteinSelfAdjointStatement` (additive-form)
- Required objects: `CenteredSelfAdjointRandomMatrixFamily`,
  `IndependentSelfAdjointRandomMatrices`, `PointwiseOperatorNormBound`,
  `matrixVarianceProxyNorm`, `operatorNorm`, `randomMatrixSum`
- Required bridge lemmas: lambda-max/operator-norm bridge, matrix Laplace
  transform, Golden-Thompson inequality, and trace-exponential machinery.
  PSD of `A_i^2`, `E[A_i^2]`, and `matrixVarianceProxy` is proved in MB-S1.
  MB-S2 adds two-sided quadratic-form event vocabulary, lintegral trace-exp
  and Laplace typed targets, and a bundled analytic prerequisite statement.
- Status: typed-prop (statement refined in MB-S1)
- Blocker: Golden-Thompson and Lieb-style trace inequalities are not
  available here. MC5.2/MC5.3 and MB-S2 provide honest trace-exponential,
  lintegral, and matrix Laplace typed targets, but no trace-mgf, matrix
  Laplace, or matrix Bernstein theorem is proved. The statement remains in
  operator-norm form rather than switching to lambda-max before the
  Rayleigh/operator-norm bridges are proved.
- Target module: `HighDimProb/RandomMatrix/ConcentrationStatements.lean`
- Proof plan: `docs/MatrixBernsteinProofPlan.md`
- Priority: Stage MC5+

## Matrix lambda-max / Operator-norm Bridge (MC4-cleanup)

- Book heading: spectral radius equals operator norm for self-adjoint matrices
- Informal statement: for a self-adjoint real matrix, `norm A = max |lambda_i(A)|`
- Target Lean statement: `operatorNorm_eq_spectralRadius_of_selfAdjointStatement`
- Required objects: `deterministicOperatorNorm`, `spectralRadius`,
  `Matrix.IsHermitian.eigenvalues`
- Status: typed-prop (MC4-cleanup), unproved
- Blocker: `spectralRadius` returns `NNReal?, not `Real; needs coercion and norm equality proof
- Target module: `HighDimProb/RandomMatrix/ConcentrationStatements.lean`
- Priority: Stage MC5

## Matrix Spectral Vocabulary (MC5.1)

- Book heading: largest eigenvalue and Rayleigh quotient prerequisites for
  matrix Bernstein.
- Informal statement: expose a small largest/smallest eigenvalue vocabulary for
  nonempty finite self-adjoint real matrices, plus proof-friendly
  quadratic-form tail predicates that can stand in for lambda-max events until
  the Rayleigh quotient theorem is proved.
- Target Lean declarations: `lambdaMax`, `lambdaMaxOrdered`, `lambdaMin`,
  `QuadraticFormUpperBound`, `QuadraticFormLowerBound`, `LambdaMaxBound`,
  `LambdaMaxPSDUpperBound`, `LambdaMaxOrderedPSDUpperBound`,
  `quadraticFormUpperTailEvent`, `quadraticFormLowerTailEvent`,
  `SelfAdjointOperatorNormTailEvent`,
  `lambdaMax_le_iff_quadraticForm_le_statement`,
  `lambdaMax_eq_lambdaMaxOrdered_statement`,
  `lambdaMaxOrdered_is_greatest_eigenvalue`,
  `operatorNorm_eq_max_abs_lambda_statement`.
- Required objects: `IsSelfAdjointMatrix`, `Matrix.IsHermitian.eigenvalues`,
  `Matrix.IsHermitian.eigenvalues?`, `IsUnitVector`, `matrixQuadraticForm`,
  `operatorNorm`.
- Status: implemented vocabulary and typed targets; MB-S7A-index adds
  `lambdaMaxOrdered` as the canonical ordered `eigenvalues? 0` endpoint and
  proves the ordered endpoint greatest theorem. MB-S7A-provider proves that
  `lambdaMaxOrdered` supplies `SpectralUpperBound` and the direct ordered
  Rayleigh wrapper.
- Blocker: future proof work must connect the ordered Rayleigh route to the
  trace-exp dominance target and still connect self-adjoint operator-norm tails
  to lambda-max tails for `A` and `-A`.
- Target module: `HighDimProb/RandomMatrix/Spectral.lean`
- Test module: `HighDimProbTest/RandomMatrixSpectralAPI.lean`
- Priority: Stage MC5

## Matrix Trace-Exponential Vocabulary (MC5.2)

- Book heading: matrix Laplace transform prerequisites.
- Informal statement: expose matrix exponential, trace, trace of matrix
  exponential, and trace-exponential moment vocabulary for future matrix
  Laplace and trace-mgf arguments.
- Target Lean declarations: `matrixExp`, `matrixTrace`, `traceMatrixExp`,
  `isSelfAdjointMatrix_matrixExp`, `traceExpIntegrand`, `traceExpMoment`,
  `traceExpMomentLIntegral`, `matrixTrace_nonneg_of_posSemidef`,
  `traceMatrixExp_nonneg_of_matrixExp_posSemidef`,
  `traceExpMoment_nonneg_of_nonneg`,
  `traceExpMomentLIntegral_nonneg`,
  `traceExpMomentLIntegral_eq_ofReal_traceExpMoment`,
  `traceExpMomentBoundStatement`, `traceExpVarianceProxyBoundStatement`.
- Required objects: `NormedSpace.exp` on matrices, `Matrix.trace`,
  `RandomMatrix`, `RandomSelfAdjointMatrix`, `IsPSDMatrix`.
- Status: implemented vocabulary; MB-S3 proves the downstream nonnegativity and
  real-expectation/lintegral bridges under explicit hypotheses, and MB-S4
  proves PSD of `matrixExp A` for self-adjoint real matrices. No
  Golden-Thompson, Lieb, trace-mgf, full matrix Laplace, or matrix Bernstein
  theorem is proved.
- Blocker: future proof work must add trace-exponential moment inequalities
  and the full matrix Laplace transform reduction over the existing vocabulary.
- Target module: `HighDimProb/RandomMatrix/TraceExp.lean`
- Test module: `HighDimProbTest/RandomMatrixTraceExpAPI.lean`
- Priority: Stage MC5

## Matrix Laplace Statement Vocabulary (MC5.3)

- Book heading: matrix Laplace transform method for matrix Bernstein.
- Informal statement: trace-exponential moment bounds should imply upper-tail
  bounds for the largest self-adjoint direction, and eventually for the
  self-adjoint operator norm by applying the route to `Y` and `-Y`.
- Target Lean declarations: `matrixLaplaceRHS`,
  `matrixLaplaceRHSLIntegral`, `traceExpThresholdEvent`,
  `TraceExpDominatesUpperBound`,
  `matrixUpperBoundTailEvent_subset_traceExpThresholdEvent_of_traceExpDominatesUpperBound`,
  `quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_rayleighUpperBound_of_traceExpDominatesUpperBound`,
  `quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_spectralUpperBound_of_traceExpDominatesUpperBound`,
  `traceExpDominatesQuadraticFormUpperTail_of_rayleighUpperBound_of_traceExpDominatesUpperBound`,
  `traceExpDominatesQuadraticFormUpperTail_of_spectralUpperBound_of_traceExpDominatesUpperBound`,
  `matrixLaplaceRHSLIntegralDiv`,
  `traceExpThresholdEvent_lintegral_bound`,
  `matrixLaplaceTransformLIntegralDiv_of_traceExpThreshold_subset`,
  `matrixLaplaceTransformLIntegral_of_traceExpThreshold_subset`,
  `TraceExpDominatesQuadraticFormUpperTail`,
  `traceExpDominatesQuadraticFormUpperTailStatement`,
  `matrixLaplaceTransformLIntegralDiv_of_traceExpDominatesQuadraticFormUpperTail`,
  `matrixLaplaceTransformLIntegral_of_traceExpDominatesQuadraticFormUpperTail`,
  `matrixLaplaceTransformLIntegralDiv_of_randomSelfAdjoint`,
  `matrixLaplaceTransformLIntegral_of_randomSelfAdjoint`,
  `matrixLaplaceTransformStatement`, `matrixChernoffFromTraceExpStatement`,
  `selfAdjointOperatorNormLaplaceStatement`.
- Required objects: `quadraticFormUpperTailEvent`,
  `SelfAdjointOperatorNormTailEvent`, `traceExpMoment`,
  `RandomSelfAdjointMatrix`, and `ENNReal.ofReal`.
- Status: conditional bridge plus typed-prop targets. MB-S5 proves the
  trace-exponential threshold Markov bound and conditional quadratic-form
  Laplace bridge under an explicit subset hypothesis; MB-S6 names that
  dominance hypothesis and proves conditional wrappers from it.
  MB-S7B-semantic adds the semantic deterministic
  `TraceExpDominatesUpperBound` predicate and proves generic event bridges from
  explicit Rayleigh/spectral and trace-exp dominance assumptions.
  MB-S7B-provider-close proves that `lambdaMaxOrdered` supplies
  `TraceExpDominatesUpperBound`. MB-S7C proves the concrete random
  self-adjoint `TraceExpDominatesQuadraticFormUpperTail` assembly. MB-S8
  proves concrete random self-adjoint lintegral Laplace wrappers; no real RHS
  bridge or trace-mgf theorem is proved.
- Blocker: future proof work must bridge the lintegral RHS to the real
  trace-exp moment/RHS vocabulary, then still prove the self-adjoint
  operator-norm/lambda-max route and the trace-mgf inequality for independent
  matrix sums.
- Target module: `HighDimProb/RandomMatrix/Laplace.lean`
- Test module: `HighDimProbTest/RandomMatrixLaplaceAPI.lean`
- Priority: Stage MC5

## Matrix Bernstein Spectral / Laplace Bridge (MB-S2)

- Book heading: matrix Bernstein analytic prerequisites.
- Informal statement: strengthen the statement layer between PSD variance
  proxy algebra and the future matrix Laplace proof by exposing monotone
  quadratic-form bounds, two-sided quadratic-form tail events, lintegral
  trace-exponential moments, lintegral matrix Laplace targets, and a bundled
  matrix Bernstein prerequisite statement.
- Target Lean declarations: `quadraticFormUpperBound_mono`,
  `quadraticFormLowerBound_mono`, `twoSidedQuadraticFormTailEvent`,
  `quadraticFormUpperTailEvent_subset_twoSidedQuadraticFormTailEvent`,
  `quadraticFormLowerTailEvent_subset_twoSidedQuadraticFormTailEvent`,
  `lambdaMax_is_greatest_eigenvalue_statement`,
  `lambdaMin_is_least_eigenvalue_statement`,
  `selfAdjointOperatorNormTailViaQuadraticFormStatement`,
  `selfAdjointOperatorNormTailViaQuadraticFormStatement_nonempty`,
  `traceExpMomentLIntegral`,
  `traceMatrixExp_nonneg_of_selfAdjoint_statement`,
  `traceExpMoment_nonneg_statement`,
  `traceExpMomentLIntegral_eq_ofReal_statement`,
  `matrixLaplaceRHSLIntegral`,
  `matrixLaplaceTransformLIntegralStatement`,
  `matrixChernoffFromTraceExpLIntegralStatement`,
  `selfAdjointOperatorNormLaplaceRHSLIntegral`,
  `selfAdjointOperatorNormLaplaceLIntegralStatement`, and
  `matrixBernsteinLaplacePrerequisitesStatement`.
- Required objects: `IsUnitVector`, `matrixQuadraticForm`,
  `quadraticFormUpperTailEvent`, `quadraticFormLowerTailEvent`,
  `traceExpMoment`, `traceExpMomentLIntegral`, and
  `selfAdjointOperatorNormTailEvent`.
- Status: partial bridge. The monotonicity and one-sided-to-two-sided event
  inclusion lemmas are proved. MB-S3 proves the trace-exp moment nonnegativity
  and lintegral bridge under explicit assumptions. MB-S4 proves self-adjoint
  trace-exp positivity, MB-S5 proves the conditional trace-exp threshold
  Markov/Laplace bridge, and MB-S6 names the missing dominance hypothesis with
  conditional Laplace wrappers. MB-S7C proves concrete random self-adjoint
  dominance, and MB-S8 proves concrete lintegral Laplace wrappers. The
  Rayleigh/operator-norm, real RHS bridge, trace-mgf, and matrix Bernstein
  results remain unproved.
- Blocker: the self-adjoint operator-norm/lambda-max route, real RHS bridge,
  and trace-mgf inequalities.
- Target modules: `HighDimProb/RandomMatrix/Spectral.lean`,
  `HighDimProb/RandomMatrix/TraceExp.lean`,
  `HighDimProb/RandomMatrix/Laplace.lean`, and
  `HighDimProb/RandomMatrix/ConcentrationStatements.lean`.
- Test modules: `HighDimProbTest/RandomMatrixSpectralAPI.lean`,
  `HighDimProbTest/RandomMatrixTraceExpAPI.lean`,
  `HighDimProbTest/RandomMatrixLaplaceAPI.lean`, and
  `HighDimProbTest/RandomMatrixConcentrationAPI.lean`.
- Repository next safe task after MB-S2 through MB-S9-foundation and
  negative-family adapter cleanup:
  RM-TROPP-S11-conditional-step-assumption-bundle-contract.

## Trace-Exponential Positivity Bridge (MB-S3/MB-S4)

- Book heading: matrix Laplace transform prerequisites.
- Informal statement: trace-exponential moments can be safely routed through
  nonnegative integrals once trace-exp nonnegativity is supplied explicitly.
- Target Lean declarations: `matrixTrace_nonneg_of_posSemidef`,
  `traceMatrixExp_nonneg_of_matrixExp_posSemidef`,
  `matrixExp_posSemidef_of_selfAdjoint_statement`,
  `matrixExp_posSemidef_of_selfAdjoint`, `traceExpIntegrand`,
  `traceMatrixExp_nonneg_of_selfAdjoint`,
  `traceExpMoment_nonneg_of_nonneg`,
  `traceExpIntegrand_nonneg_of_randomSelfAdjoint`,
  `traceExpMoment_nonneg_of_randomSelfAdjoint`,
  `traceExpMomentLIntegral_nonneg`,
  `traceExpMomentLIntegral_eq_ofReal_traceExpMoment`.
- Required objects: Mathlib `Matrix.PosSemidef.trace_nonneg`, HighDimProb
  `traceMatrixExp`, `traceExpMoment`, `traceExpMomentLIntegral`, and scalar
  integrability via `IntegrableRealRandomVariable`.
- Status: proven bridge for trace-exp nonnegativity. MB-S4 proves
  `matrixExp_posSemidef_of_selfAdjoint` from Mathlib's scoped matrix Loewner
  order and CFC theorem `IsSelfAdjoint.exp_nonneg`, then derives deterministic
  trace nonnegativity and random self-adjoint trace-exp moment nonnegativity.
- Blocker: none for the matrix-exponential PSD bridge. Matrix Laplace,
  trace-mgf inequalities, Golden-Thompson/Lieb inputs, and spectral/operator
  norm tail reductions remain future work.
- Target module: `HighDimProb/RandomMatrix/TraceExp.lean`
- Test module: `HighDimProbTest/RandomMatrixTraceExpAPI.lean`
- Priority: Stage MB-S4 complete; MB-S5 has completed the conditional
  Markov/Laplace bridge over the existing trace-exp vocabulary.

## Conditional Matrix Laplace Bridge (MB-S5)

- Book heading: matrix Laplace transform method for matrix Bernstein.
- Informal statement: once the quadratic-form upper-tail event is known to be
  contained in the trace-exponential threshold event, Mathlib's lintegral
  Markov inequality bounds the quadratic-form tail by the lintegral Laplace
  RHS.
- Target Lean declarations: `traceExpThresholdEvent`,
  `matrixLaplaceRHSLIntegralDiv`,
  `matrixLaplaceRHSLIntegralDiv_eq_matrixLaplaceRHSLIntegral`,
  `traceExpThresholdEvent_lintegral_bound`,
  `matrixLaplaceTransformLIntegralDiv_of_traceExpThreshold_subset`, and
  `matrixLaplaceTransformLIntegral_of_traceExpThreshold_subset`.
- Required objects: Mathlib `MeasureTheory.meas_ge_le_lintegral_div`,
  `traceExpIntegrand`, `traceExpMomentLIntegral`,
  `matrixLaplaceRHSLIntegral`, and `quadraticFormUpperTailEvent`.
- Status: proven conditional bridge.
- Blocker: the subset
  `quadraticFormUpperTailEvent Y t subset traceExpThresholdEvent Y theta t` is not
  proved. Full matrix Laplace, trace-mgf, Golden-Thompson, Lieb, and matrix
  Bernstein remain unproved.
- Target module: `HighDimProb/RandomMatrix/Laplace.lean`
- Test module: `HighDimProbTest/RandomMatrixLaplaceAPI.lean`
- Judge module: `HighDimProbJudge/RandomMatrix/LaplaceUse.lean`
- Priority: Stage MB-S5 complete; MB-S6 records the missing dominance step as
  an explicit hypothesis and proves conditional wrappers.

## Source-First Conditional Trace-Exp Dominance Bridge (MB-S6)

- Book heading: matrix Laplace transform method for matrix Bernstein.
- Informal statement: the book route reduces largest-eigenvalue tails through a
  trace-exponential threshold, but the current HighDimProb
  `quadraticFormUpperTailEvent` API still needs a Rayleigh/min-max spectral
  bridge. MB-S6 exposes that step as an explicit predicate and proves only
  conditional consequences.
- Target Lean declarations: `TraceExpDominatesQuadraticFormUpperTail`,
  `traceExpDominatesQuadraticFormUpperTailStatement`,
  `quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_traceExpDominates`,
  `matrixLaplaceTransformLIntegralDiv_of_traceExpDominatesQuadraticFormUpperTail`,
  and `matrixLaplaceTransformLIntegral_of_traceExpDominatesQuadraticFormUpperTail`.
- Required objects: `quadraticFormUpperTailEvent`,
  `traceExpThresholdEvent`, `matrixLaplaceRHSLIntegralDiv`,
  `matrixLaplaceRHSLIntegral`, and `RandomSelfAdjointMatrix`.
- Status: conditional bridge proved under explicit
  `TraceExpDominatesQuadraticFormUpperTail Y theta t`.
- Blocker: MB-S7B-semantic later proves generic semantic bridges from explicit
  `TraceExpDominatesUpperBound` assumptions, MB-S7B-scalar-endpoint proves
  nonnegative scalar multiplication for the ordered endpoint, and
  MB-S7B-exp-spectral-mapping proves `lambdaMaxOrdered_matrixExp`, and
  MB-S7B-trace-dominates-endpoint proves
  `lambdaMaxOrdered_le_trace_of_posSemidef`, MB-S7B-provider-close proves
  `lambdaMaxOrdered_traceExpDominatesUpperBound`, and MB-S7C proves
  `traceExpDominatesQuadraticFormUpperTail_of_randomSelfAdjoint`. Full matrix
  Laplace, trace-mgf, Golden-Thompson, Lieb, and matrix Bernstein remain
  unproved.
- Target module: `HighDimProb/RandomMatrix/Laplace.lean`
- Test module: `HighDimProbTest/RandomMatrixLaplaceAPI.lean`
- Judge module: `HighDimProbJudge/RandomMatrix/LaplaceUse.lean`
- Priority: Stage MB-S6 is complete, but direct dominance should wait until
  the ordered endpoint PSD/Rayleigh bridge is proved.

## Semantic Trace-Exp Dominance Bridge (MB-S7B-semantic)

- Book heading: matrix Laplace transform method for matrix Bernstein.
- Informal statement: if a scalar process `L` bounds the quadratic-form upper
  tail semantically and the deterministic trace exponential dominates
  `exp(theta * L)`, then the quadratic-form tail is contained in the
  trace-exponential threshold event.
- Target Lean declarations: `TraceExpDominatesUpperBound`,
  `matrixUpperBoundTailEvent_subset_traceExpThresholdEvent_of_traceExpDominatesUpperBound`,
  `quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_rayleighUpperBound_of_traceExpDominatesUpperBound`,
  `quadraticFormUpperTailEvent_subset_traceExpThresholdEvent_of_spectralUpperBound_of_traceExpDominatesUpperBound`,
  `traceExpDominatesQuadraticFormUpperTail_of_rayleighUpperBound_of_traceExpDominatesUpperBound`,
  and
  `traceExpDominatesQuadraticFormUpperTail_of_spectralUpperBound_of_traceExpDominatesUpperBound`.
- Required objects: `matrixUpperBoundTailEvent`, `RayleighUpperBound`,
  `SpectralUpperBound`, `traceExpThresholdEvent`, `traceExpIntegrand`,
  `traceMatrixExp`, and `ENNReal.ofReal`.
- Status: proved generic semantic bridges under explicit `0 <= theta` and
  pointwise `TraceExpDominatesUpperBound` hypotheses.
- Blocker: MB-S7B-provider-close proves the `lambdaMaxOrdered` trace-exp
  provider theorem, and MB-S7C proves the concrete random self-adjoint
  dominance assembly. Full matrix Laplace, trace-mgf, Golden-Thompson, Lieb,
  and Matrix Bernstein remain unproved.
- Target module: `HighDimProb/RandomMatrix/Laplace.lean`
- Test module: `HighDimProbTest/RandomMatrixLaplaceAPI.lean`
- Judge module: `HighDimProbJudge/RandomMatrix/LaplaceUse.lean`
- Priority: MB-S7C-assemble-dominance is complete; next safe task is
  MB-S8-laplace-assembly.

## Ordered Endpoint Scalar Multiplication (MB-S7B-scalar-endpoint)

- Book heading: matrix Laplace transform method for matrix Bernstein.
- Informal statement: for `0 <= theta`, the canonical ordered endpoint of
  `theta smul A` is `theta * lambdaMaxOrdered A hA`.
- Target Lean declarations: `lambdaMaxOrdered_smul_of_nonneg`.
- Required objects: `lambdaMaxOrdered`, `isSelfAdjointMatrix_smul`, Mathlib
  real spectrum scaling, Hermitian real spectrum membership, and ordered
  eigenvalue antitonicity.
- Status: proved.
- Blocker: none for scalar multiplication. The `lambdaMaxOrdered` trace-exp
  provider theorem, exponential spectral mapping, trace-dominates-endpoint
  theorem, full matrix Laplace, trace-mgf, Golden-Thompson, Lieb, and Matrix
  Bernstein remain unproved.
- Target module: `HighDimProb/RandomMatrix/Spectral.lean`
- Test module: `HighDimProbTest/RandomMatrixSpectralAPI.lean`
- Judge module: `HighDimProbJudge/RandomMatrix/SpectralUse.lean`
- Priority: completed; MB-S7B-exp-spectral-mapping is now also complete.

## Ordered Endpoint Matrix Exponential (MB-S7B-exp-spectral-mapping)

- Book heading: matrix Laplace transform method for matrix Bernstein.
- Informal statement: for self-adjoint real matrices, the ordered largest
  endpoint of `matrixExp A` is `Real.exp (lambdaMaxOrdered A hA)`.
- Target Lean declaration: `lambdaMaxOrdered_matrixExp`.
- Required objects: `lambdaMaxOrdered`, `matrixExp`,
  `isSelfAdjointMatrix_matrixExp`, CFC spectral mapping, and Hermitian real
  spectrum endpoint APIs.
- Status: proved.
- Blocker: none for exponential spectral mapping. At this stage the
  `lambdaMaxOrdered` trace-exp provider theorem and trace endpoint theorem were
  still future splits; MB-S7B-trace-dominates-endpoint now proves the trace
  endpoint split. Full matrix Laplace, trace-mgf, Golden-Thompson, Lieb, and
  Matrix Bernstein remain unproved.
- Target module: `HighDimProb/RandomMatrix/TraceExp.lean`
- Test module: `HighDimProbTest/RandomMatrixTraceExpAPI.lean`
- Judge module: `HighDimProbJudge/RandomMatrix/TraceExpUse.lean`
- Priority: completed; MB-S7B-trace-dominates-endpoint is now also complete.

## Ordered Endpoint Trace Domination (MB-S7B-trace-dominates-endpoint)

- Book heading: matrix Laplace transform method for matrix Bernstein.
- Informal statement: for a positive semidefinite self-adjoint real matrix, the
  ordered largest endpoint is bounded by the matrix trace.
- Target Lean declaration: `lambdaMaxOrdered_le_trace_of_posSemidef`.
- Required objects: `lambdaMaxOrdered`, `Matrix.trace`, Hermitian trace as sum
  of eigenvalues, PSD eigenvalue nonnegativity, and finite nonnegative sums.
- Status: proved.
- Blocker: none for trace endpoint domination. The `lambdaMaxOrdered`
  trace-exp provider theorem is now proved by MB-S7B-provider-close. Full
  matrix Laplace, trace-mgf, Golden-Thompson, Lieb, and Matrix Bernstein
  remain unproved.
- Target module: `HighDimProb/RandomMatrix/Spectral.lean`
- Test module: `HighDimProbTest/RandomMatrixSpectralAPI.lean`
- Judge module: `HighDimProbJudge/RandomMatrix/SpectralUse.lean`
- Priority: completed; MB-S7B-provider-close is now also complete.

## Ordered Endpoint Trace-Exp Provider (MB-S7B-provider-close)

- Book heading: matrix Laplace transform method for matrix Bernstein.
- Informal statement: for `0 <= theta`, the trace exponential of `theta smul A`
  dominates `exp (theta * lambdaMaxOrdered A hA)`.
- Target Lean declaration: `lambdaMaxOrdered_traceExpDominatesUpperBound`.
- Required objects: `TraceExpDominatesUpperBound`, `lambdaMaxOrdered`,
  `lambdaMaxOrdered_smul_of_nonneg`, `lambdaMaxOrdered_matrixExp`,
  `lambdaMaxOrdered_le_trace_of_posSemidef`,
  `matrixExp_posSemidef_of_selfAdjoint`, and `traceMatrixExp`.
- Status: proved.
- Blocker: none for the deterministic provider. MB-S7C proves the concrete
  random self-adjoint dominance assembly. Full matrix Laplace, trace-mgf,
  Golden-Thompson, Lieb, and Matrix Bernstein remain unproved.
- Target module: `HighDimProb/RandomMatrix/Laplace.lean`
- Test module: `HighDimProbTest/RandomMatrixLaplaceAPI.lean`
- Judge module: `HighDimProbJudge/RandomMatrix/LaplaceUse.lean`
- Priority: MB-S7C-assemble-dominance is complete; next safe task is
  MB-S8-laplace-assembly.

## Concrete Trace-Exp Dominance Assembly (MB-S7C)

- Book heading: matrix Laplace transform method for matrix Bernstein.
- Informal statement: random self-adjointness and `0 <= theta` are enough to
  supply the concrete `TraceExpDominatesQuadraticFormUpperTail` dominance
  wrapper by using the `lambdaMaxOrdered` Rayleigh and trace-exp providers.
- Target Lean declaration:
  `traceExpDominatesQuadraticFormUpperTail_of_randomSelfAdjoint`.
- Required objects: `RandomSelfAdjointMatrix`,
  `lambdaMaxOrdered_rayleighUpperBound`,
  `lambdaMaxOrdered_traceExpDominatesUpperBound`, and
  `traceExpDominatesQuadraticFormUpperTail_of_rayleighUpperBound_of_traceExpDominatesUpperBound`.
- Status: proved.
- Blocker: none for concrete dominance assembly. Full matrix Laplace,
  trace-mgf, Golden-Thompson, Lieb, and Matrix Bernstein remain unproved.
- Target module: `HighDimProb/RandomMatrix/Laplace.lean`
- Test module: `HighDimProbTest/RandomMatrixLaplaceAPI.lean`
- Judge module: `HighDimProbJudge/RandomMatrix/LaplaceUse.lean`
- Priority: MB-S9-foundation is complete; next safe task is
  MB-S9-trace-mgf-to-laplace-tail-contract.

## Matrix Bernstein Tropp Master Trace-MGF Primitive (MB-S9-Tropp)

- Book heading: Matrix Bernstein inequality / Lieb inequality for random
  matrices.
- Informal statement: the Tropp/Lieb one-step primitive bounds
  `E tr exp(H + Z)` by `tr exp(H + log E exp Z)`.
- Target Lean declaration: `troppMasterTraceMGFStep_statement`.
- Required objects: `traceMatrixExp`, `matrixExp`, `matrixExpect`,
  `IntegrableRealRandomVariable`, `IntegrableRandomMatrix`,
  `RandomSelfAdjointMatrix`, `IsSelfAdjointMatrix`, and `IsStrictlyPositive`.
- Status: typed statement only, API-tested, and judge-tested. Lieb concavity,
  Golden-Thompson, the trace-mgf provider, full trace-mgf master theorem, and
  Matrix Bernstein remain unproved.
- Target module: `HighDimProb/RandomMatrix/TraceExp.lean`
- Test module: `HighDimProbTest/RandomMatrixTraceExpAPI.lean`
- Judge module: `HighDimProbJudge/RandomMatrix/TraceExpUse.lean`
- Priority: this has been followed by MB-S9-single-summand-mgf-typed-primitive.

## Matrix Bernstein Single-Summand MGF Primitive (MB-S9-single)

- Book heading: Matrix Bernstein inequality / single-summand moment
  generating function.
- Informal statement: for one centered self-adjoint random matrix, the matrix
  exponential moment is bounded in Loewner order by the exponential of a
  deterministic variance-proxy comparison matrix.
- Target Lean declaration: `singleSummandMatrixMGFVarianceProxy_statement`.
- Required objects: `matrixExp`, `matrixExpect`, `randomMatrixSquare`,
  `matrixSecondMoment`, `operatorNorm`, `MatrixLE`, `IsRandomMatrix`,
  `RandomSelfAdjointMatrix`, `IntegrableRandomMatrix`, `IsSelfAdjointMatrix`,
  and `IsPSDMatrix`.
- Status: typed statement only, API-tested, and judge-tested. The
  scalar-to-matrix functional-calculus bridge, single-summand provider
  assembly, operator-norm-to-spectral-interval bridge, trace-mgf provider,
  Golden-Thompson, Lieb, and Matrix Bernstein remain unproved.
- Target module: `HighDimProb/RandomMatrix/TraceExp.lean`
- Test module: `HighDimProbTest/RandomMatrixTraceExpAPI.lean`
- Judge module: `HighDimProbJudge/RandomMatrix/TraceExpUse.lean`
- Priority: this has been followed by MB-S9-bernstein-cfc-typed-primitive.

## Matrix Bernstein Bernstein CFC Primitive (MB-S9-CFC)

- Book heading: Matrix Bernstein inequality / scalar Bernstein functional
  calculus.
- Informal statement: for a deterministic self-adjoint matrix `A` with
  bounded spectrum, the matrix exponential `exp(theta A)` is bounded in
  Loewner order by `I + theta A + g(theta, R) A^2`.
- Target Lean declaration: `bernsteinMatrixExp_le_quadratic_statement`.
- Required objects: `matrixExp`, `matrixSquare`, `MatrixLE`,
  `deterministicOperatorNorm`, `IsSelfAdjointMatrix`, theta/radius
  inequalities, and the explicit Bernstein quadratic coefficient.
- Status: typed statement only, API-tested, and judge-tested. The
  functional-calculus proof, single-summand MGF theorem,
  operator-norm-to-spectral-interval bridge, trace-mgf provider,
  Golden-Thompson, Lieb, and Matrix Bernstein remain unproved.
- Target module: `HighDimProb/RandomMatrix/TraceExp.lean`
- Test module: `HighDimProbTest/RandomMatrixTraceExpAPI.lean`
- Judge module: `HighDimProbJudge/RandomMatrix/TraceExpUse.lean`
- Priority: followed by MB-S9-PSD-expectation-proof.

## Matrix Expectation PSD/Order Bridge (MB-S9)

- Book heading: Matrix Bernstein inequality / expectation monotonicity.
- Informal statement: entrywise matrix expectation preserves pointwise PSD
  matrices, and is monotone for the explicit `MatrixLE` order under entrywise
  integrability assumptions.
- Target Lean declarations:
  `isPSDMatrix_matrixExpect_of_pointwise_isPSD` and
  `matrixExpect_matrixLE_of_pointwise_matrixLE`.
- Required objects: `matrixExpect`, `IntegrableRandomMatrix`, `IsPSDMatrix`,
  `MatrixLE`, and `matrixQuadraticForm_matrixExpect`.
- Helper declarations: `integrableRandomMatrix_sub`, `matrixExpect_sub`.
- Status: proven
- Coverage: API-tested and judge-tested.
- Target module: `HighDimProb/RandomMatrix/VarianceProxy.lean`
- Test module: `HighDimProbTest/RandomMatrixVarianceProxyAPI.lean`
- Judge module: `HighDimProbJudge/RandomMatrix/VarianceProxyUse.lean`
- Priority: followed by MB-S9-expectation-linearity-proof.

## Matrix Expectation Linearity / Normalization Bridge (MB-S9)

- Book heading: Matrix Bernstein inequality / expectation algebra.
- Informal statement: entrywise matrix expectation commutes with matrix
  addition, deterministic scalar multiplication, zero, and constants; constants
  normalize to themselves over probability measures.
- Target Lean declarations:
  `integrableRandomMatrix_add`, `integrableRandomMatrix_smul`,
  `integrableRandomMatrix_zero`, `integrableRandomMatrix_const`,
  `matrixExpect_add`, `matrixExpect_smul`, `matrixExpect_zero`,
  `matrixExpect_const`, `matrixExpect_const_of_isProbabilityMeasure`, and
  `matrixExpect_one_of_isProbabilityMeasure`.
- Required objects: `matrixExpect`, `IntegrableRandomMatrix`,
  `IsFiniteMeasure`, and `IsProbabilityMeasure`.
- Status: proven and covered by focused API and judge checks.
- Blocker: none for add/smul/zero/constant expectation normalization.
  Functional calculus, the single-summand MGF theorem, trace-mgf provider,
  Golden-Thompson, Lieb, and Matrix Bernstein remain unproved.
- Target module: `HighDimProb/RandomMatrix/VarianceProxy.lean`
- Test module: `HighDimProbTest/RandomMatrixVarianceProxyAPI.lean`
- Judge module: `HighDimProbJudge/RandomMatrix/VarianceProxyUse.lean`
- Priority: followed by MB-S9-matrixle-algebra-proof.

## MatrixLE / PSD Algebra Bridge (MB-S9)

- Book heading: Matrix Bernstein inequality / Loewner-order algebra.
- Informal statement: explicit PSD and `MatrixLE` order are closed under the
  small algebraic operations needed for one-step matrix MGF RHS
  normalization: addition, nonnegative scalar multiplication, reflexivity,
  equality, transitivity, and add/smul monotonicity.
- Target Lean declarations:
  `matrixQuadraticForm_add`, `matrixQuadraticForm_smul`,
  `isPSDMatrix_zero`, `isPSDMatrix_add`,
  `isPSDMatrix_smul_of_nonneg`, `matrixLE_refl`, `matrixLE_of_eq`,
  `matrixLE_trans`, `matrixLE_add`, `matrixLE_add_left`,
  `matrixLE_add_right`, and `matrixLE_smul_of_nonneg`.
- Required objects: `matrixQuadraticForm`, `IsPSDMatrix`, `MatrixLE`, matrix
  addition/subtraction, and real scalar multiplication.
- Status: proven and covered by focused API and judge checks.
- Blocker: none for MatrixLE algebra. Functional calculus, the
  single-summand MGF provider, trace-mgf provider, Golden-Thompson, Lieb, and
  Matrix Bernstein remain unproved.
- Target module: `HighDimProb/RandomMatrix/MatrixOrder.lean`
- Test module: `HighDimProbTest/RandomMatrixVarianceProxyAPI.lean`
- Judge module: `HighDimProbJudge/RandomMatrix/VarianceProxyUse.lean`
- Priority: next safe task is
  MB-S9-trace-mgf-to-laplace-tail-contract.

## Concrete LIntegral Matrix Laplace Assembly (MB-S8)

- Book heading: matrix Laplace transform method for matrix Bernstein.
- Informal statement: random self-adjointness, explicit trace-exp integrand
  a.e. measurability, and `0 <= theta` imply the lintegral matrix Laplace
  upper-tail bound over the quadratic-form upper-tail event.
- Target Lean declarations:
  `matrixLaplaceTransformLIntegralDiv_of_randomSelfAdjoint`,
  `matrixLaplaceTransformLIntegral_of_randomSelfAdjoint`.
- Required objects: `traceExpDominatesQuadraticFormUpperTail_of_randomSelfAdjoint`,
  `matrixLaplaceTransformLIntegralDiv_of_traceExpDominatesQuadraticFormUpperTail`,
  `matrixLaplaceTransformLIntegral_of_traceExpDominatesQuadraticFormUpperTail`,
  `traceExpIntegrand`, and `AEMeasurable`.
- Status: proved for both division-RHS and product-RHS lintegral forms.
- Blocker: real RHS / real expectation bridge, trace-mgf, Golden-Thompson,
  Lieb, and Matrix Bernstein remain unproved.
- Target module: `HighDimProb/RandomMatrix/Laplace.lean`
- Test module: `HighDimProbTest/RandomMatrixLaplaceAPI.lean`
- Judge module: `HighDimProbJudge/RandomMatrix/LaplaceUse.lean`
- Priority: MB-S9-foundation is complete; next safe task is
  MB-S9-trace-mgf-to-laplace-tail-contract.

## Trace-MGF / Variance-Proxy Foundation (MB-S9)

- Book heading: matrix Laplace transform and trace-mgf method for matrix
  Bernstein.
- Informal statement: before proving the matrix trace-mgf comparison, expose
  semantic predicates for real/lintegral trace-mgf bounds and variance-proxy
  trace-mgf targets.
- Target Lean declarations: `TraceMGFBound`, `TraceMGFBoundLIntegral`,
  `TraceMGFVarianceProxyBound`, `TraceMGFVarianceProxyBoundLIntegral`,
  `MatrixVarianceProxyUpperBound`, `MatrixVarianceProxyNormBound`,
  `traceMGFBound_statement`, `traceMGFBoundLIntegral_statement`,
  `traceMGFVarianceProxyBound_statement`, and
  `matrixBernsteinTraceMGF_statement`.
- Required objects: `traceExpMoment`, `traceExpMomentLIntegral`,
  `traceMatrixExp`, `matrixVarianceProxy`, `matrixVarianceProxyNorm`, and
  `randomMatrixSum`.
- Status: semantic API and typed statement layer implemented. No
  Golden-Thompson, Lieb, full trace-mgf master theorem, real RHS bridge, or
  Matrix Bernstein theorem is proved.
- Blocker: the future provider theorem for `matrixBernsteinTraceMGF_statement`
  needs a source/API contract for noncommutative trace-mgf machinery, likely
  including Golden-Thompson/Lieb or an equivalent Mathlib route.
- Target modules: `HighDimProb/RandomMatrix/TraceExp.lean`,
  `HighDimProb/RandomMatrix/VarianceProxy.lean`, and
  `HighDimProb/RandomMatrix/ConcentrationStatements.lean`.
- Test modules: `HighDimProbTest/RandomMatrixTraceExpAPI.lean` and
  `HighDimProbTest/RandomMatrixVarianceProxyAPI.lean`.
- Judge modules: `HighDimProbJudge/RandomMatrix/TraceExpUse.lean`,
  `HighDimProbJudge/RandomMatrix/VarianceProxyUse.lean`,
  `HighDimProbJudge/RandomMatrix/MatrixBernsteinUse.lean`, and
  `HighDimProbJudge/RandomMatrix/StatementUse.lean`.
- Repository next safe task: RM-TROPP-S11-conditional-step-assumption-bundle-contract.

## PSD of Matrix Square / Second Moment / Variance Proxy (MB-S1)

- Book heading: structural PSD facts for matrix Bernstein
- Informal statement: if A is self-adjoint then A^2 is PSD; if A is self-adjoint
  random then E[A^2] is PSD; the variance proxy sum_i E[A_i^2] is PSD
- Target Lean statements: `isPSD_matrixSquare_of_selfAdjoint`,
  `isPSD_matrixSecondMoment_of_selfAdjoint`,
  `isPSD_matrixVarianceProxy_of_selfAdjoint`
- Required objects: `matrixSquare`, `matrixSecondMoment`, `matrixVarianceProxy`,
  `IsPSDMatrix`
- Status: proven structural bridge. The second-moment and variance-proxy
  theorems require explicit entrywise integrability of the squared random
  matrix terms.
- Blocker: none for this structural PSD layer.
- Target module: `HighDimProb/RandomMatrix/VarianceProxy.lean`
- Priority: completed in MB-S1

## Matrix Bernstein Spectral Bridge Typed Split (MB-S7A)

- Book heading: matrix Laplace transform prerequisites / Rayleigh reduction.
- Informal statement: before proving trace-exp dominance, HighDimProb needs a
  bridge from explicit unit-vector quadratic forms to the nonempty-dimension
  `lambdaMax` wrapper.
- Target Lean declarations:
  `matrixQuadraticForm_le_lambdaMax_statement`,
  `quadraticFormUpperBound_of_lambdaMax_le_of_matrixQuadraticForm_le_lambdaMax`,
  `lambdaMaxUpperTailEvent`,
  `quadraticFormUpperTailEvent_subset_lambdaMaxUpperTailEvent_of_matrixQuadraticForm_le_lambdaMax`,
  `not_isUnitVector_fin_zero`, `unitSphere_empty_of_zero_dim`, and
  `quadraticFormUpperTailEvent_empty_of_zero_dim`.
- Required objects: `matrixQuadraticForm`, `IsUnitVector`,
  `quadraticFormUpperTailEvent`, `lambdaMax`, and `IsSelfAdjointMatrix`.
- Status: typed split plus conditional helpers proved. The direct
  `matrixQuadraticForm_le_lambdaMax_statement` theorem is not proved.
- Dimension route: lambda wrappers stay on `Fin (n + 1)`; zero-dimensional
  unit-sphere and upper-tail events are proved empty.
- Blocker: direct Mathlib/HighDimProb Rayleigh bridge from explicit finite-sum
  quadratic forms to Hermitian eigenvalue endpoints. MB-S7A-index adds an
  ordered endpoint wrapper for the next PSD/Rayleigh proof, but trace-exp
  spectral dominance, full matrix Laplace, trace-mgf, Golden-Thompson, Lieb,
  and Matrix Bernstein remain unproved.
- Target module: `HighDimProb/RandomMatrix/Spectral.lean`
- Test module: `HighDimProbTest/RandomMatrixSpectralAPI.lean`
- Judge module: `HighDimProbJudge/RandomMatrix/SpectralUse.lean`
- Priority: completed through MB-S9-foundation; next safe task is
  MB-S9-trace-mgf-to-laplace-tail-contract.

## Matrix Bernstein Rayleigh Conversion Helper Bridge (MB-S7A-fix)

- Book heading: matrix Laplace transform prerequisites / Rayleigh reduction.
- Informal statement: a Loewner-style endpoint bound
  `((lambdaMax A hA) smul 1 - A).PosSemidef` is enough to prove the explicit
  HighDimProb unit-vector Rayleigh statement.
- Target Lean declarations: `LambdaMaxPSDUpperBound`,
  `matrixQuadraticForm_nonneg_of_posSemidef`,
  `matrixQuadraticForm_smul_one_of_isUnitVector`,
  `matrixQuadraticForm_le_lambdaMax_of_lambdaMax_sub_posSemidef`, and
  `matrixQuadraticForm_le_lambdaMax_of_lambdaMaxPSDUpperBound`.
- Required objects: Mathlib `Matrix.PosSemidef`, HighDimProb
  `matrixQuadraticForm`, `matrixQuadraticForm_sub`, `IsUnitVector`,
  `lambdaMax`, and `matrixQuadraticForm_le_lambdaMax_statement`.
- Status: helper bridge proved and consolidated, API-tested, and judge-tested.
  The direct theorem behind `matrixQuadraticForm_le_lambdaMax_statement`
  remains unproved.
- Dimension route: unchanged `Fin (n + 1)` lambda route; no coercion between
  `Fin n` and `Fin (n + 1)` was introduced.
- Blocker: MB-S7A-order found that Mathlib's ordered endpoint theorem applies
  to `Matrix.IsHermitian.eigenvalues?`, while current `lambdaMax` uses the
  reindexed `Matrix.IsHermitian.eigenvalues`. MB-S7A-index preserves current
  `lambdaMax` and introduces `lambdaMaxOrdered`; the remaining endpoint task is
  the ordered PSD/Rayleigh theorem. Trace-exp spectral dominance, full matrix
  Laplace, trace-mgf, Golden-Thompson, Lieb, and Matrix Bernstein remain
  unproved.
- Target module: `HighDimProb/RandomMatrix/Spectral.lean`
- Test module: `HighDimProbTest/RandomMatrixSpectralAPI.lean`
- Judge module: `HighDimProbJudge/RandomMatrix/SpectralUse.lean`
- Priority: completed through MB-S9-foundation; next safe task is
  MB-S9-trace-mgf-to-laplace-tail-contract.

## Matrix Bernstein Ordered Endpoint Wrapper (MB-S7A-index)

- Book heading: matrix Laplace transform prerequisites / Rayleigh reduction.
- Informal statement: preserve the legacy `lambdaMax` wrapper while exposing a
  canonical ordered largest-eigenvalue endpoint based directly on
  `Matrix.IsHermitian.eigenvalues? 0`.
- Target Lean declarations: `lambdaMaxOrdered`,
  `lambdaMaxOrdered_eq_eigenvalues?_zero`,
  `lambdaMax_eq_lambdaMaxOrdered_statement`,
  `lambdaMaxOrdered_is_greatest_eigenvalue_statement`,
  `lambdaMaxOrdered_is_greatest_eigenvalue`,
  `LambdaMaxOrderedPSDUpperBound`,
  `matrixQuadraticForm_le_lambdaMaxOrdered_statement`,
  `matrixQuadraticForm_le_lambdaMaxOrdered_of_lambdaMaxOrderedPSDUpperBound`,
  `lambdaMaxOrderedUpperTailEvent`, and
  `quadraticFormUpperTailEvent_subset_lambdaMaxOrderedUpperTailEvent_of_matrixQuadraticForm_le_lambdaMaxOrdered`.
- Required objects: Mathlib `Matrix.IsHermitian.eigenvalues?_antitone`,
  HighDimProb `matrixQuadraticForm`, `IsUnitVector`, and existing PSD
  conversion helpers.
- Status: ordered endpoint wrapper and ordered greatest theorem proved;
  conditional ordered PSD-premise-to-Rayleigh and event helpers proved.
  MB-S7A-provider later proves `lambdaMaxOrdered_spectralUpperBound`,
  `lambdaMaxOrderedPSDUpperBound`, and `lambdaMaxOrdered_rayleighUpperBound`.
- Blocker: trace-exp spectral dominance, full matrix Laplace, trace-mgf,
  Golden-Thompson, Lieb, and Matrix Bernstein remain unproved.
- Target module: `HighDimProb/RandomMatrix/Spectral.lean`
- Test module: `HighDimProbTest/RandomMatrixSpectralAPI.lean`
- Judge module: `HighDimProbJudge/RandomMatrix/SpectralUse.lean`
- Priority: completed through MB-S9-foundation; next safe task is
  MB-S9-trace-mgf-to-laplace-tail-contract.

## Matrix Bernstein Semantic Spectral API (MB-S7A-abstract)

- Book heading: matrix Laplace transform prerequisites / Rayleigh reduction.
- Informal statement: downstream spectral reductions should depend on semantic
  upper-bound predicates rather than concrete eigenvalue wrapper internals.
- Target Lean declarations: `SpectralUpperBound`, `RayleighUpperBound`,
  `scalarUpperTailEvent`, `matrixUpperBoundTailEvent`,
  `rayleighUpperBound_of_spectralUpperBound`,
  `quadraticFormUpperTailEvent_subset_scalarUpperTailEvent_of_rayleighUpperBound`,
  `quadraticFormUpperTailEvent_subset_matrixUpperBoundTailEvent_of_rayleighUpperBound`,
  `quadraticFormUpperTailEvent_subset_matrixUpperBoundTailEvent_of_spectralUpperBound`,
  `spectralUpperBound_of_lambdaMaxPSDUpperBound`,
  `spectralUpperBound_of_lambdaMaxOrderedPSDUpperBound`,
  `lambdaMaxUpperTailEvent_eq_matrixUpperBoundTailEvent`, and
  `lambdaMaxOrderedUpperTailEvent_eq_matrixUpperBoundTailEvent`.
- Required objects: existing Mathlib `Matrix.PosSemidef` API and HighDimProb
  `matrixQuadraticForm` / `IsUnitVector` helper lemmas.
- Status: semantic abstraction layer implemented, API-tested, and
  judge-tested. MB-S7A-provider later proves the ordered provider theorem.
- Blocker: trace-exp spectral dominance, full matrix Laplace, trace-mgf,
  Golden-Thompson, Lieb, and Matrix Bernstein remain unproved.
- Target module: `HighDimProb/RandomMatrix/Spectral.lean`
- Test module: `HighDimProbTest/RandomMatrixSpectralAPI.lean`
- Judge module: `HighDimProbJudge/RandomMatrix/SpectralUse.lean`
- Priority: completed through MB-S7A-provider.

## Matrix Bernstein Ordered Endpoint Provider (MB-S7A-provider)

- Book heading: matrix Laplace transform prerequisites / Rayleigh reduction.
- Informal statement: the canonical ordered endpoint wrapper
  `lambdaMaxOrdered A hA` provides the semantic upper spectral bound needed by
  downstream Rayleigh/event bridges.
- Target Lean declarations: `lambdaMaxOrdered_spectralUpperBound`,
  `lambdaMaxOrderedPSDUpperBound`, and `lambdaMaxOrdered_rayleighUpperBound`.
- Required objects: `SpectralUpperBound`, `RayleighUpperBound`,
  `lambdaMaxOrdered`, Mathlib Hermitian spectrum/order APIs, and existing
  HighDimProb PSD-to-quadratic-form helpers.
- Status: provider theorem, named provider wrapper, and direct ordered
  Rayleigh wrapper are proved, API-tested, and judge-tested.
- Blocker: trace-exp spectral dominance, full matrix Laplace, trace-mgf,
  Golden-Thompson, Lieb, and Matrix Bernstein remain unproved.
- Target module: `HighDimProb/RandomMatrix/Spectral.lean`
- Test module: `HighDimProbTest/RandomMatrixSpectralAPI.lean`
- Judge module: `HighDimProbJudge/RandomMatrix/SpectralUse.lean`
- Priority: MB-S9-foundation is complete; next safe task is
  MB-S9-trace-mgf-to-laplace-tail-contract.

## Bernstein Coefficient Nonnegativity (MB-S9-bernstein-coefficient-proof)

- Book heading: Matrix Bernstein single-summand MGF scalar coefficient.
- Informal statement: the Bernstein coefficient
  `(theta ^ 2 / 2) / (1 - abs theta * R / 3)` is nonnegative under
  `abs theta * R < 3`.
- Target Lean declaration: `bernsteinCoefficient_nonneg`.
- Required objects: real square nonnegativity, positive denominator from the
  theta-range hypothesis, and real division nonnegativity.
- Status: proved, API-tested, and judge-tested.
- Blocker: the single-summand provider, Bernstein CFC proof, matrix
  exponential lower bound `MatrixLE (1 + c smul V) (matrixExp (c smul V))`,
  trace-mgf provider, Golden-Thompson, Lieb, and Matrix Bernstein remain
  unproved.
- Target module: `HighDimProb/RandomMatrix/TraceExp.lean`
- Test module: `HighDimProbTest/RandomMatrixTraceExpAPI.lean`
- Judge module: `HighDimProbJudge/RandomMatrix/TraceExpUse.lean`
- Repository next safe task: RM-TROPP-S11-conditional-step-assumption-bundle-contract.

## Matrix Exponential Lower Bound (MB-S9-exp-lower-bound-proof)

- Book heading: deterministic matrix exponential lower bound for the
  single-summand MGF RHS normalization.
- Informal statement: for self-adjoint real matrices,
  `MatrixLE (1 + A) (matrixExp A)`.
- Target Lean declarations:
  `matrixLE_one_add_self_le_matrixExp_of_selfAdjoint` and
  `matrixLE_one_add_smul_le_matrixExp_smul_of_selfAdjoint`.
- Required objects: `Real.add_one_le_exp`, `cfc_mono`,
  `CFC.real_exp_eq_normedSpace_exp`, `matrixExp`, `MatrixLE`, and
  `isSelfAdjointMatrix_smul`.
- Status: proved, API-tested, and judge-tested.
- Blocker: the full CFC-free single-summand provider remains unproved; the
  Bernstein CFC primitive remains typed only; trace-mgf provider,
  Golden-Thompson, Lieb, and Matrix Bernstein remain unproved.
- Target module: `HighDimProb/RandomMatrix/TraceExp.lean`
- Test module: `HighDimProbTest/RandomMatrixTraceExpAPI.lean`
- Judge module: `HighDimProbJudge/RandomMatrix/TraceExpUse.lean`
- Priority: completed through MB-S9-exp-lower-bound-proof; the next safe
  task was MB-S9-trace-mgf-to-laplace-tail-contract.

## Single-Summand Provider Under CFC (MB-S9-single-summand-provider-under-cfc)

- Book heading: Matrix Bernstein single-summand MGF variance-proxy provider.
- Informal statement: assuming the pointwise typed Bernstein CFC primitive
  for every sample, the single-summand matrix MGF variance-proxy typed target
  follows from matrix expectation monotonicity, expectation linearity,
  MatrixLE algebra, coefficient nonnegativity, second-moment comparison, and
  the deterministic matrix exponential lower bound.
- Target Lean declaration:
  `singleSummandMatrixMGFVarianceProxy_of_bernsteinMatrixExp_le_quadratic`.
- Required objects: `bernsteinMatrixExp_le_quadratic_statement`,
  `singleSummandMatrixMGFVarianceProxy_statement`,
  `matrixExpect_matrixLE_of_pointwise_matrixLE`, `matrixExpect_add`,
  `matrixExpect_smul`, `matrixExpect_const_of_isProbabilityMeasure`,
  `matrixLE_trans`, `matrixLE_add_left`, `matrixLE_smul_of_nonneg`,
  `bernsteinCoefficient_nonneg`, and
  `matrixLE_one_add_smul_le_matrixExp_smul_of_selfAdjoint`.
- Status: proved, API-tested, and judge-tested as a provider under explicit
  pointwise CFC assumptions.
- Blocker: the Bernstein CFC primitive itself remains typed only; the
  trace-mgf provider, Golden-Thompson, Lieb, full CFC-free single-summand
  provider, and Matrix Bernstein remain unproved.
- Target module: `HighDimProb/RandomMatrix/TraceExp.lean`
- Test module: `HighDimProbTest/RandomMatrixTraceExpAPI.lean`
- Judge module: `HighDimProbJudge/RandomMatrix/TraceExpUse.lean`
- Priority: next safe task was
  MB-S9-trace-mgf-to-laplace-tail-contract.

## Bounded Bernstein Trace-MGF RHS Normal Form (MB-S9-rhs-normalization-proof)

- Book heading: Matrix Bernstein trace-mgf RHS normalization.
- Informal statement: the bounded Bernstein trace-mgf coefficient is
  `bernsteinMGFCoeff theta R =
  (theta ^ 2 / 2) / (1 - abs theta * R / 3)`.
- Target Lean declarations: `bernsteinMGFCoeff`,
  `bernsteinMGFCoeff_nonneg`, `TraceMGFBernsteinVarianceProxyBound`,
  `TraceMGFBernsteinVarianceProxyBoundLIntegral`,
  `traceMGFBernsteinVarianceProxyBound_statement`, and
  `matrixBernsteinTraceMGFWithBernsteinCoeff_statement`.
- Status: RHS coefficient normalized, API-tested, and judge-tested.
- Compatibility: `TraceMGFVarianceProxyBound` and
  `matrixBernsteinTraceMGF_statement` are retained with coefficient
  `theta ^ 2 / 2`; they are not the bounded Matrix Bernstein denominator
  target.
- Blocker: trace-mgf provider, Bernstein CFC proof, Tropp/Lieb primitive,
  Golden-Thompson, Lieb, and Matrix Bernstein remain unproved.
- Target modules: `HighDimProb/RandomMatrix/TraceExp.lean` and
  `HighDimProb/RandomMatrix/ConcentrationStatements.lean`.
- Test modules: `HighDimProbTest/RandomMatrixTraceExpAPI.lean` and
  `HighDimProbTest/RandomMatrixVarianceProxyAPI.lean`.
- Judge modules: `HighDimProbJudge/RandomMatrix/TraceExpUse.lean`,
  `HighDimProbJudge/RandomMatrix/MatrixBernsteinUse.lean`,
  `HighDimProbJudge/RandomMatrix/StatementUse.lean`, and
  `HighDimProbJudge/RandomMatrix/VarianceProxyUse.lean`.
- Priority: next safe task is
  MB-S9-trace-mgf-to-laplace-tail-contract.

## Finite-Family Tropp Trace-MGF Interface (MB-S9-tropp-shape-refactor)

- Informal statement: a typed finite-family Tropp/Lieb iteration primitive
  consumes per-summand matrix-MGF comparisons, independence, trace-exp
  integrability, and bounded-Bernstein RHS normalization, and returns
  `TraceMGFBernsteinVarianceProxyBound` for `randomMatrixSum`.
- Target Lean declaration: `troppMasterTraceMGFFiniteFamily_statement`.
- Status: general typed statement is API-tested and judge-tested. A narrow
  `Fin m` provider,
  `troppMasterTraceMGFFiniteFamily_of_conditionalSteps`, is proved from
  explicit conditional-step/state data; the arbitrary finite-index provider
  remains open.
- Compatibility: `troppMasterTraceMGFStep_statement` remains available as the
  one-step log-form primitive. The current step hierarchy also includes
  `troppLogExpComparisonToK_statement`,
  `troppMasterTraceMGFConditionalStep_statement`,
  `troppMasterTraceMGFConditionalStep_expect_bound`, and
  `troppTraceExpFiniteFamilyIterationSkeleton_of_conditionalSteps`.
- Blocker: natural history/state construction, independence conditioning,
  integrability propagation, arbitrary finite-index reindexing, Bernstein CFC
  proof, Golden-Thompson, Lieb, and Matrix Bernstein remain unproved.
- Target module: `HighDimProb/RandomMatrix/TraceExp.lean`.
- Test module: `HighDimProbTest/RandomMatrixTraceExpAPI.lean`.
- Judge module: `HighDimProbJudge/RandomMatrix/TraceExpUse.lean`.
- Priority: next safe task is
  MB-S9-trace-mgf-to-laplace-tail-contract.

## Bounded Trace-MGF Thin Wrappers (MB-S9-trace-mgf-provider-thin-wrapper-proof)

- Informal statement: the finite-family Tropp typed primitive directly yields
  the bounded Bernstein semantic trace-MGF target, and with
  `V = matrixVarianceProxy P A` yields the high-level bounded Matrix
  Bernstein trace-MGF statement.
- Target Lean declarations:
  `traceMGFBernsteinVarianceProxyBound_of_troppMasterTraceMGFFiniteFamily`
  and
  `matrixBernsteinTraceMGFWithBernsteinCoeff_of_troppMasterTraceMGFFiniteFamily`.
- Status: proved, API-tested, and judge-tested.
- Blocker: the arbitrary finite-index finite-family Tropp provider remains
  open, though the narrow `Fin m` conditional-step provider and
  `traceMGFBernsteinVarianceProxyBound_of_troppConditionalSteps` are proved.
  The Bernstein CFC primitive remains typed only; Lieb, Golden-Thompson, and
  Matrix Bernstein remain unproved.
- Priority: next safe task is
  MB-S9-trace-mgf-to-laplace-tail-contract.

## Matrix Bernstein Trace-MGF Under Primitives (MB-S9)

- Informal statement: ordinary finite-family Matrix Bernstein hypotheses plus
  explicit finite-family Tropp and pointwise Bernstein CFC primitive
  assumptions imply the bounded Matrix Bernstein trace-MGF statement.
- Target Lean declaration:
  `matrixBernsteinTraceMGFWithBernsteinCoeff_under_primitives`.
- Status: proved, API-tested, and judge-tested.
- Blocker: the arbitrary finite-index finite-family Tropp provider remains
  open. S7 adds no downstream Matrix Bernstein conditional-step wrapper
  because exposing positive and negative S5 conditional-step/state packages
  would make public signatures worse than the finite-family primitive route.
  The Bernstein CFC primitive remains typed only; Lieb, Golden-Thompson, and
  the Matrix Bernstein tail theorem remain unproved.
- Repository next safe task: RM-TROPP-S11-conditional-step-assumption-bundle-contract.




## Matrix Bernstein Theta Optimization Contract (MB-S9)

- Informal statement: choosing `theta = t / (sigmaSq + R * t / 3)` in the
  normalized explicit-theta scalar RHS yields the Bernstein denominator
  exponent `-(t ^ 2 / (2 * sigmaSq + (2 / 3) * R * t))`.
- Target Lean declarations:
  `bernsteinThetaChoice`, `bernsteinThetaChoice_range`,
  `bernsteinThetaChoice_exponent_eq`, and
  `matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives`.
- Status: proved, API-tested, and judge-tested.
- Blocker: the result is still one-sided and quadratic-form under explicit
  Tropp/Lieb and Bernstein CFC primitives; lambda-max/operator-norm tail
  bridges and the full Matrix Bernstein theorem remain unproved.
- Repository next safe task: RM-TROPP-S11-conditional-step-assumption-bundle-contract.

## Matrix Bernstein Trace-MGF to Laplace/Tail Contract (MB-S9)

- Informal statement: a bounded Bernstein lintegral trace-MGF bound plus the
  explicit quadratic-form event-subset bridge yields the bounded-Bernstein
  Laplace/tail RHS.
- Target Lean declarations:
  `traceMGFBernsteinVarianceProxyBoundLIntegral_of_real_statement`,
  `matrixLaplaceRHSLIntegral_le_of_traceMGFBernsteinVarianceProxyBoundLIntegral`,
  `quadraticFormUpperTail_laplace_bound_of_traceMGFBernsteinVarianceProxyBoundLIntegral`,
  `quadraticFormUpperTail_laplace_bound_of_traceMGFBernsteinVarianceProxyBoundLIntegral_statement`,
  `matrixBernsteinTraceMGFToLaplaceContract_statement`, and
  `matrixBernsteinTraceMGFToLaplaceContract_under_primitives_statement`.
- Status: conditional Laplace RHS and quadratic-form tail wrappers are proven;
  real-to-lintegral and randomMatrixSum provider assembly remain typed
  contracts.
- Blocker: prove or sharpen the real trace-MGF to lintegral bridge; keep the
  event-subset, Tropp/Lieb, Bernstein CFC, Golden-Thompson, and Matrix
  Bernstein tail theorem gaps explicit.
- Repository next safe task: RM-TROPP-S11-conditional-step-assumption-bundle-contract.

## RM Centered Structural API

- Informal statement: `centeredRandomMatrix P X` preserves entrywise
  measurability, entrywise integrability over finite measures, and
  self-adjointness; under `[IsProbabilityMeasure P]` and entrywise
  integrability its entrywise expectation is zero.  The family wrapper turns a
  `SelfAdjointRandomMatrixFamily P A` plus per-index integrability into a
  `CenteredSelfAdjointRandomMatrixFamily P (centeredRandomMatrixFamily P A)`.
- Target Lean declarations:
  `isRandomMatrix_centeredRandomMatrix`,
  `integrableRandomMatrix_centeredRandomMatrix`,
  `isSelfAdjointMatrix_matrixExpect_of_randomSelfAdjoint`,
  `randomSelfAdjointMatrix_centeredRandomMatrix`,
  `matrixExpect_centeredRandomMatrix`,
  `selfAdjointRandomMatrixFamily_centeredRandomMatrixFamily`, and
  `centeredSelfAdjointRandomMatrixFamily_centeredRandomMatrixFamily`.
- Status: proven, API-tested, and judge-tested.
- API gap recorded: this structural layer only proves centered measurability,
  integrability, self-adjointness, and zero entrywise expectation.  The
  operator-norm layer now supplies the Bochner bridge and expectation
  contraction.
- Blocker: none for structural centeredness.
- Repository next safe task: RM-TROPP-S11-conditional-step-assumption-bundle-contract.

## RM Centered Operator-Norm Bound

- Informal statement: if a random matrix family has pointwise operator-norm
  bound `R`, entrywise integrability, and the existing entrywise measurability
  assumptions, then `matrixExpect` is bounded by `R` and the centered family is
  pointwise bounded by `2 * R` (or by `R + R` in the same-radius wrapper).
- Target Lean declarations:
  `matrixExpect_eq_integral_l2Operator`, `matrixExpect_eq_integral`,
  `deterministicOperatorNorm_matrixExpect_le_of_boundedOperatorNorm`,
  `expectationOperatorNormBound_of_pointwiseOperatorNormBound`,
  `deterministicOperatorNorm_sub_le_add`,
  `BoundedOperatorNorm_centered_of_bound_expect_bound`,
  `PointwiseOperatorNormBound_centered_of_bound_expect_bound`,
  `PointwiseOperatorNormBound_centered_of_bound_expect_bound_same`,
  `BoundedOperatorNorm_centered_of_boundedOperatorNorm`,
  `PointwiseOperatorNormBound_centered_of_pointwiseOperatorNormBound`, and
  `PointwiseOperatorNormBound_centered_of_pointwiseOperatorNormBound_same`.
- Status: proven, API-tested, and judge-tested.
- Blocker: this does not prove sample-covariance Matrix Bernstein assumption
  adapters or Matrix Bernstein tails.
- Repository next safe task: RM-TROPP-S11-conditional-step-assumption-bundle-contract.


## RM Centered Rank-One Structural Adapter

- Informal statement: the named centered rank-one random matrix
  `centeredRankOneRandomMatrix P X` is entrywise random whenever `X` is a
  random vector, entrywise integrable under coordinate `MemLp ... 2`
  assumptions over finite measures, and forms a centered self-adjoint family in
  indexed form under `[IsProbabilityMeasure P]`.
- Target Lean declarations: `centeredRankOneRandomMatrix`,
  `centeredRankOneRandomMatrixFamily`,
  `centeredRankOneRandomMatrix_isRandomMatrix`,
  `centeredRankOneRandomMatrix_integrable_of_memLp_two`, and
  `centeredRankOneRandomMatrix_centeredSelfAdjoint_of_memLp_two`.
- Status: proven, API-tested, and judge-tested.
- Blocker: this does not prove sample-covariance Matrix Bernstein assumption
  adapters or Matrix Bernstein tails.
- Repository next safe task: RM-TROPP-S11-conditional-step-assumption-bundle-contract.


## RM Centered Rank-One Operator-Norm Adapter

- Informal statement: pointwise squared-vector-norm bounds and coordinate
  second-moment assumptions give `2 * R` pointwise operator-norm bounds for the
  named centered rank-one random matrix and its indexed family.
- Target Lean declarations:
  `BoundedOperatorNorm_centeredRankOneRandomMatrix_of_sqNorm_bound` and
  `PointwiseOperatorNormBound_centeredRankOneRandomMatrix_of_sqNorm_bound`.
- Status: proven, API-tested, and judge-tested.
- Blocker: this does not prove sample-covariance Matrix Bernstein assumption
  adapters, lambda-max/operator-norm Matrix Bernstein tails, Tropp/Lieb,
  Bernstein CFC, or Golden-Thompson.
- Repository next safe task: RM-TROPP-S11-conditional-step-assumption-bundle-contract.


## RM Vector-to-Rank-One Matrix Measurability / Integrability

- Informal statement: a finite random vector `X : Omega -> Fin n -> Real defines a
  rank-one random matrix with entries `X_i * X_j`; coordinate measurability
  gives entrywise matrix measurability, and entrywise product integrability or
  coordinate second-moment assumptions give entrywise matrix integrability.
- Target Lean declarations: `rankOneRandomMatrix`, `rankOneRandomMatrixFamily`,
  `isRandomMatrix_rankOneRandomMatrix`,
  `integrableRandomMatrix_rankOneRandomMatrix_of_integrable_products`, and
  `integrableRandomMatrix_rankOneRandomMatrix_of_memLp_two`.
- Status: proven, API-tested, and judge-tested.
- Blocker: this does not prove integrability from measurability alone,
  sample-covariance Matrix Bernstein assumption adapters, or Matrix Bernstein
  tails.
- Repository next safe task: RM-TROPP-S11-conditional-step-assumption-bundle-contract.


## RM PSD Nullspace Converse

- Informal statement: for a real positive semidefinite matrix `A`, the zero
  quadratic-form condition `x? A x = 0` is equivalent to the kernel condition
  `A x = 0`; HighDimProb exposes this in both Mathlib `Matrix.PosSemidef` and
  explicit `IsPSDMatrix` vocabulary.
- Target Lean declarations:
  `posSemidef_of_isPSDMatrix`,
  `matrixQuadraticForm_eq_zero_iff_mulVec_eq_zero_of_posSemidef`,
  `matrix_mulVec_eq_zero_of_posSemidef_quadraticForm_eq_zero`,
  `matrixQuadraticForm_eq_zero_iff_mulVec_eq_zero_of_isPSDMatrix`, and
  `matrix_mulVec_eq_zero_of_isPSDMatrix_quadraticForm_eq_zero`.
- Status: proven, API-tested, and judge-tested.
- Blocker: this is only a deterministic PSD kernel bridge. It does not prove
  covariance expectation identities, sample-covariance Matrix Bernstein
  assumption adapters, or Matrix Bernstein tails.
- Repository next safe task: RM-TROPP-S11-conditional-step-assumption-bundle-contract.
