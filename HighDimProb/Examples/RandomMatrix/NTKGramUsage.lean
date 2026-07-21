import HighDimProb.RandomMatrix.FeatureGramOperator
import HighDimProb.RandomVector

/-!
# NTK-style Gram matrix concentration usage example

This application specializes the generic feature-Gram operator to finite-width
NTK/random-feature Gram summands. It retains vector-level measurability,
coordinate `MemLp 2`, squared-vector-norm radii, and vector-level independence;
the caller never states independence of centered matrix summands.
-/

namespace HighDimProb.Examples.RandomMatrix.NTKGramUsage

open MeasureTheory
open scoped BigOperators

noncomputable section

abbrev NTKFeatureVector (n : Nat) := Fin (n + 1) -> Real
abbrev RandomNTKFeatureVector (Omega : Type*) [MeasurableSpace Omega] (n : Nat) :=
  RandomVector Omega (n + 1)

def ntkGramOuter {n : Nat} (v : NTKFeatureVector n) :
    Matrix (Fin (n + 1)) (Fin (n + 1)) Real := rankOneMatrix v

@[simp] theorem ntkGramOuter_apply {n : Nat} (v : NTKFeatureVector n)
    (i j : Fin (n + 1)) : ntkGramOuter v i j = v i * v j := by rfl

def ntkGramContribution {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (J : RandomNTKFeatureVector Omega n) :
    RandomMatrix Omega (n + 1) (n + 1) := rankOneRandomMatrix J

@[simp] theorem ntkGramContribution_apply {Omega : Type*} [MeasurableSpace Omega]
    {n : Nat} (J : RandomNTKFeatureVector Omega n) (omega : Omega)
    (i j : Fin (n + 1)) :
    ntkGramContribution J omega i j = J omega i * J omega j := by rfl

abbrev centeredNTKGramContribution {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {n : Nat} (J : RandomNTKFeatureVector Omega n) :
    RandomMatrix Omega (n + 1) (n + 1) := centeredRankOneRandomMatrix P J

abbrev centeredNTKGramSummands {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {n width : Nat}
    (J : Fin width -> RandomNTKFeatureVector Omega n) :
    Fin width -> RandomMatrix Omega (n + 1) (n + 1) :=
  FeatureGramOperator.centeredSummands (P := P) J

abbrev NTKGramInputs {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {n width : Nat}
    (J : Fin width -> RandomNTKFeatureVector Omega n)
    (R : Real) (Rvar : Fin width -> Real) : Prop :=
  FeatureGramOperator.Inputs (P := P) J R Rvar

theorem NTKGramInputs.ofIIndepFun {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {n width : Nat} {J : Fin width -> RandomNTKFeatureVector Omega n}
    {R : Real} {Rvar : Fin width -> Real}
    (randomVector : forall b, IsRandomVector P (J b))
    (coordinateMemLpTwo : forall b, forall j : Fin (n + 1),
      MemLpRealRandomVariable P (coord (J b) j) 2)
    (sqNormBound : forall b omega, vectorSqNorm (J b omega) <= R)
    (hIndep : ProbabilityTheory.iIndepFun J P)
    (radiusNonneg : 0 <= R)
    (varianceSqNormBound : forall b omega, vectorSqNorm (J b omega) <= Rvar b)
    (varianceRadiiNonneg : forall b, 0 <= Rvar b) :
    NTKGramInputs (P := P) J R Rvar :=
  FeatureGramOperator.Inputs.ofIIndepFun
    randomVector coordinateMemLpTwo sqNormBound hIndep radiusNonneg
    varianceSqNormBound varianceRadiiNonneg

theorem ntkGram_operatorNormTail
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {n width : Nat}
    [StandardBorelSpace (Matrix (Fin (n + 1)) (Fin (n + 1)) Real)]
    (J : Fin width -> RandomNTKFeatureVector Omega n)
    (R t : Real) (Rvar : Fin width -> Real)
    (h : NTKGramInputs (P := P) J R Rvar) (ht : 0 <= t) :
    upperTailProb P
        (operatorNorm (randomMatrixSum (centeredNTKGramSummands (P := P) J))) t <=
      matrixBernsteinTwoSidedOptimizedScalarTailRHS
        (n + 1) (2 * R) (2 * R) t
        (rowSqNormVarianceProxyNormRHS Rvar)
        (rowSqNormVarianceProxyNormRHS Rvar) := by
  simpa [centeredNTKGramSummands] using
    FeatureGramOperator.operatorNormTail J R t Rvar h ht

def ntkEmpiricalGram {Omega : Type*} [MeasurableSpace Omega] {n width : Nat}
    (J : Fin width -> RandomNTKFeatureVector Omega n) :
    RandomMatrix Omega (n + 1) (n + 1) := FeatureGramOperator.empirical J

def ntkPopulationGram {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) {n width : Nat}
    (J : Fin width -> RandomNTKFeatureVector Omega n) :
    Matrix (Fin (n + 1)) (Fin (n + 1)) Real :=
  FeatureGramOperator.population (P := P) J

def ntkGramDeviation {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {n width : Nat}
    (J : Fin width -> RandomNTKFeatureVector Omega n) :
    RandomMatrix Omega (n + 1) (n + 1) :=
  FeatureGramOperator.deviation (P := P) J

theorem ntkEmpiricalGram_sub_population
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {n width : Nat} (J : Fin width -> RandomNTKFeatureVector Omega n)
    (omega : Omega) :
    ntkEmpiricalGram J omega - ntkPopulationGram P J =
      ntkGramDeviation (P := P) J omega := by
  simpa [ntkEmpiricalGram, ntkPopulationGram, ntkGramDeviation] using
    FeatureGramOperator.empirical_sub_population (P := P) J omega

theorem ntkGramDeviation_upperTailProb
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {n width : Nat} (J : Fin width -> RandomNTKFeatureVector Omega n)
    (epsilon : Real) (hwidth : 0 < width) :
    upperTailProb P (operatorNorm (ntkGramDeviation (P := P) J)) epsilon =
      upperTailProb P
        (operatorNorm (randomMatrixSum (centeredNTKGramSummands (P := P) J)))
        ((width : Real) * epsilon) := by
  have hCard : 0 < Fintype.card (Fin width) := by simpa using hwidth
  simpa [ntkGramDeviation, centeredNTKGramSummands] using
    FeatureGramOperator.deviation_upperTailProb (P := P) J epsilon hCard

theorem ntkGram_normalizedTail
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {n width : Nat}
    [StandardBorelSpace (Matrix (Fin (n + 1)) (Fin (n + 1)) Real)]
    (J : Fin width -> RandomNTKFeatureVector Omega n)
    (R epsilon : Real) (Rvar : Fin width -> Real)
    (h : NTKGramInputs (P := P) J R Rvar)
    (hwidth : 0 < width) (hepsilon : 0 <= epsilon) :
    upperTailProb P (operatorNorm (ntkGramDeviation (P := P) J)) epsilon <=
      matrixBernsteinTwoSidedOptimizedScalarTailRHS
        (n + 1) (2 * R) (2 * R) ((width : Real) * epsilon)
        (rowSqNormVarianceProxyNormRHS Rvar)
        (rowSqNormVarianceProxyNormRHS Rvar) := by
  have hCard : 0 < Fintype.card (Fin width) := by simpa using hwidth
  simpa [ntkGramDeviation] using
    FeatureGramOperator.normalizedTail (mOmega := mOmega) (P := P) J R epsilon
      Rvar h hCard hepsilon

def ntkGramRadius (width n : Nat) (Rvar : Fin width -> Real)
    (R delta : Real) : Real := FeatureGramOperator.radius Rvar R delta n

theorem ntkGram_highProbability
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {n width : Nat}
    [StandardBorelSpace (Matrix (Fin (n + 1)) (Fin (n + 1)) Real)]
    (J : Fin width -> RandomNTKFeatureVector Omega n)
    (R delta : Real) (Rvar : Fin width -> Real)
    (h : NTKGramInputs (P := P) J R Rvar) (hwidth : 0 < width)
    (hNondegenerate : Or (0 < rowSqNormVarianceProxyNormRHS Rvar) (0 < 2 * R))
    (hdelta : 0 < delta) (hdeltaOne : delta <= 1) :
    upperTailProb P (operatorNorm (ntkGramDeviation (P := P) J))
        (ntkGramRadius width n Rvar R delta) <= ENNReal.ofReal delta := by
  have hCard : 0 < Fintype.card (Fin width) := by simpa using hwidth
  simpa [ntkGramDeviation, ntkGramRadius] using
    FeatureGramOperator.highProbability (mOmega := mOmega) (P := P) J R delta
      Rvar h hCard hNondegenerate hdelta hdeltaOne

theorem ntkGramDeviation_selfAdjoint
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {n width : Nat}
    (J : Fin width -> RandomNTKFeatureVector Omega n) (R : Real)
    (Rvar : Fin width -> Real) (h : NTKGramInputs (P := P) J R Rvar)
    (omega : Omega) : IsSelfAdjointMatrix (ntkGramDeviation (P := P) J omega) := by
  simpa [ntkGramDeviation] using
    FeatureGramOperator.deviation_selfAdjoint (P := P) J R Rvar h omega

theorem ntkGram_matrixLESandwich
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {n width : Nat}
    (J : Fin width -> RandomNTKFeatureVector Omega n)
    (R epsilon : Real) (Rvar : Fin width -> Real)
    (h : NTKGramInputs (P := P) J R Rvar) (omega : Omega)
    (hNorm : deterministicOperatorNorm (ntkGramDeviation (P := P) J omega) <= epsilon) :
    MatrixLE
        (ntkPopulationGram P J - epsilon •
          (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) Real))
        (ntkEmpiricalGram J omega) /\
      MatrixLE (ntkEmpiricalGram J omega)
        (ntkPopulationGram P J + epsilon •
          (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)) := by
  simpa [ntkEmpiricalGram, ntkPopulationGram, ntkGramDeviation] using
    FeatureGramOperator.matrixLESandwich (P := P) J R epsilon Rvar h omega
      (by simpa [ntkGramDeviation] using hNorm)

end
end HighDimProb.Examples.RandomMatrix.NTKGramUsage
