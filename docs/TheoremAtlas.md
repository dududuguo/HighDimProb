# Theorem Atlas

This is the current theorem-family index. Old atlas detail was collapsed into
[`archive.md`](archive.md); use git history for exact old wording.

## Status Vocabulary

- `proven`: implemented as a Lean theorem or lemma.
- `typed-prop`: represented as a compiled statement object, not proved.
- `scaffold`: vocabulary or statement layer only.
- `blocked`: waiting on real mathematical infrastructure.

## Scalar Concentration

The scalar concentration layer is the most mature part of the library. It
contains proved Markov/Chebyshev wrappers, Orlicz-to-tail and tail-to-Orlicz
bridges, moment implications, Rademacher/Hoeffding routes, and scalar Bernstein
families. The Lean source, focused tests, and judge files are the detailed
index; this atlas stays route-level.

## Random Object Vocabulary

The random-family layer is `scaffold`: `RandomFamily`, real-valued variants,
process/sample aliases, endpoint accessors, and deterministic map preservation
lemmas are compiled vocabulary over Mathlib `Measurable`. It intentionally does
not add filtrations, adaptedness, martingales, or conditioning providers.

## SubGaussian Process And Finite Chaining

`HighDimProb.SubGaussianProcess` defines the metric increment predicate
`HasSubGaussianMGFIncrements` and proves the radius adapter
`HasSubGaussianMGFIncrements.centeredSubGaussianMGF_of_dist_le`. The predicate
allows the zero `NNReal` proxy at equal indices and does not assume `0 < σ`;
the adapter requires `0 < σ`, `0 < r`, and `dist s t ≤ r`. It uses the proved
monotonicity bridge `hasSubgaussianMGF_mono` from `HighDimProb.SubGaussian`.

The metric-entropy roadmap has five explicit stages:

1. **finite chaining - proven.** `chain_sub_eq_sum_range`,
   `norm_sub_chain_le_sum_of_level_sup`,
   `expect_abs_sub_chain_le_sum_of_level_sup`, and the centered-subGaussian
   cardinality corollary handle supplied finite levels, parent maps, and Nat
   cardinality certificates. The metric increment adapter is
   `expect_abs_sub_chain_le_sum_of_level_sup_of_subGaussianMGFIncrements`.
2. **minimal-cover adapter - proven.**
   `exists_finset_isInternalEpsilonNet_of_totallyBounded` uses `0 < ε` and
   `TotallyBounded K` to construct a finite internal net with exact
   `coveringNumber` / `ENat` / `toNat` cardinality relations.
3. **dyadic entropy sum - proven.**
   `exists_finset_internalNetFamily_parentMap_path_of_totallyBounded` constructs
   finite internal nets for any supplied positive radius schedule, exact
   covering-number/card/toNat certificates, adjacent parent maps, and endpoint
   paths. `dyadicRadius` supplies the standard `R / 2^i` schedule,
   `finiteDyadicEntropySum` records the finite covering-number sum, and
   `expect_abs_sub_chain_le_finiteDyadicEntropySum` consumes the certificate
   for finite subGaussian chaining.
4. **entropy integral - not proved.** No entropy-integral definition or
   dyadic-to-integral comparison has been declared.
5. **Dudley - not proved.** No limiting supremum, separable-process version,
   or Dudley endpoint has been declared.

The existing measurable and integrable supremum facts are for finite
`Finset`s. The minimal-cover result does not silently upgrade
`TotallyBounded K` to compactness or a separability/measurable-supremum
theorem; those assumptions and bridges remain future contracts. No full
Dudley, full Tropp, or unconditional Matrix Bernstein theorem is claimed by
this atlas.

## RandomMatrix

The RandomMatrix layer has a supported finite-dimensional base and the public
downstream facade `HighDimProb.RandomMatrix.Concentration`; scoped `Provider.*`
facades remain internal/expert maintenance imports. The theorem contracts
remain explicit; support does not mean that arbitrary-history or unconditional
extensions are proved. The current Matrix Bernstein route includes proved
wrappers under explicit assumptions:
trace-MGF, quadratic-form, optimized scalar RHS, positive-threshold
operator-norm, sample-covariance, crude variance-proxy routes, and
prefix/state endpoint bookkeeping wrappers for the Tropp conditional-step
route. The TraceExp layer also has a natural `Fin m` trace-state route that
derives the finite-family Tropp provider and trace-MGF provider from explicit
natural conditional-step data. The sample-covariance surface includes named
negative-side provider-transfer adapters for opposite-parameter exp/trace/CFC
assumptions; these are adapter lemmas, not unconditional provider proofs.

The main layer now has a proven scalar inversion surface:
`bernsteinAdditiveTailThreshold` with its nonnegativity, square, positivity,
and exponent-equality lemmas, plus the matrix `matrixBernsteinLogFactor`,
`matrixBernsteinHighProbabilityThreshold`, and
`matrixBernsteinTwoSidedOptimizedScalarTailRHS_highProbabilityThreshold`. The
`matrixBernsteinSelfAdjointHighProbabilityStatement` is a typed public
contract, and `matrixBernsteinSelfAdjointHighProbabilityStatement_of_optimizedStatement`
is its scalar-threshold consumer. The generated-history proof is now exposed by
`MatrixBernstein.optimized_of_primitives` and
`MatrixBernstein.highProbability_of_primitives`. These APIs preserve
`0 < n`, `0 < delta <= 1`, `0 <= sigmaSq`, `0 <= R`, and
`0 < sigmaSq or 0 < R`; they do not prove unconditional Matrix Bernstein.

Important current names are listed in [`RandomMatrixAPI.md`](RandomMatrixAPI.md).
The hardbone statement atlas in
[`HardboneStatements.lean`](../HighDimProb/RandomMatrix/HardboneStatements.lean)
names CFC, log/order, Tropp/Lieb, conditioning, integrability,
variance-proxy, and dimension/rank blockers as `typed-prop` targets. Selected
consumer wrappers are proven thin applications of those targets; they do not
close the hard theorem families. The trace-exp domination-provider consumer
`traceExpIntegrable_randomMatrixSum_of_traceExpDominatingProvider` is proved
under an explicit nonnegative integrable dominator and pointwise absolute
domination assumption. The centered-square expectation expansion is proved by
`matrixSquare_centeredRandomMatrix_expectation_expansion`, using the reusable
matrix expectation helpers `matrixExpect_const_mul` and `matrixExpect_mul_const`
and the identity `matrixSecondMoment_centeredRandomMatrix`. The
variance-proxy centered-square-chain consumers
`varianceProxyNormBound_of_centeredSquareChain` and
`varianceProxyNormBound_of_centeredSquareChain_expansion` are proved; the latter
removes the explicit expansion premise but still requires Loewner comparison
and deterministic norm-control assumptions. The centered rank-one second-moment
comparison is proved by `centeredRankOneSquare_le_rankOneSecondMoment`, using
`matrixSecondMoment_centeredRandomMatrix_le_matrixSecondMoment` and
`matrixLE_sub_right_of_isPSD`. The sample-covariance consumer
`sampleCovarianceVarianceProxy_sharp_of_rankOneSecondMoment` supplies that
comparison to the abstract sharp-variance chain, and
`sampleCovarianceVarianceProxy_sharp_of_exactRowSecondMoment` chooses the exact
uncentered row second moments so the row comparison is reflexive. The generic
deterministic finite-sum norm-control bridge is exposed as
`deterministicMatrixVarianceProxyNorm_sum_le_sum`. The exact rank-one
second-moment norm providers
`deterministicMatrixVarianceProxyNorm_matrixSecondMoment_rankOneRandomMatrix_le_sq_of_sqNorm_bound`
and
`deterministicMatrixVarianceProxyNorm_sum_matrixSecondMoment_rankOneRandomMatrix_le_sum_sq_of_sqNorm_bound`
give row-specific `rowSqNormVarianceProxyNormRHS R` control under explicit square-integrability of
the rank-one squares. The direct provider
`integrableRandomMatrix_randomMatrixSquare_rankOneRandomMatrix_of_integrable_four_products`
supplies that premise from explicit four-coordinate product integrability, and
`integrableRandomMatrix_randomMatrixSquare_rankOneRandomMatrix_of_memLp_four`
supplies it from coordinate `MemLp 4` assumptions via Mathlib Holder product
APIs. The bounded-row provider
`integrableRandomMatrix_randomMatrixSquare_rankOneRandomMatrix_of_sqNorm_bound_memLp_two`
supplies it from coordinate `MemLp 2` plus pointwise `vectorSqNorm <= R`.
Centered rank-one square-integrability providers are proved for coordinate `MemLp 4` and bounded-row `MemLp 2` routes. The direct row-specific provider `MatrixVarianceProxyNormBound_centeredRankOneRandomMatrixFamily_of_rowSqNorm_bound_memLp_two` supplies `rowSqNormVarianceProxyNormRHS R` without an abstract sharp-chain premise. Positive and negative sample-covariance adapters expose the same bound, and `MatrixBernstein.centeredRankOneExactRow` / `MatrixBernstein.sampleCovarianceExactRow` compose it with generated-history Matrix Bernstein. `MatrixBernstein.centeredRankOneExactRowHighProbability` closes the centered rank-one scalar-threshold specialization, while `MatrixBernstein.sampleCovarianceExactRowHighProbability` closes the normalized sample-covariance endpoint. Both high-probability endpoints are exported through the public import `HighDimProb.RandomMatrix.Concentration`; their input bundles and scalar-side conditions remain explicit, so these are not unconditional Matrix Bernstein results. `iIndepFun_centeredRankOne` transports raw vector-family independence. The deterministic PSD Loewner-to-operator-norm bridge remains `deterministicMatrixVarianceProxyNorm_mono_of_matrixLE`. Generic variance sharpening outside the centered rank-one setting and unconditional Matrix Bernstein remain open.
The rank/support trace-bound bridge is proved by
`traceMatrixExp_le_trace_support_exp_lambdaMax_of_supportDomination`,
with rank/support consumers for the hardbone targets. Deterministic trace/rank
certificates now include the ambient PSD lambda-max certificate
`matrixTrace_le_card_mul_of_isPSD_lambdaMaxOrdered_le` and the explicit
star-projection certificate `matrixTrace_eq_rank_of_isStarProjection`; the thin
consumer `traceMatrixExp_le_rank_exp_lambdaMax_of_isStarProjection` routes that
certificate together with `isPSDMatrix_of_isStarProjection` into the rank-bound
theorem while keeping the named `MatrixExpSupportDomination` certificate
explicit. The remaining support-side work is split into the ambient
identity-support provider target and the corrected excess-support target
`MatrixExpExcessSupportDomination` /
`traceMatrixExp_excess_supportDim_exp_lambdaMax_statement`. The deterministic
excess trace bridge
`traceMatrixExp_le_card_add_trace_support_mul_exp_sub_one_of_excessSupportDomination`
and consumer `traceMatrixExp_excess_supportDim_exp_lambdaMax` are proved under
explicit excess certificate, trace support-dimension, and nonnegative
coefficient assumptions. Concrete support providers
and true effective-rank trace certificates beyond the ambient fallback remain open. The Bernstein CFC route is now proved as
`bernsteinMatrixExp_le_quadratic`, via scalar Bernstein, spectrum localization,
Bernstein-specific CFC order transfer, and expression normalization. The
trace-MGF provider surface includes
`matrixBernsteinTraceMGF_under_tropp`, which reuses
that CFC proof while keeping Tropp/Lieb and integrability assumptions explicit.
The preferred optimized Matrix Bernstein wrappers use
`MatrixBernsteinPositiveSideTroppAssumptions` and
`MatrixBernsteinNegativeSideTroppAssumptions` to avoid exposing pointwise CFC
fields in generic call sites. The sample-covariance route now has the compact
bounded-row surface `SampleCovarianceTailTarget`,
`SampleCovarianceBoundedRowTroppAssumptions`, and
`sampleCovariance_tail_optimized_under_boundedRowTroppAssumptions`, which route
quadratic-form and self-adjoint operator-norm targets through one target axis
instead of one recommended public name per combination. Lower-level CFC-free
`_of_troppPrimitive` / `_of_troppPrimitives` wrappers remain available and reuse
`bernsteinMatrixExp_le_quadratic` while keeping Tropp/Lieb and integrability
assumptions explicit. The positive-side quadratic-form wrapper
`sampleCovariance_quadraticForm_tail_optimized_under_exactRowSqNorm_bound_of_troppPrimitive` uses the exact-row variance-proxy hardbone consumer and keeps
the sharp-chain premise explicit. The local matrix-exp/log normalization leaf is proved as
`matrixExpLogSelfAdjointNormalization`; the matrix-exp log-domain leaf is proved as
`matrixExpLogDomainForSelfAdjoint`. Together they provide CFC normalization and log-domain facts needed by the Tropp/Lieb one-step chain. The log/order-to-`K`
route now includes the proved thin bridge `matrixLog_le_of_le_matrixExp`, whose
operator-log premise can be supplied by the proved witness
`operatorLogMonotoneOnPositiveMatrices`. The downstream trace-exponential
monotonicity step is proved by `traceMatrixExp_mono_add_selfAdjoint`, and
`troppLogExpComparisonToK` proves the resulting deterministic comparison.
The finite-family conditioning chain now has the thin witness
`troppConditionalStep_of_iIndepFun`; it forwards the explicit per-index
conditional-expectation provider and does not prove the history,
weaker-independence, or conditional-expectation inputs themselves. The
provider facade separately exposes strengthened history/current-step
independence from `iIndepFun` plus explicit summand measurability, together
with `TroppNaturalHistory.historyStepContractOfIsRandomMatrix`, which returns
the exact legacy contract under explicit random-matrix data. The
conditional route is now also
composed into the finite-family Bernstein trace-MGF conclusion by
`traceMGFBernsteinVarianceProxyBound_of_conditioningBridge`, under explicit
natural-state, integrability, MGF, and variance-proxy assumptions recorded in
`docs/STATEMENTS.md`. The S10 wrapper
`matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFBridge` threads
that trace-MGF conclusion into the quadratic-form Laplace/tail route under an
explicit trace-exp threshold event subset assumption, and the TailEvent provider
wrappers discharge that subset premise under random self-adjointness. Its reusable assumption
bundle `MatrixBernsteinConditioningTraceMGFTailAssumptions` and thin wrapper
`matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFTailAssumptions`
package the same tail/conditioning assumptions without proving new hard facts;
this is not a full Matrix Bernstein theorem. The newer provider-compressed
names `MatrixBernsteinConditioningTraceMGFProviderAssumptions`,
`matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFProviderAssumptions`,
and `matrixBernsteinQuadraticFormUpperTail_of_naturalStateProviderAssumptions`
package the same route with less repeated bookkeeping. The provider bundle
derives its exact history/current-step independence contract from explicit
random-matrix data while retaining finite-family independence.
`HighDimProb.RandomMatrix.Provider.Analysis` exposes the ambient matrix-exp
Frechet derivative layer, log-resolvent infrastructure, the left/right
relative-entropy route, Lieb/Epstein facades, Golden--Thompson, and spectral
endpoint monotonicity. `HighDimProb.RandomMatrix.Provider.Concentration` owns
the left/right Tropp one-step wrappers, the compatibility closure
`troppLiebJensenChain_of_leftRight`, and trace-MGF-to-Laplace
contracts. The restricted
conditional-step route `mHist <= MeasurableSpace.comap H _` is closed by
`TraceExpConditioning.troppStep_of_history_le`. The Bernstein facade
`TraceExpConditioning.bernsteinStep_of_history_le` constructs the frozen-bound
packet from standard single-summand primitives but leaves the exact statement's
`IndepFun` premise visible. Golden--Thompson is now proved by
`goldenThompsonTraceExp`. Arbitrary larger-history independence, automatic
variance-proxy normalization, and unconditional full Matrix Bernstein remain
open.

## Not Yet Proved

- The older arbitrary-denominator Matrix Bernstein chain.
- Full unconditional Matrix Bernstein theorem.
- The weaker natural-history independence statement without explicit summand
  measurability; the explicit-random-matrix compatibility contract is proved.
  Conditional-expectation reduction for arbitrary larger history
  sigma-algebras, and trace-exp integrability propagation for the conditional-step
  Tropp route. The restricted `mHist <= MeasurableSpace.comap H _` route is proved.
- Proofs of the remaining downstream Tropp conditioning targets, automatic
  trace-exp domination/integrability, automatic
  variance-proxy sharpening beyond centered-square expectation expansion,
  support-domination providers, support-construction certificates, true
  effective-rank/support trace certificates, and dimension/rank refinements
  beyond explicit star-projection rank consumers.

## Maintenance Rule

Keep this file as a compact index. Put only short historical summaries in
`archive.md`, and put exact API-name details in the relevant API index.
