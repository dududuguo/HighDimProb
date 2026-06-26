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

## RM-LIEB-S11: provider-backed deterministic log/order and trace-exp monotonicity

Consumer targets:

- `operatorLogMonotoneOnPositiveMatrices_statement`
- `traceMatrixExp_mono_add_selfAdjoint_statement`
- `troppLogExpComparisonToK_statement`

The sibling proof-provider repository `/workspace/projects/HighDimProbLiebProvider`
contains provider proofs for the first two exact HighDimProb statement surfaces
and a thin composition to the deterministic Tropp log/`K` comparison.  A
HighDimProb theorem-push task may therefore advance past the old CStar transport
and trace-exponential monotonicity blockers by importing or porting those
provider facts, rather than treating them as open analytic assumptions.

Provider facts consumed by the main-repo port:

Main-repo port status (2026-06-26): these deterministic leaves are now exposed
in `HighDimProb.RandomMatrix.LiebProvider` as
`operatorLogMonotoneOnPositiveMatrices`,
`traceMatrixExp_mono_add_selfAdjoint`, and
`troppLogExpComparisonToK_of_providerLogOrder`.

- `HighDimProbLiebProvider.operatorLogMonotoneOnPositiveMatrices`, discharging
  `operatorLogMonotoneOnPositiveMatrices_statement` through real-to-`CStarMatrix`
  strict-positivity, Loewner-order, and `CFC.log` transport.
- `HighDimProbLiebProvider.traceMatrixExp_mono_add_selfAdjoint`, discharging
  `traceMatrixExp_mono_add_selfAdjoint_statement` through the affine derivative
  of trace exponential and PSD trace-product nonnegativity.
- `HighDimProbLiebProvider.troppLogExpComparisonToK_of_providerLogOrder`, a
  deterministic bridge from provider log/order plus provider trace-exp
  monotonicity to `troppLogExpComparisonToK_statement`.

Remaining assumptions and side conditions at this layer:

- Matrix self-adjointness, strict positivity, and `MatrixLE` hypotheses remain
  exactly those in the HighDimProb statement surfaces.
- `matrixExpLogDomainForSelfAdjoint_statement` remains the local log-domain and
  `CFC.log (matrixExp K) = K` normalization input for the log-to-`K` route.
- The provider import boundary is resolved by porting the exact theorem bodies
  into HighDimProb; no reverse Lake dependency on the provider repo is used.

Non-goals for this provider-ingestion step:

- It does not prove Lieb concavity, Epstein concavity, Jensen, Golden-Thompson,
  conditional expectation, trace-MGF iteration, variance-proxy control, or full
  Matrix Bernstein.
- It should not rename deterministic log/order progress as a full Tropp/Lieb
  matrix-MGF theorem.

## RM-LIEB-S12: conditional Epstein affine-line route to Tropp one-step

Consumer targets:

- `liebTraceExpConcavity_statement`
- `liebJensenTraceExp_statement`
- `troppMasterTraceMGFStep_statement`
- the one-step-to-`K` trace bound obtained by composing the Tropp one-step with
  `troppLogExpComparisonToK_statement`

The proof-provider repository has reduced the hard Lieb input to one explicit
finite-dimensional affine-line hypothesis.  A theorem-push task may use this as
the aggressive replacement for the older fully opaque Lieb/Jensen assumption,
while keeping the affine-line analytic theorem visible in this ledger.

Primary foundational assumption:

- `EpsteinAffineLineConcavity`: for every finite dimension and self-adjoint
  `H`, `A`, and `C`, if the affine segment `A + t • C` is strictly positive for
  all `t ∈ [0, 1]`, then the scalar function
  `t ↦ traceMatrixExp (H + CFC.log (A + t • C))` is concave on `[0, 1]`.

Provider reductions consumed by the main-repo conditional port:

Main-repo port status (2026-06-26): the explicit assumption and conditional
wrappers are now exposed in `HighDimProb.RandomMatrix.LiebProvider` as
`EpsteinAffineLineConcavity`, `liebTraceExpConcavity_of_epsteinAffineLine`,
`liebJensenTraceExp_statement_of_epsteinAffineLine`,
`troppMasterTraceMGFStep_of_epsteinAffineLine`, and
`troppMasterTraceMGFStep_trace_bound_of_epsteinAffineLine_and_providerLogOrder`.

- `HighDimProbLiebProvider.liebTraceExpConcavity_of_epsteinAffineLine`
- `HighDimProbLiebProvider.liebJensenTraceExp_statement_of_epsteinAffineLine`
- `HighDimProbLiebProvider.troppMasterTraceMGFStep_of_epsteinAffineLine`
- `HighDimProbLiebProvider.troppMasterTraceMGFStep_trace_bound_of_epsteinAffineLine_and_providerLogOrder`

Proof-facing refinements of the foundational assumption:

- It is enough to prove linewise first and second derivative data on the open
  interval, with second derivative nonpositive, as packaged by
  `epsteinAffineLineConcavity_of_hasDerivAt2_nonpos` or
  `epsteinAffineLineConcavity_of_hasDerivWithinAt2_nonpos`.
- A still narrower route is to prove the `CFC.log` affine-line derivative and
  scalar trace-derivative nonpositivity consumed by
  `epsteinAffineLineConcavity_of_cfcLog_hasDerivAt_traceDerivative_nonpos`.

Side conditions that remain explicit when this assumption is consumed by the
Tropp one-step route:

- `IsSelfAdjointMatrix H`.
- `RandomSelfAdjointMatrix P Z`.
- `IntegrableRealRandomVariable P (fun omega => traceMatrixExp (H + Z omega))`.
- `IntegrableRandomMatrix P (fun omega => matrixExp (Z omega))`.
- Self-adjointness and strict positivity of
  `matrixExpect P (fun omega => matrixExp (Z omega))`.
- For the trace-bound-to-`K` form, self-adjointness of `K` and the matrix-MGF
  comparison
  `MatrixLE (matrixExpect P (fun omega => matrixExp (Z omega))) (matrixExp K)`.

Non-goals for this conditional Epstein route:

- It does not prove unconditional Lieb concavity until
  `EpsteinAffineLineConcavity` or an equivalent theorem is proved.
- It does not prove Golden-Thompson, finite-family conditioning, independence,
  integrability propagation, variance-proxy control, or full Matrix Bernstein.

## RM-LIEB-S13: provider-backed S9/S10 assumption compression inputs

Consumer targets:

- `traceMGFBernsteinVarianceProxyBound_of_conditioningBridge`
- `MatrixBernsteinConditioningTraceMGFTailAssumptions`
- `matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFTailAssumptions`

The proof-provider repository has proved several bounded or conditional provider
facts that can shrink the explicit assumption burden in the S9/S10 route.  These
facts should be consumed as theorem-backed provider inputs, not marketed as
unconditional Matrix Bernstein.

Natural-history measurability input:

Main-repo port status (2026-06-26): bounded provider facts are now exposed in
`HighDimProb.RandomMatrix.LiebProvider`, and S10 has the compressed bundle
`MatrixBernsteinConditioningTraceMGFProviderAssumptions` plus the converter
`MatrixBernsteinConditioningTraceMGFProviderAssumptions.toTailAssumptions` and
tail wrapper
`matrixBernsteinQuadraticFormUpperTail_of_conditioningTraceMGFProviderAssumptions`.

- `HighDimProbLiebProvider.troppNaturalHistoryMeasurable_of_suffix_entry_measurable`
  supplies `troppNaturalHistoryMeasurable_statement theta X K mHist` from
  explicit suffix-entry measurability: for every history index `i`, every suffix
  index `j` with `i.succ ≤ j`, and every matrix entry `r c`, the coordinate map
  `fun omega => X j omega r c` is measurable with respect to `mHist i`.

Bounded finite-measure integrability inputs:

- `HighDimProbLiebProvider.matrixExpScaledIntegrable_of_provider_finiteMeasure`
  supplies scaled matrix-exponential integrability from finite measure,
  pointwise random-matrix measurability, self-adjoint summands, nonnegative
  radius, and a uniform pointwise operator-norm bound.
- `HighDimProbLiebProvider.traceExpIntegrable_troppStateHistory_add_step_of_operatorNormBounds_finiteMeasure`
  supplies trace-exponential integrability of
  `troppStateHistory theta X K i + troppCurrentRandomStep theta X i` from finite
  measure, measurability, self-adjointness, and pointwise operator-norm bounds
  on both terms.
- `HighDimProbLiebProvider.traceExpIntegrable_troppStateHistory_add_K_of_operatorNormBounds_finiteMeasure`
  supplies trace-exponential integrability of
  `troppStateHistory theta X K i + K i` from finite measure, measurability,
  self-adjointness, and pointwise operator-norm bounds on the random history and
  deterministic comparison matrix.

Support-side deterministic provider input:

- `HighDimProbLiebProvider.matrixExpSupportDomination_identity` proves
  `matrixExpSupportDomination_identity_statement`, giving the ambient identity
  support certificate for self-adjoint matrices.  This is useful for provider
  compression of dimension/support trace-exp bounds, but it only gives the
  ambient cardinality route and no true low-rank/effective-rank provider.

Remaining assumptions for an S9/S10 theorem-push after these provider inputs:

- The exact independence bridge
  `troppHistoryStepIndependent_of_iIndepFun_statement` still needs an honest
  contract with the measurability or `AEMeasurable` hypotheses required by
  Mathlib independence APIs.
- The conditional-expectation bridge
  `condExp_traceExp_history_add_independent_step_statement` still needs an
  honest contract that includes independence of the history sigma-algebra from
  the current step, not merely an unparameterized `IndepFun H Z P` premise.
- The bounded integrability providers require a finite-measure instance and
  explicit operator-norm bounds; if the exact HighDimProb target omits these,
  add a bounded-provider wrapper instead of pretending the original target was
  discharged.

Non-goals for this S9/S10 compression step:

- It does not prove the finite-family independence bridge, conditional
  expectation reduction, Lieb/Epstein, Golden-Thompson, variance-proxy control,
  theta optimization, or full Matrix Bernstein.
- It should reduce explicit assumption burden only where the provider theorem
  actually supplies a named premise.
