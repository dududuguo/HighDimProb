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

## RandomMatrix

The RandomMatrix layer is experimental. The current Matrix Bernstein route has
proved useful wrappers under explicit primitive assumptions, including
trace-MGF, quadratic-form, optimized scalar RHS, positive-threshold
operator-norm, sample-covariance, crude variance-proxy routes, and
prefix/state endpoint bookkeeping wrappers for the Tropp conditional-step
route. The TraceExp layer also has a natural `Fin m` trace-state route that
derives the finite-family Tropp provider and trace-MGF provider from explicit
natural conditional-step data. The sample-covariance surface includes named
negative-side provider-transfer adapters for opposite-parameter exp/trace/CFC
assumptions; these are adapter lemmas, not unconditional provider proofs.

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
Centered rank-one square-integrability providers are proved for coordinate `MemLp 4` and bounded-row `MemLp 2` routes. The row-specific exact-row consumer `sampleCovarianceVarianceProxy_sharp_of_exactRowSqNorm_bound_memLp_two` now supplies a `rowSqNormVarianceProxyNormRHS R` variance-proxy bound from coordinate `MemLp 2`, pointwise `vectorSqNorm <= R_i`, nonnegative radii, and the explicit hardbone sharp-chain premise. The concrete row-moment bridge `sampleCovarianceVarianceProxy_sharp_statement_of_centeredSquareChain_exactRowSqNorm_bound_memLp_two` turns the generic centered-square variance-proxy chain into the exact-row sample-specific sharp-chain statement, and `sampleCovarianceVarianceProxy_sharp_of_exactRowSqNorm_bound_memLp_two_of_centeredSquareChain` exposes the matching consumer. The generic centered-square chain remains explicit. The negative-side provider `MatrixVarianceProxyNormBound_centeredSampleCovarianceRowRankOneFamilyNeg_of_exactRowSqNorm_bound_memLp_two` transfers that row-specific bound through `matrixVarianceProxy_negRandomMatrixFamily`. Positive-side quadratic-form tail-wrapper integration is available through `sampleCovariance_quadraticForm_tail_optimized_under_exactRowSqNorm_bound_of_troppPrimitive`, with centered-square-chain variant `sampleCovariance_quadraticForm_tail_optimized_under_exactRowSqNorm_bound_of_centeredSquareChain_of_troppPrimitive`. The CFC-free two-sided/operator-norm integration is available through `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_exactRowSqNorm_bound_with_neg_square_adapters_of_troppPrimitives`, with centered-square-chain variant `sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_exactRowSqNorm_bound_with_neg_square_adapters_of_centeredSquareChain_of_troppPrimitives`.
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
`matrixBernsteinTraceMGFWithBernsteinCoeff_under_troppPrimitive`, which reuses
that CFC proof while keeping Tropp/Lieb and integrability assumptions explicit.
The preferred optimized Matrix Bernstein wrappers use
`MatrixBernsteinPositiveSideTroppAssumptions` and
`MatrixBernsteinNegativeSideTroppAssumptions` to avoid exposing pointwise CFC
fields in generic call sites. The sample-covariance route now also has
CFC-free `_of_troppPrimitive` / `_of_troppPrimitives` wrappers that reuse
`bernsteinMatrixExp_le_quadratic` while keeping Tropp/Lieb and integrability
assumptions explicit. The positive-side quadratic-form wrapper
`sampleCovariance_quadraticForm_tail_optimized_under_exactRowSqNorm_bound_of_troppPrimitive` uses the exact-row variance-proxy hardbone consumer and keeps
the sharp-chain premise explicit. Its centered-square-chain variant replaces
that premise by the generic centered-square variance-proxy chain over
`rankOneRandomMatrixFamily (rowVector A)`. The local matrix-exp/log normalization leaf is proved as
`matrixExpLogSelfAdjointNormalization`; it supplies only the pointwise CFC
normalization needed by the Tropp/Lieb one-step chain. The log/order-to-`K`
route now includes the proved thin bridge `matrixLog_le_of_le_matrixExp`, which
composes explicit operator-log monotonicity and `matrixExp` log-domain premises.
It does not prove those premises or the downstream trace-exponential
monotonicity step. The finite-family conditioning chain now has the thin witness
`troppConditionalStep_of_iIndepFun`; it forwards the explicit per-index
conditional-expectation provider and does not prove the history, independence,
or conditional-expectation inputs themselves.

## Not Yet Proved

- Full Tropp/Lieb machinery.
- Golden-Thompson route.
- Full unconditional Matrix Bernstein theorem.
- Natural history measurability, independence conditioning,
  conditional-expectation reduction, and trace-exp integrability propagation for
  the conditional-step Tropp route.
- Proofs of the remaining hardbone statement targets for operator-log
  monotonicity, `matrixExp` log-domain support, trace-exp monotonicity,
  Tropp/Lieb, automatic trace-exp domination/integrability, automatic
  variance-proxy sharpening beyond centered-square expectation expansion,
  support-domination providers, support-construction certificates, true
  effective-rank/support trace certificates, and dimension/rank refinements
  beyond explicit star-projection rank consumers.
- Two-sided/operator-norm sample-covariance wrappers that consume exact-row variance proxies on both signs.
- A public-friendly Matrix Bernstein wrapper directly over the natural-state
  route.

## Maintenance Rule

Keep this file as a compact index. Put only short historical summaries in
`archive.md`, and put exact API-name details in the relevant API index.
