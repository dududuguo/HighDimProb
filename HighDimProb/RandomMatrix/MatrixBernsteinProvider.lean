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

/-- Normalizing a random matrix by `1 / m` rescales its operator-norm upper
tail: the normalized matrix exceeds `epsilon` exactly when the unnormalized
matrix exceeds `m * epsilon`. This is the reusable scaling step shared by the
normalized empirical-covariance and NTK Gram endpoints. -/
theorem upperTailProb_operatorNorm_smul_one_div_natCast
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega} {p q : Nat}
    (A : RandomMatrix Omega p q) (m : Nat) (hm : 0 < m) (epsilon : Real) :
    upperTailProb P
        (operatorNorm (fun omega => (1 / (m : Real)) • A omega)) epsilon =
      upperTailProb P (operatorNorm A) ((m : Real) * epsilon) := by
  have hmReal : 0 < (m : Real) := by exact_mod_cast hm
  unfold upperTailProb upperTailEvent
  congr 1
  ext omega
  simp only [operatorNorm_apply, Set.mem_setOf_eq]
  rw [norm_smul, Real.norm_eq_abs, abs_of_pos (one_div_pos.mpr hmReal),
    one_div, inv_mul_eq_div]
  simpa only [mul_comm] using
    (le_div_iff₀ hmReal :
      epsilon <= ‖A omega‖ / (m : Real) ↔
        epsilon * (m : Real) <= ‖A omega‖)

namespace MatrixBernstein

/-- Minimal inputs for optimized Matrix Bernstein on a centered rank-one
random-vector family.

The coordinate second moments and pointwise squared-norm bound generate
summand integrability, square integrability, the centered radius `2 * R`, and
the canonical centered rank-one variance proxy. Only independence of the
resulting self-adjoint matrix family remains explicit. -/
structure CenteredRankOneInputs
    {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {I : Type*} [Fintype I] {n : Nat}
    (X : I -> RandomVector Omega n) (R : Real) : Prop where
  randomVector : forall i, IsRandomVector P (X i)
  coordinateMemLpTwo :
    forall i, forall j : Fin n,
      MemLpRealRandomVariable P (coord (X i) j) 2
  sqNormBound : forall i omega, vectorSqNorm (X i omega) <= R
  independentSelfAdjoint :
    IndependentSelfAdjointRandomMatrices P
      (centeredRankOneRandomMatrixFamily P X)
  radiusNonneg : 0 <= R

/-- Row-specific inputs for optimized Matrix Bernstein on centered rank-one
random-vector families.

The uniform radius controls summand norms, while `Rvar` gives the row-specific
variance proxy `sum of Rvar_i^2`. Both the `2 * R` radius and this proxy are
valid upper bounds, not the optimal rank-one constants. -/
structure CenteredRankOneExactRowInputs
    {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {I : Type*} [Fintype I] {n : Nat}
    (X : I -> RandomVector Omega n) (R : Real) (Rvar : I -> Real)
    extends CenteredRankOneInputs (P := P) X R where
  varianceSqNormBound : forall i omega, vectorSqNorm (X i omega) <= Rvar i
  varianceRadiiNonneg : forall i, 0 <= Rvar i

/-- Build `CenteredRankOneInputs` from vector-level independence.

This is the natural downstream entry point. The caller supplies independence of
the underlying random vectors through Mathlib `iIndepFun`, and this constructor
discharges the matrix-level `IndependentSelfAdjointRandomMatrices` obligation
with `iIndepFun_centeredRankOne` and the centered self-adjoint closure. A
downstream application never needs to state independence at the centered
self-adjoint matrix-family level. -/
theorem CenteredRankOneInputs.ofIIndepFun
    {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {I : Type*} [Fintype I] {n : Nat}
    {X : I -> RandomVector Omega n} {R : Real}
    (randomVector : forall i, IsRandomVector P (X i))
    (coordinateMemLpTwo :
      forall i, forall j : Fin n, MemLpRealRandomVariable P (coord (X i) j) 2)
    (sqNormBound : forall i omega, vectorSqNorm (X i omega) <= R)
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (radiusNonneg : 0 <= R) :
    CenteredRankOneInputs (P := P) X R :=
  { randomVector := randomVector
    coordinateMemLpTwo := coordinateMemLpTwo
    sqNormBound := sqNormBound
    independentSelfAdjoint :=
      ⟨(centeredRankOneRandomMatrix_centeredSelfAdjoint_of_memLp_two
          (P := P) (X := X) randomVector coordinateMemLpTwo).1,
        iIndepFun_centeredRankOne X hIndep⟩
    radiusNonneg := radiusNonneg }

/-- Build `CenteredRankOneExactRowInputs` from vector-level independence.

This mirrors `CenteredRankOneInputs.ofIIndepFun` and additionally records the
row-specific squared-norm bounds used by the row-specific variance proxy. -/
theorem CenteredRankOneExactRowInputs.ofIIndepFun
    {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {I : Type*} [Fintype I] {n : Nat}
    {X : I -> RandomVector Omega n} {R : Real} {Rvar : I -> Real}
    (randomVector : forall i, IsRandomVector P (X i))
    (coordinateMemLpTwo :
      forall i, forall j : Fin n, MemLpRealRandomVariable P (coord (X i) j) 2)
    (sqNormBound : forall i omega, vectorSqNorm (X i omega) <= R)
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (radiusNonneg : 0 <= R)
    (varianceSqNormBound : forall i omega, vectorSqNorm (X i omega) <= Rvar i)
    (varianceRadiiNonneg : forall i, 0 <= Rvar i) :
    CenteredRankOneExactRowInputs (P := P) X R Rvar :=
  { toCenteredRankOneInputs :=
      CenteredRankOneInputs.ofIIndepFun randomVector coordinateMemLpTwo
        sqNormBound hIndep radiusNonneg
    varianceSqNormBound := varianceSqNormBound
    varianceRadiiNonneg := varianceRadiiNonneg }

/-- Minimal inputs for optimized Matrix Bernstein on centered self-adjoint
observations.

The observations `X i` are self-adjoint and integrable; centeredness,
self-adjointness, and integrability of the centered summands `X i - E[X i]` are
derived internally. The centered square-integrability, independence,
operator-norm, and variance-proxy fields are the residual proof obligations. -/
structure CenteredSelfAdjointObservationInputs
    {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {I : Type*} [Fintype I] {n : Nat}
    (X : I -> RandomMatrix Omega n n) (R sigmaSq : Real) : Prop where
  selfAdjoint : SelfAdjointRandomMatrixFamily P X
  integrable : forall i, IntegrableRandomMatrix P (X i)
  centeredSquareIntegrable :
    forall i,
      IntegrableRandomMatrix P
        (randomMatrixSquare (centeredRandomMatrixFamily P X i))
  independentCentered :
    IndependentSelfAdjointRandomMatrices P (centeredRandomMatrixFamily P X)
  centeredOperatorNormBound :
    PointwiseOperatorNormBound (centeredRandomMatrixFamily P X) R
  centeredVarianceProxyBound :
    MatrixVarianceProxyNormBound P (centeredRandomMatrixFamily P X) sigmaSq
  radiusNonneg : 0 <= R
  varianceNonneg : 0 <= sigmaSq

/-- Build centered self-adjoint observation inputs from matrix-family
independence of the raw observations. The caller states only `iIndepFun` of the
observations; the centered self-adjoint independence bundle is discharged with
`iIndepFun_centeredRandomMatrix` and the self-adjoint centering closure. -/
theorem CenteredSelfAdjointObservationInputs.ofIIndepFun
    {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {I : Type*} [Fintype I] {n : Nat}
    {X : I -> RandomMatrix Omega n n} {R sigmaSq : Real}
    (selfAdjoint : SelfAdjointRandomMatrixFamily P X)
    (integrable : forall i, IntegrableRandomMatrix P (X i))
    (centeredSquareIntegrable :
      forall i,
        IntegrableRandomMatrix P
          (randomMatrixSquare (centeredRandomMatrixFamily P X i)))
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (centeredOperatorNormBound :
      PointwiseOperatorNormBound (centeredRandomMatrixFamily P X) R)
    (centeredVarianceProxyBound :
      MatrixVarianceProxyNormBound P (centeredRandomMatrixFamily P X) sigmaSq)
    (radiusNonneg : 0 <= R) (varianceNonneg : 0 <= sigmaSq) :
    CenteredSelfAdjointObservationInputs (P := P) X R sigmaSq :=
  { selfAdjoint := selfAdjoint
    integrable := integrable
    centeredSquareIntegrable := centeredSquareIntegrable
    independentCentered :=
      ⟨selfAdjointRandomMatrixFamily_centeredRandomMatrixFamily selfAdjoint,
        iIndepFun_centeredRandomMatrix X hIndep⟩
    centeredOperatorNormBound := centeredOperatorNormBound
    centeredVarianceProxyBound := centeredVarianceProxyBound
    radiusNonneg := radiusNonneg
    varianceNonneg := varianceNonneg }

/-- Optimized operator-norm tail for centered self-adjoint observation sums.

This is the reusable application endpoint behind empirical Hessian, empirical
Fisher, kernel-slice, and general random PSD observation averages. It generates
the centeredness, self-adjointness, and centered-summand integrability premises
from the uncentered self-adjoint family. -/
theorem centeredSelfAdjointObservations
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {I : Type*} [Fintype I] {n : Nat}
    [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    (X : I -> RandomMatrix Omega n n) (R sigmaSq t : Real)
    (hn : 0 < n)
    (h : CenteredSelfAdjointObservationInputs (P := P) X R sigmaSq)
    (ht : 0 <= t) :
    upperTailProb P
        (operatorNorm
          (randomMatrixSum (centeredRandomMatrixFamily P X))) t <=
      matrixBernsteinTwoSidedOptimizedScalarTailRHS n R R t sigmaSq sigmaSq := by
  have hCentered :
      CenteredSelfAdjointRandomMatrixFamily P
        (centeredRandomMatrixFamily P X) :=
    centeredSelfAdjointRandomMatrixFamily_centeredRandomMatrixFamily
      h.selfAdjoint h.integrable
  have hInt :
      forall i,
        IntegrableRandomMatrix P (centeredRandomMatrixFamily P X i) := by
    intro i
    simpa [centeredRandomMatrixFamily] using
      integrableRandomMatrix_centeredRandomMatrix (h.integrable i)
  exact
    matrixBernsteinSelfAdjointOptimizedStatement_generatedHistory_of_bernsteinPrimitives
      (mOmega := mOmega) (P := P)
      (centeredRandomMatrixFamily P X) sigmaSq R t hn
      hInt h.centeredSquareIntegrable hCentered h.independentCentered
      h.centeredOperatorNormBound h.centeredVarianceProxyBound
      h.varianceNonneg h.radiusNonneg ht

/-- High-probability optimized tail for centered self-adjoint observation sums. -/
theorem centeredSelfAdjointObservationsHighProbability
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {I : Type*} [Fintype I] {n : Nat}
    [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    (X : I -> RandomMatrix Omega n n) (R sigmaSq delta : Real)
    (hn : 0 < n)
    (h : CenteredSelfAdjointObservationInputs (P := P) X R sigmaSq)
    (hNondegenerate : Or (0 < sigmaSq) (0 < R))
    (hDelta : 0 < delta) (hDeltaOne : delta <= 1) :
    upperTailProb P
        (operatorNorm
          (randomMatrixSum (centeredRandomMatrixFamily P X)))
        (matrixBernsteinHighProbabilityThreshold n sigmaSq R delta) <=
      ENNReal.ofReal delta := by
  have hThreshold :
      0 <= matrixBernsteinHighProbabilityThreshold n sigmaSq R delta :=
    matrixBernsteinHighProbabilityThreshold_nonneg
      hn h.radiusNonneg hDelta hDeltaOne
  have hTail :=
    centeredSelfAdjointObservations X R sigmaSq
      (matrixBernsteinHighProbabilityThreshold n sigmaSq R delta) hn h hThreshold
  refine hTail.trans_eq ?_
  exact matrixBernsteinTwoSidedOptimizedScalarTailRHS_highProbabilityThreshold
    hn h.varianceNonneg h.radiusNonneg hNondegenerate hDelta hDeltaOne

/-- Optimized operator-norm tail for centered rank-one random-vector sums.

This is the reusable application endpoint behind covariance, NTK Gram, and
fixed-subspace LoRA examples. It generates every analytic Matrix Bernstein
premise except independence from `CenteredRankOneInputs`. -/
theorem centeredRankOne
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {I : Type*} [Fintype I] {n : Nat}
    [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    (X : I -> RandomVector Omega n) (R t : Real)
    (hn : 0 < n) (h : CenteredRankOneInputs (P := P) X R)
    (ht : 0 <= t) :
    upperTailProb P
        (operatorNorm
          (randomMatrixSum (centeredRankOneRandomMatrixFamily P X))) t <=
      matrixBernsteinTwoSidedOptimizedScalarTailRHS
        n (2 * R) (2 * R) t
        (centeredRankOneVarianceProxyNormRHS (I := I) R)
        (centeredRankOneVarianceProxyNormRHS (I := I) R) := by
  have hCentered :
      CenteredSelfAdjointRandomMatrixFamily P
        (centeredRankOneRandomMatrixFamily P X) :=
    centeredRankOneRandomMatrix_centeredSelfAdjoint_of_memLp_two
      (P := P) (X := X) h.randomVector h.coordinateMemLpTwo
  have hInt :
      forall i,
        IntegrableRandomMatrix P
          (centeredRankOneRandomMatrixFamily P X i) := by
    intro i
    exact centeredRankOneRandomMatrix_integrable_of_memLp_two
      (P := P) (X := X i) (h.coordinateMemLpTwo i)
  have hIntSq :
      forall i,
        IntegrableRandomMatrix P
          (randomMatrixSquare (centeredRankOneRandomMatrixFamily P X i)) :=
    integrableRandomMatrix_randomMatrixSquare_centeredRankOneRandomMatrixFamily_of_sqNorm_bound_memLp_two
      (P := P) (X := X) (R := R) h.coordinateMemLpTwo h.sqNormBound
  have hBound :
      PointwiseOperatorNormBound
        (centeredRankOneRandomMatrixFamily P X) (2 * R) :=
    PointwiseOperatorNormBound_centeredRankOneRandomMatrix_of_sqNorm_bound
      (P := P) (X := X) h.randomVector h.coordinateMemLpTwo h.sqNormBound
        h.radiusNonneg
  have hNorm :
      MatrixVarianceProxyNormBound P
        (centeredRankOneRandomMatrixFamily P X)
        (centeredRankOneVarianceProxyNormRHS (I := I) R) :=
    MatrixVarianceProxyNormBound_centeredRankOneRandomMatrixFamily_of_sqNorm_bound_memLp_two
      (P := P) (X := X) (R := R) h.randomVector h.coordinateMemLpTwo
        h.sqNormBound h.radiusNonneg
  have hSigma :
      0 <= centeredRankOneVarianceProxyNormRHS (I := I) R := by
    positivity
  have hRadius : 0 <= 2 * R := by
    nlinarith [h.radiusNonneg]
  exact
    matrixBernsteinSelfAdjointOptimizedStatement_generatedHistory_of_bernsteinPrimitives
      (mOmega := mOmega) (P := P)
      (centeredRankOneRandomMatrixFamily P X)
      (centeredRankOneVarianceProxyNormRHS (I := I) R) (2 * R) t hn
      hInt hIntSq hCentered h.independentSelfAdjoint hBound hNorm
      hSigma hRadius ht

/-- Optimized centered rank-one tail with a row-specific variance proxy.

This closes the generated-history, integrability, boundedness, and variance-proxy
composition from `CenteredRankOneExactRowInputs`. -/
theorem centeredRankOneExactRow
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {I : Type*} [Fintype I] {n : Nat}
    [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    (X : I -> RandomVector Omega n) (R t : Real) (Rvar : I -> Real)
    (hn : 0 < n)
    (h : CenteredRankOneExactRowInputs (P := P) X R Rvar)
    (ht : 0 <= t) :
    upperTailProb P
        (operatorNorm
          (randomMatrixSum (centeredRankOneRandomMatrixFamily P X))) t <=
      matrixBernsteinTwoSidedOptimizedScalarTailRHS
        n (2 * R) (2 * R) t
        (rowSqNormVarianceProxyNormRHS Rvar)
        (rowSqNormVarianceProxyNormRHS Rvar) := by
  have hCentered :
      CenteredSelfAdjointRandomMatrixFamily P
        (centeredRankOneRandomMatrixFamily P X) :=
    centeredRankOneRandomMatrix_centeredSelfAdjoint_of_memLp_two
      (P := P) (X := X) h.randomVector h.coordinateMemLpTwo
  have hInt :
      forall i,
        IntegrableRandomMatrix P
          (centeredRankOneRandomMatrixFamily P X i) := by
    intro i
    exact centeredRankOneRandomMatrix_integrable_of_memLp_two
      (P := P) (X := X i) (h.coordinateMemLpTwo i)
  have hIntSq :
      forall i,
        IntegrableRandomMatrix P
          (randomMatrixSquare (centeredRankOneRandomMatrixFamily P X i)) :=
    integrableRandomMatrix_randomMatrixSquare_centeredRankOneRandomMatrixFamily_of_sqNorm_bound_memLp_two
      (P := P) (X := X) (R := R) h.coordinateMemLpTwo h.sqNormBound
  have hBound :
      PointwiseOperatorNormBound
        (centeredRankOneRandomMatrixFamily P X) (2 * R) :=
    PointwiseOperatorNormBound_centeredRankOneRandomMatrix_of_sqNorm_bound
      (P := P) (X := X) h.randomVector h.coordinateMemLpTwo h.sqNormBound
        h.radiusNonneg
  have hNorm :
      MatrixVarianceProxyNormBound P
        (centeredRankOneRandomMatrixFamily P X)
        (rowSqNormVarianceProxyNormRHS Rvar) :=
    MatrixVarianceProxyNormBound_centeredRankOneRandomMatrixFamily_of_rowSqNorm_bound_memLp_two
      (P := P) (X := X) (R := Rvar) h.coordinateMemLpTwo
        h.varianceSqNormBound h.varianceRadiiNonneg
  have hSigma : 0 <= rowSqNormVarianceProxyNormRHS Rvar := by
    positivity
  have hRadius : 0 <= 2 * R := by
    nlinarith [h.radiusNonneg]
  exact
    matrixBernsteinSelfAdjointOptimizedStatement_generatedHistory_of_bernsteinPrimitives
      (mOmega := mOmega) (P := P)
      (centeredRankOneRandomMatrixFamily P X)
      (rowSqNormVarianceProxyNormRHS Rvar) (2 * R) t hn
      hInt hIntSq hCentered h.independentSelfAdjoint hBound hNorm
      hSigma hRadius ht

/-- High-probability optimized tail for centered rank-one random-vector sums
with a row-specific variance proxy. -/
theorem centeredRankOneExactRowHighProbability
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {I : Type*} [Fintype I] {n : Nat}
    [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    (X : I -> RandomVector Omega n) (R delta : Real) (Rvar : I -> Real)
    (hn : 0 < n)
    (h : CenteredRankOneExactRowInputs (P := P) X R Rvar)
    (hNondegenerate :
      Or (0 < rowSqNormVarianceProxyNormRHS Rvar) (0 < 2 * R))
    (hDelta : 0 < delta) (hDeltaOne : delta <= 1) :
    upperTailProb P
        (operatorNorm
          (randomMatrixSum (centeredRankOneRandomMatrixFamily P X)))
        (matrixBernsteinHighProbabilityThreshold n
          (rowSqNormVarianceProxyNormRHS Rvar) (2 * R) delta) <=
      ENNReal.ofReal delta := by
  have hSigma : 0 <= rowSqNormVarianceProxyNormRHS Rvar := by
    positivity
  have hRadius : 0 <= 2 * R := by
    nlinarith [h.radiusNonneg]
  have hThreshold :
      0 <= matrixBernsteinHighProbabilityThreshold n
        (rowSqNormVarianceProxyNormRHS Rvar) (2 * R) delta :=
    matrixBernsteinHighProbabilityThreshold_nonneg
      hn hRadius hDelta hDeltaOne
  have hTail :=
    centeredRankOneExactRow
      (mOmega := mOmega) (P := P) (X := X) (R := R)
      (t := matrixBernsteinHighProbabilityThreshold n
        (rowSqNormVarianceProxyNormRHS Rvar) (2 * R) delta)
      (Rvar := Rvar) hn h hThreshold
  refine hTail.trans_eq ?_
  exact matrixBernsteinTwoSidedOptimizedScalarTailRHS_highProbabilityThreshold
    hn hSigma hRadius hNondegenerate hDelta hDeltaOne

/-- Optimized operator-norm tail for centered sample covariance with exact-row
variance control.

The conclusion is normalized through the row count. Tropp primitives and
exponential integrability are generated internally. -/
theorem sampleCovarianceExactRow
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {m n : Nat}
    [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    (A : RandomMatrix Omega m n) (R t : Real) (Rvar : Fin m -> Real)
    (hm : 0 < m) (hn : 0 < n)
    (hMeas : IsRandomMatrix P A)
    (hLp : forall k : Fin m, forall j : Fin n,
      MemLpRealRandomVariable P (matrixEntry A k j) 2)
    (hSq : forall k omega, vectorSqNorm (rowVector A k omega) <= R)
    (hSqVar : forall k omega, vectorSqNorm (rowVector A k omega) <= Rvar k)
    (hIndep : IndependentRandomMatrices P
      (centeredSampleCovarianceRowRankOneFamily (P := P) A))
    (hR : 0 <= R) (hRvar : forall k, 0 <= Rvar k)
    (ht : 0 <= t) :
    P (SelfAdjointOperatorNormTailEvent
        (centeredRandomMatrix P (sampleCovariance A)) t) <=
      matrixBernsteinTwoSidedOptimizedScalarTailRHS
        n (2 * R) (2 * R) ((m : Real) * t)
        (rowSqNormVarianceProxyNormRHS Rvar)
        (rowSqNormVarianceProxyNormRHS Rvar) := by
  have hRowsRandom : forall k, IsRandomVector P (rowVector A k) := by
    intro k
    exact isRandomVector_rowVector hMeas k
  have hRowsLp : forall k, forall j : Fin n,
      MemLpRealRandomVariable P (coord (rowVector A k) j) 2 := by
    intro k j
    change MemLpRealRandomVariable P (matrixEntry A k j) 2
    exact hLp k j
  have hCentered : CenteredSelfAdjointRandomMatrixFamily P
      (centeredSampleCovarianceRowRankOneFamily (P := P) A) := by
    simpa [centeredSampleCovarianceRowRankOneFamily] using
      centeredRankOneRandomMatrix_centeredSelfAdjoint_of_memLp_two
        (P := P) (X := rowVector A) hRowsRandom hRowsLp
  have hInputs : CenteredRankOneExactRowInputs (P := P)
      (rowVector A) R Rvar := by
    refine {
      randomVector := hRowsRandom
      coordinateMemLpTwo := hRowsLp
      sqNormBound := hSq
      varianceSqNormBound := hSqVar
      independentSelfAdjoint := And.intro hCentered.1 hIndep
      radiusNonneg := hR
      varianceRadiiNonneg := hRvar }
  have hRows := centeredRankOneExactRow
    (mOmega := mOmega) (P := P) (X := rowVector A)
    (R := R) (t := (m : Real) * t) (Rvar := Rvar) hn hInputs
    (mul_nonneg (Nat.cast_nonneg m) ht)
  have hRankInt : forall k,
      IntegrableRandomMatrix P (rankOneRandomMatrix (rowVector A k)) := by
    intro k
    exact integrableRandomMatrix_rankOneRandomMatrix_of_memLp_two
      (P := P) (X := rowVector A k) (hRowsLp k)
  have hSubset :=
    sampleCovariance_selfAdjointOperatorNormTailEvent_subset_centeredRowRankOneSum
      (P := P) A t hm hRankInt
  apply (measure_mono hSubset).trans
  simpa [upperTailProb, upperTailEvent,
    centeredSampleCovarianceRowRankOneSum,
    centeredSampleCovarianceRowRankOneFamily] using hRows

/-- High-probability centered sample-covariance bound with exact-row variance
control.

The canonical Bernstein threshold is divided by the row count because
`sampleCovariance` is normalized by `m`. The nondegeneracy assumption is the
exact boundary required by the inclusive upper-tail event at threshold zero. -/
theorem sampleCovarianceExactRowHighProbability
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {m n : Nat}
    [StandardBorelSpace (Matrix (Fin n) (Fin n) Real)]
    (A : RandomMatrix Omega m n) (R delta : Real) (Rvar : Fin m -> Real)
    (hm : 0 < m) (hn : 0 < n)
    (hMeas : IsRandomMatrix P A)
    (hLp : forall k : Fin m, forall j : Fin n,
      MemLpRealRandomVariable P (matrixEntry A k j) 2)
    (hSq : forall k omega, vectorSqNorm (rowVector A k omega) <= R)
    (hSqVar : forall k omega, vectorSqNorm (rowVector A k omega) <= Rvar k)
    (hIndep : IndependentRandomMatrices P
      (centeredSampleCovarianceRowRankOneFamily (P := P) A))
    (hR : 0 <= R) (hRvar : forall k, 0 <= Rvar k)
    (hNondegenerate :
      0 < rowSqNormVarianceProxyNormRHS Rvar ∨ 0 < 2 * R)
    (hDelta : 0 < delta) (hDeltaOne : delta <= 1) :
    HighProbabilityBound P
      (SelfAdjointOperatorNormTailEvent
        (centeredRandomMatrix P (sampleCovariance A))
        (matrixBernsteinHighProbabilityThreshold n
          (rowSqNormVarianceProxyNormRHS Rvar) (2 * R) delta / (m : Real)))
      (ENNReal.ofReal delta) := by
  have hmReal : 0 < (m : Real) := by
    exact_mod_cast hm
  have hSigma : 0 <= rowSqNormVarianceProxyNormRHS Rvar := by
    positivity
  have hRadius : 0 <= 2 * R := by
    positivity
  have hThreshold :
      0 <= matrixBernsteinHighProbabilityThreshold n
        (rowSqNormVarianceProxyNormRHS Rvar) (2 * R) delta :=
    matrixBernsteinHighProbabilityThreshold_nonneg
      hn hRadius hDelta hDeltaOne
  have hTail :=
    sampleCovarianceExactRow
      (mOmega := mOmega) (P := P) (A := A) (R := R)
      (t := matrixBernsteinHighProbabilityThreshold n
        (rowSqNormVarianceProxyNormRHS Rvar) (2 * R) delta / (m : Real))
      (Rvar := Rvar) hm hn hMeas hLp hSq hSqVar hIndep hR hRvar
      (div_nonneg hThreshold hmReal.le)
  have hScale :
      (m : Real) *
          (matrixBernsteinHighProbabilityThreshold n
            (rowSqNormVarianceProxyNormRHS Rvar) (2 * R) delta / (m : Real)) =
        matrixBernsteinHighProbabilityThreshold n
          (rowSqNormVarianceProxyNormRHS Rvar) (2 * R) delta := by
    field_simp
  have hRhs :=
    matrixBernsteinTwoSidedOptimizedScalarTailRHS_highProbabilityThreshold
      hn hSigma hRadius hNondegenerate hDelta hDeltaOne
  change
    P (SelfAdjointOperatorNormTailEvent
      (centeredRandomMatrix P (sampleCovariance A))
      (matrixBernsteinHighProbabilityThreshold n
        (rowSqNormVarianceProxyNormRHS Rvar) (2 * R) delta / (m : Real))) <=
      ENNReal.ofReal delta
  exact hTail.trans_eq (by simpa [hScale] using hRhs)

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
