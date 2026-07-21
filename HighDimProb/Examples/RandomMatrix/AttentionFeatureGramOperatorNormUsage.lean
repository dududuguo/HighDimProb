import HighDimProb.RandomMatrix.FeatureGramOperator
import HighDimProb.Analysis.Softmax

/-!
# Attention-feature Gram operator-norm usage

This examples-only file keeps the attention-specific token-feature and
positive-temperature softmax constructions. Their normalized feature-Gram
concentration is supplied by `FeatureGramOperator`.
-/

namespace HighDimProb
namespace Examples
namespace RandomMatrix
namespace AttentionFeatureGramOperatorNormUsage

open MeasureTheory
open scoped BigOperators

noncomputable section

abbrev AttentionFeatureVector (numTokens : Nat) := Fin (numTokens + 1) -> Real
abbrev AttentionFeatureTable (numHeads numTokens : Nat) :=
  Fin numHeads -> AttentionFeatureVector numTokens
abbrev RandomAttentionFeatureTable (Omega : Type*) [MeasurableSpace Omega]
    (numHeads numTokens : Nat) := Omega -> AttentionFeatureTable numHeads numTokens

def attentionFeatureGramContribution {numHeads numTokens : Nat}
    (Phi : AttentionFeatureTable numHeads numTokens) (h : Fin numHeads) :
    Matrix (Fin (numTokens + 1)) (Fin (numTokens + 1)) Real :=
  rankOneMatrix (Phi h)

@[simp] theorem attentionFeatureGramContribution_apply {numHeads numTokens : Nat}
    (Phi : AttentionFeatureTable numHeads numTokens) (h : Fin numHeads)
    (i j : Fin (numTokens + 1)) :
    attentionFeatureGramContribution Phi h i j = Phi h i * Phi h j := by rfl

def empiricalAttentionFeatureGram {numHeads numTokens : Nat}
    (Phi : AttentionFeatureTable numHeads numTokens) :
    Matrix (Fin (numTokens + 1)) (Fin (numTokens + 1)) Real :=
  fun i j => Finset.univ.sum fun h : Fin numHeads => Phi h i * Phi h j

@[simp] theorem empiricalAttentionFeatureGram_apply {numHeads numTokens : Nat}
    (Phi : AttentionFeatureTable numHeads numTokens)
    (i j : Fin (numTokens + 1)) :
    empiricalAttentionFeatureGram Phi i j =
      Finset.univ.sum fun h : Fin numHeads => Phi h i * Phi h j := by rfl

abbrev randomAttentionFeatureVector {Omega : Type*} [MeasurableSpace Omega]
    {numHeads numTokens : Nat}
    (Phi : RandomAttentionFeatureTable Omega numHeads numTokens)
    (h : Fin numHeads) : RandomVector Omega (numTokens + 1) :=
  fun omega => Phi omega h

abbrev attentionFeatureFamily {Omega : Type*} [MeasurableSpace Omega]
    {numHeads numTokens : Nat}
    (Phi : RandomAttentionFeatureTable Omega numHeads numTokens) :
    Fin numHeads -> RandomVector Omega (numTokens + 1) :=
  fun h => randomAttentionFeatureVector Phi h

abbrev centeredAttentionFeatureGramSummands {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {numHeads numTokens : Nat}
    (Phi : RandomAttentionFeatureTable Omega numHeads numTokens) :
    Fin numHeads -> RandomMatrix Omega (numTokens + 1) (numTokens + 1) :=
  FeatureGramOperator.centeredSummands (P := P) (attentionFeatureFamily Phi)

abbrev AttentionGramInputs {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {numHeads numTokens : Nat}
    (Phi : RandomAttentionFeatureTable Omega numHeads numTokens)
    (R : Real) (Rvar : Fin numHeads -> Real) : Prop :=
  FeatureGramOperator.Inputs (P := P) (attentionFeatureFamily Phi) R Rvar

theorem AttentionGramInputs.ofIIndepFun {Omega : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {numHeads numTokens : Nat}
    {Phi : RandomAttentionFeatureTable Omega numHeads numTokens}
    {R : Real} {Rvar : Fin numHeads -> Real}
    (randomVector : forall h, IsRandomVector P (attentionFeatureFamily Phi h))
    (coordinateMemLpTwo : forall h, forall i : Fin (numTokens + 1),
      MemLpRealRandomVariable P (coord (attentionFeatureFamily Phi h) i) 2)
    (sqNormBound : forall h omega,
      vectorSqNorm (attentionFeatureFamily Phi h omega) <= R)
    (hIndep : ProbabilityTheory.iIndepFun (attentionFeatureFamily Phi) P)
    (radiusNonneg : 0 <= R)
    (varianceSqNormBound : forall h omega,
      vectorSqNorm (attentionFeatureFamily Phi h omega) <= Rvar h)
    (varianceRadiiNonneg : forall h, 0 <= Rvar h) :
    AttentionGramInputs (P := P) Phi R Rvar :=
  FeatureGramOperator.Inputs.ofIIndepFun
    randomVector coordinateMemLpTwo sqNormBound hIndep radiusNonneg
    varianceSqNormBound varianceRadiiNonneg

theorem attentionGram_operatorNormTail
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {numHeads numTokens : Nat}
    [StandardBorelSpace (Matrix (Fin (numTokens + 1)) (Fin (numTokens + 1)) Real)]
    (Phi : RandomAttentionFeatureTable Omega numHeads numTokens)
    (R t : Real) (Rvar : Fin numHeads -> Real)
    (h : AttentionGramInputs (P := P) Phi R Rvar) (ht : 0 <= t) :
    upperTailProb P
        (operatorNorm
          (randomMatrixSum (centeredAttentionFeatureGramSummands (P := P) Phi))) t <=
      matrixBernsteinTwoSidedOptimizedScalarTailRHS
        (numTokens + 1) (2 * R) (2 * R) t
        (rowSqNormVarianceProxyNormRHS Rvar)
        (rowSqNormVarianceProxyNormRHS Rvar) := by
  simpa [centeredAttentionFeatureGramSummands] using
    FeatureGramOperator.operatorNormTail (P := P) (attentionFeatureFamily Phi)
      R t Rvar h ht

def attentionEmpiricalGram {Omega : Type*} [MeasurableSpace Omega]
    {numHeads numTokens : Nat}
    (Phi : RandomAttentionFeatureTable Omega numHeads numTokens) :
    RandomMatrix Omega (numTokens + 1) (numTokens + 1) :=
  FeatureGramOperator.empirical (attentionFeatureFamily Phi)

def attentionPopulationGram {Omega : Type*} [MeasurableSpace Omega]
    (P : Measure Omega) {numHeads numTokens : Nat}
    (Phi : RandomAttentionFeatureTable Omega numHeads numTokens) :
    Matrix (Fin (numTokens + 1)) (Fin (numTokens + 1)) Real :=
  FeatureGramOperator.population (P := P) (attentionFeatureFamily Phi)

def attentionGramDeviation {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} {numHeads numTokens : Nat}
    (Phi : RandomAttentionFeatureTable Omega numHeads numTokens) :
    RandomMatrix Omega (numTokens + 1) (numTokens + 1) :=
  FeatureGramOperator.deviation (P := P) (attentionFeatureFamily Phi)

theorem attentionEmpiricalGram_sub_population
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {numHeads numTokens : Nat}
    (Phi : RandomAttentionFeatureTable Omega numHeads numTokens) (omega : Omega) :
    attentionEmpiricalGram Phi omega - attentionPopulationGram P Phi =
      attentionGramDeviation (P := P) Phi omega := by
  simpa [attentionEmpiricalGram, attentionPopulationGram, attentionGramDeviation] using
    FeatureGramOperator.empirical_sub_population (P := P)
      (attentionFeatureFamily Phi) omega

theorem attentionGramDeviation_upperTailProb
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {numHeads numTokens : Nat}
    (Phi : RandomAttentionFeatureTable Omega numHeads numTokens)
    (epsilon : Real) (hHeads : 0 < numHeads) :
    upperTailProb P (operatorNorm (attentionGramDeviation (P := P) Phi)) epsilon =
      upperTailProb P
        (operatorNorm
          (randomMatrixSum (centeredAttentionFeatureGramSummands (P := P) Phi)))
        ((numHeads : Real) * epsilon) := by
  have hCard : 0 < Fintype.card (Fin numHeads) := by simpa using hHeads
  simpa [attentionGramDeviation, centeredAttentionFeatureGramSummands] using
    FeatureGramOperator.deviation_upperTailProb (P := P)
      (attentionFeatureFamily Phi) epsilon hCard

theorem attentionGram_normalizedTail
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {numHeads numTokens : Nat}
    [StandardBorelSpace (Matrix (Fin (numTokens + 1)) (Fin (numTokens + 1)) Real)]
    (Phi : RandomAttentionFeatureTable Omega numHeads numTokens)
    (R epsilon : Real) (Rvar : Fin numHeads -> Real)
    (h : AttentionGramInputs (P := P) Phi R Rvar)
    (hHeads : 0 < numHeads) (hepsilon : 0 <= epsilon) :
    upperTailProb P (operatorNorm (attentionGramDeviation (P := P) Phi)) epsilon <=
      matrixBernsteinTwoSidedOptimizedScalarTailRHS
        (numTokens + 1) (2 * R) (2 * R) ((numHeads : Real) * epsilon)
        (rowSqNormVarianceProxyNormRHS Rvar)
        (rowSqNormVarianceProxyNormRHS Rvar) := by
  have hCard : 0 < Fintype.card (Fin numHeads) := by simpa using hHeads
  simpa [attentionGramDeviation] using
    FeatureGramOperator.normalizedTail (mOmega := mOmega) (P := P)
      (attentionFeatureFamily Phi) R epsilon Rvar h hCard hepsilon

def attentionGramRadius (numHeads numTokens : Nat) (Rvar : Fin numHeads -> Real)
    (R delta : Real) : Real := FeatureGramOperator.radius Rvar R delta numTokens

theorem attentionGram_highProbability
    {Omega : Type*} [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {numHeads numTokens : Nat}
    [StandardBorelSpace (Matrix (Fin (numTokens + 1)) (Fin (numTokens + 1)) Real)]
    (Phi : RandomAttentionFeatureTable Omega numHeads numTokens)
    (R delta : Real) (Rvar : Fin numHeads -> Real)
    (h : AttentionGramInputs (P := P) Phi R Rvar) (hHeads : 0 < numHeads)
    (hNondegenerate : Or (0 < rowSqNormVarianceProxyNormRHS Rvar) (0 < 2 * R))
    (hdelta : 0 < delta) (hdeltaOne : delta <= 1) :
    upperTailProb P (operatorNorm (attentionGramDeviation (P := P) Phi))
        (attentionGramRadius numHeads numTokens Rvar R delta) <= ENNReal.ofReal delta := by
  have hCard : 0 < Fintype.card (Fin numHeads) := by simpa using hHeads
  simpa [attentionGramDeviation, attentionGramRadius] using
    FeatureGramOperator.highProbability (mOmega := mOmega) (P := P)
      (attentionFeatureFamily Phi) R delta Rvar h hCard hNondegenerate hdelta hdeltaOne

theorem attentionGramDeviation_selfAdjoint
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {numHeads numTokens : Nat}
    (Phi : RandomAttentionFeatureTable Omega numHeads numTokens)
    (R : Real) (Rvar : Fin numHeads -> Real)
    (h : AttentionGramInputs (P := P) Phi R Rvar) (omega : Omega) :
    IsSelfAdjointMatrix (attentionGramDeviation (P := P) Phi omega) := by
  simpa [attentionGramDeviation] using
    FeatureGramOperator.deviation_selfAdjoint (P := P)
      (attentionFeatureFamily Phi) R Rvar h omega

theorem attentionGram_matrixLESandwich
    {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {numHeads numTokens : Nat}
    (Phi : RandomAttentionFeatureTable Omega numHeads numTokens)
    (R epsilon : Real) (Rvar : Fin numHeads -> Real)
    (h : AttentionGramInputs (P := P) Phi R Rvar) (omega : Omega)
    (hNorm : deterministicOperatorNorm
      (attentionGramDeviation (P := P) Phi omega) <= epsilon) :
    MatrixLE (attentionPopulationGram P Phi - epsilon •
      (1 : Matrix (Fin (numTokens + 1)) (Fin (numTokens + 1)) Real))
      (attentionEmpiricalGram Phi omega) /\
      MatrixLE (attentionEmpiricalGram Phi omega)
        (attentionPopulationGram P Phi + epsilon •
          (1 : Matrix (Fin (numTokens + 1)) (Fin (numTokens + 1)) Real)) := by
  simpa [attentionEmpiricalGram, attentionPopulationGram, attentionGramDeviation] using
    FeatureGramOperator.matrixLESandwich (P := P) (attentionFeatureFamily Phi)
      R epsilon Rvar h omega (by simpa [attentionGramDeviation] using hNorm)

/-! ## Softmax-attention closure -/

noncomputable def attentionSoftmaxFeatures {Omega : Type*} [MeasurableSpace Omega]
    {numHeads numTokens : Nat} (tau : {t : Real // 0 < t})
    (L : Fin numHeads -> RandomVector Omega (numTokens + 1)) :
    RandomAttentionFeatureTable Omega numHeads numTokens :=
  fun omega h => expNormalized tau.val (L h omega)

theorem attentionSoftmaxGramInputs {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {numHeads numTokens : Nat}
    (tau : {t : Real // 0 < t})
    (L : Fin numHeads -> RandomVector Omega (numTokens + 1))
    (hL : forall h, IsRandomVector P (L h))
    (hIndep : ProbabilityTheory.iIndepFun L P) :
    AttentionGramInputs (P := P) (attentionSoftmaxFeatures tau L) 1 (fun _ => 1) := by
  have hLmeas : forall h, Measurable (L h) := fun h => measurable_pi_iff.mpr (hL h)
  refine AttentionGramInputs.ofIIndepFun (P := P)
    (Phi := attentionSoftmaxFeatures tau L) (R := 1) (Rvar := fun _ => 1)
    ?_ ?_ ?_ ?_ ?_ ?_ ?_
  · intro h i
    show Measurable (fun omega => expNormalized tau.val (L h omega) i)
    exact (measurable_expNormalized_coord tau.val i).comp (hLmeas h)
  · intro h i
    refine MemLp.of_bound
      (((measurable_expNormalized_coord tau.val i).comp (hLmeas h)).aestronglyMeasurable) 1
      (Filter.Eventually.of_forall (fun omega => ?_))
    show ‖expNormalized tau.val (L h omega) i‖ ≤ 1
    rw [Real.norm_eq_abs, abs_of_nonneg (expNormalized_nonneg tau.val (L h omega) i)]
    exact expNormalized_le_one tau.val (L h omega) i
  · intro h omega
    show vectorSqNorm (expNormalized tau.val (L h omega)) ≤ 1
    simpa using expNormalized_sq_sum_le_one tau.val (L h omega)
  · exact hIndep.comp (fun _ => expNormalized tau.val)
      (fun _ => measurable_expNormalized tau.val)
  · exact zero_le_one
  · intro h omega
    show vectorSqNorm (expNormalized tau.val (L h omega)) ≤ 1
    simpa using expNormalized_sq_sum_le_one tau.val (L h omega)
  · intro _
    exact zero_le_one

theorem attentionSoftmaxGram_highProbability {Omega : Type*}
    [mOmega : MeasurableSpace Omega] [Nonempty Omega]
    {P : Measure Omega} [IsProbabilityMeasure P] {numHeads numTokens : Nat}
    [StandardBorelSpace (Matrix (Fin (numTokens + 1)) (Fin (numTokens + 1)) Real)]
    (tau : {t : Real // 0 < t})
    (L : Fin numHeads -> RandomVector Omega (numTokens + 1))
    (hL : forall h, IsRandomVector P (L h))
    (hIndep : ProbabilityTheory.iIndepFun L P)
    (hHeads : 0 < numHeads) (delta : Real)
    (hdelta : 0 < delta) (hdeltaOne : delta <= 1) :
    upperTailProb P
        (operatorNorm
          (attentionGramDeviation (P := P) (attentionSoftmaxFeatures tau L)))
        (attentionGramRadius numHeads numTokens (fun _ => 1) 1 delta) <=
      ENNReal.ofReal delta :=
  attentionGram_highProbability (attentionSoftmaxFeatures tau L) 1 delta (fun _ => 1)
    (attentionSoftmaxGramInputs tau L hL hIndep) hHeads
    (Or.inr (by norm_num)) hdelta hdeltaOne

example {Omega : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {numHeads numTokens : Nat}
    (L : Fin numHeads -> RandomVector Omega (numTokens + 1))
    (hL : forall h, IsRandomVector P (L h))
    (hIndep : ProbabilityTheory.iIndepFun L P) :
    AttentionGramInputs (P := P) (attentionSoftmaxFeatures ⟨1, by norm_num⟩ L)
      1 (fun _ => 1) :=
  attentionSoftmaxGramInputs ⟨1, by norm_num⟩ L hL hIndep

end
end AttentionFeatureGramOperatorNormUsage
end RandomMatrix
end Examples
end HighDimProb
