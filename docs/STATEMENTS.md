# Statement Assumption Ledger

This file lists hard analytic assumptions that progress-first RandomMatrix
contracts are allowed to consume explicitly while separate provider work fills
them in. Entries here are not claims that the assumptions are proved.

This is a developer-facing hardbone ledger, not a downstream API reference.
The strategy is to make hard proof frontiers precise enough that independent
provider work can discharge them while HighDimProb remains deliverable and
extensible. Composition theorems recorded here may be useful scaffolds for
type-checking the route, but they should not be treated as the preferred
user-facing surface. Once provider theorems are imported, these scaffolds should
be collapsed, deprecated, or hidden behind smaller stable wrappers.

## RM-LIEB-S9: finite-family trace-MGF from explicit conditioning inputs

Consumer theorem:

- `traceMGFBernsteinVarianceProxyBound_of_conditioningBridge`

This theorem composes the conditioning bridge with the natural-state
finite-family trace-MGF route. It requires the following hard facts as explicit
premises:

- `troppConditionalStep_of_iIndepFun_statement theta X K mHist`, the
  source-level conditioning chain target.
- `troppNaturalHistoryMeasurable_statement theta X K mHist`, used with
  `hHistSub` to supply natural-state history measurability.
- `troppHistoryStepIndependent_of_iIndepFun_statement theta X K`, used with
  finite-family `iIndepFun X P` to supply history/current-step independence.
- Per-index `condExp_traceExp_history_add_independent_step_statement`, the
  conditional-expectation reduction from a history-measurable matrix and an
  independent current step.
- Natural-state side conditions for each index: history sub-sigma algebra,
  history/current random-matrix measurability, self-adjoint history/current
  steps, trace-exponential integrability of `H_i + Z_i`, matrix-exponential
  integrability of `Z_i`, self-adjointness and strict positivity of the
  matrix-exponential mean, sigma-finiteness of the trimmed history measure, and
  trace-exponential integrability of `H_i + K_i`.
- Finite-family Bernstein side conditions: random/self-adjoint summands,
  finite-family independence, scaled matrix-exponential integrability,
  full-sum trace-exponential integrability, self-adjoint comparison matrices,
  self-adjoint variance proxy, nonnegative radius, Bernstein theta range,
  per-index MGF Loewner comparison, and the variance-proxy normalization
  `sum K_i = SMul.smul (bernsteinMGFCoeff theta R) V`.

Non-goals for this consumer:

- It does not prove natural-history measurability, history/current-step
  independence, finite-family independence, conditional-expectation reduction,
  trace-exponential integrability propagation, strict positivity of the
  matrix-exponential mean, variance-proxy control, Lieb/Jensen,
  Golden-Thompson, or full Matrix Bernstein.

## RM-LIEB-S10: conditioning trace-MGF to explicit Laplace/tail route

Consumer theorems:

- `matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFBridge`
- `matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFTailAssumptions`,
  which is only a field-access wrapper around the named assumption bundle
  `MatrixBernsteinConditioningTraceMGFTailAssumptions`.

This theorem composes the S9 conditioning trace-MGF consumer with the existing
quadratic-form Laplace route. It requires all S9 assumptions listed above, plus
the following tail-side facts as explicit premises:

- AEMeasurability of `fun omega => ENNReal.ofReal
  (traceExpIntegrand (randomMatrixSum X) theta omega)`.
- The event bridge from `quadraticFormUpperTailEvent (randomMatrixSum X) t`
  to `traceExpThresholdEvent (randomMatrixSum X) theta t`.

The real trace-MGF to `TraceMGFBernsteinVarianceProxyBoundLIntegral` conversion
is provided by the existing proved bridge, using the explicit full-sum
trace-exponential integrability and self-adjoint summand assumptions already
required by S9.

Non-goals for this consumer:

- It does not prove the tail event domination, natural-history measurability,
  independence conditioning, conditional-expectation reduction, trace-exp
  integrability propagation, strict positivity of matrix-exponential means,
  variance-proxy control, Lieb/Jensen, Golden-Thompson, theta optimization,
  dimension/rank reduction, or full Matrix Bernstein.

## RM-LIEB-S11-S16: provider-facing Lieb/Tropp and natural-state route

Provider-facing import:

- `HighDimProb.RandomMatrix.LiebProvider`

Provider theorem surfaces:

- `matrixExpFDeriv`, `hasFDerivAt_matrix_exp`,
  `hasStrictFDerivAt_matrix_exp`, `hasFDerivAt_matrix_exp_trunc`,
  `matrixExpSelfAdjoint`, `matrixExpFDerivSelfAdjoint`,
  `matrixExpFDerivSelfAdjoint_spectral_equiv`,
  `hasFDerivAt_matrix_exp_selfAdjoint`, and
  `hasStrictFDerivAt_matrix_exp_selfAdjoint`, the ambient and self-adjoint
  carrier finite-dimensional matrix-exponential Frechet derivative layers plus
  the self-adjoint spectral-equivalence primitive.
- `cfcLogSelfAdjoint`, `CFCLog.derivSAAt`, `CFCLog.lineDeriv`,
  `CFCLog.hasDerivAt_line`,
  `exists_hasDerivAt_cfcLog_affineLine_of_strictlyPositive`, and
  `hasDerivAt_cfcLog_affineLine_of_strictlyPositive`, the strictly-positive
  self-adjoint carrier first-order `CFC.log` derivative layer. This is not a
  second-order sign theorem.
- `hasDerivAt_inverse_affineLine`,
  `hasDerivAt_trace_mul_inverse_affineLine_general_neg_cycle`, and their
  strict-positive / identity-line specializations, the short inverse and
  trace-resolvent derivative layer. This is not a log-resolvent representation.
- `lambdaMaxOrdered_le_of_matrixLE_selfAdjoint` and
  `lambdaMinOrdered_le_of_matrixLE_selfAdjoint`, ordered spectral endpoint
  monotonicity under explicit self-adjointness and `MatrixLE`.
- `traceMGFBernsteinVarianceProxyBoundLIntegral_of_real`,
  `matrixBernsteinTraceMGFToLaplaceContract`, and
  `matrixBernsteinTraceMGFToLaplaceContract_under_primitives`, thin
  trace-MGF-to-Laplace contracts under explicit premises.
- `troppNaturalHistoryMeasurable_of_suffix_entry_measurable`, the conditional
  suffix-entry measurability bridge for natural Tropp histories.
- `troppHistoryStepIndependent_of_iIndepFun_of_measurable`, the strengthened
  independence bridge from `iIndepFun X P` plus explicit summand measurability;
  the weaker exact statement contract is still kept separate.
- `matrixExpScaledIntegrable_of_provider_finiteMeasure`,
  `traceExpIntegrable_troppStateHistory_add_step_of_operatorNormBounds_finiteMeasure`,
  `traceExpIntegrable_troppStateHistory_add_K_of_operatorNormBounds_finiteMeasure`,
  `troppCurrentRandomStep_operatorNorm_le_of_summand_bound`,
  `troppStateHistory_operatorNorm_le_of_summand_and_comparison_bounds`, and the
  summand/comparison-bound finite-measure trace-exp wrappers, bounded
  replacements that do not discharge weaker unbounded hardbone statements.
- `EpsteinAffineLineConcavity`, an explicit analytic assumption. It is not
  proved here.
- `liebTraceExpConcavity_of_epsteinAffineLine` and
  `liebJensenTraceExp_statement_of_epsteinAffineLine`, which route the explicit
  Epstein affine-line assumption into the existing Lieb/Jensen statement shape.
- `troppMasterTraceMGFStep_of_epsteinAffineLine` and
  `troppMasterTraceMGFStep_trace_bound_of_epsteinAffineLine_and_providerLogOrder`,
  which compose the conditional Lieb/Jensen route with the proved deterministic
  log/order-to-`K` bridge.
- `MatrixBernsteinConditioningTraceMGFProviderAssumptions` and
  `MatrixBernsteinConditioningTraceMGFProviderAssumptions.toTailAssumptions`,
  which synthesize natural-history measurability and bounded finite-measure
  trace-exp integrability fields only.
- `matrixBernsteinQuadraticFormUpperTail_of_naturalStateProviderAssumptions`,
  which exposes the S10 tail bound through the provider-compressed bundle.

Non-goals for this provider layer:

- It does not prove a log-resolvent representation, the Epstein trace-second
  sign theorem, the unconditional Epstein affine-line theorem, full Lieb
  concavity, Golden-Thompson, history/current independence, conditional
  expectation, variance-proxy normalization, full-sum trace-integrability,
  tail-event domination, or full Matrix Bernstein.
