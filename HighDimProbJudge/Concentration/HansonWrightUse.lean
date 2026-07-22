import HighDimProb.Concentration

open MeasureTheory ProbabilityTheory Real

example {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {n : ℕ} {A : Matrix (Fin n) (Fin n) ℝ} {X : Fin n → Ω → ℝ}
    {K : ℝ} (hK : 0 < K)
    (h_indep : iIndepFun X μ)
    (hX_subG : ∀ i, HasSubgaussianMGF (X i) ⟨K ^ 2, sq_nonneg K⟩ μ) :
    ∃ c : ℝ, 0 < c ∧ ∀ t : ℝ, 0 ≤ t →
      (μ {ω | t ≤
        |HighDimProb.HansonWright.centeredQuadraticForm μ A X ω|}).toReal ≤
        2 * exp (-c *
          min
            (t ^ 2 /
              (K ^ 4 *
                HighDimProb.HansonWright.deterministicFrobeniusNorm A ^ 2))
            (t /
              (K ^ 2 * HighDimProb.deterministicOperatorNorm A))) := by
  exact HighDimProb.HansonWright.hanson_wright_inequality_hdp hK h_indep hX_subG
