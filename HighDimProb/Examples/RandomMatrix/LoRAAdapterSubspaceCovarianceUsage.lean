import HighDimProb.Examples.RandomMatrix.GradientCovarianceUsage
import HighDimProb.RandomMatrix.MatrixBernsteinProvider

/-!
# LoRA adapter-subspace covariance concentration

The original LoRA parameterization has the form `Delta W = B A`. This
examples-only file does not formalize the factor-training dynamics. Instead, it
models a fixed linear adapter-gradient subspace by a real compression matrix
`Q` and proves covariance concentration for the resulting adapter-coordinate
gradients.

The result does not claim a theorem about training dynamics or any performance
guarantee from the LoRA paper. Its statistical input is a bounded independent
mini-batch of adapter-coordinate gradients.
-/

namespace HighDimProb
namespace Examples
namespace RandomMatrix
namespace LoRAAdapterSubspaceCovarianceUsage

open MeasureTheory
open HighDimProb.Examples.RandomMatrix.GradientCovarianceUsage
open scoped BigOperators Matrix.Norms.L2Operator MatrixOrder

noncomputable section

/-! ## Fixed linear adapter coordinates -/

/-- A full model gradient in a finite ambient parameter dimension. -/
abbrev FullGradient (d : Nat) :=
  Fin (d + 1) -> Real

/-- Gradient coordinates in a finite adapter subspace. -/
abbrev AdapterGradient (r : Nat) :=
  Fin (r + 1) -> Real

/-- A fixed linear compression from full-gradient to adapter coordinates. -/
abbrev AdapterCompression (d r : Nat) :=
  Matrix (Fin (r + 1)) (Fin (d + 1)) Real

/-- Apply a fixed adapter-coordinate compression to a full gradient. -/
def adapterFeature {d r : Nat} (Q : AdapterCompression d r)
    (g : FullGradient d) : AdapterGradient r :=
  Matrix.mulVec Q g

/-- Rank-one covariance is transported exactly by adapter compression. -/
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

/-- Loewner order is preserved by the same adapter compression. -/
theorem adapterCompression_matrixLE {d r : Nat}
    (Q : AdapterCompression d r)
    {A B : Matrix (Fin (d + 1)) (Fin (d + 1)) Real}
    (hAB : MatrixLE A B) :
    MatrixLE (Q * A * Q.transpose) (Q * B * Q.transpose) := by
  apply matrixLE_of_mathlib_le
  rw [Matrix.le_iff]
  have hPSD : (B - A).PosSemidef :=
    posSemidef_of_isPSDMatrix hAB
  have hCompressed :=
    hPSD.mul_mul_conjTranspose_same Q
  simpa only [Matrix.conjTranspose_eq_transpose_of_trivial,
    Matrix.mul_sub, Matrix.sub_mul] using hCompressed

/-! ## Random adapter-gradient covariance -/

/-- A random mini-batch of full gradients. -/
abbrev RandomFullGradientTable (Omega : Type*) [MeasurableSpace Omega]
    (batch d : Nat) :=
  Omega -> Fin batch -> FullGradient d

/-- Compress a random full-gradient mini-batch into adapter coordinates. -/
def adapterGradientTable {Omega : Type*} [MeasurableSpace Omega]
    {batch d r : Nat}
    (Q : AdapterCompression d r)
    (fullGradients : RandomFullGradientTable Omega batch d) :
    RandomGradientTable Omega batch r :=
  fun omega b => adapterFeature Q (fullGradients omega b)

/-- The adapter-coordinate random-vector family indexed by the mini-batch. -/
abbrev loraAdapterGradientFamily {Omega : Type*} [MeasurableSpace Omega]
    {batch d r : Nat}
    (Q : AdapterCompression d r)
    (fullGradients : RandomFullGradientTable Omega batch d) :
    Fin batch -> RandomVector Omega (r + 1) :=
  randomGradientVectorFamily (adapterGradientTable Q fullGradients)

/-- Centered rank-one covariance summands in adapter coordinates. -/
abbrev centeredLoRAAdapterCovarianceSummands {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {batch d r : Nat}
    (Q : AdapterCompression d r)
    (fullGradients : RandomFullGradientTable Omega batch d) :
    Fin batch -> RandomMatrix Omega (r + 1) (r + 1) :=
  centeredGradientCovarianceSummands
    (P := P) (adapterGradientTable Q fullGradients)

/-- LoRA-facing alias for the reusable centered rank-one inputs.

The assumptions are stated on the concrete adapter-coordinate gradients.
Independence remains at the centered self-adjoint matrix-family level.
-/
abbrev LoRACovarianceInputs {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {batch d r : Nat}
    (Q : AdapterCompression d r)
    (fullGradients : RandomFullGradientTable Omega batch d)
    (R : Real) : Prop :=
  MatrixBernstein.CenteredRankOneInputs (P := P)
    (loraAdapterGradientFamily Q fullGradients) R

/-- Mini-batch empirical covariance in adapter coordinates. -/
def loraEmpiricalCovariance
    {Omega : Type*} [MeasurableSpace Omega] {batch d r : Nat}
    (Q : AdapterCompression d r)
    (fullGradients : RandomFullGradientTable Omega batch d) :
    RandomMatrix Omega (r + 1) (r + 1) :=
  fun omega =>
    normalizedEmpiricalGradientCovariance
      (adapterGradientTable Q fullGradients omega)
/-- Average population covariance of the adapter-coordinate mini-batch. -/
def loraMeanCovariance
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega)
    {batch d r : Nat}
    (Q : AdapterCompression d r)
    (fullGradients : RandomFullGradientTable Omega batch d) :
    Matrix (Fin (r + 1)) (Fin (r + 1)) Real :=
  (1 / (batch : Real)) •
    ∑ b, matrixExpect P
      (rankOneRandomMatrix (loraAdapterGradientFamily Q fullGradients b))

/-- Normalized centered covariance fluctuation in adapter coordinates. -/
def loraCovarianceDeviation
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {batch d r : Nat}
    (Q : AdapterCompression d r)
    (fullGradients : RandomFullGradientTable Omega batch d) :
    RandomMatrix Omega (r + 1) (r + 1) :=
  fun omega =>
    (1 / (batch : Real)) •
      randomMatrixSum
        (centeredLoRAAdapterCovarianceSummands
          (P := P) Q fullGradients) omega

/-- The normalized centered sum is exactly empirical minus mean covariance. -/
theorem loraEmpiricalCovariance_sub_mean
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {batch d r : Nat}
    (Q : AdapterCompression d r)
    (fullGradients : RandomFullGradientTable Omega batch d)
    (omega : Omega) :
    loraEmpiricalCovariance Q fullGradients omega -
        loraMeanCovariance P Q fullGradients =
      loraCovarianceDeviation (P := P) Q fullGradients omega := by
  change
    (1 / (batch : Real)) •
          (∑ b, rankOneMatrix (loraAdapterGradientFamily Q fullGradients b omega)) -
        (1 / (batch : Real)) •
          (∑ b, matrixExpect P
            (rankOneRandomMatrix (loraAdapterGradientFamily Q fullGradients b))) =
      (1 / (batch : Real)) •
        (∑ b, centeredRankOneRandomMatrixFamily P
          (loraAdapterGradientFamily Q fullGradients) b omega)
  rw [← smul_sub, ← Finset.sum_sub_distrib]
  congr 1

/-- Scaling the covariance fluctuation by the batch size scales its
operator-norm upper-tail threshold by the same factor. -/
theorem loraCovarianceDeviation_upperTailProb
    {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {batch d r : Nat}
    (Q : AdapterCompression d r)
    (fullGradients : RandomFullGradientTable Omega batch d)
    (epsilon : Real) (hbatch : 0 < batch) :
    upperTailProb P
        (operatorNorm
          (loraCovarianceDeviation (P := P) Q fullGradients)) epsilon =
      upperTailProb P
        (operatorNorm
          (randomMatrixSum
            (centeredLoRAAdapterCovarianceSummands
              (P := P) Q fullGradients)))
        ((batch : Real) * epsilon) := by
  have hbatchReal : 0 < (batch : Real) := by exact_mod_cast hbatch
  unfold upperTailProb upperTailEvent
  congr 1
  ext omega
  change
    epsilon <=
        ‖(1 / (batch : Real)) •
          randomMatrixSum
            (centeredLoRAAdapterCovarianceSummands
              (P := P) Q fullGradients) omega‖ ↔
      (batch : Real) * epsilon <=
        ‖randomMatrixSum
          (centeredLoRAAdapterCovarianceSummands
            (P := P) Q fullGradients) omega‖
  rw [norm_smul, Real.norm_eq_abs,
    abs_of_pos (one_div_pos.mpr hbatchReal)]
  rw [one_div, inv_mul_eq_div]
  simpa only [mul_comm] using
    (le_div_iff₀ hbatchReal :
      epsilon <=
          ‖randomMatrixSum
            (centeredLoRAAdapterCovarianceSummands
              (P := P) Q fullGradients) omega‖ / (batch : Real) ↔
        epsilon * (batch : Real) <=
          ‖randomMatrixSum
            (centeredLoRAAdapterCovarianceSummands
              (P := P) Q fullGradients) omega‖)

/-- Operator-norm upper-tail bound for centered LoRA adapter-gradient covariance.

The centered summand radius is `2 * R`; the variance parameter is generated
from the same squared-norm bound.
-/
theorem loraCovariance_operatorNormTail
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {batch d r : Nat}
    [StandardBorelSpace (Matrix (Fin (r + 1)) (Fin (r + 1)) Real)]
    (Q : AdapterCompression d r)
    (fullGradients : RandomFullGradientTable Omega batch d)
    (R t : Real)
    (h : LoRACovarianceInputs (P := P) Q fullGradients R)
    (ht : 0 <= t) :
    upperTailProb P
        (operatorNorm
          (randomMatrixSum
            (centeredLoRAAdapterCovarianceSummands
              (P := P) Q fullGradients))) t <=
      matrixBernsteinTwoSidedOptimizedScalarTailRHS
        (r + 1) (2 * R) (2 * R) t
        (centeredRankOneVarianceProxyNormRHS (I := Fin batch) R)
        (centeredRankOneVarianceProxyNormRHS (I := Fin batch) R) := by
  simpa using
    MatrixBernstein.centeredRankOne
      (mOmega := mOmega) (P := P)
      (loraAdapterGradientFamily Q fullGradients) R t
      (Nat.succ_pos r) h ht

/-- Explicit normalized covariance tail bound generated by the current crude
centered rank-one variance proxy. -/
theorem loraCovariance_normalizedTail
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {batch d r : Nat}
    [StandardBorelSpace (Matrix (Fin (r + 1)) (Fin (r + 1)) Real)]
    (Q : AdapterCompression d r)
    (fullGradients : RandomFullGradientTable Omega batch d)
    (R epsilon : Real)
    (h : LoRACovarianceInputs (P := P) Q fullGradients R)
    (hbatch : 0 < batch) (hR : 0 < R) (hepsilon : 0 <= epsilon) :
    upperTailProb P
        (operatorNorm
          (loraCovarianceDeviation (P := P) Q fullGradients)) epsilon <=
      ENNReal.ofReal
        (2 * (r + 1 : Real) *
          Real.exp
            (-((batch : Real) * epsilon ^ 2 /
              (8 * R ^ 2 + (4 / 3) * R * epsilon)))) := by
  rw [loraCovarianceDeviation_upperTailProb
    (Q := Q) (fullGradients := fullGradients) epsilon hbatch]
  have hTail :=
    loraCovariance_operatorNormTail Q fullGradients R
      ((batch : Real) * epsilon) h
      (mul_nonneg (Nat.cast_nonneg batch) hepsilon)
  refine hTail.trans_eq ?_
  rw [matrixBernsteinTwoSidedOptimizedScalarTailRHS_sameParameters]
  simp only [centeredRankOneVarianceProxyNormRHS,
    pointwiseOperatorNormVarianceProxyNormRHS, Fintype.card_fin,
    Nat.cast_add, Nat.cast_one]
  have hm : (batch : Real) ≠ 0 := by
    exact_mod_cast (Nat.ne_of_gt hbatch)
  have hden : 8 * R ^ 2 + (4 / 3) * R * epsilon ≠ 0 := by
    positivity
  congr 3
  field_simp [hm, hden]
  ring

/-- Canonical normalized radius for a requested failure probability. -/
def loraCovarianceRadius (batch r : Nat) (R delta : Real) : Real :=
  (1 / (batch : Real)) *
    matrixBernsteinHighProbabilityThreshold
      (r + 1)
      (centeredRankOneVarianceProxyNormRHS (I := Fin batch) R)
      (2 * R) delta

/-- Normalized LoRA covariance deviation at the canonical Matrix Bernstein
high-probability radius. -/
theorem loraCovariance_highProbability
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {batch d r : Nat}
    [StandardBorelSpace (Matrix (Fin (r + 1)) (Fin (r + 1)) Real)]
    (Q : AdapterCompression d r)
    (fullGradients : RandomFullGradientTable Omega batch d)
    (R delta : Real)
    (h : LoRACovarianceInputs (P := P) Q fullGradients R)
    (hbatch : 0 < batch) (hR : 0 < R)
    (hdelta : 0 < delta) (hdeltaOne : delta <= 1) :
    upperTailProb P
        (operatorNorm
          (loraCovarianceDeviation (P := P) Q fullGradients))
        (loraCovarianceRadius batch r R delta) <=
      ENNReal.ofReal delta := by
  rw [loraCovarianceDeviation_upperTailProb
    (Q := Q) (fullGradients := fullGradients)
    (loraCovarianceRadius batch r R delta) hbatch]
  have hm : (batch : Real) ≠ 0 := by
    exact_mod_cast (Nat.ne_of_gt hbatch)
  have hScale :
      (batch : Real) * loraCovarianceRadius batch r R delta =
        matrixBernsteinHighProbabilityThreshold
          (r + 1)
          (centeredRankOneVarianceProxyNormRHS (I := Fin batch) R)
          (2 * R) delta := by
    unfold loraCovarianceRadius
    field_simp [hm]
  rw [hScale]
  have hSigma :
      0 <= centeredRankOneVarianceProxyNormRHS (I := Fin batch) R := by
    positivity
  have hRadius : 0 <= 2 * R := by positivity
  have hThreshold :
      0 <= matrixBernsteinHighProbabilityThreshold
        (r + 1)
        (centeredRankOneVarianceProxyNormRHS (I := Fin batch) R)
        (2 * R) delta :=
    matrixBernsteinHighProbabilityThreshold_nonneg
      (Nat.succ_pos r) hRadius hdelta hdeltaOne
  have hTail :=
    loraCovariance_operatorNormTail Q fullGradients R
      (matrixBernsteinHighProbabilityThreshold
        (r + 1)
        (centeredRankOneVarianceProxyNormRHS (I := Fin batch) R)
        (2 * R) delta)
      h hThreshold
  refine hTail.trans_eq ?_
  exact matrixBernsteinTwoSidedOptimizedScalarTailRHS_highProbabilityThreshold
    (Nat.succ_pos r) hSigma hRadius
    (Or.inr (mul_pos (by norm_num) hR)) hdelta hdeltaOne

/-- The normalized centered LoRA covariance fluctuation is self-adjoint. -/
theorem loraCovarianceDeviation_selfAdjoint
    {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {batch d r : Nat}
    (Q : AdapterCompression d r)
    (fullGradients : RandomFullGradientTable Omega batch d)
    (R : Real)
    (h : LoRACovarianceInputs (P := P) Q fullGradients R)
    (omega : Omega) :
    IsSelfAdjointMatrix
      (loraCovarianceDeviation (P := P) Q fullGradients omega) := by
  have hCentered :
      CenteredSelfAdjointRandomMatrixFamily P
        (centeredRankOneRandomMatrixFamily P
          (loraAdapterGradientFamily Q fullGradients)) :=
    centeredRankOneRandomMatrix_centeredSelfAdjoint_of_memLp_two
      h.randomVector h.coordinateMemLpTwo
  apply isSelfAdjointMatrix_smul
  apply isSelfAdjointMatrix_sum
  intro b
  exact hCentered.1.2 b omega

/-- Operator-norm control gives the covariance Loewner sandwich used for
upper and lower spectral endpoint estimates. -/
theorem loraCovariance_matrixLESandwich
    {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {batch d r : Nat}
    (Q : AdapterCompression d r)
    (fullGradients : RandomFullGradientTable Omega batch d)
    (R epsilon : Real)
    (h : LoRACovarianceInputs (P := P) Q fullGradients R)
    (omega : Omega)
    (hNorm :
      deterministicOperatorNorm
        (loraCovarianceDeviation (P := P) Q fullGradients omega) <=
          epsilon) :
    MatrixLE
        (loraMeanCovariance P Q fullGradients -
          epsilon • (1 : Matrix (Fin (r + 1)) (Fin (r + 1)) Real))
        (loraEmpiricalCovariance Q fullGradients omega) /\
      MatrixLE
        (loraEmpiricalCovariance Q fullGradients omega)
        (loraMeanCovariance P Q fullGradients +
          epsilon • (1 : Matrix (Fin (r + 1)) (Fin (r + 1)) Real)) := by
  have hSandwich :=
    matrixLESandwich_of_selfAdjoint_operatorNorm_le
      (loraCovarianceDeviation_selfAdjoint
        Q fullGradients R h omega) hNorm
  have hDeviation :=
    loraEmpiricalCovariance_sub_mean
      (P := P) Q fullGradients omega
  constructor
  · have hLower := hSandwich.1
    rw [MatrixLE] at hLower ⊢
    have hEq :
        loraEmpiricalCovariance Q fullGradients omega -
            (loraMeanCovariance P Q fullGradients -
              epsilon • (1 : Matrix (Fin (r + 1)) (Fin (r + 1)) Real)) =
          loraCovarianceDeviation (P := P) Q fullGradients omega -
            (-epsilon) •
              (1 : Matrix (Fin (r + 1)) (Fin (r + 1)) Real) := by
      rw [← hDeviation]
      simp only [neg_smul]
      abel
    rwa [hEq]
  · have hUpper := hSandwich.2
    rw [MatrixLE] at hUpper ⊢
    have hEq :
        (loraMeanCovariance P Q fullGradients +
            epsilon • (1 : Matrix (Fin (r + 1)) (Fin (r + 1)) Real)) -
            loraEmpiricalCovariance Q fullGradients omega =
          epsilon • (1 : Matrix (Fin (r + 1)) (Fin (r + 1)) Real) -
            loraCovarianceDeviation (P := P) Q fullGradients omega := by
      rw [← hDeviation]
      abel
    rwa [hEq]

end

end LoRAAdapterSubspaceCovarianceUsage
end RandomMatrix
end Examples
end HighDimProb
