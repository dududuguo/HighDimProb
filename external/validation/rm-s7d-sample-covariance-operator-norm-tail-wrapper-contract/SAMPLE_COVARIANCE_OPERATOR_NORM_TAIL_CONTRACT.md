# RM-S7D Sample Covariance Operator-Norm Tail Contract

## Classification

`SAMPLE_COVARIANCE_OPERATOR_NORM_EVENT_BRIDGE_REQUIRED`

## Contract Answers

1. `centeredRandomMatrix P (sampleCovariance A)` cannot feed directly into
   `matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives`.
   The RM-S7C wrapper is stated for `SelfAdjointOperatorNormTailEvent (randomMatrixSum A) t`.
   The sample-covariance deviation route first rewrites
   `centeredRandomMatrix P (sampleCovariance A)` as the normalized centered
   row-rank-one sum
   `normalizedCenteredSampleCovarianceRowRankOneSum (P := P) A`.

2. For the positive centered row-rank-one family
   `centeredSampleCovarianceRowRankOneFamily (P := P) A`, S0-S5 already
   discharge:
   - centered self-adjoint family structure;
   - ordinary summand integrability from coordinate `MemLp ... 2`;
   - the pointwise operator-norm bound
     `sampleCovarianceCenteredRankOneRadius R = 2 * R`.

   The square integrability, matrix-exponential integrability, trace-exponential
   integrability, variance-proxy bound, Tropp primitive, and Bernstein CFC
   primitive remain explicit.

3. The RM-S7C application still needs explicit assumptions for both signs:
   - independence for the positive family;
   - square/exponential/trace integrability for the positive family;
   - variance-proxy norm bound for the positive family;
   - CFC and Tropp primitives for the positive family;
   - centeredness, independence, integrability, operator-norm bound,
     variance-proxy norm bound, CFC, and Tropp assumptions for the pointwise
     negated family;
   - the explicit operator bridge
     `selfAdjointOperatorNormTailViaQuadraticFormStatement` for the unnormalized
     centered row-rank-one sum.

4. A sample covariance operator-norm tail theorem is not a public thin wrapper
   yet. RM-S7C can be instantiated on the unnormalized centered row-rank-one
   summand family, but the public event target is the normalized centered sample
   covariance deviation. There is no named event bridge transporting
   `SelfAdjointOperatorNormTailEvent (centeredRandomMatrix P (sampleCovariance A)) t`
   to the unnormalized event at threshold `(m : Real) * t`.

5. The first missing bridge is:

   ```lean
   theorem sampleCovariance_selfAdjointOperatorNormTailEvent_subset_centeredRowRankOneSum
       {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
       {m n : Nat}
       (A : RandomMatrix Omega m (n + 1)) (t : Real)
       (hm : 0 < m)
       (hInt : forall k : Fin m,
         IntegrableRandomMatrix P (rankOneRandomMatrix (rowVector A k))) :
       SelfAdjointOperatorNormTailEvent
           (centeredRandomMatrix P (sampleCovariance A)) t <=
         SelfAdjointOperatorNormTailEvent
           (centeredSampleCovarianceRowRankOneSum (P := P) A)
           ((m : Real) * t) := by
     ...
   ```

   This should reuse
   `sampleCovariance_deviation_eq_normalized_centered_rowRankOne_sum`, the
   definition of `normalizedCenteredSampleCovarianceRowRankOneSum`, and the
   existing Mathlib L2 operator-norm scalar multiplication lemma exposed through
   `operatorNorm`.

## APIs Reused

- `centeredRandomMatrix`
- `sampleCovariance`
- `centeredSampleCovarianceRowRankOneFamily`
- `centeredSampleCovarianceRowRankOneSum`
- `normalizedCenteredSampleCovarianceRowRankOneSum`
- `sampleCovariance_deviation_eq_normalized_centered_rowRankOne_sum`
- `centeredRankOneRandomMatrix_centeredSelfAdjoint_of_memLp_two`
- `centeredRankOneRandomMatrix_integrable_of_memLp_two`
- `PointwiseOperatorNormBound_centeredRankOneRandomMatrix_of_sqNorm_bound`
- `sampleCovarianceCenteredRankOneRadius`
- `sampleCovarianceTailTheta`
- `sampleCovarianceQuadraticFormTailRHS`
- `sampleCovariance_quadraticForm_tail_optimized_under_explicit_variance_proxy`
- `matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives`
- `SelfAdjointOperatorNormTailEvent`
- `selfAdjointOperatorNormTailViaQuadraticFormStatement`
- `twoSidedQuadraticFormTailEvent`

## Non-Goals

This contract does not prove variance-proxy control, Tropp/Lieb, Bernstein CFC,
Golden-Thompson, finite-net reduction, full Matrix Bernstein, or a CFC-free
sample-covariance concentration theorem.

## FSM State Log

`QUEUED -> EXTRACTING -> EXTRACTED -> REUSE_SOURCE_VALIDATING -> TRANSLATING -> TRANSLATED -> COMPILING -> COMPILED -> REVIEWING -> APPROVED -> VERIFYING -> VERIFIED -> INTEGRATING`

## Next Safe Task

Prove the sample-covariance operator-norm normalization event bridge from
`centeredRandomMatrix P (sampleCovariance A)` to the unnormalized centered
row-rank-one sum at threshold `(m : Real) * t`.
