import HighDimProb.Concentration.SubGaussianSums

/-!
# Hoeffding bounds for bounded centered variables

This file packages Mathlib's one-variable Hoeffding lemma for bounded centered
real random variables with the existing HighDimProb finite independent-sum MGF
and tail infrastructure.
-/

namespace HighDimProb

open MeasureTheory ProbabilityTheory

noncomputable section

open scoped BigOperators NNReal

/--
A bounded centered real random variable is centered subGaussian.

This a.e.-bounded wrapper reuses Mathlib's Hoeffding lemma
`ProbabilityTheory.hasSubgaussianMGF_of_mem_Icc_of_integral_eq_zero` with
HighDimProb's `Centered` and `CenteredSubGaussianMGF` interfaces. The scale is
the half-width `(b - a) / 2`.
-/
theorem centeredSubGaussianMGF_of_ae_mem_Icc_of_centered
    {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω} [IsProbabilityMeasure P]
    {X : RealRandomVariable Ω} {a b : ℝ}
    (hX : IsRealRandomVariable P X)
    (hmem : ∀ᵐ ω ∂P, X ω ∈ Set.Icc a b)
    (hcentered : Centered P X)
    (hwidth : 0 < b - a) :
    CenteredSubGaussianMGF P X ((b - a) / 2) := by
  refine ⟨div_pos hwidth two_pos, ?_⟩
  have hzero : ∫ ω, X ω ∂P = 0 := by
    exact hcentered
  have hsub :=
    ProbabilityTheory.hasSubgaussianMGF_of_mem_Icc_of_integral_eq_zero
      (X := X) (a := a) (b := b) hX.aemeasurable hmem hzero
  convert hsub using 1
  ext
  simp [Real.norm_eq_abs, abs_of_nonneg (le_of_lt hwidth)]

/--
Pointwise-bounded version of
`centeredSubGaussianMGF_of_ae_mem_Icc_of_centered`.
-/
theorem centeredSubGaussianMGF_of_forall_mem_Icc_of_centered
    {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω} [IsProbabilityMeasure P]
    {X : RealRandomVariable Ω} {a b : ℝ}
    (hX : IsRealRandomVariable P X)
    (hmem : ∀ ω, X ω ∈ Set.Icc a b)
    (hcentered : Centered P X)
    (hwidth : 0 < b - a) :
    CenteredSubGaussianMGF P X ((b - a) / 2) :=
  centeredSubGaussianMGF_of_ae_mem_Icc_of_centered
    (P := P) (X := X) (a := a) (b := b)
    hX (ae_of_all P hmem) hcentered hwidth

/--
Finite independent sums of bounded centered variables are centered
subGaussian.

The scale is `sqrt (sum_i ((b_i - a_i) / 2)^2)`, inherited directly from the
one-variable half-width MGF scale and the existing independent finite-sum MGF
closure theorem.
-/
theorem centeredSubGaussianMGF_sum_of_iIndepFun_bounded_centered
    {Ω ι : Type*} [MeasurableSpace Ω] [Fintype ι]
    {P : Measure Ω} [IsProbabilityMeasure P]
    {X : ι → RealRandomVariable Ω} {a b : ι → ℝ}
    (hpos : 0 < ∑ i : ι, ((b i - a i) / 2) ^ 2)
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (hX : ∀ i : ι, IsRealRandomVariable P (X i))
    (hmem : ∀ i : ι, ∀ᵐ ω ∂P, X i ω ∈ Set.Icc (a i) (b i))
    (hcentered : ∀ i : ι, Centered P (X i))
    (hwidth : ∀ i : ι, 0 < b i - a i) :
    CenteredSubGaussianMGF P
      (fun ω => ∑ i : ι, X i ω)
      (Real.sqrt (∑ i : ι, ((b i - a i) / 2) ^ 2)) := by
  exact
    centeredSubGaussianMGF_sum_of_iIndepFun_of_pos
      (P := P) (X := X) (K := fun i : ι => (b i - a i) / 2)
      hpos hIndep
      (fun i =>
        centeredSubGaussianMGF_of_ae_mem_Icc_of_centered
          (P := P) (X := X i) (a := a i) (b := b i)
          (hX i) (hmem i) (hcentered i) (hwidth i))

/--
Two-sided subGaussian tail corollary for finite independent sums of bounded
centered variables.

The tail scale doubles the MGF scale through
`subGaussianTail_of_centeredSubGaussianMGF`.
-/
theorem subGaussianTail_sum_of_iIndepFun_bounded_centered
    {Ω ι : Type*} [MeasurableSpace Ω] [Fintype ι]
    {P : Measure Ω} [IsProbabilityMeasure P]
    {X : ι → RealRandomVariable Ω} {a b : ι → ℝ}
    (hpos : 0 < ∑ i : ι, ((b i - a i) / 2) ^ 2)
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (hX : ∀ i : ι, IsRealRandomVariable P (X i))
    (hmem : ∀ i : ι, ∀ᵐ ω ∂P, X i ω ∈ Set.Icc (a i) (b i))
    (hcentered : ∀ i : ι, Centered P (X i))
    (hwidth : ∀ i : ι, 0 < b i - a i) :
    SubGaussianTail P
      (fun ω => ∑ i : ι, X i ω)
      (2 * Real.sqrt (∑ i : ι, ((b i - a i) / 2) ^ 2)) := by
  exact
    subGaussianTail_sum_of_iIndepFun_of_pos
      (P := P) (X := X) (K := fun i : ι => (b i - a i) / 2)
      hX hpos hIndep
      (fun i =>
        centeredSubGaussianMGF_of_ae_mem_Icc_of_centered
          (P := P) (X := X i) (a := a i) (b := b i)
          (hX i) (hmem i) (hcentered i) (hwidth i))

/--
Explicit HighDimProb-facing Hoeffding bound for finite independent sums of
bounded centered variables.

The denominator is `sum_i (b_i - a_i)^2`. This follows from the half-width MGF
scale and the existing MGF-to-tail bridge, so it is a conservative two-sided
constant rather than the sharp classical `2` in the exponent.
-/
theorem hoeffding_sum_bounded_centered
    {Ω ι : Type*} [MeasurableSpace Ω] [Fintype ι]
    {P : Measure Ω} [IsProbabilityMeasure P]
    {X : ι → RealRandomVariable Ω} {a b : ι → ℝ}
    (hpos : 0 < ∑ i : ι, ((b i - a i) / 2) ^ 2)
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (hX : ∀ i : ι, IsRealRandomVariable P (X i))
    (hmem : ∀ i : ι, ∀ᵐ ω ∂P, X i ω ∈ Set.Icc (a i) (b i))
    (hcentered : ∀ i : ι, Centered P (X i))
    (hwidth : ∀ i : ι, 0 < b i - a i)
    {t : ℝ} (ht : 0 ≤ t) :
    absTailProb P (fun ω => ∑ i : ι, X i ω) t ≤
      ENNReal.ofReal
        (2 * Real.exp (-(t ^ 2 / ∑ i : ι, (b i - a i) ^ 2))) := by
  have htail :=
    (subGaussianTail_sum_of_iIndepFun_bounded_centered
      (P := P) (X := X) (a := a) (b := b)
      hpos hIndep hX hmem hcentered hwidth).2 t ht
  have hsum_nonneg :
      0 ≤ ∑ i : ι, ((b i - a i) / 2) ^ 2 :=
    le_of_lt hpos
  have hden :
      (2 * Real.sqrt (∑ i : ι, ((b i - a i) / 2) ^ 2)) ^ 2 =
        ∑ i : ι, (b i - a i) ^ 2 := by
    rw [mul_pow, Real.sq_sqrt hsum_nonneg]
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro i _hi
    ring
  simpa [hden] using htail

end

end HighDimProb
