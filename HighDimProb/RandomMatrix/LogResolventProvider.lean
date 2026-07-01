import HighDimProb.RandomMatrix.CStarBridge
import Mathlib.Analysis.Matrix.HermitianFunctionalCalculus
import Mathlib.Analysis.Matrix.Spectrum
import Mathlib.Analysis.Calculus.Deriv.MeanValue
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
import Mathlib.Analysis.SpecialFunctions.Integrability.Basic
import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic

/-!
# Trace/CFC scalar cutoff-resolvent provider layer

This module exposes only the trace/CFC scalar cutoff-resolvent provider
layer. It is not a Lieb/Epstein sign theorem, and it does not claim
arbitrary-weight cutoff removal or any improper-integral representation.
-/

namespace HighDimProb

noncomputable section

open scoped MatrixOrder Topology

/-- Finite-dimensional Hermitian CFC trace-sum bridge in the `RCLike` setting. -/
theorem trace_cfc_eq_sum_of_isHermitian_RCLike
    {n : Type*} [Fintype n] [DecidableEq n] {𝕜 : Type*} [RCLike 𝕜]
    {M : Matrix n n 𝕜} (hM : M.IsHermitian) (f : Real -> Real) :
    Matrix.trace (cfc f M) = Finset.univ.sum (fun i => (f (hM.eigenvalues i) : 𝕜)) := by
  rw [hM.cfc_eq f, Matrix.IsHermitian.cfc, Unitary.conjStarAlgAut_apply]
  calc
    Matrix.trace
        ((hM.eigenvectorUnitary : Matrix n n 𝕜) *
          Matrix.diagonal (RCLike.ofReal ∘ f ∘ hM.eigenvalues) *
          star (hM.eigenvectorUnitary : Matrix n n 𝕜)) =
        Matrix.trace
          (star (hM.eigenvectorUnitary : Matrix n n 𝕜) *
            (hM.eigenvectorUnitary : Matrix n n 𝕜) *
            Matrix.diagonal (RCLike.ofReal ∘ f ∘ hM.eigenvalues)) := by
      simpa [Matrix.mul_assoc] using
        Matrix.trace_mul_cycle
          (hM.eigenvectorUnitary : Matrix n n 𝕜)
          (Matrix.diagonal (RCLike.ofReal ∘ f ∘ hM.eigenvalues))
          (star (hM.eigenvectorUnitary : Matrix n n 𝕜))
    _ = Matrix.trace (Matrix.diagonal (RCLike.ofReal ∘ f ∘ hM.eigenvalues)) := by
      simp
    _ = Finset.univ.sum (fun i => (f (hM.eigenvalues i) : 𝕜)) := by
      simp [Matrix.trace_diagonal]

/-- Real finite-dimensional specialization of `trace_cfc_eq_sum_of_isHermitian_RCLike`. -/
theorem trace_cfc_eq_sum_of_isHermitian
    {n : Nat} {M : Matrix (Fin n) (Fin n) Real}
    (hM : M.IsHermitian) (f : Real -> Real) :
    Matrix.trace (cfc f M) = Finset.univ.sum (fun i => f (hM.eigenvalues i)) := by
  simpa using trace_cfc_eq_sum_of_isHermitian_RCLike (M := M) hM f

/-- Weighted finite-dimensional Hermitian CFC trace-sum bridge in the `RCLike`
setting. The weights are the diagonal entries of `B` in the eigenbasis of `M`. -/
theorem trace_mul_cfc_eq_sum_conj_diag_of_isHermitian_RCLike
    {n : Type*} [Fintype n] [DecidableEq n] {K : Type*} [RCLike K]
    {M B : Matrix n n K} (hM : M.IsHermitian) (f : Real -> Real) :
    Matrix.trace (B * cfc f M) =
      Finset.univ.sum (fun i =>
        ((star (hM.eigenvectorUnitary : Matrix n n K) * B *
              (hM.eigenvectorUnitary : Matrix n n K)) i i) *
          (f (hM.eigenvalues i) : K)) := by
  rw [hM.cfc_eq f, Matrix.IsHermitian.cfc, Unitary.conjStarAlgAut_apply]
  let U : Matrix n n K := hM.eigenvectorUnitary
  let D : Matrix n n K := Matrix.diagonal (fun i => RCLike.ofReal (f (hM.eigenvalues i)))
  change Matrix.trace (B * (U * D * star U)) =
      Finset.univ.sum (fun i => ((star U * B * U) i i) * (f (hM.eigenvalues i) : K))
  calc
    Matrix.trace (B * (U * D * star U))
        = Matrix.trace ((star U * B * U) * D) := by
            calc
              Matrix.trace (B * (U * D * star U))
                  = Matrix.trace ((B * U) * D * star U) := by simp [Matrix.mul_assoc]
              _ = Matrix.trace (star U * (B * U) * D) := by
                    simpa using Matrix.trace_mul_cycle (B * U) D (star U)
              _ = Matrix.trace ((star U * B * U) * D) := by simp [Matrix.mul_assoc]
    _ = Finset.univ.sum (fun i => ((star U * B * U) i i) * (f (hM.eigenvalues i) : K)) := by
          simp [D, Matrix.trace, Matrix.mul_apply, Matrix.diagonal]

/-- Real weighted specialization of
`trace_mul_cfc_eq_sum_conj_diag_of_isHermitian_RCLike`. -/
theorem trace_mul_cfc_eq_sum_conj_diag_of_isHermitian
    {n : Nat} {M B : Matrix (Fin n) (Fin n) Real}
    (hM : M.IsHermitian) (f : Real -> Real) :
    Matrix.trace (B * cfc f M) =
      Finset.univ.sum (fun i =>
        ((star (hM.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) * B *
              (hM.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real)) i i) *
          f (hM.eigenvalues i)) := by
  simpa using
    trace_mul_cfc_eq_sum_conj_diag_of_isHermitian_RCLike (M := M) (B := B) hM f

/-- Trace of the inverse of a strictly positive Hermitian matrix after an
identity shift as a finite sum of shifted scalar inverses. -/
theorem trace_inv_add_const_eq_sum_inv_of_isHermitian_of_strictlyPositive
    {n : Nat} {A : Matrix (Fin n) (Fin n) Real}
    (hA : A.IsHermitian)
    (hPos : IsStrictlyPositive A) (s : Real) (hs : 0 <= s) :
    Matrix.trace (Inv.inv (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real))) =
      Finset.univ.sum (fun i => Inv.inv (hA.eigenvalues i + s)) := by
  have hShift :
      cfc (fun x : Real => x + s) A =
        A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real) := by
    calc
      cfc (fun x : Real => x + s) A
          = cfc (fun x : Real => x) A + cfc (fun _ : Real => s) A := by
              rw [cfc_add (R := Real) (a := A) (fun x : Real => x) (fun _ : Real => s)]
      _ = A + cfc (fun _ : Real => s) A := by
            simpa using congrArg (fun X => X + cfc (fun _ : Real => s) A)
              (cfc_id' (R := Real) (a := A) (ha := hA))
      _ = A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real) := by
            simpa [Algebra.algebraMap_eq_smul_one] using congrArg (fun X => A + X)
              (cfc_const (R := Real) s A (ha := hA))
  have hEigPos : forall i, 0 < hA.eigenvalues i := by
    exact hA.posDef_iff_eigenvalues_pos.mp (Matrix.isStrictlyPositive_iff_posDef.mp hPos)
  have hInv :
      cfc (fun x : Real => Inv.inv (x + s)) A =
        Ring.inverse (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real)) := by
    calc
      cfc (fun x : Real => Inv.inv (x + s)) A
          = Ring.inverse (cfc (fun x : Real => x + s) A) := by
              simpa using
                (cfc_inv (R := Real) (a := A) (f := fun x : Real => x + s)
                  (ha := hA) (hf' := by
                    intro x hx
                    rw [hA.spectrum_real_eq_range_eigenvalues] at hx
                    have hmem : Exists (fun i => hA.eigenvalues i = x) := by
                      simpa [Set.mem_range] using hx
                    cases hmem with
                    | intro i hi =>
                        simpa [hi] using
                          (ne_of_gt (add_pos_of_pos_of_nonneg (hEigPos i) hs) :
                            Ne (hA.eigenvalues i + s) 0)))
      _ = Ring.inverse (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real)) := by
            exact congrArg Ring.inverse hShift
  have hTraceInv :
      Matrix.trace (Inv.inv (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real))) =
        Matrix.trace (Ring.inverse (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real))) := by
    rw [<- Matrix.nonsing_inv_eq_ringInverse]
  calc
    Matrix.trace (Inv.inv (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real)))
        = Matrix.trace (Ring.inverse (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real))) := hTraceInv
    _ = Matrix.trace (cfc (fun x : Real => Inv.inv (x + s)) A) := by
          rw [hInv]
    _ = Finset.univ.sum (fun i => Inv.inv (hA.eigenvalues i + s)) := by
          simpa using trace_cfc_eq_sum_of_isHermitian hA (fun x => Inv.inv (x + s))

/-- Scalar trace-resolvent integrand along an affine matrix line. -/
noncomputable def traceMulResolventAffineLine
    {n : Nat} (A B C : Matrix (Fin n) (Fin n) Real) (t : Real) : Real :=
  Matrix.trace (B * (A + SMul.smul t C)⁻¹)

/-- Finite-cutoff trace-resolvent prototype for the log-resolvent route. -/
noncomputable def traceMulResolventCutoff
    {n : Nat} (A B C : Matrix (Fin n) (Fin n) Real) (T t : Real) : Real :=
  ∫ s in 0..T, Matrix.trace (B * (A + SMul.smul t C + SMul.smul s
    (1 : Matrix (Fin n) (Fin n) Real))⁻¹)

/-- Fixed-cutoff trace-resolvent kernel integral over identity shifts. -/
noncomputable def traceMulResolventKernelCutoff
    {n : Nat} (A B C : Matrix (Fin n) (Fin n) Real) (T : Real) : Real :=
  ∫ s in 0..T,
    Matrix.trace (Inv.inv (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real)) * B *
      Inv.inv (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real)) * C)
/-- Scalar finite-cutoff resolvent integral as a log ratio. -/
theorem integral_inv_add_eq_log_div_of_pos
    {x T : Real} (hx : 0 < x) (hT : 0 <= T) :
    ∫ s in 0..T, (x + s)⁻¹ = Real.log ((x + T) / x) := by
  rw [intervalIntegral.integral_comp_add_left (f := fun u : Real => u⁻¹) (d := x)]
  simpa [add_comm, add_left_comm, add_assoc] using
    (integral_inv_of_pos (a := x) (b := x + T) hx (add_pos_of_pos_of_nonneg hx hT))

/-- Shift the scalar `Real.log` inside `cfc` along an affine identity translate. -/
theorem cfc_log_add_const_eq_of_isHermitian
    {n : Nat} {A : Matrix (Fin n) (Fin n) Real}
    (hA : A.IsHermitian) (t : Real) :
    cfc (fun x : Real => Real.log (x + t)) A =
      cfc Real.log (A + SMul.smul t (1 : Matrix (Fin n) (Fin n) Real)) := by
  have hShift :
      cfc (fun x : Real => x + t) A =
        A + SMul.smul t (1 : Matrix (Fin n) (Fin n) Real) := by
    calc
      cfc (fun x : Real => x + t) A
          = cfc (fun x : Real => x) A + cfc (fun _ : Real => t) A := by
              rw [cfc_add (R := Real) (a := A) (fun x : Real => x) (fun _ : Real => t)]
      _ = A + cfc (fun _ : Real => t) A := by
            simpa using congrArg (fun X => X + cfc (fun _ : Real => t) A)
              (cfc_id' (R := Real) (a := A) (ha := hA))
      _ = A + SMul.smul t (1 : Matrix (Fin n) (Fin n) Real) := by
            simpa [Algebra.algebraMap_eq_smul_one] using congrArg (fun X => A + X)
              (cfc_const (R := Real) t A (ha := hA))
  have hLogCont : ContinuousOn Real.log ((fun x : Real => x + t) '' spectrum ℝ A) := by
    rw [hA.spectrum_real_eq_range_eigenvalues]
    convert (Set.finite_range fun i => hA.eigenvalues i + t).continuousOn Real.log using 1
    ext y
    constructor
    · intro hy
      rcases hy with ⟨ _, ⟨ i, rfl⟩, rfl⟩
      exact ⟨ i, rfl⟩
    · intro hy
      rcases hy with ⟨ i, rfl⟩
      exact ⟨ hA.eigenvalues i, ⟨ i, rfl⟩, rfl⟩
  rw [show A + SMul.smul t (1 : Matrix (Fin n) (Fin n) Real) =
      cfc (fun x : Real => x + t) A by simpa using hShift.symm]
  symm
  rw [← cfc_comp' Real.log (fun x : Real => x + t) A hLogCont]

/-- Trace of the shifted matrix log as the sum of shifted scalar logs. -/
theorem trace_cfcLog_add_const_eq_sum_of_isHermitian
    {n : Nat} {A : Matrix (Fin n) (Fin n) Real}
    (hA : A.IsHermitian) (t : Real) :
    Matrix.trace (cfc Real.log (A + SMul.smul t (1 : Matrix (Fin n) (Fin n) Real))) =
      Finset.univ.sum (fun i => Real.log (hA.eigenvalues i + t)) := by
  rw [← cfc_log_add_const_eq_of_isHermitian (A := A) hA t]
  simpa using trace_cfc_eq_sum_of_isHermitian hA (fun x => Real.log (x + t))

/-- Trace difference between the shifted matrix log and the base matrix log. -/
theorem trace_cfcLog_add_const_sub_trace_cfcLog_eq_sum_log_sub_of_isHermitian
    {n : Nat} {A : Matrix (Fin n) (Fin n) Real}
    (hA : A.IsHermitian) (t : Real) :
    Matrix.trace (cfc Real.log (A + SMul.smul t (1 : Matrix (Fin n) (Fin n) Real))) -
        Matrix.trace (cfc Real.log A) =
      Finset.univ.sum (fun i => (Real.log (hA.eigenvalues i + t) - Real.log (hA.eigenvalues i))) := by
  rw [trace_cfcLog_add_const_eq_sum_of_isHermitian (A := A) hA t,
    trace_cfc_eq_sum_of_isHermitian hA Real.log]
  simp [Finset.sum_sub_distrib]

/-- Identity-weight finite-cutoff resolvent specialization as a finite sum of
scalar log differences. -/
theorem traceMulResolventCutoff_one_zero_eq_sum_log_sub_of_isHermitian_of_strictlyPositive
    {n : Nat} {A : Matrix (Fin n) (Fin n) Real}
    (hA : A.IsHermitian) (hPos : IsStrictlyPositive A)
    {T : Real} (hT : 0 <= T) :
    traceMulResolventCutoff A (1 : Matrix (Fin n) (Fin n) Real)
        (0 : Matrix (Fin n) (Fin n) Real) T 0 =
      Finset.univ.sum
        (fun i => Real.log (hA.eigenvalues i + T) - Real.log (hA.eigenvalues i)) := by
  have hEigPos : forall i, 0 < hA.eigenvalues i := by
    exact hA.posDef_iff_eigenvalues_pos.mp (Matrix.isStrictlyPositive_iff_posDef.mp hPos)
  have hInt :
      forall i : Fin n,
        IntervalIntegrable
          (fun s : Real => Inv.inv (hA.eigenvalues i + s))
          MeasureTheory.volume 0 T := by
    intro i
    refine intervalIntegral.intervalIntegrable_inv
      (fun s hs => by
        have hsIcc : s ∈ Set.Icc (0 : Real) T := by
          simpa [Set.uIcc_of_le hT] using hs
        exact ne_of_gt (add_pos_of_pos_of_nonneg (hEigPos i) hsIcc.1))
      ((continuous_const.add continuous_id).continuousOn)
  rw [traceMulResolventCutoff]
  calc
    ∫ s in (0 : Real)..T,
        Matrix.trace
          ((1 : Matrix (Fin n) (Fin n) Real) *
            Inv.inv
              (A + SMul.smul (0 : Real) (0 : Matrix (Fin n) (Fin n) Real) +
                SMul.smul s (1 : Matrix (Fin n) (Fin n) Real))) =
        ∫ s in (0 : Real)..T,
          Matrix.trace (Inv.inv (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real))) := by
      refine intervalIntegral.integral_congr ?_
      intro s hs
      have hzero :
          SMul.smul (0 : Real) (0 : Matrix (Fin n) (Fin n) Real) =
            (0 : Matrix (Fin n) (Fin n) Real) := by
        change (0 : Real) • (0 : Matrix (Fin n) (Fin n) Real) =
          (0 : Matrix (Fin n) (Fin n) Real)
        simp
      have harg :
          A + SMul.smul (0 : Real) (0 : Matrix (Fin n) (Fin n) Real) +
              SMul.smul s (1 : Matrix (Fin n) (Fin n) Real) =
            A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real) := by
        calc
          A + SMul.smul (0 : Real) (0 : Matrix (Fin n) (Fin n) Real) +
              SMul.smul s (1 : Matrix (Fin n) (Fin n) Real) =
              A + 0 + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real) := by rw [hzero]
          _ = A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real) := by simp
      change
        Matrix.trace
          ((1 : Matrix (Fin n) (Fin n) Real) *
            Inv.inv
              (A + SMul.smul (0 : Real) (0 : Matrix (Fin n) (Fin n) Real) +
                SMul.smul s (1 : Matrix (Fin n) (Fin n) Real))) =
          Matrix.trace (Inv.inv (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real)))
      simp [harg]
    _ = ∫ s in (0 : Real)..T,
          Finset.univ.sum (fun i => Inv.inv (hA.eigenvalues i + s)) := by
      refine intervalIntegral.integral_congr ?_
      intro s hs
      have hsIcc : s ∈ Set.Icc (0 : Real) T := by
        simpa [Set.uIcc_of_le hT] using hs
      simpa using
        trace_inv_add_const_eq_sum_inv_of_isHermitian_of_strictlyPositive
          hA hPos s hsIcc.1
    _ = Finset.univ.sum
          (fun i => ∫ s in (0 : Real)..T, Inv.inv (hA.eigenvalues i + s)) := by
      simpa using
        (intervalIntegral.integral_finset_sum
          (μ := MeasureTheory.volume)
          (a := (0 : Real)) (b := T)
          (s := Finset.univ)
          (f := fun i s => Inv.inv (hA.eigenvalues i + s))
          (fun i _hi => hInt i))
    _ = Finset.univ.sum (fun i => Real.log ((hA.eigenvalues i + T) / hA.eigenvalues i)) := by
      refine Finset.sum_congr rfl ?_
      intro i _hi
      simpa using
        integral_inv_add_eq_log_div_of_pos (x := hA.eigenvalues i) (T := T) (hEigPos i) hT
    _ = Finset.univ.sum
          (fun i => Real.log (hA.eigenvalues i + T) - Real.log (hA.eigenvalues i)) := by
      refine Finset.sum_congr rfl ?_
      intro i _hi
      rw [Real.log_div]
      · exact ne_of_gt (add_pos_of_pos_of_nonneg (hEigPos i) hT)
      · exact ne_of_gt (hEigPos i)

/-- Identity-weight finite-cutoff resolvent specialization as the corresponding
trace-`CFC.log` difference. -/
theorem traceMulResolventCutoff_one_zero_eq_trace_cfcLog_sub_of_isHermitian_of_strictlyPositive
    {n : Nat} {A : Matrix (Fin n) (Fin n) Real}
    (hA : A.IsHermitian) (hPos : IsStrictlyPositive A)
    {T : Real} (hT : 0 <= T) :
    traceMulResolventCutoff A (1 : Matrix (Fin n) (Fin n) Real)
        (0 : Matrix (Fin n) (Fin n) Real) T 0 =
      Matrix.trace (cfc Real.log (A + SMul.smul T (1 : Matrix (Fin n) (Fin n) Real))) -
        Matrix.trace (cfc Real.log A) := by
  rw [traceMulResolventCutoff_one_zero_eq_sum_log_sub_of_isHermitian_of_strictlyPositive
        hA hPos hT,
      ← trace_cfcLog_add_const_sub_trace_cfcLog_eq_sum_log_sub_of_isHermitian
        (A := A) hA T]

/-- Weighted trace of the inverse of a strictly positive Hermitian matrix after
an identity shift as a finite eigenbasis sum. -/
theorem trace_mul_inv_add_const_eq_sum_weighted_inv_of_isHermitian_of_strictlyPositive
    {n : Nat} {A B : Matrix (Fin n) (Fin n) Real}
    (hA : A.IsHermitian)
    (hPos : IsStrictlyPositive A) (s : Real) (hs : 0 <= s) :
    Matrix.trace (B * Inv.inv (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real))) =
      Finset.univ.sum (fun i =>
        ((star (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) * B *
              (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real)) i i) *
          Inv.inv (hA.eigenvalues i + s)) := by
  have hShift :
      cfc (fun x : Real => x + s) A =
        A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real) := by
    calc
      cfc (fun x : Real => x + s) A
          = cfc (fun x : Real => x) A + cfc (fun _ : Real => s) A := by
              rw [cfc_add (R := Real) (a := A) (fun x : Real => x) (fun _ : Real => s)]
      _ = A + cfc (fun _ : Real => s) A := by
            simpa using congrArg (fun X => X + cfc (fun _ : Real => s) A)
              (cfc_id' (R := Real) (a := A) (ha := hA))
      _ = A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real) := by
            simpa [Algebra.algebraMap_eq_smul_one] using congrArg (fun X => A + X)
              (cfc_const (R := Real) s A (ha := hA))
  have hEigPos : forall i, 0 < hA.eigenvalues i := by
    exact hA.posDef_iff_eigenvalues_pos.mp (Matrix.isStrictlyPositive_iff_posDef.mp hPos)
  have hInv :
      cfc (fun x : Real => Inv.inv (x + s)) A =
        Ring.inverse (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real)) := by
    calc
      cfc (fun x : Real => Inv.inv (x + s)) A
          = Ring.inverse (cfc (fun x : Real => x + s) A) := by
              simpa using
                (cfc_inv (R := Real) (a := A) (f := fun x : Real => x + s)
                  (ha := hA) (hf' := by
                    intro x hx
                    rw [hA.spectrum_real_eq_range_eigenvalues] at hx
                    have hmem : Exists (fun i => hA.eigenvalues i = x) := by
                      simpa [Set.mem_range] using hx
                    cases hmem with
                    | intro i hi =>
                        simpa [hi] using
                          (ne_of_gt (add_pos_of_pos_of_nonneg (hEigPos i) hs) :
                            Ne (hA.eigenvalues i + s) 0)))
      _ = Ring.inverse (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real)) := by
            exact congrArg Ring.inverse hShift
  calc
    Matrix.trace (B * Inv.inv (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real)))
        = Matrix.trace (B * Ring.inverse (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real))) := by
            rw [<- Matrix.nonsing_inv_eq_ringInverse]
    _ = Matrix.trace (B * cfc (fun x : Real => Inv.inv (x + s)) A) := by
          rw [hInv]
    _ = Finset.univ.sum (fun i =>
        ((star (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) * B *
              (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real)) i i) *
          Inv.inv (hA.eigenvalues i + s)) := by
          simpa using
            trace_mul_cfc_eq_sum_conj_diag_of_isHermitian (M := A) (B := B) hA
              (fun x => Inv.inv (x + s))

/-- Fixed-shift resolvent kernel trace pairing as a conjugated-basis double sum.
This is the pointwise kernel formula later integrated by
`traceMulResolventKernelCutoff_eq_sum_integral_conj_entries_of_isHermitian_of_strictlyPositive`. -/
theorem trace_resolvent_kernel_eq_sum_conj_entries_of_isHermitian_of_strictlyPositive
    {n : Nat} {A B C : Matrix (Fin n) (Fin n) Real}
    (hA : A.IsHermitian) (hPos : IsStrictlyPositive A) (s : Real) (hs : 0 <= s) :
    Matrix.trace (Inv.inv (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real)) * B *
      Inv.inv (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real)) * C) =
      Finset.univ.sum (fun p => Finset.univ.sum (fun q =>
        ((star (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) * B *
              (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real)) p q) *
          ((star (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) * C *
              (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real)) q p) *
          Inv.inv (hA.eigenvalues p + s) *
          Inv.inv (hA.eigenvalues q + s))) := by
  let U : Matrix (Fin n) (Fin n) Real := hA.eigenvectorUnitary
  let D : Matrix (Fin n) (Fin n) Real :=
    Matrix.diagonal (fun i => Inv.inv (hA.eigenvalues i + s))
  let B' : Matrix (Fin n) (Fin n) Real := star U * B * U
  let C' : Matrix (Fin n) (Fin n) Real := star U * C * U
  have hShift :
      cfc (fun x : Real => x + s) A =
        A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real) := by
    calc
      cfc (fun x : Real => x + s) A
          = cfc (fun x : Real => x) A + cfc (fun _ : Real => s) A := by
              rw [cfc_add (R := Real) (a := A) (fun x : Real => x) (fun _ : Real => s)]
      _ = A + cfc (fun _ : Real => s) A := by
            simpa using congrArg (fun X => X + cfc (fun _ : Real => s) A)
              (cfc_id' (R := Real) (a := A) (ha := hA))
      _ = A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real) := by
            simpa [Algebra.algebraMap_eq_smul_one] using congrArg (fun X => A + X)
              (cfc_const (R := Real) s A (ha := hA))
  have hEigPos : forall i, 0 < hA.eigenvalues i := by
    exact hA.posDef_iff_eigenvalues_pos.mp (Matrix.isStrictlyPositive_iff_posDef.mp hPos)
  have hInv :
      cfc (fun x : Real => Inv.inv (x + s)) A =
        Ring.inverse (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real)) := by
    calc
      cfc (fun x : Real => Inv.inv (x + s)) A
          = Ring.inverse (cfc (fun x : Real => x + s) A) := by
              simpa using
                (cfc_inv (R := Real) (a := A) (f := fun x : Real => x + s)
                  (ha := hA) (hf' := by
                    intro x hx
                    rw [hA.spectrum_real_eq_range_eigenvalues] at hx
                    have hmem : Exists (fun i => hA.eigenvalues i = x) := by
                      simpa [Set.mem_range] using hx
                    cases hmem with
                    | intro i hi =>
                        simpa [hi] using
                          (ne_of_gt (add_pos_of_pos_of_nonneg (hEigPos i) hs) :
                            Ne (hA.eigenvalues i + s) 0)))
      _ = Ring.inverse (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real)) := by
            exact congrArg Ring.inverse hShift
  have hInvDiag :
      Inv.inv (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real)) = U * D * star U := by
    calc
      Inv.inv (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real))
          = Ring.inverse (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real)) := by
              rw [<- Matrix.nonsing_inv_eq_ringInverse]
      _ = cfc (fun x : Real => Inv.inv (x + s)) A := by
            rw [<- hInv]
      _ = U * D * star U := by
            rw [hA.cfc_eq (fun x : Real => Inv.inv (x + s)), Matrix.IsHermitian.cfc,
              Unitary.conjStarAlgAut_apply]
            ext i j
            simp [U, D, Matrix.mul_apply, Matrix.diagonal]
  calc
    Matrix.trace (Inv.inv (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real)) * B *
        Inv.inv (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real)) * C)
        = Matrix.trace ((U * D * star U) * B * (U * D * star U) * C) := by
            simp [hInvDiag, Matrix.mul_assoc]
    _ = Matrix.trace (B' * D * C' * D) := by
          simpa [B', C', Matrix.mul_assoc] using
            Matrix.trace_mul_cycle U D (star U * B * U * D * star U * C)
    _ = Matrix.trace (B' * (D * C' * D)) := by
          simp [Matrix.mul_assoc]
    _ = Finset.univ.sum (fun p => Finset.univ.sum (fun q => B' p q * ((D * C' * D) q p))) := by
          simp [Matrix.trace, Matrix.mul_apply]
    _ = Finset.univ.sum (fun p => Finset.univ.sum (fun q =>
          B' p q * (D q q * C' q p * D p p))) := by
          refine Finset.sum_congr rfl ?_
          intro p _hp
          refine Finset.sum_congr rfl ?_
          intro q _hq
          simp [D, Matrix.mul_apply, Matrix.diagonal, mul_assoc]
    _ = Finset.univ.sum (fun p => Finset.univ.sum (fun q =>
          B' p q * C' q p * Inv.inv (hA.eigenvalues p + s) *
            Inv.inv (hA.eigenvalues q + s))) := by
          refine Finset.sum_congr rfl ?_
          intro p _hp
          refine Finset.sum_congr rfl ?_
          intro q _hq
          simp [D]
          ring
    _ = Finset.univ.sum (fun p => Finset.univ.sum (fun q =>
          ((star (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) * B *
                (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real)) p q) *
            ((star (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) * C *
                (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real)) q p) *
            Inv.inv (hA.eigenvalues p + s) *
            Inv.inv (hA.eigenvalues q + s))) := by
          simp [B', C']
          ring

/-- Fixed-cutoff resolvent-kernel integral as a finite double sum in the
eigenbasis of the Hermitian base matrix. The coefficient is kept outside the
interval integral for downstream resolvent-kernel adapters. -/
theorem traceMulResolventKernelCutoff_eq_sum_integral_conj_entries_of_isHermitian_of_strictlyPositive
    {n : Nat} {A B C : Matrix (Fin n) (Fin n) Real}
    (hA : A.IsHermitian) (hPos : IsStrictlyPositive A)
    {T : Real} (hT : 0 <= T) :
    traceMulResolventKernelCutoff A B C T =
      Finset.univ.sum (fun p => Finset.univ.sum (fun q =>
        ((star (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) * B *
              (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real)) p q) *
          ((star (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) * C *
              (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real)) q p) *
          (∫ s in (0 : Real)..T,
            Inv.inv (hA.eigenvalues p + s) * Inv.inv (hA.eigenvalues q + s)))) := by
  have hEigPos : forall i, 0 < hA.eigenvalues i := by
    exact hA.posDef_iff_eigenvalues_pos.mp (Matrix.isStrictlyPositive_iff_posDef.mp hPos)
  let W : Fin n -> Fin n -> Real := fun p q =>
    ((star (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) * B *
          (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real)) p q) *
      ((star (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) * C *
          (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real)) q p)
  have hInvCont :
      forall i : Fin n,
        ContinuousOn
          (fun s : Real => Inv.inv (hA.eigenvalues i + s))
          (Set.Icc (0 : Real) T) := by
    intro i
    have hAddCont :
        ContinuousOn (fun s : Real => hA.eigenvalues i + s) (Set.Icc (0 : Real) T) :=
      (continuous_const.add continuous_id).continuousOn
    have hMapsTo :
        Set.MapsTo (fun s : Real => hA.eigenvalues i + s)
          (Set.Icc (0 : Real) T) ({0}ᶜ : Set Real) := by
      intro s hs
      simp only [Set.mem_compl_iff, Set.mem_singleton_iff]
      exact ne_of_gt (add_pos_of_pos_of_nonneg (hEigPos i) hs.1)
    exact ContinuousOn.comp continuousOn_inv₀ hAddCont hMapsTo
  have hInt :
      forall p q : Fin n,
        IntervalIntegrable
          (fun s : Real =>
            W p q * Inv.inv (hA.eigenvalues p + s) * Inv.inv (hA.eigenvalues q + s))
          MeasureTheory.volume 0 T := by
    intro p q
    exact (((hInvCont p).const_mul (W p q)).mul (hInvCont q)).intervalIntegrable_of_Icc hT
  have hIntInner :
      forall p : Fin n,
        IntervalIntegrable
          (fun s : Real =>
            Finset.univ.sum (fun q =>
              W p q * Inv.inv (hA.eigenvalues p + s) * Inv.inv (hA.eigenvalues q + s)))
          MeasureTheory.volume 0 T := by
    intro p
    convert
      (IntervalIntegrable.sum
        (s := Finset.univ)
        (f := fun q s =>
          W p q * Inv.inv (hA.eigenvalues p + s) * Inv.inv (hA.eigenvalues q + s))
        (h := fun q _hq => hInt p q)) using 1
    funext s
    simp
  rw [traceMulResolventKernelCutoff]
  calc
    ∫ s in (0 : Real)..T,
        Matrix.trace (Inv.inv (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real)) * B *
          Inv.inv (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real)) * C) =
      ∫ s in (0 : Real)..T,
        Finset.univ.sum (fun p => Finset.univ.sum (fun q =>
          W p q * Inv.inv (hA.eigenvalues p + s) * Inv.inv (hA.eigenvalues q + s))) := by
      refine intervalIntegral.integral_congr ?_
      intro s hs
      have hsIcc : s ∈ Set.Icc (0 : Real) T := by
        simpa [Set.uIcc_of_le hT] using hs
      simpa [W] using
        trace_resolvent_kernel_eq_sum_conj_entries_of_isHermitian_of_strictlyPositive
          (A := A) (B := B) (C := C) hA hPos s hsIcc.1
    _ = Finset.univ.sum (fun p =>
          ∫ s in (0 : Real)..T,
            Finset.univ.sum (fun q =>
              W p q * Inv.inv (hA.eigenvalues p + s) * Inv.inv (hA.eigenvalues q + s))) := by
      simpa using
        (intervalIntegral.integral_finset_sum
          (μ := MeasureTheory.volume)
          (a := (0 : Real)) (b := T)
          (s := Finset.univ)
          (f := fun p s =>
            Finset.univ.sum (fun q =>
              W p q * Inv.inv (hA.eigenvalues p + s) * Inv.inv (hA.eigenvalues q + s)))
          (fun p _hp => hIntInner p))
    _ = Finset.univ.sum (fun p => Finset.univ.sum (fun q =>
          ∫ s in (0 : Real)..T,
            W p q * Inv.inv (hA.eigenvalues p + s) * Inv.inv (hA.eigenvalues q + s))) := by
      refine Finset.sum_congr rfl ?_
      intro p _hp
      simpa using
        (intervalIntegral.integral_finset_sum
          (μ := MeasureTheory.volume)
          (a := (0 : Real)) (b := T)
          (s := Finset.univ)
          (f := fun q s =>
            W p q * Inv.inv (hA.eigenvalues p + s) * Inv.inv (hA.eigenvalues q + s))
          (fun q _hq => hInt p q))
    _ = Finset.univ.sum (fun p => Finset.univ.sum (fun q =>
          ∫ s in (0 : Real)..T,
            W p q * (Inv.inv (hA.eigenvalues p + s) * Inv.inv (hA.eigenvalues q + s)))) := by
      refine Finset.sum_congr rfl ?_
      intro p _hp
      refine Finset.sum_congr rfl ?_
      intro q _hq
      refine intervalIntegral.integral_congr ?_
      intro s _hs
      simp [mul_assoc]
    _ = Finset.univ.sum (fun p => Finset.univ.sum (fun q =>
          W p q *
            (∫ s in (0 : Real)..T,
              Inv.inv (hA.eigenvalues p + s) * Inv.inv (hA.eigenvalues q + s)))) := by
      refine Finset.sum_congr rfl ?_
      intro p _hp
      refine Finset.sum_congr rfl ?_
      intro q _hq
      rw [intervalIntegral.integral_const_mul]
    _ = Finset.univ.sum (fun p => Finset.univ.sum (fun q =>
          ((star (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) * B *
                (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real)) p q) *
            ((star (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) * C *
                (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real)) q p) *
            (∫ s in (0 : Real)..T,
              Inv.inv (hA.eigenvalues p + s) * Inv.inv (hA.eigenvalues q + s)))) := by
      simp [W]
/-- Weighted trace difference between the shifted matrix log and the base matrix
log, expressed in the eigenbasis of the base Hermitian matrix. -/
theorem trace_mul_cfcLog_add_const_sub_trace_mul_cfcLog_eq_sum_weighted_log_sub_of_isHermitian
    {n : Nat} {A B : Matrix (Fin n) (Fin n) Real}
    (hA : A.IsHermitian) (t : Real) :
    Matrix.trace (B * cfc Real.log (A + SMul.smul t (1 : Matrix (Fin n) (Fin n) Real))) -
        Matrix.trace (B * cfc Real.log A) =
      Finset.univ.sum (fun i =>
        ((star (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) * B *
              (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real)) i i) *
          (Real.log (hA.eigenvalues i + t) - Real.log (hA.eigenvalues i))) := by
  rw [<- cfc_log_add_const_eq_of_isHermitian (A := A) hA t]
  rw [trace_mul_cfc_eq_sum_conj_diag_of_isHermitian (M := A) (B := B) hA
      (fun x => Real.log (x + t)),
    trace_mul_cfc_eq_sum_conj_diag_of_isHermitian (M := A) (B := B) hA Real.log]
  rw [<- Finset.sum_sub_distrib]
  refine Finset.sum_congr rfl ?_
  intro i _hi
  ring

/-- Weighted identity-shift finite-cutoff resolvent specialization as a finite
sum of weighted scalar log differences. -/
theorem traceMulResolventCutoff_weight_zero_eq_sum_weighted_log_sub_of_isHermitian_of_strictlyPositive
    {n : Nat} {A B : Matrix (Fin n) (Fin n) Real}
    (hA : A.IsHermitian) (hPos : IsStrictlyPositive A)
    {T : Real} (hT : 0 <= T) :
    traceMulResolventCutoff A B (0 : Matrix (Fin n) (Fin n) Real) T 0 =
      Finset.univ.sum (fun i =>
        ((star (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) * B *
              (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real)) i i) *
          (Real.log (hA.eigenvalues i + T) - Real.log (hA.eigenvalues i))) := by
  have hEigPos : forall i, 0 < hA.eigenvalues i := by
    exact hA.posDef_iff_eigenvalues_pos.mp (Matrix.isStrictlyPositive_iff_posDef.mp hPos)
  let W : Fin n -> Real := fun i =>
    ((star (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) * B *
        (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real)) i i)
  have hBaseInt :
      forall i : Fin n,
        IntervalIntegrable
          (fun s : Real => Inv.inv (hA.eigenvalues i + s))
          MeasureTheory.volume 0 T := by
    intro i
    refine intervalIntegral.intervalIntegrable_inv ?_ ((continuous_const.add continuous_id).continuousOn)
    intro s hs
    have hsIcc := by
      simpa [Set.uIcc_of_le hT] using hs
    exact ne_of_gt (add_pos_of_pos_of_nonneg (hEigPos i) hsIcc.1)
  have hInt :
      forall i : Fin n,
        IntervalIntegrable
          (fun s : Real => W i * Inv.inv (hA.eigenvalues i + s))
          MeasureTheory.volume 0 T := by
    intro i
    exact (hBaseInt i).const_mul (W i)
  rw [traceMulResolventCutoff]
  calc
    ∫ s in (0 : Real)..T,
        Matrix.trace
          (B * Inv.inv
            (A + SMul.smul (0 : Real) (0 : Matrix (Fin n) (Fin n) Real) +
              SMul.smul s (1 : Matrix (Fin n) (Fin n) Real)))
        = ∫ s in (0 : Real)..T,
          Matrix.trace (B * Inv.inv (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real))) := by
      refine intervalIntegral.integral_congr ?_
      intro s _hs
      have hzero :
          SMul.smul (0 : Real) (0 : Matrix (Fin n) (Fin n) Real) =
            (0 : Matrix (Fin n) (Fin n) Real) := by
        change (0 : Real) • (0 : Matrix (Fin n) (Fin n) Real) =
          (0 : Matrix (Fin n) (Fin n) Real)
        simp
      have harg :
          A + SMul.smul (0 : Real) (0 : Matrix (Fin n) (Fin n) Real) +
              SMul.smul s (1 : Matrix (Fin n) (Fin n) Real) =
            A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real) := by
        calc
          A + SMul.smul (0 : Real) (0 : Matrix (Fin n) (Fin n) Real) +
              SMul.smul s (1 : Matrix (Fin n) (Fin n) Real) =
              A + 0 + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real) := by rw [hzero]
          _ = A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real) := by simp
      change
        Matrix.trace
          (B * Inv.inv
            (A + SMul.smul (0 : Real) (0 : Matrix (Fin n) (Fin n) Real) +
              SMul.smul s (1 : Matrix (Fin n) (Fin n) Real))) =
          Matrix.trace (B * Inv.inv (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real)))
      simp [harg]
    _ = ∫ s in (0 : Real)..T,
          Finset.univ.sum (fun i => W i * Inv.inv (hA.eigenvalues i + s)) := by
      refine intervalIntegral.integral_congr ?_
      intro s hs
      have hsIcc := by
        simpa [Set.uIcc_of_le hT] using hs
      simpa [W] using
        trace_mul_inv_add_const_eq_sum_weighted_inv_of_isHermitian_of_strictlyPositive
          (A := A) (B := B) hA hPos s hsIcc.1
    _ = Finset.univ.sum
          (fun i => ∫ s in (0 : Real)..T, W i * Inv.inv (hA.eigenvalues i + s)) := by
      simpa using
        (intervalIntegral.integral_finset_sum
          (μ := MeasureTheory.volume)
          (a := (0 : Real)) (b := T)
          (s := Finset.univ)
          (f := fun i s => W i * Inv.inv (hA.eigenvalues i + s))
          (fun i _hi => hInt i))
    _ = Finset.univ.sum
          (fun i => W i * (∫ s in (0 : Real)..T, Inv.inv (hA.eigenvalues i + s))) := by
      refine Finset.sum_congr rfl ?_
      intro i _hi
      rw [intervalIntegral.integral_const_mul]
    _ = Finset.univ.sum
          (fun i => W i * Real.log ((hA.eigenvalues i + T) / hA.eigenvalues i)) := by
      refine Finset.sum_congr rfl ?_
      intro i _hi
      rw [integral_inv_add_eq_log_div_of_pos (x := hA.eigenvalues i) (T := T) (hEigPos i) hT]
    _ = Finset.univ.sum
          (fun i => W i * (Real.log (hA.eigenvalues i + T) - Real.log (hA.eigenvalues i))) := by
      refine Finset.sum_congr rfl ?_
      intro i _hi
      rw [Real.log_div
        (ne_of_gt (add_pos_of_pos_of_nonneg (hEigPos i) hT))
        (ne_of_gt (hEigPos i))]

/-- Weighted identity-shift finite-cutoff resolvent specialization as the
corresponding weighted trace-`CFC.log` difference. -/
theorem traceMulResolventCutoff_weight_zero_eq_trace_mul_cfcLog_sub_of_isHermitian_of_strictlyPositive
    {n : Nat} {A B : Matrix (Fin n) (Fin n) Real}
    (hA : A.IsHermitian) (hPos : IsStrictlyPositive A)
    {T : Real} (hT : 0 <= T) :
    traceMulResolventCutoff A B (0 : Matrix (Fin n) (Fin n) Real) T 0 =
      Matrix.trace (B * cfc Real.log (A + SMul.smul T (1 : Matrix (Fin n) (Fin n) Real))) -
        Matrix.trace (B * cfc Real.log A) := by
  rw [traceMulResolventCutoff_weight_zero_eq_sum_weighted_log_sub_of_isHermitian_of_strictlyPositive
        hA hPos hT,
      <- trace_mul_cfcLog_add_const_sub_trace_mul_cfcLog_eq_sum_weighted_log_sub_of_isHermitian
        (A := A) (B := B) hA T]

/- Short, namespaced API aliases for the identity-weight trace-log resolvent
cutoff package. The long theorem names above remain descriptive compatibility
surface; these aliases are the preferred downstream entry points. -/
namespace LogResolvent

/-- Short alias for the fixed-shift resolvent-kernel conjugated-basis double-sum formula. -/
theorem kernelFixedSum
    {n : Nat} {A B C : Matrix (Fin n) (Fin n) Real}
    (hA : A.IsHermitian) (hPos : IsStrictlyPositive A) (s : Real) (hs : 0 <= s) :
    Matrix.trace (Inv.inv (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real)) * B *
      Inv.inv (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real)) * C) =
      Finset.univ.sum (fun p => Finset.univ.sum (fun q =>
        ((star (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) * B *
              (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real)) p q) *
          ((star (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) * C *
              (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real)) q p) *
          Inv.inv (hA.eigenvalues p + s) *
          Inv.inv (hA.eigenvalues q + s))) :=
  trace_resolvent_kernel_eq_sum_conj_entries_of_isHermitian_of_strictlyPositive
    hA hPos s hs

/-- Short alias for the fixed-cutoff resolvent-kernel double-sum formula. -/
theorem kernelCutoffSum
    {n : Nat} {A B C : Matrix (Fin n) (Fin n) Real}
    (hA : A.IsHermitian) (hPos : IsStrictlyPositive A)
    {T : Real} (hT : 0 <= T) :
    traceMulResolventKernelCutoff A B C T =
      Finset.univ.sum (fun p => Finset.univ.sum (fun q =>
        ((star (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) * B *
              (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real)) p q) *
          ((star (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) * C *
              (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real)) q p) *
          (∫ s in (0 : Real)..T,
            Inv.inv (hA.eigenvalues p + s) * Inv.inv (hA.eigenvalues q + s)))) :=
  traceMulResolventKernelCutoff_eq_sum_integral_conj_entries_of_isHermitian_of_strictlyPositive
    hA hPos hT

/-- Trace of a shifted inverse as a finite eigenvalue sum. -/
theorem shiftedInvTraceSum
    {n : Nat} {A : Matrix (Fin n) (Fin n) Real}
    (hA : A.IsHermitian)
    (hPos : IsStrictlyPositive A) (s : Real) (hs : 0 <= s) :
    Matrix.trace (Inv.inv (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real))) =
      Finset.univ.sum (fun i => Inv.inv (hA.eigenvalues i + s)) :=
  trace_inv_add_const_eq_sum_inv_of_isHermitian_of_strictlyPositive hA hPos s hs

/-- Identity-weight finite cutoff as a finite sum of scalar log differences. -/
theorem identityCutoffSum
    {n : Nat} {A : Matrix (Fin n) (Fin n) Real}
    (hA : A.IsHermitian) (hPos : IsStrictlyPositive A)
    {T : Real} (hT : 0 <= T) :
    traceMulResolventCutoff A (1 : Matrix (Fin n) (Fin n) Real)
        (0 : Matrix (Fin n) (Fin n) Real) T 0 =
      Finset.univ.sum
        (fun i => Real.log (hA.eigenvalues i + T) - Real.log (hA.eigenvalues i)) :=
  traceMulResolventCutoff_one_zero_eq_sum_log_sub_of_isHermitian_of_strictlyPositive
    hA hPos hT

/-- Weighted finite cutoff as a finite sum of scalar log differences in the
base eigenbasis. -/
theorem weightedCutoffSum
    {n : Nat} {A B : Matrix (Fin n) (Fin n) Real}
    (hA : A.IsHermitian) (hPos : IsStrictlyPositive A)
    {T : Real} (hT : 0 <= T) :
    traceMulResolventCutoff A B (0 : Matrix (Fin n) (Fin n) Real) T 0 =
      Finset.univ.sum (fun i =>
        ((star (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) * B *
              (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real)) i i) *
          (Real.log (hA.eigenvalues i + T) - Real.log (hA.eigenvalues i))) :=
  traceMulResolventCutoff_weight_zero_eq_sum_weighted_log_sub_of_isHermitian_of_strictlyPositive
    hA hPos hT

/-- Identity-weight finite cutoff as the corresponding trace-`CFC.log`
difference. -/
theorem identityCutoffTraceLogSub
    {n : Nat} {A : Matrix (Fin n) (Fin n) Real}
    (hA : A.IsHermitian) (hPos : IsStrictlyPositive A)
    {T : Real} (hT : 0 <= T) :
    traceMulResolventCutoff A (1 : Matrix (Fin n) (Fin n) Real)
        (0 : Matrix (Fin n) (Fin n) Real) T 0 =
      Matrix.trace (cfc Real.log (A + SMul.smul T (1 : Matrix (Fin n) (Fin n) Real))) -
        Matrix.trace (cfc Real.log A) :=
  traceMulResolventCutoff_one_zero_eq_trace_cfcLog_sub_of_isHermitian_of_strictlyPositive
    hA hPos hT

/-- Weighted finite cutoff as the corresponding trace-`CFC.log` difference. -/
theorem weightedCutoffTraceLogSub
    {n : Nat} {A B : Matrix (Fin n) (Fin n) Real}
    (hA : A.IsHermitian) (hPos : IsStrictlyPositive A)
    {T : Real} (hT : 0 <= T) :
    traceMulResolventCutoff A B (0 : Matrix (Fin n) (Fin n) Real) T 0 =
      Matrix.trace (B * cfc Real.log (A + SMul.smul T (1 : Matrix (Fin n) (Fin n) Real))) -
        Matrix.trace (B * cfc Real.log A) :=
  traceMulResolventCutoff_weight_zero_eq_trace_mul_cfcLog_sub_of_isHermitian_of_strictlyPositive
    hA hPos hT

/-- Weighted fixed-cutoff trace-log representation, solved for the base
trace-log term. This keeps the shifted-log cutoff remainder visible; it is not
an improper-integral representation or cutoff-removal theorem. -/
theorem weightedTraceLogEqShiftSubCutoff
    {n : Nat} {A B : Matrix (Fin n) (Fin n) Real}
    (hA : A.IsHermitian) (hPos : IsStrictlyPositive A)
    {T : Real} (hT : 0 <= T) :
    Matrix.trace (B * cfc Real.log A) =
      Matrix.trace (B * cfc Real.log (A + SMul.smul T (1 : Matrix (Fin n) (Fin n) Real))) -
        traceMulResolventCutoff A B (0 : Matrix (Fin n) (Fin n) Real) T 0 := by
  rw [weightedCutoffTraceLogSub (A := A) (B := B) hA hPos hT]
  ring

/-- After subtracting the universal scalar divergence `trace B * log T`, the
shifted weighted trace-log remainder tends to zero. This is a renormalized
asymptotic, not a cutoff-removal theorem. -/
theorem weightedShiftTraceLogSubScalarLog_tendsto_zero
    {n : Nat} {A B : Matrix (Fin n) (Fin n) Real}
    (hA : A.IsHermitian) :
    Filter.Tendsto
      (fun T : Real =>
        Matrix.trace (B * cfc Real.log (A + SMul.smul T (1 : Matrix (Fin n) (Fin n) Real))) -
          Matrix.trace B * Real.log T)
      Filter.atTop
      (𝓝 0) := by
  let W : Fin n -> Real := fun i =>
    ((star (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) * B *
        (hA.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real)) i i)
  have hOne :
      cfc (fun _ : Real => (1 : Real)) A = (1 : Matrix (Fin n) (Fin n) Real) := by
    simpa [Algebra.algebraMap_eq_smul_one] using
      (cfc_const (R := Real) (1 : Real) A (ha := hA))
  have htraceB :
      Matrix.trace B = Finset.sum Finset.univ (fun i => W i) := by
    calc
      Matrix.trace B = Matrix.trace (B * (1 : Matrix (Fin n) (Fin n) Real)) := by
        simp
      _ = Matrix.trace (B * cfc (fun _ : Real => (1 : Real)) A) := by
        rw [hOne]
      _ = Finset.sum Finset.univ (fun i => W i * (1 : Real)) := by
        simpa [W] using
          trace_mul_cfc_eq_sum_conj_diag_of_isHermitian (M := A) (B := B) hA
            (fun _ : Real => (1 : Real))
      _ = Finset.sum Finset.univ (fun i => W i) := by
        simp
  have hterm :
      forall i : Fin n,
        Filter.Tendsto
          (fun T : Real => W i * (Real.log (hA.eigenvalues i + T) - Real.log T))
          Filter.atTop
          (𝓝 0) := by
    intro i
    simpa [add_comm] using
      Filter.Tendsto.const_mul (W i) (Real.tendsto_log_comp_add_sub_log (hA.eigenvalues i))
  have hsum :
      Filter.Tendsto
        (fun T : Real =>
          Finset.sum Finset.univ (fun i =>
            W i * (Real.log (hA.eigenvalues i + T) - Real.log T)))
        Filter.atTop
        (𝓝 0) := by
    classical
    have hs :
        forall s : Finset (Fin n),
          Filter.Tendsto
            (fun T : Real =>
              Finset.sum s (fun i => W i * (Real.log (hA.eigenvalues i + T) - Real.log T)))
            Filter.atTop
            (𝓝 0) := by
      intro s
      induction s using Finset.induction_on with
      | empty =>
          simp
      | insert a s ha ih =>
          simpa [Finset.sum_insert ha] using (hterm a).add ih
    simpa using hs Finset.univ
  have hEq :
      (fun T : Real =>
        Matrix.trace (B * cfc Real.log (A + SMul.smul T (1 : Matrix (Fin n) (Fin n) Real))) -
          Matrix.trace B * Real.log T) =
      (fun T : Real =>
        Finset.sum Finset.univ (fun i =>
          W i * (Real.log (hA.eigenvalues i + T) - Real.log T))) := by
    funext T
    calc
      Matrix.trace (B * cfc Real.log (A + SMul.smul T (1 : Matrix (Fin n) (Fin n) Real))) -
          Matrix.trace B * Real.log T
          =
          Finset.sum Finset.univ (fun i => W i * Real.log (hA.eigenvalues i + T)) -
            Matrix.trace B * Real.log T := by
              rw [<- cfc_log_add_const_eq_of_isHermitian (A := A) hA T]
              simpa [W] using
                trace_mul_cfc_eq_sum_conj_diag_of_isHermitian
                  (M := A) (B := B) hA (fun x : Real => Real.log (x + T))
      _ =
          Finset.sum Finset.univ (fun i => W i * Real.log (hA.eigenvalues i + T)) -
            Finset.sum Finset.univ (fun i => W i) * Real.log T := by
              rw [htraceB]
      _ =
          Finset.sum Finset.univ (fun i => W i * Real.log (hA.eigenvalues i + T)) -
            Finset.sum Finset.univ (fun i => W i * Real.log T) := by
              rw [Finset.sum_mul]
      _ =
          Finset.sum Finset.univ (fun i => W i * Real.log (hA.eigenvalues i + T) - W i * Real.log T) := by
              rw [Finset.sum_sub_distrib]
      _ =
          Finset.sum Finset.univ (fun i =>
            W i * (Real.log (hA.eigenvalues i + T) - Real.log T)) := by
              refine Finset.sum_congr rfl ?_
              intro i _hi
              ring
  rw [hEq]
  exact hsum

/-- Renormalized cutoff removal for the weighted identity-shift resolvent
package. The cutoff integral still needs the scalar counterterm
`trace B * log T`; this is not a plain improper-integral representation. -/
theorem weightedCutoffSubScalarLog_tendsto_negTraceLog
    {n : Nat} {A B : Matrix (Fin n) (Fin n) Real}
    (hA : A.IsHermitian) (hPos : IsStrictlyPositive A) :
    Filter.Tendsto
      (fun T : Real =>
        traceMulResolventCutoff A B (0 : Matrix (Fin n) (Fin n) Real) T 0 -
          Matrix.trace B * Real.log T)
      Filter.atTop
      (𝓝 (-Matrix.trace (B * cfc Real.log A))) := by
  have hshift :=
    weightedShiftTraceLogSubScalarLog_tendsto_zero (A := A) (B := B) hA
  have hlimit :
      Filter.Tendsto
        (fun T : Real =>
          (Matrix.trace (B * cfc Real.log (A + SMul.smul T (1 : Matrix (Fin n) (Fin n) Real))) -
              Matrix.trace B * Real.log T) -
            Matrix.trace (B * cfc Real.log A))
        Filter.atTop
        (𝓝 (-Matrix.trace (B * cfc Real.log A))) := by
    simpa using (hshift.sub tendsto_const_nhds)
  refine Filter.Tendsto.congr' ?_ hlimit
  filter_upwards [Filter.eventually_ge_atTop (0 : Real)] with T hT
  rw [weightedCutoffTraceLogSub (A := A) (B := B) hA hPos hT]
  ring

/-- Short alias for the renormalized shifted-log remainder limit. -/
theorem weightedShiftRemainderTendstoZero
    {n : Nat} {A B : Matrix (Fin n) (Fin n) Real}
    (hA : A.IsHermitian) :
    Filter.Tendsto
      (fun T : Real =>
        Matrix.trace (B * cfc Real.log (A + SMul.smul T (1 : Matrix (Fin n) (Fin n) Real))) -
          Matrix.trace B * Real.log T)
      Filter.atTop
      (𝓝 0) :=
  weightedShiftTraceLogSubScalarLog_tendsto_zero hA

/-- Short alias for renormalized weighted cutoff removal. -/
theorem weightedCutoffRenormTendstoNegTraceLog
    {n : Nat} {A B : Matrix (Fin n) (Fin n) Real}
    (hA : A.IsHermitian) (hPos : IsStrictlyPositive A) :
    Filter.Tendsto
      (fun T : Real =>
        traceMulResolventCutoff A B (0 : Matrix (Fin n) (Fin n) Real) T 0 -
          Matrix.trace B * Real.log T)
      Filter.atTop
      (𝓝 (-Matrix.trace (B * cfc Real.log A))) :=
  weightedCutoffSubScalarLog_tendsto_negTraceLog hA hPos
end LogResolvent
end

end HighDimProb
