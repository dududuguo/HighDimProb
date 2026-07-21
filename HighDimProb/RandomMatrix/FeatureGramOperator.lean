import HighDimProb.RandomMatrix.Provider.Concentration

/-!
# Normalized feature-Gram operator

This module packages the uncentered second-moment operator
`(1 / card I) • sum_i x_i x_i*` and its population counterpart. The deviation
is the normalized sum of centered rank-one observations. The consumer API
keeps the Matrix Bernstein provider assumptions behind `Inputs` and exposes
the vector-level constructor and the resulting concentration statements.
-/

namespace HighDimProb
namespace FeatureGramOperator

open MeasureTheory
open scoped BigOperators Matrix.Norms.L2Operator MatrixOrder

noncomputable section

/-- Consumer-facing assumptions for a finite feature family. -/
abbrev Inputs {Omega I : Type*} [MeasurableSpace Omega] [Fintype I]
    {P : Measure Omega} [IsProbabilityMeasure P] {n : Nat}
    (X : I -> RandomVector Omega (n + 1)) (R : Real)
    (Rvar : I -> Real) : Prop :=
  MatrixBernstein.CenteredRankOneExactRowInputs (P := P) X R Rvar

/-- The centered rank-one summand family underlying the feature-Gram
deviation. -/
abbrev centeredSummands {Omega I : Type*} [MeasurableSpace Omega]
    [Fintype I] {P : Measure Omega} {n : Nat}
    (X : I -> RandomVector Omega (n + 1)) :
    I -> RandomMatrix Omega (n + 1) (n + 1) :=
  centeredRankOneRandomMatrixFamily P X

/-- Build `Inputs` from measurability, coordinate `MemLp 2`, norm radii, and
vector-level independence. -/
theorem Inputs.ofIIndepFun {Omega I : Type*} [MeasurableSpace Omega]
    [Fintype I] {P : Measure Omega} [IsProbabilityMeasure P] {n : Nat}
    {X : I -> RandomVector Omega (n + 1)} {R : Real} {Rvar : I -> Real}
    (randomVector : forall i, IsRandomVector P (X i))
    (coordinateMemLpTwo :
      forall i, forall j : Fin (n + 1),
        MemLpRealRandomVariable P (coord (X i) j) 2)
    (sqNormBound : forall i omega, vectorSqNorm (X i omega) <= R)
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (radiusNonneg : 0 <= R)
    (varianceSqNormBound : forall i omega, vectorSqNorm (X i omega) <= Rvar i)
    (varianceRadiiNonneg : forall i, 0 <= Rvar i) :
    Inputs (P := P) X R Rvar :=
  MatrixBernstein.CenteredRankOneExactRowInputs.ofIIndepFun
    randomVector coordinateMemLpTwo sqNormBound hIndep radiusNonneg
    varianceSqNormBound varianceRadiiNonneg

/-- Normalized empirical feature-Gram operator. -/
def empirical {Omega I : Type*} [MeasurableSpace Omega] [Fintype I]
    {n : Nat} (X : I -> RandomVector Omega (n + 1)) :
    RandomMatrix Omega (n + 1) (n + 1) :=
  fun omega =>
    (1 / (Fintype.card I : Real)) •
      ∑ i, rankOneMatrix (X i omega)

/-- Population uncentered feature second-moment operator. -/
def population {Omega I : Type*} [MeasurableSpace Omega] [Fintype I]
    {P : Measure Omega} {n : Nat} (X : I -> RandomVector Omega (n + 1)) :
    Matrix (Fin (n + 1)) (Fin (n + 1)) Real :=
  (1 / (Fintype.card I : Real)) •
    ∑ i, matrixExpect P (rankOneRandomMatrix (X i))

/-- Normalized deviation of empirical from population feature second moments. -/
def deviation {Omega I : Type*} [MeasurableSpace Omega] [Fintype I]
    {P : Measure Omega} {n : Nat} (X : I -> RandomVector Omega (n + 1)) :
    RandomMatrix Omega (n + 1) (n + 1) :=
  fun omega =>
    (1 / (Fintype.card I : Real)) •
      randomMatrixSum (centeredSummands (P := P) X) omega

/-- Empirical minus population is the normalized centered rank-one sum. -/
theorem empirical_sub_population {Omega I : Type*} [MeasurableSpace Omega]
    [Fintype I] {P : Measure Omega} {n : Nat}
    (X : I -> RandomVector Omega (n + 1)) (omega : Omega) :
    empirical X omega - population (P := P) X =
      deviation (P := P) X omega := by
  change
    (1 / (Fintype.card I : Real)) •
          (∑ i, rankOneMatrix (X i omega)) -
        (1 / (Fintype.card I : Real)) •
          (∑ i, matrixExpect P (rankOneRandomMatrix (X i))) =
      (1 / (Fintype.card I : Real)) •
        (∑ i, centeredRankOneRandomMatrixFamily P X i omega)
  rw [← smul_sub, ← Finset.sum_sub_distrib]
  congr 1

/-- Unnormalized centered-rank-one Bernstein tail. -/
theorem operatorNormTail
    {Omega I : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    [Fintype I] {P : Measure Omega} [IsProbabilityMeasure P] {n : Nat}
    [StandardBorelSpace (Matrix (Fin (n + 1)) (Fin (n + 1)) Real)]
    (X : I -> RandomVector Omega (n + 1)) (R t : Real)
    (Rvar : I -> Real) (h : Inputs (P := P) X R Rvar) (ht : 0 <= t) :
    upperTailProb P
        (operatorNorm (randomMatrixSum (centeredSummands (P := P) X))) t <=
      matrixBernsteinTwoSidedOptimizedScalarTailRHS
        (n + 1) (2 * R) (2 * R) t
        (rowSqNormVarianceProxyNormRHS Rvar)
        (rowSqNormVarianceProxyNormRHS Rvar) := by
  simpa using
    MatrixBernstein.centeredRankOneExactRow
      (mOmega := mOmega) (P := P) X R t Rvar (Nat.succ_pos n) h ht

/-- Scaling identity for the normalized deviation tail. -/
theorem deviation_upperTailProb
    {Omega I : Type*} [MeasurableSpace Omega] [Fintype I]
    {P : Measure Omega} {n : Nat}
    (X : I -> RandomVector Omega (n + 1)) (epsilon : Real)
    (hCard : 0 < Fintype.card I) :
    upperTailProb P (operatorNorm (deviation (P := P) X)) epsilon =
      upperTailProb P
        (operatorNorm (randomMatrixSum (centeredSummands (P := P) X)))
        ((Fintype.card I : Real) * epsilon) := by
  simpa only [deviation, centeredSummands] using
    upperTailProb_operatorNorm_smul_one_div_natCast
      (randomMatrixSum (centeredSummands (P := P) X))
      (Fintype.card I) hCard epsilon

/-- Normalized feature-Gram Bernstein tail. -/
theorem normalizedTail
    {Omega I : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    [Fintype I] {P : Measure Omega} [IsProbabilityMeasure P] {n : Nat}
    [StandardBorelSpace (Matrix (Fin (n + 1)) (Fin (n + 1)) Real)]
    (X : I -> RandomVector Omega (n + 1)) (R epsilon : Real)
    (Rvar : I -> Real) (h : Inputs (P := P) X R Rvar)
    (hCard : 0 < Fintype.card I) (hepsilon : 0 <= epsilon) :
    upperTailProb P (operatorNorm (deviation (P := P) X)) epsilon <=
      matrixBernsteinTwoSidedOptimizedScalarTailRHS
        (n + 1) (2 * R) (2 * R) ((Fintype.card I : Real) * epsilon)
        (rowSqNormVarianceProxyNormRHS Rvar)
        (rowSqNormVarianceProxyNormRHS Rvar) := by
  rw [deviation_upperTailProb (P := P) X epsilon hCard]
  exact operatorNormTail X R ((Fintype.card I : Real) * epsilon) Rvar h
    (mul_nonneg (Nat.cast_nonneg _) hepsilon)

/-- Canonical normalized radius at failure probability `delta`. -/
def radius {I : Type*} [Fintype I] (Rvar : I -> Real) (R delta : Real)
    (n : Nat) : Real :=
  (1 / (Fintype.card I : Real)) *
    matrixBernsteinHighProbabilityThreshold (n + 1)
      (rowSqNormVarianceProxyNormRHS Rvar) (2 * R) delta

/-- The normalized deviation is bounded by `delta` at `radius`. -/
theorem highProbability
    {Omega I : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    [Fintype I] {P : Measure Omega} [IsProbabilityMeasure P] {n : Nat}
    [StandardBorelSpace (Matrix (Fin (n + 1)) (Fin (n + 1)) Real)]
    (X : I -> RandomVector Omega (n + 1)) (R delta : Real)
    (Rvar : I -> Real) (h : Inputs (P := P) X R Rvar)
    (hCard : 0 < Fintype.card I)
    (hNondegenerate :
      Or (0 < rowSqNormVarianceProxyNormRHS Rvar) (0 < 2 * R))
    (hdelta : 0 < delta) (hdeltaOne : delta <= 1) :
    upperTailProb P
        (operatorNorm (deviation (P := P) X))
        (radius Rvar R delta n) <= ENNReal.ofReal delta := by
  rw [deviation_upperTailProb (P := P) X (radius Rvar R delta n) hCard]
  have hm : (Fintype.card I : Real) ≠ 0 := by
    exact_mod_cast (Nat.ne_of_gt hCard)
  have hScale :
      (Fintype.card I : Real) * radius Rvar R delta n =
        matrixBernsteinHighProbabilityThreshold (n + 1)
          (rowSqNormVarianceProxyNormRHS Rvar) (2 * R) delta := by
    unfold radius
    field_simp [hm]
  rw [hScale]
  simpa using
    MatrixBernstein.centeredRankOneExactRowHighProbability
      (mOmega := mOmega) (P := P) X R delta Rvar
      (Nat.succ_pos n) h hNondegenerate hdelta hdeltaOne

/-- The normalized feature-Gram deviation is self-adjoint. -/
theorem deviation_selfAdjoint
    {Omega I : Type*} [MeasurableSpace Omega] [Fintype I]
    {P : Measure Omega} [IsProbabilityMeasure P] {n : Nat}
    (X : I -> RandomVector Omega (n + 1)) (R : Real)
    (Rvar : I -> Real) (h : Inputs (P := P) X R Rvar) (omega : Omega) :
    IsSelfAdjointMatrix (deviation (P := P) X omega) := by
  have hCentered :
      CenteredSelfAdjointRandomMatrixFamily P
        (centeredSummands (P := P) X) :=
    centeredRankOneRandomMatrix_centeredSelfAdjoint_of_memLp_two
      h.randomVector h.coordinateMemLpTwo
  apply isSelfAdjointMatrix_smul
  apply isSelfAdjointMatrix_sum
  intro i
  exact hCentered.1.2 i omega

/-- Loewner sandwich for empirical and population uncentered second moments. -/
theorem matrixLESandwich
    {Omega I : Type*} [MeasurableSpace Omega] [Fintype I]
    {P : Measure Omega} [IsProbabilityMeasure P] {n : Nat}
    (X : I -> RandomVector Omega (n + 1)) (R epsilon : Real)
    (Rvar : I -> Real) (h : Inputs (P := P) X R Rvar) (omega : Omega)
    (hNorm : deterministicOperatorNorm (deviation (P := P) X omega) <= epsilon) :
    MatrixLE
        (population (P := P) X -
          epsilon • (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) Real))
        (empirical X omega) /\
      MatrixLE
        (empirical X omega)
        (population (P := P) X +
          epsilon • (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)) := by
  have hSandwich :=
    matrixLESandwich_of_selfAdjoint_operatorNorm_le
      (deviation_selfAdjoint X R Rvar h omega) hNorm
  have hDeviation := empirical_sub_population (P := P) X omega
  constructor
  · have hLower := hSandwich.1
    rw [MatrixLE] at hLower ⊢
    have hEq :
        empirical X omega -
            (population (P := P) X -
              epsilon • (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)) =
          deviation (P := P) X omega -
            (-epsilon) • (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) Real) := by
      rw [← hDeviation]
      simp only [neg_smul]
      abel
    rwa [hEq]
  · have hUpper := hSandwich.2
    rw [MatrixLE] at hUpper ⊢
    have hEq :
        (population (P := P) X +
            epsilon • (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)) -
            empirical X omega =
          epsilon • (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) Real) -
            deviation (P := P) X omega := by
      rw [← hDeviation]
      abel
    rwa [hEq]

end

end FeatureGramOperator
end HighDimProb
