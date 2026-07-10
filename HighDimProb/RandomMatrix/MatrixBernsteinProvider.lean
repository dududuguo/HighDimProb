import HighDimProb.RandomMatrix.ConditioningBernsteinTraceExpProvider

/-!
# Bernstein operator-norm tail composition

This module packages the generated-history Bernstein primitives into the
existing optimized self-adjoint operator-norm consumer from HighDimProb.
-/

namespace HighDimProb

open HighDimProb
open MeasureTheory
open scoped ProbabilityTheory MatrixOrder Matrix.Norms.L2Operator

noncomputable section

/-- Generated-history composition leaf for the existing optimized self-adjoint
operator-norm Matrix Bernstein consumer.

This theorem constructs the positive- and negative-side Tropp bundles directly
from the usual bounded centered self-adjoint Bernstein primitives, then reuses
`HighDimProb.matrixBernsteinOpNormTail_opt_of_tropp`. -/
theorem matrixBernsteinSelfAdjointOperatorNormTailOptimized_generatedHistory_of_bernsteinPrimitives
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {m n : Nat}
    [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    (X : Fin m -> RandomMatrix Omega n n)
    (R t sigmaSq : Real)
    (hCentered : CenteredSelfAdjointRandomMatrixFamily P X)
    (hIndepSA : IndependentSelfAdjointRandomMatrices P X)
    (hIntX : forall j, IntegrableRandomMatrix P (X j))
    (hIntSq : forall j, IntegrableRandomMatrix P (randomMatrixSquare (X j)))
    (hBound : PointwiseOperatorNormBound X R)
    (hR : 0 <= R)
    (hSigma : 0 < sigmaSq)
    (ht : 0 < t)
    (hNorm : MatrixVarianceProxyNormBound P X sigmaSq) :
    P (SelfAdjointOperatorNormTailEvent (randomMatrixSum X) t) <=
      matrixBernsteinTwoSidedOptimizedScalarTailRHS n R R t sigmaSq sigmaSq := by
  have hX : forall j, IsRandomMatrix P (X j) := hCentered.1.1
  have hIndep : ProbabilityTheory.iIndepFun X P := hIndepSA.2
  have hRange :
      abs (bernsteinThetaChoice t sigmaSq R) * R < 3 :=
    bernsteinThetaChoice_range hSigma hR ht.le
  have hExpInt :
      forall i,
        IntegrableRandomMatrix P
          (matrixExpScaledFamily X (bernsteinThetaChoice t sigmaSq R) i) := by
    have h :=
      matrixExpScaledIntegrable_of_provider_finiteMeasure
        (bernsteinThetaChoice t sigmaSq R) R X hX hR
        (fun j omega => hBound j omega)
    simpa [matrixExpScaledFamily] using h
  have hTraceInt :
      IntegrableRealRandomVariable P
        (traceExpIntegrand (randomMatrixSum X)
          (bernsteinThetaChoice t sigmaSq R)) :=
    traceExpIntegrable_randomMatrixSum_of_operatorNormBounds_finiteMeasure
      (bernsteinThetaChoice t sigmaSq R) R X hX hR
      (fun j omega => hBound j omega)
  have hTropp :
      HighDimProb.troppMasterTraceMGFFiniteFamily_statement (P := P) X
        (bernsteinSecondMomentComparisonFamily P X
          (bernsteinThetaChoice t sigmaSq R) R)
        (matrixVarianceProxy P X)
        (bernsteinThetaChoice t sigmaSq R) R :=
    troppMasterTraceMGFFiniteFamily_generatedHistory_of_bernsteinPrimitives
      (mOmega := mOmega) (P := P) (bernsteinThetaChoice t sigmaSq R) R X
      (matrixVarianceProxy P X) hCentered hIntX hIntSq hBound hR hRange hIndep
  have hCenteredNeg :
      CenteredSelfAdjointRandomMatrixFamily P (negRandomMatrixFamily X) :=
    centeredSelfAdjointRandomMatrixFamily_negRandomMatrixFamily
      (P := P) (A := X) hCentered
  have hIndepSANeg :
      IndependentSelfAdjointRandomMatrices P (negRandomMatrixFamily X) :=
    independentSelfAdjointRandomMatrices_negRandomMatrixFamily
      (P := P) (A := X) hIndepSA
  have hIntXNeg :
      forall j, IntegrableRandomMatrix P ((negRandomMatrixFamily X) j) :=
    integrableRandomMatrix_negRandomMatrixFamily (P := P) (A := X) hIntX
  have hIntSqNeg :
      forall j,
        IntegrableRandomMatrix P
          (randomMatrixSquare ((negRandomMatrixFamily X) j)) :=
    integrableRandomMatrix_randomMatrixSquare_negRandomMatrixFamily
      (P := P) (A := X) hIntSq
  have hBoundNeg :
      PointwiseOperatorNormBound (negRandomMatrixFamily X) R :=
    PointwiseOperatorNormBound_negRandomMatrixFamily (A := X) hBound
  have hExpIntNegTheta :
      forall i,
        IntegrableRandomMatrix P
          (matrixExpScaledFamily X (-(bernsteinThetaChoice t sigmaSq R)) i) := by
    have h :=
      matrixExpScaledIntegrable_of_provider_finiteMeasure
        (-(bernsteinThetaChoice t sigmaSq R)) R X hX hR
        (fun j omega => hBound j omega)
    intro i
    change IntegrableRandomMatrix P
      (fun omega =>
        matrixExp ((-(bernsteinThetaChoice t sigmaSq R)) • X i omega))
    have hEq :
        (fun omega =>
          matrixExp ((-(bernsteinThetaChoice t sigmaSq R)) • X i omega)) =
        fun omega =>
          matrixExp (-(bernsteinThetaChoice t sigmaSq R • X i omega)) := by
      funext omega
      rw [neg_smul]
    rw [hEq]
    simpa [matrixExp] using h i
  have hExpIntNeg :
      forall i,
        IntegrableRandomMatrix P
          (matrixExpScaledFamily (negRandomMatrixFamily X)
            (bernsteinThetaChoice t sigmaSq R) i) :=
    integrableRandomMatrix_matrixExpScaledFamily_negRandomMatrixFamily
      (P := P) (A := X) (theta := bernsteinThetaChoice t sigmaSq R)
      hExpIntNegTheta
  have hTraceIntNegTheta :
      IntegrableRealRandomVariable P
        (traceExpIntegrand (randomMatrixSum X)
          (-(bernsteinThetaChoice t sigmaSq R))) :=
    traceExpIntegrable_randomMatrixSum_of_operatorNormBounds_finiteMeasure
      (-(bernsteinThetaChoice t sigmaSq R)) R X hX hR
      (fun j omega => hBound j omega)
  have hTraceIntNeg :
      IntegrableRealRandomVariable P
        (traceExpIntegrand (randomMatrixSum (negRandomMatrixFamily X))
          (bernsteinThetaChoice t sigmaSq R)) :=
    integrableRealRandomVariable_traceExpIntegrand_randomMatrixSum_negRandomMatrixFamily
      (P := P) (A := X) (theta := bernsteinThetaChoice t sigmaSq R)
      hTraceIntNegTheta
  have hNormNeg :
      MatrixVarianceProxyNormBound P (negRandomMatrixFamily X) sigmaSq := by
    simpa [MatrixVarianceProxyNormBound,
      matrixVarianceProxy_negRandomMatrixFamily (P := P) (A := X)] using hNorm
  have hIndepNeg : ProbabilityTheory.iIndepFun (negRandomMatrixFamily X) P :=
    hIndepSANeg.2
  have hTroppNeg :
      HighDimProb.troppMasterTraceMGFFiniteFamily_statement
        (P := P) (negRandomMatrixFamily X)
        (bernsteinSecondMomentComparisonFamily P (negRandomMatrixFamily X)
          (bernsteinThetaChoice t sigmaSq R) R)
        (matrixVarianceProxy P (negRandomMatrixFamily X))
        (bernsteinThetaChoice t sigmaSq R) R :=
    troppMasterTraceMGFFiniteFamily_generatedHistory_of_bernsteinPrimitives
      (mOmega := mOmega) (P := P) (bernsteinThetaChoice t sigmaSq R) R
      (negRandomMatrixFamily X) (matrixVarianceProxy P (negRandomMatrixFamily X))
      hCenteredNeg hIntXNeg hIntSqNeg hBoundNeg hR hRange hIndepNeg
  let hPos : MatrixBernsteinPositiveSideTroppAssumptions (P := P) X R t sigmaSq :=
    { centered := hCentered
      independentSelfAdjoint := hIndepSA
      integrable := hIntX
      squareIntegrable := hIntSq
      expIntegrable := hExpInt
      traceExpIntegrable := hTraceInt
      operatorNormBound := hBound
      sigmaPositive := hSigma
      radiusNonneg := hR
      deviationPositive := ht
      varianceProxyNormBound := hNorm
      troppPrimitive := hTropp }
  let hNeg : MatrixBernsteinNegativeSideTroppAssumptions (P := P) X R t sigmaSq :=
    { centered := hCenteredNeg
      independentSelfAdjoint := hIndepSANeg
      integrable := hIntXNeg
      squareIntegrable := hIntSqNeg
      expIntegrable := hExpIntNeg
      traceExpIntegrable := hTraceIntNeg
      operatorNormBound := hBoundNeg
      sigmaPositive := hSigma
      radiusNonneg := hR
      varianceProxyNormBound := hNormNeg
      troppPrimitive := hTroppNeg }
  exact
    HighDimProb.matrixBernsteinOpNormTail_opt_of_tropp
      (P := P) X R R t sigmaSq sigmaSq hPos hNeg

/-- Generated-history Matrix Bernstein operator-norm tail for a nonnegative
variance parameter and positive threshold.

The positive-variance branch reuses the generated-history Tropp composition
above. When the variance parameter is zero, the variance proxy and every
self-adjoint summand vanish almost everywhere, so the tail event has measure
zero. -/
theorem matrixBernsteinSelfAdjointOperatorNormTailOptimized_generatedHistory_of_bernsteinPrimitives_of_variance_nonneg
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {m n : Nat}
    [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    (X : Fin m -> RandomMatrix Omega n n)
    (R t sigmaSq : Real)
    (hCentered : CenteredSelfAdjointRandomMatrixFamily P X)
    (hIndepSA : IndependentSelfAdjointRandomMatrices P X)
    (hIntX : forall j, IntegrableRandomMatrix P (X j))
    (hIntSq : forall j, IntegrableRandomMatrix P (randomMatrixSquare (X j)))
    (hBound : PointwiseOperatorNormBound X R)
    (hR : 0 <= R)
    (hSigma : 0 <= sigmaSq)
    (ht : 0 < t)
    (hNorm : MatrixVarianceProxyNormBound P X sigmaSq) :
    P (SelfAdjointOperatorNormTailEvent (randomMatrixSum X) t) <=
      matrixBernsteinTwoSidedOptimizedScalarTailRHS n R R t sigmaSq sigmaSq := by
  by_cases hZero : sigmaSq = 0
  · subst sigmaSq
    have hTailZero :
        upperTailProb P (operatorNorm (randomMatrixSum X)) t = 0 :=
      upperTailProb_operatorNorm_randomMatrixSum_eq_zero_of_varianceNormBound_zero
        hCentered.1.2 hIntSq hNorm ht
    have hEventZero :
        P (SelfAdjointOperatorNormTailEvent (randomMatrixSum X) t) = 0 := by
      simpa [upperTailProb, upperTailEvent, SelfAdjointOperatorNormTailEvent] using
        hTailZero
    rw [hEventZero]
    exact bot_le
  · have hSigmaPos : 0 < sigmaSq :=
      lt_of_le_of_ne hSigma (Ne.symm hZero)
    exact
      matrixBernsteinSelfAdjointOperatorNormTailOptimized_generatedHistory_of_bernsteinPrimitives
        (mOmega := mOmega) (P := P) X R t sigmaSq hCentered hIndepSA
        hIntX hIntSq hBound hR hSigmaPos ht hNorm

/-- Public upper-tail-probability form of the generated-history Matrix
Bernstein operator-norm bound for nonnegative variance and positive threshold. -/
theorem matrixBernsteinSelfAdjointOperatorNormUpperTailOptimized_generatedHistory_of_bernsteinPrimitives_of_variance_nonneg
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {m n : Nat}
    [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    (X : Fin m -> RandomMatrix Omega n n)
    (R t sigmaSq : Real)
    (hCentered : CenteredSelfAdjointRandomMatrixFamily P X)
    (hIndepSA : IndependentSelfAdjointRandomMatrices P X)
    (hIntX : forall j, IntegrableRandomMatrix P (X j))
    (hIntSq : forall j, IntegrableRandomMatrix P (randomMatrixSquare (X j)))
    (hBound : PointwiseOperatorNormBound X R)
    (hR : 0 <= R)
    (hSigma : 0 <= sigmaSq)
    (ht : 0 < t)
    (hNorm : MatrixVarianceProxyNormBound P X sigmaSq) :
    upperTailProb P (operatorNorm (randomMatrixSum X)) t <=
      matrixBernsteinTwoSidedOptimizedScalarTailRHS n R R t sigmaSq sigmaSq := by
  simpa [upperTailProb, upperTailEvent, SelfAdjointOperatorNormTailEvent] using
    matrixBernsteinSelfAdjointOperatorNormTailOptimized_generatedHistory_of_bernsteinPrimitives_of_variance_nonneg
      (mOmega := mOmega) (P := P) X R t sigmaSq hCentered hIndepSA
      hIntX hIntSq hBound hR hSigma ht hNorm

private theorem matrixBernsteinSelfAdjointOptimizedStatement_fin_generatedHistory_of_bernsteinPrimitives
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {m n : Nat}
    [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    (X : Fin m -> RandomMatrix Omega n n)
    (sigmaSq R t : Real) :
    matrixBernsteinSelfAdjointOptimizedStatement
      (P := P) X sigmaSq R t := by
  intro hn hIntX hIntSq hCentered hIndepSA hBound hNorm hSigma hR ht
  rcases eq_or_lt_of_le ht with htZero | htPos
  · subst t
    calc
      upperTailProb P (operatorNorm (randomMatrixSum X)) 0 <= 1 := by
        rw [upperTailProb, ← measure_univ (μ := P)]
        exact measure_mono (Set.subset_univ _)
      _ <= matrixBernsteinTwoSidedOptimizedScalarTailRHS
          n R R 0 sigmaSq sigmaSq :=
        one_le_matrixBernsteinTwoSidedOptimizedScalarTailRHS_zero R sigmaSq hn
  · exact
      matrixBernsteinSelfAdjointOperatorNormUpperTailOptimized_generatedHistory_of_bernsteinPrimitives_of_variance_nonneg
        (mOmega := mOmega) (P := P) X R t sigmaSq hCentered hIndepSA
        hIntX hIntSq hBound hR hSigma htPos hNorm

/-- The generated-history Bernstein primitives prove the canonical optimized
self-adjoint Matrix Bernstein statement for every finite index type, including
the zero-threshold branch.

The conditioning proof is carried out after reindexing the family by
`Fin (Fintype.card I)`. The random-matrix sum and matrix variance proxy are
unchanged by this equivalence. -/
theorem matrixBernsteinSelfAdjointOptimizedStatement_generatedHistory_of_bernsteinPrimitives
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {I : Type*} [Fintype I] {n : Nat}
    [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    (X : I -> RandomMatrix Omega n n)
    (sigmaSq R t : Real) :
    matrixBernsteinSelfAdjointOptimizedStatement
      (P := P) X sigmaSq R t := by
  classical
  intro hn hIntX hIntSq hCentered hIndepSA hBound hNorm hSigma hR ht
  let e : Fin (Fintype.card I) ≃ I := (Fintype.equivFin I).symm
  let XFin : Fin (Fintype.card I) -> RandomMatrix Omega n n :=
    fun j => X (e j)
  have hSumX : randomMatrixSum XFin = randomMatrixSum X := by
    funext omega
    unfold randomMatrixSum
    ext r c
    rw [Matrix.sum_apply, Matrix.sum_apply]
    simpa [XFin, e] using (e.sum_comp (fun i : I => X i omega r c))
  have hIntXFin : forall j, IntegrableRandomMatrix P (XFin j) := by
    intro j
    exact hIntX (e j)
  have hIntSqFin :
      forall j, IntegrableRandomMatrix P (randomMatrixSquare (XFin j)) := by
    intro j
    exact hIntSq (e j)
  have hCenteredFin : CenteredSelfAdjointRandomMatrixFamily P XFin := by
    refine ⟨⟨?_, ?_⟩, ?_⟩
    · intro j
      exact hCentered.1.1 (e j)
    · intro j
      exact hCentered.1.2 (e j)
    · intro j
      exact hCentered.2 (e j)
  have hIndepSAFin : IndependentSelfAdjointRandomMatrices P XFin := by
    refine ⟨⟨?_, ?_⟩, ?_⟩
    · intro j
      exact hIndepSA.1.1 (e j)
    · intro j
      exact hIndepSA.1.2 (e j)
    · simpa [XFin] using hIndepSA.2.precomp e.injective
  have hBoundFin : PointwiseOperatorNormBound XFin R := by
    intro j
    exact hBound (e j)
  have hVariance :
      matrixVarianceProxy P XFin = matrixVarianceProxy P X := by
    simpa [matrixVarianceProxy, XFin, e] using
      (e.sum_comp (fun i : I => matrixSecondMoment P (X i)))
  have hNormFin : MatrixVarianceProxyNormBound P XFin sigmaSq := by
    simpa [MatrixVarianceProxyNormBound, matrixVarianceProxyNorm, hVariance] using
      hNorm
  have hFin :=
    matrixBernsteinSelfAdjointOptimizedStatement_fin_generatedHistory_of_bernsteinPrimitives
      (mOmega := mOmega) (P := P) XFin sigmaSq R t
      hn hIntXFin hIntSqFin hCenteredFin hIndepSAFin hBoundFin hNormFin
      hSigma hR ht
  simpa [hSumX] using hFin

/-- The generated-history Bernstein primitives prove the canonical
high-probability self-adjoint Matrix Bernstein statement for every finite
index type.

The scalar logarithmic threshold and its exact inversion are owned by
`HighDimProb`; this provider theorem only supplies the optimized Bernstein
statement at that threshold. The public statement records the nondegenerate
boundary `0 < sigmaSq or 0 < R` explicitly. -/
theorem matrixBernsteinSelfAdjointHighProbabilityStatement_generatedHistory_of_bernsteinPrimitives
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {I : Type*} [Fintype I] {n : Nat}
    [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    (X : I -> RandomMatrix Omega n n)
    (sigmaSq R delta : Real) :
    matrixBernsteinSelfAdjointHighProbabilityStatement
      (P := P) X sigmaSq R delta := by
  exact
    matrixBernsteinSelfAdjointHighProbabilityStatement_of_optimizedStatement
      (P := P) X sigmaSq R delta
      (matrixBernsteinSelfAdjointOptimizedStatement_generatedHistory_of_bernsteinPrimitives
        (mOmega := mOmega) (P := P) X sigmaSq R
        (matrixBernsteinHighProbabilityThreshold n sigmaSq R delta))

namespace MatrixBernstein

/-- Short public alias for the positive-variance operator-norm tail bridge. -/
abbrev operatorNormTail_of_primitives :=
  @matrixBernsteinSelfAdjointOperatorNormTailOptimized_generatedHistory_of_bernsteinPrimitives

/-- Short public alias for the nonnegative-variance operator-norm tail bridge. -/
abbrev operatorNormTail_of_primitives_nonneg :=
  @matrixBernsteinSelfAdjointOperatorNormTailOptimized_generatedHistory_of_bernsteinPrimitives_of_variance_nonneg

/-- Short public alias for the public upper-tail-probability bridge. -/
abbrev operatorNormUpperTail_of_primitives :=
  @matrixBernsteinSelfAdjointOperatorNormUpperTailOptimized_generatedHistory_of_bernsteinPrimitives_of_variance_nonneg

/-- Short public alias for the canonical optimized Matrix Bernstein statement. -/
abbrev optimized_of_primitives :=
  @matrixBernsteinSelfAdjointOptimizedStatement_generatedHistory_of_bernsteinPrimitives

/-- Short public alias for the canonical high-probability statement. -/
abbrev highProbability_of_primitives :=
  @matrixBernsteinSelfAdjointHighProbabilityStatement_generatedHistory_of_bernsteinPrimitives

end MatrixBernstein
end

end HighDimProb
