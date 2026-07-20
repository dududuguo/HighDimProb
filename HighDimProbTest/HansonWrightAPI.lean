import HighDimProb.Concentration

namespace HighDimProbTest

open MeasureTheory ProbabilityTheory Real

noncomputable section

open scoped BigOperators

example {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {n : ℕ}
    {A : Matrix (Fin n) (Fin n) ℝ} {X : Fin n → Ω → ℝ}
    {K C t : ℝ} (hK : 0 < K) (hC : 0 < C)
    (hC_domain : 4 * exp 1 ≤ C)
    (hC_diag_quad : 8 * exp 1 ^ 3 ≤ C)
    (hC_offdiag_domain : 16 * exp 1 ≤ C ^ 2)
    (hC_offdiag_quad : 64 * exp 1 ^ 2 ≤ C)
    (hF : 0 < HighDimProb.HansonWright.deterministicFrobeniusNorm A)
    (hOp : 0 < HighDimProb.deterministicOperatorNorm A)
    (h_indep : iIndepFun X μ)
    (hX_subG : ∀ i, HasSubgaussianMGF (X i) ⟨K ^ 2, sq_nonneg K⟩ μ)
    (ht : 0 ≤ t) :
    (μ {ω | t ≤
      |HighDimProb.HansonWright.centeredQuadraticForm μ A X ω|}).toReal ≤
      2 * exp (-(1 / (4 * C)) *
        min (t ^ 2 /
          (K ^ 4 * HighDimProb.HansonWright.deterministicFrobeniusNorm A ^ 2))
          (t / (K ^ 2 * HighDimProb.deterministicOperatorNorm A))) := by
  exact HighDimProb.HansonWright.hanson_wright_inequality
    hK hC hC_domain hC_diag_quad hC_offdiag_domain hC_offdiag_quad
    hF hOp h_indep hX_subG ht

example {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {n : ℕ}
    {A : Matrix (Fin n) (Fin n) ℝ} {X : Fin n → Ω → ℝ}
    {K : ℝ} (hK : 0 < K)
    (h_indep : iIndepFun X μ)
    (hX_subG : ∀ i, HasSubgaussianMGF (X i) ⟨K ^ 2, sq_nonneg K⟩ μ) :
    ∃ c : ℝ, 0 < c ∧ ∀ t : ℝ, 0 ≤ t →
      (μ {ω | t ≤
        |HighDimProb.HansonWright.centeredQuadraticForm μ A X ω|}).toReal ≤
        2 * exp (-c *
          min (t ^ 2 /
            (K ^ 4 * HighDimProb.HansonWright.deterministicFrobeniusNorm A ^ 2))
            (t / (K ^ 2 * HighDimProb.deterministicOperatorNorm A))) := by
  exact HighDimProb.HansonWright.hanson_wright_inequality_hdp
    hK h_indep hX_subG

end

end HighDimProbTest
