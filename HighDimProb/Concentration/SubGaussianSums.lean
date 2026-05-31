import HighDimProb.Concentration.MGF

/-!
# Independent finite sums of centered subGaussian variables

This file packages Mathlib's finite independent-sum theorem for
`ProbabilityTheory.HasSubgaussianMGF` into the HighDimProb scalar MGF and tail
interfaces.
-/

namespace HighDimProb

open MeasureTheory ProbabilityTheory

noncomputable section

open scoped BigOperators NNReal

/-- A finite sum of measurable real random variables is measurable. -/
theorem isRealRandomVariable_finset_sum {Omega ι : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {s : Finset ι}
    {X : ι -> RealRandomVariable Omega}
    (hX : forall i, i ∈ s -> IsRealRandomVariable P (X i)) :
    IsRealRandomVariable P (fun omega => s.sum (fun i => X i omega)) := by
  dsimp [IsRealRandomVariable, IsRandomVariable]
  exact Finset.measurable_sum s hX

/-- A finite weighted sum of measurable real random variables is measurable. -/
theorem isRealRandomVariable_finset_weighted_sum {Omega ι : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} {s : Finset ι}
    (a : ι -> ℝ) {X : ι -> RealRandomVariable Omega}
    (hX : forall i, i ∈ s -> IsRealRandomVariable P (X i)) :
    IsRealRandomVariable P (fun omega => s.sum (fun i => a i * X i omega)) := by
  dsimp [IsRealRandomVariable, IsRandomVariable]
  exact Finset.measurable_sum s (fun i hi => (hX i hi).const_mul (a i))

/--
Mathlib MGF proxy for a finite independent sum.

The proxy adds as `sum_i K_i^2`, matching the scale
`sqrt (sum_i K_i^2)` in the HighDimProb wrapper below.
-/
theorem hasSubgaussianMGF_finset_sum_of_iIndepFun {Omega ι : Type*}
    [MeasurableSpace Omega] {P : Measure Omega} [IsProbabilityMeasure P]
    {s : Finset ι} {X : ι -> RealRandomVariable Omega} {K : ι -> ℝ}
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (hMGF : forall i, i ∈ s -> CenteredSubGaussianMGF P (X i) (K i)) :
    ProbabilityTheory.HasSubgaussianMGF
      (fun omega => s.sum (fun i => X i omega))
      (s.sum (fun i => (⟨(K i) ^ 2, sq_nonneg (K i)⟩ : ℝ≥0))) P := by
  exact
    ProbabilityTheory.HasSubgaussianMGF.sum_of_iIndepFun
      hIndep
      (s := s)
      (c := fun i => (⟨(K i) ^ 2, sq_nonneg (K i)⟩ : ℝ≥0))
      (fun i hi => (hMGF i hi).2)

/--
A finite independent sum of centered subGaussian variables is centered
subGaussian with scale `sqrt (sum_i K_i^2)`.

The positivity assumption is only needed because `CenteredSubGaussianMGF`
requires a strictly positive scale.
-/
theorem centeredSubGaussianMGF_finset_sum_of_iIndepFun_of_pos
    {Omega ι : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {s : Finset ι}
    {X : ι -> RealRandomVariable Omega} {K : ι -> ℝ}
    (hpos : 0 < s.sum (fun i => (K i) ^ 2))
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (hMGF : forall i, i ∈ s -> CenteredSubGaussianMGF P (X i) (K i)) :
    CenteredSubGaussianMGF P
      (fun omega => s.sum (fun i => X i omega))
      (Real.sqrt (s.sum (fun i => (K i) ^ 2))) := by
  refine ⟨Real.sqrt_pos.2 hpos, ?_⟩
  have hsum_nonneg : 0 ≤ s.sum (fun i => (K i) ^ 2) := by
    exact Finset.sum_nonneg (fun i _hi => sq_nonneg (K i))
  have hproxy :
      (⟨(Real.sqrt (s.sum (fun i => (K i) ^ 2))) ^ 2,
          sq_nonneg (Real.sqrt (s.sum (fun i => (K i) ^ 2)))⟩ : ℝ≥0)
        = s.sum (fun i => (⟨(K i) ^ 2, sq_nonneg (K i)⟩ : ℝ≥0)) := by
    have hcoe :
        (((s.sum (fun i => (⟨(K i) ^ 2, sq_nonneg (K i)⟩ : ℝ≥0)) : ℝ≥0) : ℝ)
          = s.sum (fun i => (K i) ^ 2)) := by
      exact NNReal.coe_sum s (fun i => (⟨(K i) ^ 2, sq_nonneg (K i)⟩ : ℝ≥0))
    ext
    simp only [Real.sq_sqrt hsum_nonneg]
    exact hcoe.symm
  simpa [hproxy] using
    hasSubgaussianMGF_finset_sum_of_iIndepFun
      (P := P) (s := s) (X := X) (K := K) hIndep hMGF

/--
Fintype-facing wrapper for independent finite sums.

This is the main user-facing version when the index type itself is finite.
-/
theorem centeredSubGaussianMGF_sum_of_iIndepFun_of_pos
    {Omega ι : Type*} [MeasurableSpace Omega] [Fintype ι]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {X : ι -> RealRandomVariable Omega} {K : ι -> ℝ}
    (hpos : 0 < ∑ i : ι, (K i) ^ 2)
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (hMGF : forall i : ι, CenteredSubGaussianMGF P (X i) (K i)) :
    CenteredSubGaussianMGF P
      (fun omega => ∑ i : ι, X i omega)
      (Real.sqrt (∑ i : ι, (K i) ^ 2)) := by
  simpa using
    centeredSubGaussianMGF_finset_sum_of_iIndepFun_of_pos
      (P := P) (s := Finset.univ) (X := X) (K := K)
      hpos hIndep (fun i _hi => hMGF i)

/-- Tail corollary for independent finite sums, in Finset form. -/
theorem subGaussianTail_finset_sum_of_iIndepFun_of_pos
    {Omega ι : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {s : Finset ι}
    {X : ι -> RealRandomVariable Omega} {K : ι -> ℝ}
    (hX : forall i, i ∈ s -> IsRealRandomVariable P (X i))
    (hpos : 0 < s.sum (fun i => (K i) ^ 2))
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (hMGF : forall i, i ∈ s -> CenteredSubGaussianMGF P (X i) (K i)) :
    SubGaussianTail P
      (fun omega => s.sum (fun i => X i omega))
      (2 * Real.sqrt (s.sum (fun i => (K i) ^ 2))) := by
  exact
    subGaussianTail_of_centeredSubGaussianMGF
      (P := P)
      (X := fun omega => s.sum (fun i => X i omega))
      (K := Real.sqrt (s.sum (fun i => (K i) ^ 2)))
      (isRealRandomVariable_finset_sum (P := P) (s := s) (X := X) hX)
      (centeredSubGaussianMGF_finset_sum_of_iIndepFun_of_pos
        (P := P) (s := s) (X := X) (K := K) hpos hIndep hMGF)

/-- Tail corollary for independent finite sums over a finite index type. -/
theorem subGaussianTail_sum_of_iIndepFun_of_pos
    {Omega ι : Type*} [MeasurableSpace Omega] [Fintype ι]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {X : ι -> RealRandomVariable Omega} {K : ι -> ℝ}
    (hX : forall i : ι, IsRealRandomVariable P (X i))
    (hpos : 0 < ∑ i : ι, (K i) ^ 2)
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (hMGF : forall i : ι, CenteredSubGaussianMGF P (X i) (K i)) :
    SubGaussianTail P
      (fun omega => ∑ i : ι, X i omega)
      (2 * Real.sqrt (∑ i : ι, (K i) ^ 2)) := by
  simpa using
    subGaussianTail_finset_sum_of_iIndepFun_of_pos
      (P := P) (s := Finset.univ) (X := X) (K := K)
      (fun i _hi => hX i) hpos hIndep (fun i _hi => hMGF i)

/-- Deterministic scalar multiples preserve independence of an indexed family. -/
theorem iIndepFun_weighted_of_iIndepFun {Omega ι : Type*}
    [MeasurableSpace Omega] {P : Measure Omega}
    {X : ι -> RealRandomVariable Omega} (a : ι -> ℝ)
    (hIndep : ProbabilityTheory.iIndepFun X P) :
    ProbabilityTheory.iIndepFun
      (fun i : ι => fun omega : Omega => a i * X i omega) P := by
  have h :=
    hIndep.comp
      (fun i : ι => fun x : ℝ => a i * x)
      (by
        intro i
        fun_prop)
  simpa [Function.comp_def] using h

/-- A weighted centered subGaussian variable has Mathlib proxy `(a_i*K_i)^2`. -/
theorem hasSubgaussianMGF_weighted_of_centeredSubGaussianMGF
    {Omega ι : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    {X : ι -> RealRandomVariable Omega} {K : ι -> ℝ}
    (a : ι -> ℝ) (i : ι)
    (hMGF : CenteredSubGaussianMGF P (X i) (K i)) :
    ProbabilityTheory.HasSubgaussianMGF
      (fun omega => a i * X i omega)
      (⟨(a i * K i) ^ 2, sq_nonneg (a i * K i)⟩ : ℝ≥0) P := by
  have h := hMGF.2.const_mul (a i)
  convert h using 1
  ext
  simp
  ring

/-- Mathlib MGF proxy for a finite independent weighted sum. -/
theorem hasSubgaussianMGF_finset_weighted_sum_of_iIndepFun
    {Omega ι : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {s : Finset ι}
    {X : ι -> RealRandomVariable Omega} {K : ι -> ℝ} (a : ι -> ℝ)
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (hMGF : forall i, i ∈ s -> CenteredSubGaussianMGF P (X i) (K i)) :
    ProbabilityTheory.HasSubgaussianMGF
      (fun omega => s.sum (fun i => a i * X i omega))
      (s.sum (fun i => (⟨(a i * K i) ^ 2, sq_nonneg (a i * K i)⟩ : ℝ≥0))) P := by
  exact
    ProbabilityTheory.HasSubgaussianMGF.sum_of_iIndepFun
      (iIndepFun_weighted_of_iIndepFun (P := P) (X := X) a hIndep)
      (s := s)
      (c := fun i => (⟨(a i * K i) ^ 2, sq_nonneg (a i * K i)⟩ : ℝ≥0))
      (fun i hi => hasSubgaussianMGF_weighted_of_centeredSubGaussianMGF
        (P := P) (X := X) (K := K) a i (hMGF i hi))

/--
A finite independent weighted sum of centered subGaussian variables is centered
subGaussian with scale `sqrt (sum_i (a_i*K_i)^2)`.
-/
theorem centeredSubGaussianMGF_finset_weighted_sum_of_iIndepFun_of_pos
    {Omega ι : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {s : Finset ι}
    {X : ι -> RealRandomVariable Omega} {K : ι -> ℝ} (a : ι -> ℝ)
    (hpos : 0 < s.sum (fun i => (a i * K i) ^ 2))
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (hMGF : forall i, i ∈ s -> CenteredSubGaussianMGF P (X i) (K i)) :
    CenteredSubGaussianMGF P
      (fun omega => s.sum (fun i => a i * X i omega))
      (Real.sqrt (s.sum (fun i => (a i * K i) ^ 2))) := by
  refine ⟨Real.sqrt_pos.2 hpos, ?_⟩
  have hsum_nonneg : 0 ≤ s.sum (fun i => (a i * K i) ^ 2) := by
    exact Finset.sum_nonneg (fun i _hi => sq_nonneg (a i * K i))
  have hproxy :
      (⟨(Real.sqrt (s.sum (fun i => (a i * K i) ^ 2))) ^ 2,
          sq_nonneg (Real.sqrt (s.sum (fun i => (a i * K i) ^ 2)))⟩ : ℝ≥0)
        =
          s.sum
            (fun i => (⟨(a i * K i) ^ 2, sq_nonneg (a i * K i)⟩ : ℝ≥0)) := by
    have hcoe :
        (((s.sum
          (fun i => (⟨(a i * K i) ^ 2, sq_nonneg (a i * K i)⟩ : ℝ≥0)) : ℝ≥0) : ℝ)
          = s.sum (fun i => (a i * K i) ^ 2)) := by
      exact
        NNReal.coe_sum s
          (fun i => (⟨(a i * K i) ^ 2, sq_nonneg (a i * K i)⟩ : ℝ≥0))
    ext
    simp only [Real.sq_sqrt hsum_nonneg]
    exact hcoe.symm
  simpa [hproxy] using
    hasSubgaussianMGF_finset_weighted_sum_of_iIndepFun
      (P := P) (s := s) (X := X) (K := K) a hIndep hMGF

/-- Fintype-facing wrapper for independent finite weighted sums. -/
theorem centeredSubGaussianMGF_weighted_sum_of_iIndepFun_of_pos
    {Omega ι : Type*} [MeasurableSpace Omega] [Fintype ι]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {X : ι -> RealRandomVariable Omega} {K : ι -> ℝ} (a : ι -> ℝ)
    (hpos : 0 < ∑ i : ι, (a i * K i) ^ 2)
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (hMGF : forall i : ι, CenteredSubGaussianMGF P (X i) (K i)) :
    CenteredSubGaussianMGF P
      (fun omega => ∑ i : ι, a i * X i omega)
      (Real.sqrt (∑ i : ι, (a i * K i) ^ 2)) := by
  simpa using
    centeredSubGaussianMGF_finset_weighted_sum_of_iIndepFun_of_pos
      (P := P) (s := Finset.univ) (X := X) (K := K) a
      hpos hIndep (fun i _hi => hMGF i)

/-- Tail corollary for independent finite weighted sums, in Finset form. -/
theorem subGaussianTail_finset_weighted_sum_of_iIndepFun_of_pos
    {Omega ι : Type*} [MeasurableSpace Omega] {P : Measure Omega}
    [IsProbabilityMeasure P] {s : Finset ι}
    {X : ι -> RealRandomVariable Omega} {K : ι -> ℝ} (a : ι -> ℝ)
    (hX : forall i, i ∈ s -> IsRealRandomVariable P (X i))
    (hpos : 0 < s.sum (fun i => (a i * K i) ^ 2))
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (hMGF : forall i, i ∈ s -> CenteredSubGaussianMGF P (X i) (K i)) :
    SubGaussianTail P
      (fun omega => s.sum (fun i => a i * X i omega))
      (2 * Real.sqrt (s.sum (fun i => (a i * K i) ^ 2))) := by
  exact
    subGaussianTail_of_centeredSubGaussianMGF
      (P := P)
      (X := fun omega => s.sum (fun i => a i * X i omega))
      (K := Real.sqrt (s.sum (fun i => (a i * K i) ^ 2)))
      (isRealRandomVariable_finset_weighted_sum (P := P) (s := s) a (X := X) hX)
      (centeredSubGaussianMGF_finset_weighted_sum_of_iIndepFun_of_pos
        (P := P) (s := s) (X := X) (K := K) a hpos hIndep hMGF)

/-- Tail corollary for independent finite weighted sums over a finite index type. -/
theorem subGaussianTail_weighted_sum_of_iIndepFun_of_pos
    {Omega ι : Type*} [MeasurableSpace Omega] [Fintype ι]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {X : ι -> RealRandomVariable Omega} {K : ι -> ℝ} (a : ι -> ℝ)
    (hX : forall i : ι, IsRealRandomVariable P (X i))
    (hpos : 0 < ∑ i : ι, (a i * K i) ^ 2)
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (hMGF : forall i : ι, CenteredSubGaussianMGF P (X i) (K i)) :
    SubGaussianTail P
      (fun omega => ∑ i : ι, a i * X i omega)
      (2 * Real.sqrt (∑ i : ι, (a i * K i) ^ 2)) := by
  simpa using
    subGaussianTail_finset_weighted_sum_of_iIndepFun_of_pos
      (P := P) (s := Finset.univ) (X := X) (K := K) a
      (fun i _hi => hX i) hpos hIndep (fun i _hi => hMGF i)

end

end HighDimProb
