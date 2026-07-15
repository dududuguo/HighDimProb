# Leaf Plan

## Scalar

- Centering
- Variance
- ExpectationBridges
- TailBridges
- IntegrabilityBridges

## Analysis

- RealInequalities
- GammaBounds
- GaussianMomentBounds

## Concentration

- LayerCake
- Markov
- Chebyshev
- Chernoff
- MGF
- SubGaussianSums
- RademacherSums
- Hoeffding
  - Rademacher specialization: implemented in `RademacherSums`
  - Finite unweighted bounded-variable form: conservative, sharp centered, and sharp non-centered versions implemented in `Hoeffding`
  - Weighted bounded-variable form: implemented in `Hoeffding`
- Bernstein
  - Stage B1: `Concentration/SubExponentialSums.lean`, `Concentration/Bernstein.lean`
  - Stage B1-fix: `Concentration/MaxScale.lean`, normalized raw/lintegral finite-sum MGF, local quadratic Bernstein
  - Stage B2: full scalar Bernstein min-form tail bound under the lintegral predicate
  - Stage B3: deterministic weighted scalar Bernstein theorem under the lintegral predicate
  - Stage M-real-1: real-exponent `SubGaussianMoment` bridge
  - Stage M-real-2: real-exponent `SubExponentialMoment` bridge
  - Stage SC-final-update: scalar closeout refreshed after both moment bridges
  - Current repository next task:
    RM-VP-negative-exact-row-variance-proxy-provider-contract. Natural-state
    assumption bundling, negative trace-MGF provider cleanup, Matrix Bernstein,
    Hanson-Wright, and WLLN/SLLN remain separate future directions.
- OrliczToTail
- TailToOrlicz
- MomentImplications
- Implications
- SubGaussianImplications
- SubExponentialImplications

## Distributions

- Rademacher
- RademacherProduct
- BernoulliAtoms
- BoundedSigns

## Vector

- Marginals
- VectorNorms
- Centered
- CovarianceTheorems
- IsotropicTheorems
- SubGaussianVectorTheorems

## Geometry

- CoveringPacking
- MetricEntropyLog
- GaussianWidth
- StableDimension
- ChainingStatements

### Current Five-Stage Process Roadmap

- [x] **finite chaining:** finite chains, level suprema, finite measurability /
  integrability, and centered-subGaussian cardinality bounds are proved for
  supplied finite data; the metric increment adapter is
  `expect_abs_sub_chain_le_sum_of_level_sup_of_subGaussianMGFIncrements`.
- [x] **minimal-cover adapter:**
  `exists_finset_isInternalEpsilonNet_of_totallyBounded` connects
  `TotallyBounded K` and positive cover radii to finite internal nets and
  exact `coveringNumber` cardinality data. The `dist` versus `epsilonRadius`
  conversion remains explicit.
- [ ] **dyadic entropy sum:** the single-layer and finite-level parent bridges
  `exists_parentMap_of_subset_of_isInternalEpsilonNet` and
  `exists_finset_parentMap_of_internalLevels` are proved; construct compatible
  finite dyadic nets and endpoint paths next, retaining the positive `σ`/`r`
  hypotheses of the radius adapter.
- [ ] **entropy integral:** prove the finite-sum comparison with an explicitly
  finite entropy integral; no such definition is present yet.
- [ ] **Dudley:** add the separability, measurable-supremum, and limiting
  contract only after the preceding stages are real declarations.

The current supremum API is finite `Finset`-only. The increment predicate does
not require `0 < σ`, but its radius adapter does; `TotallyBounded K` does not by
itself supply compactness, separability, or an infinite measurable supremum.
Full Dudley, full Tropp, and unconditional Matrix Bernstein remain outside this
leaf plan.

## RandomMatrix

- SelfAdjoint
- MatrixOrder
- Expectation
- Sums
- VarianceProxy
- ConcentrationStatements
- Spectral
- TraceExp
- Laplace
- IndependentRows
- IidRows
- Algebra
- Statements
- SampleCovarianceAlgebra
- SampleCovarianceTheorems
- UnitSphere
- OperatorNormMeasurability
- OperatorNormNetBridge
- MatrixDeviationStatements
- MatrixBernsteinStatements
- HansonWrightStatements
- JLStatements
- CovarianceEstimationStatements
- Follow-up at the time: Stage MB-S9-trace-mgf-to-laplace-tail-contract. Audit
  the trace-mgf provider route now that the single-summand MGF provider is
  proved under explicit pointwise Bernstein CFC assumptions and the bounded
  Bernstein RHS coefficient is normalized. At that time the Bernstein CFC
  primitive itself was still typed only; the later hardbone leaf proves it as
  `bernsteinMatrixExp_le_quadratic`. Do not prove Golden-Thompson, Lieb, the
  full trace-mgf provider, or Matrix Bernstein in that contract stage.

## Current RandomMatrix Leaf

### Tropp bookkeeping reduction: prefix/suffix partial sums

- Completed leaf ID: `RM-BR-state-prefix-suffix-partial-sum-api`.
- Purpose: finite-sum/state bookkeeping for the existing `Fin m` Tropp
  conditional-step route.
- New API in `HighDimProb/RandomMatrix/Sums.lean`:
  `comparisonMatrixPrefixSum`, `comparisonMatrixSuffixSum`,
  `randomMatrixPrefixSum`, `randomMatrixSuffixSum`, endpoint/successor
  lemmas, and `randomMatrixSum_eq_prefixSum_last`.
- Abstraction boundary: deterministic comparison-matrix prefix/suffix sums
  live below random-matrix prefix/suffix sums; both remain bookkeeping APIs
  for state construction and do not replace `randomMatrixSum`.
- Scope preserved: this does not prove Lieb, Bernstein CFC, Golden-Thompson,
  Matrix Bernstein, arbitrary finite-index Tropp, or natural history/state
  construction.
- Follow-up completed leaf:
  `RM-lightweight-bookkeeping-bridges`, adding the trace-exp endpoint wrappers
  `traceMatrixExp_randomMatrixPrefixSum_last` and
  `traceMatrixExp_comparisonMatrixPrefixSum_last`, plus example-only
  prefix/state and reindex transport usage modules.
- Boundary preserved: `ConditionalStateEndpointData` is example-local; no
  Lieb, Golden-Thompson, Bernstein CFC, conditional-expectation independence,
  full Matrix Bernstein, or arbitrary finite-index primitive was proved.
- Follow-up completed leaf:
  `RM-MAIN-natural-tropp-matrix-bernstein-pipeline`, adding the natural
  `Fin m` trace state, endpoint theorems, finite-family Tropp provider, and
  trace-MGF provider wrapper.
- Boundary preserved: this remains a TraceExp-level route. It does not prove
  Lieb, Golden-Thompson, Bernstein CFC, independence conditioning,
  trace-exp integrability propagation, full Matrix Bernstein, or a
  public-friendly sample covariance natural-state wrapper.
- Follow-up completed leaf:
  `RM-HB-hardbone-statement-atlas`, naming CFC, log/order, Tropp/Lieb,
  conditioning, integrability, variance-proxy, and dimension/rank blockers as
  typed statement targets with selected thin consumers.
- Follow-up completed leaf:
  `RM-HB-scalar-Bernstein-exp-quadratic-proof`, proving the scalar real
  inequality target `scalarBernsteinExpQuadraticInequality` while leaving
  matrix CFC, spectrum/localization, expression normalization, Tropp/Lieb,
  conditioning, integrability, variance-proxy, and dimension/rank hardbone
  leaves open.
- Follow-up completed leaf:
  `RM-HB-cfc-expression-normalization-contract`, proving spectrum localization,
  Bernstein-specific CFC order transfer, CFC expression normalization, and the
  pointwise Bernstein CFC primitive `bernsteinMatrixExp_le_quadratic`.
- Follow-up completed cleanup:
  generic optimized Matrix Bernstein wrappers now have CFC-free
  `*_of_troppAssumptions` entry points through
  `MatrixBernsteinPositiveSideTroppAssumptions` and
  `MatrixBernsteinNegativeSideTroppAssumptions`.
- Boundary preserved: this does not prove Tropp/Lieb, Golden-Thompson,
  trace-MGF iteration, variance-proxy sharpening, full Matrix Bernstein, or
  sample-covariance CFC-free wrappers.
- Follow-up completed leaf:
  `RM-HB-sample-covariance-cfc-free-wrapper-contract`, adding CFC-free
  sample-covariance wrapper surfaces through the proved Bernstein CFC leaf.
- Follow-up completed leaf:
  `CG-B17-star-projection-rank-support-consumer-contract`, adding the
  star-projection trace/rank certificate consumer for rank/support trace-exp
  bounds.
- Follow-up completed leaf:
  `CG-B18-star-projection-psd-bridge-contract`, adding
  `isPSDMatrix_of_isStarProjection` and removing the explicit PSD premise from
  the star-projection rank/support consumer.
- Follow-up completed abstraction leaf:
  `CG-B19-support-domination-certificate-contract`, naming the explicit support
  domination premise as `MatrixExpSupportDomination` without proving a provider.
- Follow-up completed abstraction leaf:
  `CG-B20-support-domination-provider-contract`, splitting the provider frontier
  into ambient identity-support and corrected excess-support statement targets.
- Follow-up completed proof leaf:
  `CG-B21-excess-support-trace-bridge-contract`, adding the deterministic
  excess-support trace bridge and hardbone supportDim consumer under explicit
  excess certificate, trace support-dimension, and nonnegative coefficient
  assumptions.
- Boundary preserved: this does not construct a support provider, prove a true
  effective-rank certificate, prove Tropp/Lieb or Golden-Thompson, sharpen the
  variance proxy, or prove Matrix Bernstein.
- Follow-up completed proof leaf:
  `RM-VP-deterministic-matrix-expectation-mul-bridge-contract`, proving
  deterministic expectation multiplication bridges, centered-square expectation
  expansion, and an expansion-free centered-square-chain variance-proxy
  consumer.
- Follow-up completed proof leaf:
  `RM-VP-rank-one-second-moment-contract`, proving the centered rank-one
  second-moment Loewner comparison and a thin sample-covariance hardbone
  consumer that supplies that comparison to the abstract sharp-variance chain.
- Boundary preserved: this does not prove the uncentered row second-moment
  comparison against a concrete `V_i`, deterministic variance-proxy norm
  control, sharper sample-covariance variance-proxy control, Tropp/Lieb,
  Golden-Thompson, Bernstein CFC, or Matrix Bernstein.
- Follow-up completed proof leaf:
  `RM-VP-sample-covariance-row-second-moment-contract`, adding the exact
  row-second-moment hardbone consumer and removing the reflexive row comparison
  when `V_i` is chosen as `matrixSecondMoment P (rankOneRandomMatrix (X i))`.
- Follow-up completed proof leaf:
  `RM-VP-exact-row-second-moment-norm-control-contract`, adding the generic
  finite-sum subadditivity bridge
  `deterministicMatrixVarianceProxyNorm_sum_le_sum`.
- Follow-up completed proof leaf:
  `RM-VP-exact-row-second-moment-operator-norm-provider-contract`, adding
  single-row and row-specific finite-family norm providers for exact rank-one
  second moments under explicit rank-one square-integrability assumptions.
- Follow-up completed proof leaf:
  `RM-VP-rank-one-square-integrability-provider-contract`, adding
  `integrableRandomMatrix_randomMatrixSquare_rankOneRandomMatrix_of_integrable_four_products`
  as a direct provider from explicit four-coordinate product integrability.
- Follow-up completed proof leaf:
  `RM-VP-rank-one-square-integrability-memlp4-provider-contract`, adding
  `integrableRandomMatrix_randomMatrixSquare_rankOneRandomMatrix_of_memLp_four`
  as a coordinate-`MemLp 4` provider via Mathlib Holder product APIs.
- Follow-up completed proof leaf:
  `RM-VP-rank-one-square-integrability-bounded-row-provider-contract`, adding
  `coordinate_sq_le_vectorSqNorm` and
  `integrableRandomMatrix_randomMatrixSquare_rankOneRandomMatrix_of_sqNorm_bound_memLp_two`
  as the bounded-row square-integrability provider from coordinate `MemLp 2`
  plus pointwise `vectorSqNorm <= R`.
- Follow-up completed proof leaf:
  `RM-VP-centered-rank-one-square-integrability-provider-contract`, adding centered rank-one square-integrability providers and the bounded-row crude variance-proxy consumer that supplies the centered square-integrability premise.
- Follow-up completed proof leaf:
  `RM-VP-sample-covariance-exact-row-variance-proxy-wrapper-contract`, adding
  `sampleCovarianceVarianceProxy_sharp_of_exactRowSqNorm_bound_memLp_two` as a
  row-specific exact-row variance-proxy hardbone consumer with RHS `rowSqNormVarianceProxyNormRHS R`.
- Boundary preserved: this does not prove concrete sample-covariance row-moment evaluation, the hardbone sharp-chain provider, Tropp/Lieb, Golden-Thompson, Bernstein CFC, or Matrix Bernstein.
- Follow-up completed proof leaf:
  `RM-VP-sample-covariance-tail-wrapper-with-exact-row-vp-contract`, adding
  `sampleCovariance_quadraticForm_tail_optimized_under_exactRowSqNorm_bound_of_troppPrimitive` as a positive-side quadratic-form wrapper over the
  row-specific exact-row variance-proxy consumer.
- Boundary preserved: this does not prove the hardbone sharp-chain provider,
  Tropp/Lieb, Golden-Thompson, Bernstein CFC, two-sided control, operator-norm
  control, or Matrix Bernstein.
- Follow-up completed API-consolidation leaf:
  `RM-API-matrix-bernstein-tail-assumption-bundle-consolidation`, adding
  `SampleCovarianceTailTarget`, `SampleCovarianceBoundedRowTroppAssumptions`,
  and `sampleCovariance_tail_optimized_under_boundedRowTroppAssumptions` as the
  compact bounded-row sample-covariance route.
- Boundary preserved: this does not prove new Tropp/Lieb, Golden-Thompson,
  trace-exp integrability, variance-proxy sharpening, or full Matrix Bernstein;
  it only consolidates already proved wrappers behind a target axis and one
  record.
- Integrated bridge-layer PR stack: exact-row centered-square sample-covariance
  wrappers/bundles, negative-side exact-row variance-proxy transfer, and
  deterministic PSD Loewner variance-proxy norm monotonicity. These are proof
  infrastructure, not a replacement for the compact bounded-row public route.
- Follow-up completed API leaf:
  `RM-API-matrix-bernstein-high-probability-threshold-contract`, adding the
  scalar `bernsteinAdditiveTailThreshold` inversion lemmas and the public
  `matrixBernsteinSelfAdjointHighProbabilityStatement` consumer surface.
- Boundary preserved: the main layer owns scalar inversion and the public
  contract/consumer under `0 < n`, `0 < delta <= 1`, `0 <= sigmaSq`,
  `0 <= R`, and `0 < sigmaSq or 0 < R`; it does not construct the
  generated-history witness or prove unconditional Matrix Bernstein.
- Next safe leaf: supply or audit a separate optimized-tail provider while
  keeping this public consumer boundary explicit.

## Process

- GaussianProcess
- CanonicalMetric
- SubGaussianIncrement
- EmpiricalMeasure
- EmpiricalProcessBounds
- VC

## LimitTheorems

- Basic
- WeakLaw
- Assumptions
- SampleMean
- ConvergenceInProbability
- Independence
- VarianceSums
- StrongLawStatements

## Statements

- ConcentrationStatements
- RandomMatrixStatements
- RandomMatrixConcentrationStatements
- ProcessStatements
- RecoveryStatements

## Tactic

- Measurability
- FinsetSimp
- MatrixEntry
- Tail

## RM-LIEB-S2 Log-Domain Core Proof And Operator-Log Representation Bridge

- Status: partially proved.
- Added: `matrixExpLogDomainForSelfAdjoint`, proving the `matrixExp` log-domain and normalization provider used by `matrixLog_le_of_le_matrixExp`.
- Boundary preserved: this does not prove operator-log monotonicity, trace-exp monotonicity, Lieb concavity, Jensen, Golden-Thompson, conditioning, or full Matrix Bernstein.
- Next safe leaf: continue toward Lieb/Jensen or the finite-family conditioning/integrability providers.

## RM-LIEB-S3 Operator-Log Monotonicity Representation Bridge

- Status: proved as infrastructure.
- Added: `isPSDMatrix_of_posSemidef`, `matrixLE_of_mathlib_le`, and `mathlib_le_of_matrixLE` as reusable `MatrixOrder` bridges below `Spectral`.
- Boundary preserved: this bridge only relates HighDimProb's explicit PSD/order vocabulary to Mathlib's matrix order.
- Next safe leaf: continue toward Lieb/Jensen or the finite-family conditioning/integrability providers.

## RM-LIEB-S4 Real Matrix To CStar Log Monotonicity Contract

- Status: consumed by proof.
- Result: Mathlib `CFC.log_le_log` is available on `CStarMatrix (Fin n) (Fin n) ℂ` and is now used by `operatorLogMonotoneOnPositiveMatrices`.
- Boundary preserved: this does not prove Lieb concavity, Jensen, Golden-Thompson, conditioning, or full Matrix Bernstein.
- Next safe leaf: continue toward Lieb/Jensen or the finite-family conditioning/integrability providers.

## RM-LIEB-S5 Real To CStar Transport API Contract

- Status: proved in main.
- Result: `CStarBridge` now proves the real-to-`CStarMatrix` star-algebra hom, strict positivity transport, `MatrixLE` transport, strictly-positive self-adjoint `CFC.log` transport, and reflected order transport.
- Boundary preserved: log-back is intentionally restricted to strictly positive self-adjoint matrices.
- Next safe leaf: continue toward Lieb/Jensen or the finite-family conditioning/integrability providers.

## RM-LIEB-S6 Real-To-CStar Transport And Operator-Log Witness

- Status: proved.
- Added: `realMatrixToCStar_nonneg`, `realMatrixToCStar_strictlyPositive`, `realMatrixToCStar_matrixLE`, `realMatrixToCStar_log`, `matrixLE_of_realMatrixToCStar_matrixLE`, and `operatorLogMonotoneOnPositiveMatrices`.
- Boundary preserved: this closes the real-matrix operator-log monotonicity leaf only. It does not prove Lieb concavity, Jensen, Golden-Thompson, conditioning, trace-exp integrability propagation, variance-proxy control, or full Matrix Bernstein.
- Next safe leaf: continue toward Lieb/Jensen or the finite-family conditioning/integrability providers.

## RM-LIEB-S7 Trace-Exponential Monotonicity Hardbone Witness

- Status: proved.
- Added: `TraceExpDerivative.lean` for the scalar derivative of `trace (exp (X + t • C))`, `TraceExpMonotonicity.lean` for deterministic Loewner-direction trace-exp monotonicity, and the hardbone witness `traceMatrixExp_mono_add_selfAdjoint`.
- Boundary preserved: this proves only the deterministic trace-exponential monotonicity leaf. It does not prove operator-log monotonicity, Lieb concavity, Jensen, Golden-Thompson, conditioning, trace-exp integrability propagation, variance-proxy control, or full Matrix Bernstein.
- Next safe leaf: continue toward Lieb/Jensen or the finite-family conditioning/integrability providers.

## RM-LIEB-S8 Direct Log/Order-To-K Wrapper

- Status: proved.
- Added: `troppLogExpComparisonToK`, a deterministic wrapper proving `troppLogExpComparisonToK_statement` from the already proved matrix-exp log-domain, operator-log monotonicity, and trace-exp monotonicity leaves.
- Boundary preserved: this does not prove Lieb concavity, Jensen, Golden-Thompson, conditioning, trace-exp integrability propagation, variance-proxy control, or full Matrix Bernstein.
- Next safe leaf: continue toward Lieb/Jensen or the finite-family conditioning/integrability providers.
