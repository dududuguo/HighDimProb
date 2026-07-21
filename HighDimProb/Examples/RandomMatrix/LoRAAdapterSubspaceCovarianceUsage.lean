import HighDimProb.RandomMatrix.FeatureGramOperator

/-!
# LoRA adapter-subspace gradient second-moment concentration

The original LoRA parameterization has the form `Delta W = B A`. This
examples-only file models a fixed linear adapter-gradient subspace by a real
compression matrix `Q`; it does not formalize factor-training dynamics.

The controlled quantity is the uncentered second moment (a Gram /
empirical-Fisher-style outer product) of the adapter-coordinate gradients.
The `Covariance` identifier names are retained for compatibility, but the
object is not centered and is a covariance only when the features are centered.
-/

namespace HighDimProb
namespace Examples
namespace RandomMatrix
namespace LoRAAdapterSubspaceCovarianceUsage

open MeasureTheory
open scoped BigOperators Matrix.Norms.L2Operator MatrixOrder

noncomputable section

/-! ## Fixed linear adapter coordinates -/

abbrev FullGradient (d : Nat) := Fin (d + 1) -> Real
abbrev AdapterGradient (r : Nat) := Fin (r + 1) -> Real
abbrev AdapterCompression (d r : Nat) :=
  Matrix (Fin (r + 1)) (Fin (d + 1)) Real

def adapterFeature {d r : Nat} (Q : AdapterCompression d r)
    (g : FullGradient d) : AdapterGradient r :=
  Matrix.mulVec Q g

theorem rankOneMatrix_adapterFeature {d r : Nat}
    (Q : AdapterCompression d r) (g : FullGradient d) :
    rankOneMatrix (adapterFeature Q g) =
      Q * rankOneMatrix g * Q.transpose := by
  classical
  ext i j
  simp [adapterFeature, rankOneMatrix, Matrix.mul_apply, Matrix.mulVec,
    dotProduct, Finset.mul_sum, Finset.sum_mul]
  apply Finset.sum_congr rfl
  intro k _
  apply Finset.sum_congr rfl
  intro l _
  ring

theorem adapterCompression_matrixLE {d r : Nat}
    (Q : AdapterCompression d r)
    {A B : Matrix (Fin (d + 1)) (Fin (d + 1)) Real}
    (hAB : MatrixLE A B) :
    MatrixLE (Q * A * Q.transpose) (Q * B * Q.transpose) := by
  apply matrixLE_of_mathlib_le
  rw [Matrix.le_iff]
  have hPSD : (B - A).PosSemidef := posSemidef_of_isPSDMatrix hAB
  have hCompressed := hPSD.mul_mul_conjTranspose_same Q
  simpa only [Matrix.conjTranspose_eq_transpose_of_trivial,
    Matrix.mul_sub, Matrix.sub_mul] using hCompressed

/-! ## Random adapter-gradient second moment -/

abbrev RandomFullGradientTable (Omega : Type*) [MeasurableSpace Omega]
    (batch d : Nat) := Omega -> Fin batch -> FullGradient d

def adapterGradientTable {Omega : Type*} [MeasurableSpace Omega]
    {batch d r : Nat} (Q : AdapterCompression d r)
    (fullGradients : RandomFullGradientTable Omega batch d) :
    Omega -> Fin batch -> AdapterGradient r :=
  fun omega b => adapterFeature Q (fullGradients omega b)

abbrev loraAdapterGradientFamily {Omega : Type*} [MeasurableSpace Omega]
    {batch d r : Nat} (Q : AdapterCompression d r)
    (fullGradients : RandomFullGradientTable Omega batch d) :
    Fin batch -> RandomVector Omega (r + 1) :=
  fun b => fun omega => adapterGradientTable Q fullGradients omega b

abbrev centeredLoRAAdapterCovarianceSummands {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {batch d r : Nat}
    (Q : AdapterCompression d r)
    (fullGradients : RandomFullGradientTable Omega batch d) :
    Fin batch -> RandomMatrix Omega (r + 1) (r + 1) :=
  FeatureGramOperator.centeredSummands
    (P := P) (loraAdapterGradientFamily Q fullGradients)

abbrev LoRACovarianceInputs {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {batch d r : Nat} (Q : AdapterCompression d r)
    (fullGradients : RandomFullGradientTable Omega batch d)
    (R : Real) (Rvar : Fin batch -> Real) : Prop :=
  FeatureGramOperator.Inputs
    (P := P) (loraAdapterGradientFamily Q fullGradients) R Rvar

theorem LoRACovarianceInputs.ofIIndepFun {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {batch d r : Nat} (Q : AdapterCompression d r)
    (fullGradients : RandomFullGradientTable Omega batch d)
    {R : Real} {Rvar : Fin batch -> Real}
    (randomVector :
      forall b, IsRandomVector P (loraAdapterGradientFamily Q fullGradients b))
    (coordinateMemLpTwo :
      forall b, forall j : Fin (r + 1),
        MemLpRealRandomVariable P
          (coord (loraAdapterGradientFamily Q fullGradients b) j) 2)
    (sqNormBound :
      forall b omega,
        vectorSqNorm (loraAdapterGradientFamily Q fullGradients b omega) <= R)
    (hIndep : ProbabilityTheory.iIndepFun
      (loraAdapterGradientFamily Q fullGradients) P)
    (radiusNonneg : 0 <= R)
    (varianceSqNormBound :
      forall b omega,
        vectorSqNorm (loraAdapterGradientFamily Q fullGradients b omega) <=
          Rvar b)
    (varianceRadiiNonneg : forall b, 0 <= Rvar b) :
    LoRACovarianceInputs (P := P) Q fullGradients R Rvar :=
  FeatureGramOperator.Inputs.ofIIndepFun
    randomVector coordinateMemLpTwo sqNormBound hIndep radiusNonneg
    varianceSqNormBound varianceRadiiNonneg

def loraEmpiricalCovariance {Omega : Type*} [MeasurableSpace Omega]
    {batch d r : Nat} (Q : AdapterCompression d r)
    (fullGradients : RandomFullGradientTable Omega batch d) :
    RandomMatrix Omega (r + 1) (r + 1) :=
  FeatureGramOperator.empirical (loraAdapterGradientFamily Q fullGradients)

def loraMeanCovariance {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) {batch d r : Nat} (Q : AdapterCompression d r)
    (fullGradients : RandomFullGradientTable Omega batch d) :
    Matrix (Fin (r + 1)) (Fin (r + 1)) Real :=
  FeatureGramOperator.population
    (P := P) (loraAdapterGradientFamily Q fullGradients)

def loraCovarianceDeviation {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {batch d r : Nat} (Q : AdapterCompression d r)
    (fullGradients : RandomFullGradientTable Omega batch d) :
    RandomMatrix Omega (r + 1) (r + 1) :=
  FeatureGramOperator.deviation
    (P := P) (loraAdapterGradientFamily Q fullGradients)

theorem loraEmpiricalCovariance_sub_mean
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {batch d r : Nat} (Q : AdapterCompression d r)
    (fullGradients : RandomFullGradientTable Omega batch d) (omega : Omega) :
    loraEmpiricalCovariance Q fullGradients omega -
        loraMeanCovariance P Q fullGradients =
      loraCovarianceDeviation (P := P) Q fullGradients omega := by
  simpa [loraEmpiricalCovariance, loraMeanCovariance,
    loraCovarianceDeviation] using
    FeatureGramOperator.empirical_sub_population
      (P := P) (loraAdapterGradientFamily Q fullGradients) omega

theorem loraCovarianceDeviation_upperTailProb
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {batch d r : Nat} (Q : AdapterCompression d r)
    (fullGradients : RandomFullGradientTable Omega batch d) (epsilon : Real)
    (hbatch : 0 < batch) :
    upperTailProb P
        (operatorNorm
          (loraCovarianceDeviation (P := P) Q fullGradients)) epsilon =
      upperTailProb P
        (operatorNorm
          (randomMatrixSum
            (centeredLoRAAdapterCovarianceSummands
              (P := P) Q fullGradients)))
        ((batch : Real) * epsilon) := by
  have hCard : 0 < Fintype.card (Fin batch) := by simpa using hbatch
  simpa [loraCovarianceDeviation, centeredLoRAAdapterCovarianceSummands] using
    FeatureGramOperator.deviation_upperTailProb
      (P := P) (loraAdapterGradientFamily Q fullGradients) epsilon hCard

theorem loraCovariance_operatorNormTail
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {batch d r : Nat}
    [StandardBorelSpace (Matrix (Fin (r + 1)) (Fin (r + 1)) Real)]
    (Q : AdapterCompression d r)
    (fullGradients : RandomFullGradientTable Omega batch d)
    (R t : Real) (Rvar : Fin batch -> Real)
    (h : LoRACovarianceInputs (P := P) Q fullGradients R Rvar)
    (ht : 0 <= t) :
    upperTailProb P
        (operatorNorm
          (randomMatrixSum
            (centeredLoRAAdapterCovarianceSummands
              (P := P) Q fullGradients))) t <=
      matrixBernsteinTwoSidedOptimizedScalarTailRHS
        (r + 1) (2 * R) (2 * R) t
        (rowSqNormVarianceProxyNormRHS Rvar)
        (rowSqNormVarianceProxyNormRHS Rvar) := by
  simpa [centeredLoRAAdapterCovarianceSummands] using
    FeatureGramOperator.operatorNormTail
      (mOmega := mOmega) (P := P)
      (loraAdapterGradientFamily Q fullGradients) R t Rvar h ht

theorem loraCovariance_normalizedTail
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {batch d r : Nat}
    [StandardBorelSpace (Matrix (Fin (r + 1)) (Fin (r + 1)) Real)]
    (Q : AdapterCompression d r)
    (fullGradients : RandomFullGradientTable Omega batch d)
    (R epsilon : Real) (Rvar : Fin batch -> Real)
    (h : LoRACovarianceInputs (P := P) Q fullGradients R Rvar)
    (hbatch : 0 < batch) (hepsilon : 0 <= epsilon) :
    upperTailProb P
        (operatorNorm
          (loraCovarianceDeviation (P := P) Q fullGradients)) epsilon <=
      matrixBernsteinTwoSidedOptimizedScalarTailRHS
        (r + 1) (2 * R) (2 * R) ((batch : Real) * epsilon)
        (rowSqNormVarianceProxyNormRHS Rvar)
        (rowSqNormVarianceProxyNormRHS Rvar) := by
  have hCard : 0 < Fintype.card (Fin batch) := by simpa using hbatch
  simpa [loraCovarianceDeviation] using
    FeatureGramOperator.normalizedTail
      (mOmega := mOmega) (P := P)
      (loraAdapterGradientFamily Q fullGradients) R epsilon Rvar h hCard
      hepsilon

def loraCovarianceRadius (batch r : Nat) (Rvar : Fin batch -> Real)
    (R delta : Real) : Real :=
  FeatureGramOperator.radius Rvar R delta r

theorem loraCovariance_highProbability
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {batch d r : Nat}
    [StandardBorelSpace (Matrix (Fin (r + 1)) (Fin (r + 1)) Real)]
    (Q : AdapterCompression d r)
    (fullGradients : RandomFullGradientTable Omega batch d)
    (R delta : Real) (Rvar : Fin batch -> Real)
    (h : LoRACovarianceInputs (P := P) Q fullGradients R Rvar)
    (hbatch : 0 < batch)
    (hNondegenerate :
      Or (0 < rowSqNormVarianceProxyNormRHS Rvar) (0 < 2 * R))
    (hdelta : 0 < delta) (hdeltaOne : delta <= 1) :
    upperTailProb P
        (operatorNorm
          (loraCovarianceDeviation (P := P) Q fullGradients))
        (loraCovarianceRadius batch r Rvar R delta) <= ENNReal.ofReal delta := by
  have hCard : 0 < Fintype.card (Fin batch) := by simpa using hbatch
  simpa [loraCovarianceDeviation, loraCovarianceRadius] using
    FeatureGramOperator.highProbability
      (mOmega := mOmega) (P := P)
      (loraAdapterGradientFamily Q fullGradients) R delta Rvar h hCard
      hNondegenerate hdelta hdeltaOne

theorem loraCovarianceDeviation_selfAdjoint
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {batch d r : Nat}
    (Q : AdapterCompression d r)
    (fullGradients : RandomFullGradientTable Omega batch d)
    (R : Real) (Rvar : Fin batch -> Real)
    (h : LoRACovarianceInputs (P := P) Q fullGradients R Rvar)
    (omega : Omega) :
    IsSelfAdjointMatrix
      (loraCovarianceDeviation (P := P) Q fullGradients omega) := by
  simpa [loraCovarianceDeviation] using
    FeatureGramOperator.deviation_selfAdjoint
      (P := P) (loraAdapterGradientFamily Q fullGradients) R Rvar h omega

theorem loraCovariance_matrixLESandwich
    {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {batch d r : Nat} (Q : AdapterCompression d r)
    (fullGradients : RandomFullGradientTable Omega batch d)
    (R epsilon : Real) (Rvar : Fin batch -> Real)
    (h : LoRACovarianceInputs (P := P) Q fullGradients R Rvar)
    (omega : Omega)
    (hNorm : deterministicOperatorNorm
      (loraCovarianceDeviation (P := P) Q fullGradients omega) <= epsilon) :
    MatrixLE
        (loraMeanCovariance P Q fullGradients -
          epsilon • (1 : Matrix (Fin (r + 1)) (Fin (r + 1)) Real))
        (loraEmpiricalCovariance Q fullGradients omega) /\
      MatrixLE
        (loraEmpiricalCovariance Q fullGradients omega)
        (loraMeanCovariance P Q fullGradients +
          epsilon • (1 : Matrix (Fin (r + 1)) (Fin (r + 1)) Real)) := by
  simpa [loraEmpiricalCovariance, loraMeanCovariance,
    loraCovarianceDeviation] using
    FeatureGramOperator.matrixLESandwich
      (P := P) (loraAdapterGradientFamily Q fullGradients) R epsilon Rvar h
      omega (by simpa [loraCovarianceDeviation] using hNorm)

end
end LoRAAdapterSubspaceCovarianceUsage
end RandomMatrix
end Examples
end HighDimProb
