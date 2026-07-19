import HighDimProb.RandomMatrix.Concentration
import HighDimProb.RandomVector

/-!
# Attention-feature Gram concentration

This example carries a random table of token-indexed attention features all the
way to an operator-norm concentration statement. Each sampled head or channel
contributes a rank-one token Gram matrix. The public centered-rank-one Matrix
Bernstein provider derives the analytic concentration machinery from explicit
feature-level assumptions; no preassembled positive- or negative-side Tropp
bundle appears in the example interface.

The feature table is intentionally abstract. This file does not formalize the
query-key score map or softmax itself; a concrete attention model can use the
same route after proving the random-vector, second-moment, norm, and
independence inputs recorded by `AttentionFeatureGramInputs`.
-/

namespace HighDimProb.Examples.RandomMatrix.AttentionFeatureGramOperatorNormUsage

open MeasureTheory
open scoped BigOperators MatrixOrder Matrix.Norms.L2Operator

noncomputable section

/-! ## Attention-feature Gram vocabulary -/

/-- A token-indexed attention feature vector. -/
abbrev AttentionFeatureVector (numTokens : Nat) :=
  Fin (numTokens + 1) -> Real

/-- A finite collection of head/channel features over the same tokens. -/
abbrev AttentionFeatureTable (numHeads numTokens : Nat) :=
  Fin numHeads -> AttentionFeatureVector numTokens

/-- A random attention feature table. -/
abbrev RandomAttentionFeatureTable (Omega : Type*) [MeasurableSpace Omega]
    (numHeads numTokens : Nat) :=
  Omega -> AttentionFeatureTable numHeads numTokens

/-- One rank-one token Gram contribution from an attention feature. -/
def attentionFeatureGramContribution {numHeads numTokens : Nat}
    (Phi : AttentionFeatureTable numHeads numTokens) (h : Fin numHeads) :
    Matrix (Fin (numTokens + 1)) (Fin (numTokens + 1)) Real :=
  rankOneMatrix (Phi h)

@[simp]
theorem attentionFeatureGramContribution_apply {numHeads numTokens : Nat}
    (Phi : AttentionFeatureTable numHeads numTokens) (h : Fin numHeads)
    (i j : Fin (numTokens + 1)) :
    attentionFeatureGramContribution Phi h i j = Phi h i * Phi h j := by
  rfl

/-- Unnormalized empirical token Gram matrix. -/
def empiricalAttentionFeatureGram {numHeads numTokens : Nat}
    (Phi : AttentionFeatureTable numHeads numTokens) :
    Matrix (Fin (numTokens + 1)) (Fin (numTokens + 1)) Real :=
  Finset.univ.sum fun h => attentionFeatureGramContribution Phi h

@[simp]
theorem empiricalAttentionFeatureGram_apply {numHeads numTokens : Nat}
    (Phi : AttentionFeatureTable numHeads numTokens)
    (i j : Fin (numTokens + 1)) :
    empiricalAttentionFeatureGram Phi i j =
      Finset.univ.sum fun h : Fin numHeads => Phi h i * Phi h j := by
  simpa [empiricalAttentionFeatureGram,
    attentionFeatureGramContribution] using
    (Matrix.sum_apply i j Finset.univ
      (fun h : Fin numHeads => attentionFeatureGramContribution Phi h))

/-- Head-count-normalized empirical token Gram matrix. -/
def normalizedEmpiricalAttentionFeatureGram {numHeads numTokens : Nat}
    (Phi : AttentionFeatureTable numHeads numTokens) :
    Matrix (Fin (numTokens + 1)) (Fin (numTokens + 1)) Real :=
  (1 / (numHeads : Real)) • empiricalAttentionFeatureGram Phi

/-- The random vector associated with one sampled attention head/channel. -/
def randomAttentionFeatureVectorFamily {Omega : Type*} [MeasurableSpace Omega]
    {numHeads numTokens : Nat}
    (Phi : RandomAttentionFeatureTable Omega numHeads numTokens) :
    Fin numHeads -> RandomVector Omega (numTokens + 1) :=
  fun h omega => Phi omega h

@[simp]
theorem randomAttentionFeatureVectorFamily_apply
    {Omega : Type*} [MeasurableSpace Omega] {numHeads numTokens : Nat}
    (Phi : RandomAttentionFeatureTable Omega numHeads numTokens)
    (h : Fin numHeads) (omega : Omega) :
    randomAttentionFeatureVectorFamily Phi h omega = Phi omega h := by
  rfl

/-- Centered rank-one token Gram summands generated directly from `Phi`. -/
abbrev centeredAttentionFeatureGramSummands {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {numHeads numTokens : Nat}
    (Phi : RandomAttentionFeatureTable Omega numHeads numTokens) :
    Fin numHeads -> RandomMatrix Omega (numTokens + 1) (numTokens + 1) :=
  centeredRankOneRandomMatrixFamily P (randomAttentionFeatureVectorFamily Phi)

/-- Feature-level inputs for attention-feature Gram concentration.

The independence hypothesis is stated on the random feature vectors themselves.
The example transports it through the centered rank-one map before invoking the
provider. All Matrix Bernstein integrability, centeredness, operator-norm,
variance-proxy, and generated-history obligations are then derived internally. -/
structure AttentionFeatureGramInputs {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {numHeads numTokens : Nat}
    (Phi : RandomAttentionFeatureTable Omega numHeads numTokens)
    (R : Real) (Rvar : Fin numHeads -> Real) : Prop where
  randomVector : forall head,
    IsRandomVector P (randomAttentionFeatureVectorFamily Phi head)
  coordinateMemLpTwo :
    forall head, forall token : Fin (numTokens + 1),
      MemLpRealRandomVariable P
        (coord (randomAttentionFeatureVectorFamily Phi head) token) 2
  sqNormBound : forall head omega,
    vectorSqNorm (Phi omega head) <= R
  varianceSqNormBound : forall head omega,
    vectorSqNorm (Phi omega head) <= Rvar head
  independent : ProbabilityTheory.iIndepFun
    (randomAttentionFeatureVectorFamily Phi) P
  radiusNonneg : 0 <= R
  varianceRadiiNonneg : forall head, 0 <= Rvar head

/-- Convert attention-feature assumptions to the reusable exact-row provider
inputs. In particular, vector independence is transported through the centered
rank-one map here rather than required from the caller as a matrix-level fact. -/
def AttentionFeatureGramInputs.toCenteredRankOneExactRowInputs
    {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {numHeads numTokens : Nat}
    {Phi : RandomAttentionFeatureTable Omega numHeads numTokens}
    {R : Real} {Rvar : Fin numHeads -> Real}
    (h : AttentionFeatureGramInputs (P := P) Phi R Rvar) :
    MatrixBernstein.CenteredRankOneExactRowInputs (P := P)
      (randomAttentionFeatureVectorFamily Phi) R Rvar := by
  have hCentered :
      CenteredSelfAdjointRandomMatrixFamily P
        (centeredRankOneRandomMatrixFamily P
          (randomAttentionFeatureVectorFamily Phi)) :=
    centeredRankOneRandomMatrix_centeredSelfAdjoint_of_memLp_two
      h.randomVector h.coordinateMemLpTwo
  exact
    { randomVector := h.randomVector
      coordinateMemLpTwo := h.coordinateMemLpTwo
      sqNormBound := h.sqNormBound
      independentSelfAdjoint :=
        ⟨hCentered.1,
          iIndepFun_centeredRankOne
            (randomAttentionFeatureVectorFamily Phi) h.independent⟩
      radiusNonneg := h.radiusNonneg
      varianceSqNormBound := h.varianceSqNormBound
      varianceRadiiNonneg := h.varianceRadiiNonneg }

/-! ## Empirical Gram, population Gram, and centered deviation -/

/-- Random normalized empirical attention-feature Gram matrix. -/
def randomEmpiricalAttentionFeatureGram
    {Omega : Type*} [MeasurableSpace Omega] {numHeads numTokens : Nat}
    (Phi : RandomAttentionFeatureTable Omega numHeads numTokens) :
    RandomMatrix Omega (numTokens + 1) (numTokens + 1) :=
  fun omega => normalizedEmpiricalAttentionFeatureGram (Phi omega)

/-- Average population Gram matrix across the sampled heads/channels. -/
def meanAttentionFeatureGram
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega)
    {numHeads numTokens : Nat}
    (Phi : RandomAttentionFeatureTable Omega numHeads numTokens) :
    Matrix (Fin (numTokens + 1)) (Fin (numTokens + 1)) Real :=
  (1 / (numHeads : Real)) •
    ∑ h, matrixExpect P
      (rankOneRandomMatrix (randomAttentionFeatureVectorFamily Phi h))

/-- Normalized centered attention-feature Gram fluctuation. -/
def attentionFeatureGramDeviation
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {numHeads numTokens : Nat}
    (Phi : RandomAttentionFeatureTable Omega numHeads numTokens) :
    RandomMatrix Omega (numTokens + 1) (numTokens + 1) :=
  fun omega =>
    (1 / (numHeads : Real)) •
      randomMatrixSum
        (centeredAttentionFeatureGramSummands (P := P) Phi) omega

/-- The normalized centered sum is exactly empirical Gram minus mean Gram. -/
theorem attentionFeatureGram_empirical_sub_mean
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {numHeads numTokens : Nat}
    (Phi : RandomAttentionFeatureTable Omega numHeads numTokens)
    (omega : Omega) :
    randomEmpiricalAttentionFeatureGram Phi omega -
        meanAttentionFeatureGram P Phi =
      attentionFeatureGramDeviation (P := P) Phi omega := by
  change
    (1 / (numHeads : Real)) •
          (∑ h, rankOneMatrix
            (randomAttentionFeatureVectorFamily Phi h omega)) -
        (1 / (numHeads : Real)) •
          (∑ h, matrixExpect P
            (rankOneRandomMatrix
              (randomAttentionFeatureVectorFamily Phi h))) =
      (1 / (numHeads : Real)) •
        (∑ h, centeredRankOneRandomMatrixFamily P
          (randomAttentionFeatureVectorFamily Phi) h omega)
  rw [← smul_sub, ← Finset.sum_sub_distrib]
  congr 1

/-- Scaling the normalized fluctuation by the head count scales its tail
threshold by the same factor. -/
theorem attentionFeatureGramDeviation_upperTailProb
    {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {numHeads numTokens : Nat}
    (Phi : RandomAttentionFeatureTable Omega numHeads numTokens)
    (epsilon : Real) (hHeads : 0 < numHeads) :
    upperTailProb P
        (operatorNorm (attentionFeatureGramDeviation (P := P) Phi)) epsilon =
      upperTailProb P
        (operatorNorm
          (randomMatrixSum
            (centeredAttentionFeatureGramSummands (P := P) Phi)))
        ((numHeads : Real) * epsilon) := by
  have hHeadsReal : 0 < (numHeads : Real) := by exact_mod_cast hHeads
  unfold upperTailProb upperTailEvent
  congr 1
  ext omega
  change
    epsilon <=
        ‖(1 / (numHeads : Real)) •
          randomMatrixSum
            (centeredAttentionFeatureGramSummands (P := P) Phi) omega‖ ↔
      (numHeads : Real) * epsilon <=
        ‖randomMatrixSum
          (centeredAttentionFeatureGramSummands (P := P) Phi) omega‖
  rw [norm_smul, Real.norm_eq_abs,
    abs_of_pos (one_div_pos.mpr hHeadsReal)]
  rw [one_div, inv_mul_eq_div]
  simpa only [mul_comm] using
    (le_div_iff₀ hHeadsReal :
      epsilon <=
          ‖randomMatrixSum
            (centeredAttentionFeatureGramSummands (P := P) Phi) omega‖ /
              (numHeads : Real) ↔
        epsilon * (numHeads : Real) <=
          ‖randomMatrixSum
            (centeredAttentionFeatureGramSummands (P := P) Phi) omega‖)

/-! ## End-to-end concentration endpoints -/

/-- Optimized operator-norm tail for the unnormalized centered Gram sum. -/
theorem attentionFeatureGram_operatorNormTail
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {numHeads numTokens : Nat}
    [StandardBorelSpace
      (Matrix (Fin (numTokens + 1)) (Fin (numTokens + 1)) Real)]
    (Phi : RandomAttentionFeatureTable Omega numHeads numTokens)
    (R t : Real) (Rvar : Fin numHeads -> Real)
    (h : AttentionFeatureGramInputs (P := P) Phi R Rvar) (ht : 0 <= t) :
    upperTailProb P
        (operatorNorm
          (randomMatrixSum
            (centeredAttentionFeatureGramSummands (P := P) Phi))) t <=
      matrixBernsteinTwoSidedOptimizedScalarTailRHS
        (numTokens + 1) (2 * R) (2 * R) t
        (rowSqNormVarianceProxyNormRHS Rvar)
        (rowSqNormVarianceProxyNormRHS Rvar) := by
  simpa using
    MatrixBernstein.centeredRankOneExactRow
      (mOmega := mOmega) (P := P)
      (randomAttentionFeatureVectorFamily Phi) R t Rvar
      (Nat.succ_pos numTokens) h.toCenteredRankOneExactRowInputs ht

/-- Operator-norm tail for normalized empirical Gram minus population Gram. -/
theorem attentionFeatureGram_normalizedTail
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {numHeads numTokens : Nat}
    [StandardBorelSpace
      (Matrix (Fin (numTokens + 1)) (Fin (numTokens + 1)) Real)]
    (Phi : RandomAttentionFeatureTable Omega numHeads numTokens)
    (R epsilon : Real) (Rvar : Fin numHeads -> Real)
    (h : AttentionFeatureGramInputs (P := P) Phi R Rvar)
    (hHeads : 0 < numHeads) (hEpsilon : 0 <= epsilon) :
    upperTailProb P
        (operatorNorm (attentionFeatureGramDeviation (P := P) Phi)) epsilon <=
      matrixBernsteinTwoSidedOptimizedScalarTailRHS
        (numTokens + 1) (2 * R) (2 * R)
        ((numHeads : Real) * epsilon)
        (rowSqNormVarianceProxyNormRHS Rvar)
        (rowSqNormVarianceProxyNormRHS Rvar) := by
  rw [attentionFeatureGramDeviation_upperTailProb Phi epsilon hHeads]
  exact attentionFeatureGram_operatorNormTail Phi R
    ((numHeads : Real) * epsilon) Rvar h
    (mul_nonneg (Nat.cast_nonneg numHeads) hEpsilon)

/-- Canonical normalized radius for failure probability `delta`. -/
def attentionFeatureGramRadius (numHeads numTokens : Nat)
    (R delta : Real) (Rvar : Fin numHeads -> Real) : Real :=
  (1 / (numHeads : Real)) *
    matrixBernsteinHighProbabilityThreshold
      (numTokens + 1) (rowSqNormVarianceProxyNormRHS Rvar) (2 * R) delta

/-- High-probability bound for normalized empirical Gram minus population Gram. -/
theorem attentionFeatureGram_highProbability
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {numHeads numTokens : Nat}
    [StandardBorelSpace
      (Matrix (Fin (numTokens + 1)) (Fin (numTokens + 1)) Real)]
    (Phi : RandomAttentionFeatureTable Omega numHeads numTokens)
    (R delta : Real) (Rvar : Fin numHeads -> Real)
    (h : AttentionFeatureGramInputs (P := P) Phi R Rvar)
    (hHeads : 0 < numHeads)
    (hNondegenerate :
      0 < rowSqNormVarianceProxyNormRHS Rvar ∨ 0 < 2 * R)
    (hDelta : 0 < delta) (hDeltaOne : delta <= 1) :
    upperTailProb P
        (operatorNorm (attentionFeatureGramDeviation (P := P) Phi))
        (attentionFeatureGramRadius numHeads numTokens R delta Rvar) <=
      ENNReal.ofReal delta := by
  rw [attentionFeatureGramDeviation_upperTailProb Phi
    (attentionFeatureGramRadius numHeads numTokens R delta Rvar) hHeads]
  have hHeadsNe : (numHeads : Real) ≠ 0 := by
    exact_mod_cast (Nat.ne_of_gt hHeads)
  have hScale :
      (numHeads : Real) *
          attentionFeatureGramRadius numHeads numTokens R delta Rvar =
        matrixBernsteinHighProbabilityThreshold
          (numTokens + 1) (rowSqNormVarianceProxyNormRHS Rvar)
          (2 * R) delta := by
    unfold attentionFeatureGramRadius
    field_simp [hHeadsNe]
  rw [hScale]
  simpa using
    MatrixBernstein.centeredRankOneExactRowHighProbability
      (mOmega := mOmega) (P := P)
      (randomAttentionFeatureVectorFamily Phi) R delta Rvar
      (Nat.succ_pos numTokens) h.toCenteredRankOneExactRowInputs
      hNondegenerate hDelta hDeltaOne

/-- The normalized centered attention-feature Gram fluctuation is self-adjoint. -/
theorem attentionFeatureGramDeviation_selfAdjoint
    {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {numHeads numTokens : Nat}
    (Phi : RandomAttentionFeatureTable Omega numHeads numTokens)
    (R : Real) (Rvar : Fin numHeads -> Real)
    (h : AttentionFeatureGramInputs (P := P) Phi R Rvar)
    (omega : Omega) :
    IsSelfAdjointMatrix (attentionFeatureGramDeviation (P := P) Phi omega) := by
  have hCentered :
      CenteredSelfAdjointRandomMatrixFamily P
        (centeredRankOneRandomMatrixFamily P
          (randomAttentionFeatureVectorFamily Phi)) :=
    centeredRankOneRandomMatrix_centeredSelfAdjoint_of_memLp_two
      h.randomVector h.coordinateMemLpTwo
  apply isSelfAdjointMatrix_smul
  apply isSelfAdjointMatrix_sum
  intro head
  exact hCentered.1.2 head omega

/-- Operator-norm control gives a Loewner sandwich for the empirical Gram. -/
theorem attentionFeatureGram_matrixLESandwich
    {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {numHeads numTokens : Nat}
    (Phi : RandomAttentionFeatureTable Omega numHeads numTokens)
    (R epsilon : Real) (Rvar : Fin numHeads -> Real)
    (h : AttentionFeatureGramInputs (P := P) Phi R Rvar)
    (omega : Omega)
    (hNorm :
      deterministicOperatorNorm
          (attentionFeatureGramDeviation (P := P) Phi omega) <= epsilon) :
    MatrixLE
        (meanAttentionFeatureGram P Phi -
          epsilon •
            (1 : Matrix (Fin (numTokens + 1)) (Fin (numTokens + 1)) Real))
        (randomEmpiricalAttentionFeatureGram Phi omega) /\
      MatrixLE
        (randomEmpiricalAttentionFeatureGram Phi omega)
        (meanAttentionFeatureGram P Phi +
          epsilon •
            (1 : Matrix (Fin (numTokens + 1)) (Fin (numTokens + 1)) Real)) := by
  have hSandwich :=
    matrixLESandwich_of_selfAdjoint_operatorNorm_le
      (attentionFeatureGramDeviation_selfAdjoint Phi R Rvar h omega) hNorm
  have hDeviation :=
    attentionFeatureGram_empirical_sub_mean (P := P) Phi omega
  constructor
  · have hLower := hSandwich.1
    rw [MatrixLE] at hLower ⊢
    have hEq :
        randomEmpiricalAttentionFeatureGram Phi omega -
            (meanAttentionFeatureGram P Phi - epsilon •
              (1 : Matrix (Fin (numTokens + 1))
                (Fin (numTokens + 1)) Real)) =
          attentionFeatureGramDeviation (P := P) Phi omega -
            (-epsilon) •
              (1 : Matrix (Fin (numTokens + 1))
                (Fin (numTokens + 1)) Real) := by
      rw [← hDeviation]
      simp only [neg_smul]
      abel
    rwa [hEq]
  · have hUpper := hSandwich.2
    rw [MatrixLE] at hUpper ⊢
    have hEq :
        (meanAttentionFeatureGram P Phi + epsilon •
            (1 : Matrix (Fin (numTokens + 1))
              (Fin (numTokens + 1)) Real)) -
            randomEmpiricalAttentionFeatureGram Phi omega =
          epsilon •
              (1 : Matrix (Fin (numTokens + 1))
                (Fin (numTokens + 1)) Real) -
            attentionFeatureGramDeviation (P := P) Phi omega := by
      rw [← hDeviation]
      abel
    rwa [hEq]

/-- Reader-facing alias for the optimized tail endpoint. -/
theorem attentionFeatureGram_operatorNorm_tail_usage
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {numHeads numTokens : Nat}
    [StandardBorelSpace
      (Matrix (Fin (numTokens + 1)) (Fin (numTokens + 1)) Real)]
    (Phi : RandomAttentionFeatureTable Omega numHeads numTokens)
    (R t : Real) (Rvar : Fin numHeads -> Real)
    (h : AttentionFeatureGramInputs (P := P) Phi R Rvar) (ht : 0 <= t) :
    upperTailProb P
        (operatorNorm
          (randomMatrixSum
            (centeredAttentionFeatureGramSummands (P := P) Phi))) t <=
      matrixBernsteinTwoSidedOptimizedScalarTailRHS
        (numTokens + 1) (2 * R) (2 * R) t
        (rowSqNormVarianceProxyNormRHS Rvar)
        (rowSqNormVarianceProxyNormRHS Rvar) :=
  attentionFeatureGram_operatorNormTail Phi R t Rvar h ht

end

end HighDimProb.Examples.RandomMatrix.AttentionFeatureGramOperatorNormUsage
