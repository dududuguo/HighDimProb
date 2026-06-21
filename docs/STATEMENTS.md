# Statement Assumption Ledger

This file lists hard analytic assumptions that progress-first RandomMatrix
contracts are allowed to consume explicitly while separate provider work fills
them in.  Entries here are not claims that the assumptions are proved.

## RM-LIEB-S8: Tropp one-step `K` bound from explicit Lieb/log-order inputs

Consumer theorem:

- `troppMasterTraceMGFStep_trace_bound_of_liebJensen_logOrder`

This theorem composes existing thin consumers and requires the following hard
facts as explicit premises:

- `troppMasterTraceMGFStep_of_liebJensen_statement H Z`, the source-level
  statement target reducing the Tropp one-step primitive to Lieb/Jensen facts.
- `liebJensenTraceExp_statement H (fun omega => matrixExp (Z omega))`, the
  Jensen consequence of Lieb trace-exponential concavity for the exponential
  random matrix.
- `forall omega, matrixExpLogSelfAdjointNormalization_statement (Z omega)`, the
  pointwise `log (exp Z) = Z` normalization target.
- `troppLogExpComparisonToK_of_logOrderKChain_statement H
  (matrixExpect P (fun omega => matrixExp (Z omega))) K`, the statement-chain
  target for replacing the logarithmic one-step RHS by a deterministic `K`.
- `matrixLog_le_of_le_matrixExp_statement
  (matrixExpect P (fun omega => matrixExp (Z omega))) K`, the explicit
  operator-log/log-domain bridge for the matrix MGF mean.
- `traceMatrixExp_mono_add_selfAdjoint_statement H
  (CFC.log (matrixExpect P (fun omega => matrixExp (Z omega)))) K`, the
  trace-exponential monotonicity step after adding the history matrix.
- The ordinary side conditions consumed by `troppMasterTraceMGFStep_statement`
  and `troppLogExpComparisonToK_statement`: self-adjointness, random
  self-adjointness, trace integrability, matrix-exp integrability, strict
  positivity of the matrix-exp mean, self-adjointness of `K`, and the MGF
  Loewner comparison against `matrixExp K`.

Non-goals for this consumer:

- It does not prove Lieb concavity, Jensen, operator-log monotonicity,
  trace-exp monotonicity, Golden-Thompson, conditional expectation,
  integrability propagation, variance-proxy control, or full Matrix Bernstein.

## RM-LIEB-S9: finite-family trace-MGF from explicit conditioning inputs

Consumer theorem:

- `traceMGFBernsteinVarianceProxyBound_of_conditioningBridge`

This theorem composes the Phase 4 conditioning bridge with the natural-state
finite-family trace-MGF route.  It requires the following hard facts as explicit
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
  `sum K_i = bernsteinMGFCoeff theta R • V`.

Non-goals for this consumer:

- It does not prove natural-history measurability, history/current-step
  independence, finite-family independence, conditional-expectation reduction,
  trace-exponential integrability propagation, strict positivity of the
  matrix-exponential mean, variance-proxy control, Lieb/Jensen,
  Golden-Thompson, or full Matrix Bernstein.

## RM-LIEB-S10: conditioning trace-MGF to explicit Laplace/tail route

Consumer theorem:

- `matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFBridge`

This theorem composes the S9 conditioning trace-MGF consumer with the existing
quadratic-form Laplace route. It requires all S9 assumptions listed above, plus
the following tail-side facts as explicit premises:

- AEMeasurability of `fun omega => ENNReal.ofReal
  (traceExpIntegrand (randomMatrixSum X) theta omega)`.
- The event bridge `quadraticFormUpperTailEvent (randomMatrixSum X) t ⊆
  traceExpThresholdEvent (randomMatrixSum X) theta t`.

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
