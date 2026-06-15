# RM-S7D Final Report

Status: `DONE_WITH_CONCERNS`

Classification:

`SAMPLE_COVARIANCE_OPERATOR_NORM_EVENT_BRIDGE_REQUIRED`

## Working Directory

`pwd`:

```text
C:\Users\11388\reserach\HighDimProb
```

Final `git status --short`:

```text
 M HighDimProb/RandomMatrix/ConcentrationStatements.lean
 M HighDimProb/RandomMatrix/Spectral.lean
 M HighDimProbJudge/RandomMatrix/MatrixBernsteinUse.lean
 M HighDimProbJudge/RandomMatrix/SpectralUse.lean
 M HighDimProbJudge/RandomMatrix/StatementUse.lean
 M HighDimProbTest/RandomMatrixConcentrationAPI.lean
 M HighDimProbTest/RandomMatrixSpectralAPI.lean
 M docs/Status.md
 M docs/TermMap.md
 M docs/TestPlan.md
 M docs/visualizations/lake_import_graph.html
```

## Contract Result

`centeredRandomMatrix P (sampleCovariance A)` does not feed directly into
`matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives`.
RM-S7C is stated for
`SelfAdjointOperatorNormTailEvent (randomMatrixSum A) t`; the sample-covariance
route first rewrites the public target as
`normalizedCenteredSampleCovarianceRowRankOneSum (P := P) A`.

S0-S5 already discharge the positive centered row-rank-one family facts:

- `CenteredSelfAdjointRandomMatrixFamily P (centeredSampleCovarianceRowRankOneFamily (P := P) A)`;
- `forall k, IntegrableRandomMatrix P ((centeredSampleCovarianceRowRankOneFamily (P := P) A) k)`;
- `PointwiseOperatorNormBound (centeredSampleCovarianceRowRankOneFamily (P := P) A) (sampleCovarianceCenteredRankOneRadius R)`.

The missing first bridge is the normalization event bridge from the public
centered sample-covariance operator-norm event to the unnormalized centered
row-rank-one sum event at threshold `(m : Real) * t`.

## Candidate Next Theorem

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
`sampleCovariance_deviation_eq_normalized_centered_rowRankOne_sum`,
`normalizedCenteredSampleCovarianceRowRankOneSum`, `operatorNorm`, and the
Mathlib scalar norm rewrite available through the underlying L2 operator norm.

## Explicit Assumptions Still Needed

- positive-sign independence;
- positive-sign square, matrix-exponential, and trace-exponential integrability;
- positive-sign `MatrixVarianceProxyNormBound`;
- positive-sign Bernstein CFC and Tropp primitives;
- negated-family centeredness, self-adjointness, independence, integrability,
  operator-norm bound, variance proxy, Bernstein CFC, and Tropp primitives;
- `selfAdjointOperatorNormTailViaQuadraticFormStatement` for the unnormalized
  centered row-rank-one sum;
- the new sample-covariance normalization event bridge above.

## APIs Reused

`centeredRandomMatrix`, `sampleCovariance`,
`centeredSampleCovarianceRowRankOneFamily`,
`centeredSampleCovarianceRowRankOneSum`,
`normalizedCenteredSampleCovarianceRowRankOneSum`,
`sampleCovariance_deviation_eq_normalized_centered_rowRankOne_sum`,
`centeredRankOneRandomMatrix_centeredSelfAdjoint_of_memLp_two`,
`centeredRankOneRandomMatrix_integrable_of_memLp_two`,
`PointwiseOperatorNormBound_centeredRankOneRandomMatrix_of_sqNorm_bound`,
`sampleCovarianceCenteredRankOneRadius`, `sampleCovarianceTailTheta`,
`sampleCovarianceQuadraticFormTailRHS`,
`sampleCovariance_quadraticForm_tail_optimized_under_explicit_variance_proxy`,
`SelfAdjointOperatorNormTailEvent`, `twoSidedQuadraticFormTailEvent`,
`selfAdjointOperatorNormTailViaQuadraticFormStatement`,
`matrixBernsteinTwoSidedQuadraticFormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives`,
and
`matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives`.

## Docs Updated

- `docs/Status.md`
- `docs/TermMap.md`
- `docs/TestPlan.md`

## Validation Artifacts

- `external/validation/rm-s7d-sample-covariance-operator-norm-tail-wrapper-contract/READ_ONCE_MANIFEST.md`
- `external/validation/rm-s7d-sample-covariance-operator-norm-tail-wrapper-contract/RM_S7D_SampleCovarianceOperatorNormTailProbe.lean`
- `external/validation/rm-s7d-sample-covariance-operator-norm-tail-wrapper-contract/SAMPLE_COVARIANCE_OPERATOR_NORM_TAIL_CONTRACT.md`
- `external/validation/rm-s7d-sample-covariance-operator-norm-tail-wrapper-contract/final_report.md`

## FSM State Log

`QUEUED -> EXTRACTING -> EXTRACTED -> REUSE_SOURCE_VALIDATING -> TRANSLATING -> TRANSLATED -> COMPILING -> COMPILED -> REVIEWING -> APPROVED -> VERIFYING -> VERIFIED -> INTEGRATING`

## Command Status

- `lake env lean external/validation/rm-s7d-sample-covariance-operator-norm-tail-wrapper-contract/RM_S7D_SampleCovarianceOperatorNormTailProbe.lean`: exit 0.
- `lake build HighDimProb.RandomMatrix.ConcentrationStatements`: exit 0.
- `lake env lean HighDimProbTest/RandomMatrixConcentrationAPI.lean`: exit 0.
- `lake env lean HighDimProbJudge/RandomMatrix/MatrixBernsteinUse.lean`: exit 0.
- `lake env lean HighDimProbJudge/RandomMatrix/SpectralUse.lean`: exit 0.
- `lake build`: exit 0.
- `lake test`: exit 0.
- `lake build HighDimProbJudge`: exit 0.
- `python scripts/judge_policy_check.py`: exit 0.
- `git diff --check`: exit 0; emitted the pre-existing warning that
  `docs/visualizations/lake_import_graph.html` will have CRLF replaced by LF
  when Git touches it.
- `rg "sorry|admit|axiom|unsafe" HighDimProb HighDimProbTest HighDimProbJudge`: exit 1, no matches.
- `rg ":= True" HighDimProb HighDimProbTest HighDimProbJudge docs`: exit 1, no matches.

## Unrelated Dirty Files Preserved

- `HighDimProb/RandomMatrix/ConcentrationStatements.lean`
- `HighDimProb/RandomMatrix/Spectral.lean`
- `HighDimProbJudge/RandomMatrix/MatrixBernsteinUse.lean`
- `HighDimProbJudge/RandomMatrix/SpectralUse.lean`
- `HighDimProbJudge/RandomMatrix/StatementUse.lean`
- `HighDimProbTest/RandomMatrixConcentrationAPI.lean`
- `HighDimProbTest/RandomMatrixSpectralAPI.lean`
- `docs/visualizations/lake_import_graph.html`

The three required docs were already dirty when RM-S7D started and were updated
in place for this contract.

## Next Safe Task

Prove `sampleCovariance_selfAdjointOperatorNormTailEvent_subset_centeredRowRankOneSum`.
