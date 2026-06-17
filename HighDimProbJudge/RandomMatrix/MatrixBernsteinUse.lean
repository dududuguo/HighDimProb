import HighDimProb.RandomMatrix

open MeasureTheory
open HighDimProb

#check HighDimProb.matrixBernsteinStatement
#check HighDimProb.matrixBernsteinSelfAdjointStatement
#check HighDimProb.matrixBernsteinLaplacePrerequisitesStatement
#check HighDimProb.matrixBernsteinTraceMGF_statement
#check HighDimProb.matrixBernsteinTraceMGFWithBernsteinCoeff_statement
#check HighDimProb.matrixBernsteinTraceMGFWithBernsteinCoeff_of_troppMasterTraceMGFFiniteFamily
#check HighDimProb.matrixBernsteinTraceMGFWithBernsteinCoeff_under_primitives
#check HighDimProb.matrixBernsteinTraceMGFToLaplaceContract_statement
#check HighDimProb.matrixBernsteinTraceMGFToLaplaceContract_under_primitives_statement
#check HighDimProb.matrixBernsteinQuadraticFormUpperTailWithBernsteinCoeff_under_primitives
#check HighDimProb.traceMatrixExp_bernsteinMGFCoeff_matrixVarianceProxy_le_card_exp
#check HighDimProb.matrixBernsteinQuadraticFormUpperTailScalarRHSWithBernsteinCoeff_under_primitives
#check HighDimProb.matrixBernsteinQuadraticFormUpperTailScalarExpRHSWithBernsteinCoeff_under_primitives
#check HighDimProb.matrixBernsteinQuadraticFormUpperTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives
#check HighDimProb.matrixBernsteinTwoSidedQuadraticFormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives
#check HighDimProb.matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_under_primitives
#check HighDimProb.matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_nonempty_under_primitives
#check HighDimProb.matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_arbitrary_of_pos_under_primitives
#check HighDimProb.MatrixBernsteinPositiveSideAssumptions
#check HighDimProb.MatrixBernsteinNegativeSideAssumptions
#check HighDimProb.matrixBernsteinTwoSidedQuadraticFormTailOptimizedScalarRHSWithBernsteinCoeff_of_assumptions
#check HighDimProb.matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_arbitrary_of_assumptions
#check HighDimProb.sampleCovarianceCenteredRankOneRadius
#check HighDimProb.sampleCovarianceCenteredRankOneVarianceProxyBound
#check HighDimProb.sampleCovarianceCenteredRankOneVarianceProxyBound_pos
#check HighDimProb.sampleCovarianceCenteredRankOneVarianceProxyBoundOfRows
#check HighDimProb.sampleCovarianceCenteredRankOneVarianceProxyBoundOfRows_pos
#check HighDimProb.MatrixVarianceProxyNormBound_centeredSampleCovarianceRowRankOneFamily_of_rowSqNorm_bound
#check HighDimProb.sampleCovarianceTailTheta
#check HighDimProb.sampleCovarianceTailThetaOfRows
#check HighDimProb.sampleCovarianceQuadraticFormTailRHS
#check HighDimProb.sampleCovariance_quadraticForm_tail_optimized_under_explicit_variance_proxy
#check HighDimProb.sampleCovariance_quadraticForm_tail_optimized_under_rowSqNorm_bound
#check HighDimProb.sampleCovariance_selfAdjointOperatorNormTailEvent_subset_centeredRowRankOneSum
#check HighDimProb.sampleCovariance_selfAdjointOperatorNorm_tail_optimized_under_explicit_variance_proxy
#check HighDimProb.sampleCovariance_selfAdjointOperatorNorm_tail_optimized_nonempty_under_explicit_variance_proxy
#check HighDimProb.sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_explicit_variance_proxy
#check HighDimProb.sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound
#check HighDimProb.sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound_with_neg_adapters
#check HighDimProb.sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_rowSqNorm_bound_with_neg_square_adapters
#check HighDimProb.negRandomMatrixFamily
#check HighDimProb.matrixExpScaledFamily_negRandomMatrixFamily
#check HighDimProb.integrableRandomMatrix_matrixExpScaledFamily_negRandomMatrixFamily
#check HighDimProb.randomMatrixSum_negRandomMatrixFamily
#check HighDimProb.traceExpIntegrand_randomMatrixSum_negRandomMatrixFamily
#check HighDimProb.integrableRealRandomVariable_traceExpIntegrand_randomMatrixSum_negRandomMatrixFamily
#check HighDimProb.matrixSecondMoment_negRandomMatrixFamily
#check HighDimProb.matrixVarianceProxy_negRandomMatrixFamily
#check HighDimProb.bernsteinSecondMomentComparisonFamily_negRandomMatrixFamily
#check HighDimProb.bernsteinMGFComparison_negRandomMatrixFamily
#check HighDimProb.traceMGFBernsteinVarianceProxyBound_negRandomMatrixFamily
#check HighDimProb.matrixBernsteinTraceMGFWithBernsteinCoeff_negRandomMatrixFamily
#check HighDimProb.centeredSampleCovarianceRowRankOneFamilyNeg
#check HighDimProb.centeredSampleCovarianceRowRankOneSumNeg
#check HighDimProb.isRandomMatrix_negRandomMatrixFamily
#check HighDimProb.integrableRandomMatrix_negRandomMatrixFamily
#check HighDimProb.selfAdjointRandomMatrixFamily_negRandomMatrixFamily
#check HighDimProb.centeredSelfAdjointRandomMatrixFamily_negRandomMatrixFamily
#check HighDimProb.independentRandomMatrices_negRandomMatrixFamily
#check HighDimProb.independentSelfAdjointRandomMatrices_negRandomMatrixFamily
#check HighDimProb.PointwiseOperatorNormBound_negRandomMatrixFamily
#check HighDimProb.randomMatrixSquare_negRandomMatrixFamily
#check HighDimProb.integrableRandomMatrix_randomMatrixSquare_negRandomMatrixFamily
#check HighDimProb.centeredSampleCovarianceRowRankOneFamilyNeg_integrable_of_memLp_two
#check HighDimProb.centeredSampleCovarianceRowRankOneFamilyNeg_centeredSelfAdjoint_of_memLp_two
#check HighDimProb.PointwiseOperatorNormBound_centeredSampleCovarianceRowRankOneFamilyNeg_of_rowSqNorm_bound
#check HighDimProb.centeredSampleCovarianceRowRankOneFamilyNeg_squareIntegrable_of_squareIntegrable
#check HighDimProb.centeredSampleCovarianceRowRankOneFamilyNeg_expIntegrable_of_expIntegrable_neg_theta
#check HighDimProb.centeredSampleCovarianceRowRankOneSumNeg_traceExpIntegrable_of_traceExpIntegrable_neg_theta
#check HighDimProb.centeredSampleCovarianceRowRankOneFamilyNeg_cfcPrimitive_of_cfcPrimitive_neg_theta
#check HighDimProb.matrixVarianceProxyNorm
#check HighDimProb.PointwiseOperatorNormBound
#check HighDimProb.IndependentSelfAdjointRandomMatrices
#check HighDimProb.CenteredSelfAdjointRandomMatrixFamily
#check HighDimProb.isPSD_matrixVarianceProxy_of_selfAdjoint
#check HighDimProb.matrixLaplaceTransformStatement
#check HighDimProb.matrixLaplaceTransformLIntegralStatement
#check HighDimProb.selfAdjointOperatorNormLaplaceStatement
#check HighDimProb.selfAdjointOperatorNormLaplaceLIntegralStatement

example {Omega I : Type*} [MeasurableSpace Omega] [Fintype I]
    {n : Nat} (P : MeasureTheory.Measure Omega)
    [MeasureTheory.IsProbabilityMeasure P]
    (A : I -> HighDimProb.RandomMatrix Omega n n)
    (sigma2 R c1 c2 t : Real) : Prop :=
  HighDimProb.matrixBernsteinSelfAdjointStatement P A sigma2 R c1 c2 t

example {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : MeasureTheory.Measure Omega)
    (Y : HighDimProb.RandomMatrix Omega n n) (theta t : Real) : Prop :=
  HighDimProb.matrixBernsteinLaplacePrerequisitesStatement P Y theta t

example {Omega I : Type*} [MeasurableSpace Omega] [Fintype I]
    {n : Nat} (P : MeasureTheory.Measure Omega)
    (A : I -> HighDimProb.RandomMatrix Omega n n)
    (theta : Real) : Prop :=
  HighDimProb.matrixBernsteinTraceMGF_statement P A theta

example {Omega I : Type*} [MeasurableSpace Omega] [Fintype I]
    {n : Nat} (P : MeasureTheory.Measure Omega)
    (A : I -> HighDimProb.RandomMatrix Omega n n)
    (theta R : Real) : Prop :=
  HighDimProb.matrixBernsteinTraceMGFWithBernsteinCoeff_statement P A theta R

example {Omega I : Type*} [MeasurableSpace Omega] [Fintype I]
    {n : Nat} (P : MeasureTheory.Measure Omega)
    [MeasureTheory.IsProbabilityMeasure P]
    (A : I -> HighDimProb.RandomMatrix Omega n n)
    (theta t R : Real) : Prop :=
  HighDimProb.matrixBernsteinTraceMGFToLaplaceContract_statement P A theta t R

example {Omega I : Type*} [MeasurableSpace Omega] [Fintype I]
    {n : Nat} (P : MeasureTheory.Measure Omega)
    [MeasureTheory.IsProbabilityMeasure P]
    (A : I -> HighDimProb.RandomMatrix Omega n n)
    (theta t R : Real) : Prop :=
  HighDimProb.matrixBernsteinTraceMGFToLaplaceContract_under_primitives_statement P A theta t R

section NonemptyMatrixBernsteinOperatorNormUse

variable {Omega I : Type*} [MeasurableSpace Omega] [Fintype I]
variable {P : Measure Omega} [IsProbabilityMeasure P]
variable {n : Nat}
variable (A : I -> RandomMatrix Omega (n + 1) (n + 1))
variable (R Rneg t sigmaSq sigmaSqNeg : Real)
variable
  (hCentered : CenteredSelfAdjointRandomMatrixFamily P A)
  (hIndepSA : IndependentSelfAdjointRandomMatrices P A)
  (hIntX : forall i, IntegrableRandomMatrix P (A i))
  (hIntSq : forall i, IntegrableRandomMatrix P (randomMatrixSquare (A i)))
  (hExpInt :
    forall i,
      IntegrableRandomMatrix P
        (matrixExpScaledFamily A (bernsteinThetaChoice t sigmaSq R) i))
  (hTraceInt :
    IntegrableRealRandomVariable P
      (traceExpIntegrand (randomMatrixSum A)
        (bernsteinThetaChoice t sigmaSq R)))
  (hBound : PointwiseOperatorNormBound A R)
  (hSigma : 0 < sigmaSq)
  (hR : 0 <= R)
  (ht : 0 < t)
  (hNorm : MatrixVarianceProxyNormBound P A sigmaSq)
  (hCFC :
    forall i omega,
      bernsteinMatrixExp_le_quadratic_statement (A i omega)
        (bernsteinThetaChoice t sigmaSq R) R)
  (hTropp :
    troppMasterTraceMGFFiniteFamily_statement
      (P := P) A
      (bernsteinSecondMomentComparisonFamily P A
        (bernsteinThetaChoice t sigmaSq R) R)
      (matrixVarianceProxy P A) (bernsteinThetaChoice t sigmaSq R) R)
  (hCenteredNeg :
    CenteredSelfAdjointRandomMatrixFamily P
      (negRandomMatrixFamily A))
  (hIndepSANeg :
    IndependentSelfAdjointRandomMatrices P
      (negRandomMatrixFamily A))
  (hIntXNeg :
    forall i,
      IntegrableRandomMatrix P
        ((negRandomMatrixFamily A) i))
  (hIntSqNeg :
    forall i,
      IntegrableRandomMatrix P
        (randomMatrixSquare
          ((negRandomMatrixFamily A) i)))
  (hExpIntNeg :
    forall i,
      IntegrableRandomMatrix P
        (matrixExpScaledFamily
          (negRandomMatrixFamily A)
          (bernsteinThetaChoice t sigmaSqNeg Rneg) i))
  (hTraceIntNeg :
    IntegrableRealRandomVariable P
      (traceExpIntegrand
        (randomMatrixSum
          (negRandomMatrixFamily A))
        (bernsteinThetaChoice t sigmaSqNeg Rneg)))
  (hBoundNeg :
    PointwiseOperatorNormBound
      (negRandomMatrixFamily A) Rneg)
  (hSigmaNeg : 0 < sigmaSqNeg)
  (hRNeg : 0 <= Rneg)
  (hNormNeg :
    MatrixVarianceProxyNormBound P
      (negRandomMatrixFamily A) sigmaSqNeg)
  (hCFCNeg :
    forall i omega,
      bernsteinMatrixExp_le_quadratic_statement
        ((negRandomMatrixFamily A) i omega)
        (bernsteinThetaChoice t sigmaSqNeg Rneg) Rneg)
  (hTroppNeg :
    troppMasterTraceMGFFiniteFamily_statement
      (P := P) (negRandomMatrixFamily A)
      (bernsteinSecondMomentComparisonFamily P
        (negRandomMatrixFamily A)
        (bernsteinThetaChoice t sigmaSqNeg Rneg) Rneg)
      (matrixVarianceProxy P
        (negRandomMatrixFamily A))
      (bernsteinThetaChoice t sigmaSqNeg Rneg) Rneg)

example :
    P (SelfAdjointOperatorNormTailEvent (randomMatrixSum A) t) <=
      matrixBernsteinTwoSidedOptimizedScalarTailRHS
        (n + 1) R Rneg t sigmaSq sigmaSqNeg := by
  simpa [matrixBernsteinTwoSidedOptimizedScalarTailRHS,
    matrixBernsteinOptimizedScalarTailRHS, Nat.cast_add, Nat.cast_one] using
    (matrixBernsteinSelfAdjointOperatorNormTailOptimizedScalarRHSWithBernsteinCoeff_nonempty_under_primitives
      (P := P) (A := A) (R := R) (Rneg := Rneg) (t := t)
      (sigmaSq := sigmaSq) (sigmaSqNeg := sigmaSqNeg)
      hCentered hIndepSA hIntX hIntSq hExpInt hTraceInt hBound
      hSigma hR ht hNorm hCFC hTropp hCenteredNeg hIndepSANeg
      hIntXNeg hIntSqNeg hExpIntNeg hTraceIntNeg hBoundNeg hSigmaNeg
      hRNeg hNormNeg hCFCNeg hTroppNeg)

end NonemptyMatrixBernsteinOperatorNormUse

section NonemptySampleCovarianceOperatorNormUse

variable {Omega : Type*} [MeasurableSpace Omega]
variable {P : Measure Omega} [IsProbabilityMeasure P]
variable {m n : Nat}
variable (A : RandomMatrix Omega m (n + 1))
variable (R Rneg t sigmaSq sigmaSqNeg : Real)
variable
  (hm : 0 < m)
  (hMeas : IsRandomMatrix P A)
  (hLp :
    forall k : Fin m, forall j : Fin (n + 1),
      MemLpRealRandomVariable P (matrixEntry A k j) 2)
  (hSq :
    forall k : Fin m, forall omega,
      vectorSqNorm (rowVector A k omega) <= R)
  (hIndep :
    IndependentRandomMatrices P
      (centeredSampleCovarianceRowRankOneFamily (P := P) A))
  (hIntSq :
    forall k : Fin m,
      IntegrableRandomMatrix P
        (randomMatrixSquare
          ((centeredSampleCovarianceRowRankOneFamily (P := P) A) k)))
  (hExpInt :
    forall k : Fin m,
      IntegrableRandomMatrix P
        (matrixExpScaledFamily
          (centeredSampleCovarianceRowRankOneFamily (P := P) A)
          (sampleCovarianceTailTheta (m := m) R t sigmaSq)
          k))
  (hTraceInt :
    IntegrableRealRandomVariable P
      (traceExpIntegrand
        (centeredSampleCovarianceRowRankOneSum (P := P) A)
        (sampleCovarianceTailTheta (m := m) R t sigmaSq)))
  (hSigma : 0 < sigmaSq)
  (hR : 0 <= R)
  (ht : 0 < t)
  (hNorm :
    MatrixVarianceProxyNormBound P
      (centeredSampleCovarianceRowRankOneFamily (P := P) A) sigmaSq)
  (hCFC :
    forall k : Fin m, forall omega,
      bernsteinMatrixExp_le_quadratic_statement
        ((centeredSampleCovarianceRowRankOneFamily (P := P) A) k omega)
        (sampleCovarianceTailTheta (m := m) R t sigmaSq)
        (sampleCovarianceCenteredRankOneRadius R))
  (hTropp :
    troppMasterTraceMGFFiniteFamily_statement
      (P := P)
      (centeredSampleCovarianceRowRankOneFamily (P := P) A)
      (bernsteinSecondMomentComparisonFamily P
        (centeredSampleCovarianceRowRankOneFamily (P := P) A)
        (sampleCovarianceTailTheta (m := m) R t sigmaSq)
        (sampleCovarianceCenteredRankOneRadius R))
      (matrixVarianceProxy P
        (centeredSampleCovarianceRowRankOneFamily (P := P) A))
      (sampleCovarianceTailTheta (m := m) R t sigmaSq)
      (sampleCovarianceCenteredRankOneRadius R))
  (hCenteredNeg :
    CenteredSelfAdjointRandomMatrixFamily P
      (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A))
  (hIndepSANeg :
    IndependentSelfAdjointRandomMatrices P
      (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A))
  (hIntXNeg :
    forall k : Fin m,
      IntegrableRandomMatrix P
        ((centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A) k))
  (hIntSqNeg :
    forall k : Fin m,
      IntegrableRandomMatrix P
        (randomMatrixSquare
          ((centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A) k)))
  (hExpIntNeg :
    forall k : Fin m,
      IntegrableRandomMatrix P
        (matrixExpScaledFamily
          (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
          (sampleCovarianceTailTheta (m := m) Rneg t sigmaSqNeg)
          k))
  (hTraceIntNeg :
    IntegrableRealRandomVariable P
      (traceExpIntegrand
        (centeredSampleCovarianceRowRankOneSumNeg (P := P) A)
        (sampleCovarianceTailTheta (m := m) Rneg t sigmaSqNeg)))
  (hBoundNeg :
    PointwiseOperatorNormBound
      (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
      (sampleCovarianceCenteredRankOneRadius Rneg))
  (hSigmaNeg : 0 < sigmaSqNeg)
  (hRNeg : 0 <= Rneg)
  (hNormNeg :
    MatrixVarianceProxyNormBound P
      (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
      sigmaSqNeg)
  (hCFCNeg :
    forall k : Fin m, forall omega,
      bernsteinMatrixExp_le_quadratic_statement
        ((centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
          k omega)
        (sampleCovarianceTailTheta (m := m) Rneg t sigmaSqNeg)
        (sampleCovarianceCenteredRankOneRadius Rneg))
  (hTroppNeg :
    troppMasterTraceMGFFiniteFamily_statement
      (P := P)
      (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
      (bernsteinSecondMomentComparisonFamily P
        (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A)
        (sampleCovarianceTailTheta (m := m) Rneg t sigmaSqNeg)
        (sampleCovarianceCenteredRankOneRadius Rneg))
      (matrixVarianceProxy P
        (centeredSampleCovarianceRowRankOneFamilyNeg (P := P) A))
      (sampleCovarianceTailTheta (m := m) Rneg t sigmaSqNeg)
      (sampleCovarianceCenteredRankOneRadius Rneg))

example :
    P (SelfAdjointOperatorNormTailEvent
        (centeredRandomMatrix P (sampleCovariance A)) t) <=
      sampleCovarianceQuadraticFormTailRHS
          (m := m) (n := n + 1) R t sigmaSq +
        sampleCovarianceQuadraticFormTailRHS
          (m := m) (n := n + 1) Rneg t sigmaSqNeg := by
  exact
    sampleCovariance_selfAdjointOperatorNorm_tail_optimized_arbitrary_of_pos_under_explicit_variance_proxy
      (P := P) (A := A) (R := R) (Rneg := Rneg) (t := t)
      (sigmaSq := sigmaSq) (sigmaSqNeg := sigmaSqNeg)
      hm hMeas hLp hSq hIndep hIntSq hExpInt hTraceInt hSigma hR ht
      hNorm hCFC hTropp hCenteredNeg hIndepSANeg hIntXNeg hIntSqNeg
      hExpIntNeg hTraceIntNeg hBoundNeg hSigmaNeg hRNeg hNormNeg
      hCFCNeg hTroppNeg

end NonemptySampleCovarianceOperatorNormUse
