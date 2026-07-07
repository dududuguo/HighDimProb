import HighDimProb.RandomMatrix.CFCLogResolventRemainderProvider

/-!
# Cutoff-limit bridge for same-eigenbasis CFC.log remainders

This module removes the cutoff only for the explicit remainder already reduced
by `CFCLogResolventRemainderProvider` to the same-eigenbasis diagonal case.
It proves a scalar square-kernel remainder limit and lifts it through the
finite eigenvalue sum.

It does not prove the general two-index `B,C` cutoff limit, Epstein/Lieb
concavity, or any second-derivative sign.
-/

namespace HighDimProb

open scoped MatrixOrder Matrix.Norms.Operator Topology

noncomputable section

namespace LogResolvent

/-- `X` is diagonal in the eigenbasis used to diagonalize the positive base point `M`.

This is a transparent predicate for same-eigenbasis cutoff-remainder leaves. It
packages the repeated conjugation equality without changing the mathematical
hypothesis. -/
abbrev SameEigenbasisDiagonal {n : Nat} (M X : CFCLog.Carrier n) (x : Fin n -> Real) : Prop :=
  star (M.2.isHermitian.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) *
      (X : Matrix (Fin n) (Fin n) Real) *
      (M.2.isHermitian.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) =
    Matrix.diagonal x

/-- Scalar square-kernel cutoff integral for a positive shift.

This is the diagonal kernel identity used by the same-eigenbasis remainder
limit. -/
theorem scalarSquareKernelIntegral
    {a T : Real} (ha : 0 < a) (hT : 0 <= T) :
    ∫ s in (0 : Real)..T, Inv.inv (a + s) * Inv.inv (a + s) =
      Inv.inv a - Inv.inv (a + T) := by
  have hderiv : ∀ x ∈ Set.uIcc (0 : Real) T,
      HasDerivAt (fun y : Real => -Inv.inv (a + y))
        (Inv.inv (a + x) * Inv.inv (a + x)) x := by
    intro x hx
    have hxIcc : x ∈ Set.Icc (0 : Real) T := by
      simpa [Set.uIcc_of_le hT] using hx
    have hnonzero : a + x ≠ 0 := by
      exact ne_of_gt (add_pos_of_pos_of_nonneg ha hxIcc.1)
    have hinner : HasDerivAt (fun y : Real => a + y) 1 x := by
      simpa using (hasDerivAt_id x).const_add a
    have hinv : HasDerivAt (fun y : Real => Inv.inv (a + y))
        (-(1 : Real) / (a + x) ^ 2) x := by
      simpa using hinner.inv hnonzero
    have hneg := hinv.neg
    have hneg' : HasDerivAt (fun y : Real => -Inv.inv (a + y))
        (((a + x) * (a + x))⁻¹) x := by
      simpa [Pi.neg_apply, Inv.inv, one_div, div_eq_mul_inv, pow_two] using hneg
    have hcoeff : ((a + x) * (a + x))⁻¹ =
        Inv.inv (a + x) * Inv.inv (a + x) := by
      field_simp [hnonzero]
    simpa [hcoeff] using hneg'
  have hcontInv : ContinuousOn (fun x : Real => Inv.inv (a + x))
      (Set.uIcc (0 : Real) T) := by
    refine ContinuousOn.inv₀ ((continuous_const.add continuous_id).continuousOn) ?_
    intro x hx
    have hxIcc : x ∈ Set.Icc (0 : Real) T := by
      simpa [Set.uIcc_of_le hT] using hx
    exact ne_of_gt (add_pos_of_pos_of_nonneg ha hxIcc.1)
  have hint : IntervalIntegrable
      (fun x : Real => Inv.inv (a + x) * Inv.inv (a + x))
      MeasureTheory.volume (0 : Real) T := by
    exact (hcontInv.mul hcontInv).intervalIntegrable
  simpa [sub_eq_add_neg, add_comm, add_left_comm, add_assoc] using
    (intervalIntegral.integral_eq_sub_of_hasDerivAt
      (f := fun y : Real => -Inv.inv (a + y))
      (f' := fun y : Real => Inv.inv (a + y) * Inv.inv (a + y))
      hderiv hint)

/-- The scalar diagonal cutoff remainder tends to zero as `T -> +∞`. -/
theorem scalarSquareKernelRemainderTendstoZero {a : Real} (ha : 0 < a) :
    Filter.Tendsto (fun T : Real =>
      Inv.inv a - (∫ s in (0 : Real)..T,
        Inv.inv (a + s) * Inv.inv (a + s)))
      Filter.atTop (𝓝 0) := by
  have hadd : Filter.Tendsto (fun T : Real => a + T) Filter.atTop Filter.atTop := by
    refine Filter.tendsto_atTop.mpr ?_
    intro b
    filter_upwards [Filter.eventually_ge_atTop (b - a)] with T hT
    linarith
  have hinv : Filter.Tendsto (fun T : Real => Inv.inv (a + T))
      Filter.atTop (𝓝 0) := by
    simpa [Inv.inv, Function.comp_def] using (tendsto_inv_atTop_zero.comp hadd)
  refine Filter.Tendsto.congr' ?_ hinv
  filter_upwards [Filter.eventually_ge_atTop (0 : Real)] with T hT
  rw [scalarSquareKernelIntegral ha hT]
  ring

/-- Same-eigenbasis cutoff remainder vanishes as the cutoff goes to infinity.

The hypotheses require `B` and `C` to be diagonal in the eigenbasis of the
strictly positive base point `M`. This is the honest consumer of
`derivSAAtCutoffRemainder_eq_sum_inv_sub_kernel_conjDiagonal_of_strictlyPositive`;
it is not the general two-index remainder limit. -/
theorem sameEigenbasisCutoffRemainderTendstoZero
    {n : Nat} (M B C : CFCLog.Carrier n)
    (hPos : Set.Mem (selfAdjointStrictlyPositiveSet n) M)
    {b c : Fin n -> Real}
    (hB : SameEigenbasisDiagonal M B b)
    (hC : SameEigenbasisDiagonal M C c) :
    Filter.Tendsto (fun T : Real => derivSAAtCutoffRemainder M B C T)
      Filter.atTop (𝓝 0) := by
  have hEigPos : ∀ i, 0 < M.2.isHermitian.eigenvalues i := by
    exact M.2.isHermitian.posDef_iff_eigenvalues_pos.mp
      (Matrix.isStrictlyPositive_iff_posDef.mp (by simpa using hPos))
  have hsum : Filter.Tendsto
      (fun T : Real =>
        Finset.univ.sum (fun i =>
          b i * c i *
            (Inv.inv (M.2.isHermitian.eigenvalues i) -
              (∫ s in (0 : Real)..T,
                Inv.inv (M.2.isHermitian.eigenvalues i + s) *
                  Inv.inv (M.2.isHermitian.eigenvalues i + s)))))
      Filter.atTop (𝓝 0) := by
    classical
    have hsum0 : Filter.Tendsto
        (fun T : Real =>
          Finset.univ.sum (fun i =>
            b i * c i *
              (Inv.inv (M.2.isHermitian.eigenvalues i) -
                (∫ s in (0 : Real)..T,
                  Inv.inv (M.2.isHermitian.eigenvalues i + s) *
                    Inv.inv (M.2.isHermitian.eigenvalues i + s)))))
        Filter.atTop (𝓝 (Finset.univ.sum (fun _i : Fin n => (0 : Real)))) := by
      refine tendsto_finset_sum Finset.univ ?_
      intro i _hi
      have hscalar := scalarSquareKernelRemainderTendstoZero (hEigPos i)
      simpa [mul_zero] using Filter.Tendsto.const_mul (b i * c i) hscalar
    simpa using hsum0
  refine Filter.Tendsto.congr' ?_ hsum
  filter_upwards with T
  rw [derivSAAtCutoffRemainder_eq_sum_inv_sub_kernel_conjDiagonal_of_strictlyPositive
    (M := M) (B := B) (C := C) (hPos := hPos) (T := T) (hB := hB) (hC := hC)]

end LogResolvent

end

end HighDimProb