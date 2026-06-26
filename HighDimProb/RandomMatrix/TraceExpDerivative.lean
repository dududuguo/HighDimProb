import Mathlib.Analysis.Calculus.FDeriv.Pow
import Mathlib.Analysis.Calculus.FDeriv.Linear
import Mathlib.Analysis.Calculus.Deriv.Comp
import Mathlib.Analysis.Calculus.Deriv.Linear
import Mathlib.Analysis.Calculus.Deriv.Add
import Mathlib.Analysis.Calculus.Deriv.Mul
import Mathlib.Analysis.Calculus.SmoothSeries
import Mathlib.Analysis.Normed.Algebra.MatrixExponential
import Mathlib.Analysis.Normed.Module.FiniteDimension
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Data.Real.Basic
import Mathlib.LinearAlgebra.Matrix.Trace

/-!
# Trace derivatives for noncommutative matrix powers

This module provides the finite-polynomial trace derivative used as the
termwise ingredient for the noncommutative trace-exponential derivative route.
It proves the affine derivative of `trace (exp (X + t • C))` by summing the
finite-polynomial derivative route. It does not prove the Duhamel integral
formula.
-/

namespace HighDimProb

open scoped Matrix.Norms.Operator RightActions

noncomputable section

private theorem trace_pow_deriv_trace_sum_eq_trace_mul_pow
    {n k : Nat} (A C : Matrix (Fin n) (Fin n) Real) :
    Finset.sum (Finset.range k)
      (fun i => Matrix.trace (A ^ (k - 1 - i) * C * A ^ i)) =
      (k : Real) * Matrix.trace (C * A ^ (k - 1)) := by
  trans Finset.sum (Finset.range k) (fun _ => Matrix.trace (C * A ^ (k - 1)))
  . apply Finset.sum_congr rfl
    intro i hi
    have hi' : i < k := Finset.mem_range.mp hi
    have hi_le_pred : i <= k.pred := Nat.le_pred_of_lt hi'
    have hi_le : i <= k - 1 := by
      simpa [Nat.pred_eq_sub_one] using hi_le_pred
    calc
      Matrix.trace (A ^ (k - 1 - i) * C * A ^ i)
          = Matrix.trace (A ^ i * A ^ (k - 1 - i) * C) := by
              rw [Matrix.trace_mul_cycle]
      _ = Matrix.trace (C * (A ^ i * A ^ (k - 1 - i))) := by
              rw [Matrix.trace_mul_comm]
      _ = Matrix.trace (C * A ^ (k - 1)) := by
              congr 1
              rw [<- pow_add]
              have hsum : i + (k - 1 - i) = k - 1 := Nat.add_sub_of_le hi_le
              exact congrArg (fun m : Nat => C * A ^ m) hsum
  . rw [Finset.sum_const, Finset.card_range]
    simp [nsmul_eq_mul]
/-- Frechet derivative of `X ↦ trace (X ^ k)` in the noncommutative sum form.

This packages Mathlib's noncommutative power derivative into a reusable theorem
with a matrix-to-scalar continuous linear map target.
-/
theorem hasFDerivAt_trace_pow_sum
    {n k : Nat} (A : Matrix (Fin n) (Fin n) Real) :
    HasFDerivAt
      (fun X : Matrix (Fin n) (Fin n) Real => Matrix.trace (X ^ k))
      (LinearMap.toContinuousLinearMap
        (Finset.sum (Finset.range k) fun i =>
          (Matrix.traceLinearMap (Fin n) Real Real).comp
            ((LinearMap.mulLeft Real (A ^ (k - 1 - i))).comp
              (LinearMap.mulRight Real (A ^ i)))))
      A := by
  have hId : HasFDerivAt (fun X : Matrix (Fin n) (Fin n) Real => X)
      (ContinuousLinearMap.id Real (Matrix (Fin n) (Fin n) Real)) A := by
    simpa using (hasFDerivAt_id A)
  have hPowF := hId.fun_pow' k
  have hTraceF :=
    ((LinearMap.toContinuousLinearMap (Matrix.traceLinearMap (Fin n) Real Real)).hasFDerivAt.comp
      A hPowF)
  refine hTraceF.congr_fderiv ?_
  ext H
  simp [ContinuousLinearMap.comp_apply, ContinuousLinearMap.sum_apply,
    Matrix.traceLinearMap_apply, LinearMap.comp_apply, LinearMap.mulLeft_apply,
    LinearMap.mulRight_apply, MulOpposite.smul_eq_mul_unop, mul_assoc]

/-- Frechet derivative of `X ↦ trace (X ^ k)` after collapsing the cyclic sum.

The derivative map is the scalar multiple of right multiplication by A ^ (k - 1)
followed by the trace.
-/
theorem hasFDerivAt_trace_pow
    {n k : Nat} (A : Matrix (Fin n) (Fin n) Real) :
    HasFDerivAt
      (fun X : Matrix (Fin n) (Fin n) Real => Matrix.trace (X ^ k))
      ((k : Real) •
        ((LinearMap.toContinuousLinearMap (Matrix.traceLinearMap (Fin n) Real Real)).comp
          (LinearMap.toContinuousLinearMap (LinearMap.mulRight Real (A ^ (k - 1))))))
      A := by
  have hsum := hasFDerivAt_trace_pow_sum (A := A) (k := k)
  refine hsum.congr_fderiv ?_
  ext H
  simp [ContinuousLinearMap.sum_apply, Matrix.traceLinearMap_apply, LinearMap.comp_apply,
    LinearMap.mulRight_apply, smul_eq_mul]
  simpa [mul_assoc] using
    trace_pow_deriv_trace_sum_eq_trace_mul_pow (A := A) (C := H) (k := k)

/-- Derivative of the trace of a noncommutative matrix power along an affine line.

Mathlib's `HasFDerivAt.fun_pow'` gives the noncommutative Frechet derivative of
`A => A ^ k` as a cyclic sum. Taking the trace collapses the cyclic sum to
`k * trace (C * A ^ (k - 1))`.

This is a finite-polynomial ingredient for the trace-exponential derivative
route; it is not the Duhamel integral formula and it is not the derivative of
`trace (NormedSpace.exp _)`.
-/
theorem hasDerivAt_trace_pow_add_smul_const
    {n k : Nat} (X C : Matrix (Fin n) (Fin n) Real) (t : Real) :
    HasDerivAt
      (fun u : Real => Matrix.trace ((X + SMul.smul u C) ^ k))
      ((k : Real) * Matrix.trace (C * (X + SMul.smul t C) ^ (k - 1)))
      t := by
  let A : Matrix (Fin n) (Fin n) Real := X + SMul.smul t C
  have hAffine : HasDerivAt (fun u : Real => X + SMul.smul u C) C t := by
    have hConst : HasDerivAt (fun _ : Real => X) 0 t := hasDerivAt_const t X
    have hLin : HasDerivAt (fun u : Real => SMul.smul u C) C t := by
      simpa using
        (HasDerivAt.smul_const
          (hasDerivAt_id t : HasDerivAt (fun u : Real => u) 1 t) C)
    change HasDerivAt ((fun _ : Real => X) + (fun u : Real => SMul.smul u C)) C t
    simpa using hConst.add hLin
  have hDeriv := (hasFDerivAt_trace_pow (A := A) (k := k)).comp_hasDerivAt t hAffine
  simpa [A, ContinuousLinearMap.comp_apply, Matrix.traceLinearMap_apply,
    LinearMap.mulRight_apply, smul_eq_mul] using hDeriv

/-- Termwise derivative of the finite truncated trace-exponential series along an affine line.

This is a finite truncation only: it packages the polynomial power derivative above into a
finite sum with exponential-series coefficients. It does not prove the derivative of the
infinite trace exponential series.
-/
theorem hasDerivAt_trace_exp_trunc_add_smul_const
    {n m : Nat} (X C : Matrix (Fin n) (Fin n) Real) (t : Real) :
    HasDerivAt
      (fun u : Real =>
        Finset.sum (Finset.range m)
          (fun k => (1 / (Nat.factorial k : Real)) *
            Matrix.trace ((X + SMul.smul u C) ^ k)))
      (Finset.sum (Finset.range m)
        (fun k => (1 / (Nat.factorial k : Real)) *
          ((k : Real) * Matrix.trace (C * (X + SMul.smul t C) ^ (k - 1)))))
      t := by
  simpa using
    (HasDerivAt.fun_sum
      (u := Finset.range m)
      (A := fun k u =>
        (1 / (Nat.factorial k : Real)) *
          Matrix.trace ((X + SMul.smul u C) ^ k))
      (A' := fun k =>
        (1 / (Nat.factorial k : Real)) *
          ((k : Real) * Matrix.trace (C * (X + SMul.smul t C) ^ (k - 1))))
      (x := t)
      (fun k hk =>
        (hasDerivAt_trace_pow_add_smul_const (k := k) X C t).const_mul
          (1 / (Nat.factorial k : Real))))

/-- Algebraic normalization of the differentiated truncated trace-exponential sum. -/
private theorem trace_exp_trunc_deriv_weight_succ
    (x : Real) (k : Nat) :
    (1 / (Nat.factorial (k + 1) : Real)) * ((k + 1 : Real) * x) =
    (1 / (Nat.factorial k : Real)) * x := by
  rw [Nat.factorial_succ]
  field_simp [Nat.factorial_ne_zero]
  norm_num [Nat.cast_add, Nat.cast_mul, mul_add, add_mul, mul_assoc, mul_left_comm, mul_comm]

/-- Continuous-linear-map version of the factorial weight normalization. -/
private theorem trace_exp_trunc_deriv_weight_succ_clm
    {E F : Type*} [NormedAddCommGroup E] [NormedSpace Real E]
    [NormedAddCommGroup F] [NormedSpace Real F]
    (L : E →L[Real] F) (k : Nat) :
    (1 / (Nat.factorial (k + 1) : Real)) • ((k + 1 : Real) • L) =
      (1 / (Nat.factorial k : Real)) • L := by
  have hcoef : (1 / (Nat.factorial (k + 1) : Real)) * (k + 1 : Real) =
      1 / (Nat.factorial k : Real) := by
    simpa using (trace_exp_trunc_deriv_weight_succ (x := (1 : Real)) k)
  ext x
  simpa [ContinuousLinearMap.smul_apply, smul_smul] using
    congrArg (fun a : Real => a • L x) hcoef
/-- Frechet derivative of the finite truncated trace-exponential polynomial. -/
theorem hasFDerivAt_trace_exp_trunc
    {n m : Nat} (A : Matrix (Fin n) (Fin n) Real) :
    HasFDerivAt
      (fun X : Matrix (Fin n) (Fin n) Real =>
        Finset.sum (Finset.range m)
          (fun k => (1 / (Nat.factorial k : Real)) * Matrix.trace (X ^ k)))
      (Finset.sum (Finset.range m)
        (fun k =>
          SMul.smul (1 / (Nat.factorial k : Real))
            (SMul.smul (k : Real)
              ((LinearMap.toContinuousLinearMap (Matrix.traceLinearMap (Fin n) Real Real)).comp
                (LinearMap.toContinuousLinearMap (LinearMap.mulRight Real (A ^ (k - 1))))))))
      A := by
  refine HasFDerivAt.fun_sum (u := Finset.range m) ?_
  intro k hk
  simpa [smul_eq_mul] using
    (hasFDerivAt_trace_pow (A := A) (k := k)).const_smul
      (1 / (Nat.factorial k : Real))

/-- Algebraic normalization of the shifted Frechet derivative sum for trace-exp truncations. -/
private theorem trace_exp_trunc_fderiv_sum_eq_shifted
    {n m : Nat} (A : Matrix (Fin n) (Fin n) Real) :
    Finset.sum (Finset.range (m + 1))
      (fun k =>
        SMul.smul (1 / (Nat.factorial k : Real))
          (SMul.smul (k : Real)
            ((LinearMap.toContinuousLinearMap (Matrix.traceLinearMap (Fin n) Real Real)).comp
              (LinearMap.toContinuousLinearMap (LinearMap.mulRight Real (A ^ (k - 1))))))) =
    Finset.sum (Finset.range m)
      (fun j =>
        SMul.smul (1 / (Nat.factorial j : Real))
          ((LinearMap.toContinuousLinearMap (Matrix.traceLinearMap (Fin n) Real Real)).comp
            (LinearMap.toContinuousLinearMap (LinearMap.mulRight Real (A ^ j))))) := by
  induction m with
  | zero =>
      simp
      have hzero :
          SMul.smul (0 : Real)
            ((LinearMap.toContinuousLinearMap (Matrix.traceLinearMap (Fin n) Real Real)).comp
              (LinearMap.toContinuousLinearMap LinearMap.id)) = 0 := by
        exact zero_smul Real _
      rw [hzero]
      exact smul_zero (1 : Real)
  | succ m ih =>
      rw [Finset.sum_range_succ]
      conv_rhs => rw [Finset.sum_range_succ]
      rw [ih]
      congr 1
      simpa [Nat.succ_eq_add_one, Nat.add_comm, Nat.add_left_comm, Nat.add_assoc,
        Nat.add_sub_cancel] using
        (trace_exp_trunc_deriv_weight_succ_clm
          (((LinearMap.toContinuousLinearMap (Matrix.traceLinearMap (Fin n) Real Real)).comp
            (LinearMap.toContinuousLinearMap (LinearMap.mulRight Real (A ^ m))))) m)

/-- Frechet derivative of the shifted truncated trace-exponential polynomial. -/
theorem hasFDerivAt_trace_exp_trunc_succ
    {n m : Nat} (A : Matrix (Fin n) (Fin n) Real) :
    HasFDerivAt
      (fun X : Matrix (Fin n) (Fin n) Real =>
        Finset.sum (Finset.range (m + 1))
          (fun k => (1 / (Nat.factorial k : Real)) * Matrix.trace (X ^ k)))
      (Finset.sum (Finset.range m)
        (fun j =>
          SMul.smul (1 / (Nat.factorial j : Real))
            ((LinearMap.toContinuousLinearMap (Matrix.traceLinearMap (Fin n) Real Real)).comp
              (LinearMap.toContinuousLinearMap (LinearMap.mulRight Real (A ^ j))))))
      A := by
  have h := hasFDerivAt_trace_exp_trunc (A := A) (m := m + 1)
  refine h.congr_fderiv ?_
  simpa using trace_exp_trunc_fderiv_sum_eq_shifted (A := A) (m := m)

/-- Algebraic normalization for the shifted differentiated truncated trace-exponential sum. -/
theorem trace_exp_trunc_deriv_sum_eq_shifted
    {n m : Nat} (A C : Matrix (Fin n) (Fin n) Real) :
    Finset.sum (Finset.range (m + 1))
      (fun k => (1 / (Nat.factorial k : Real)) *
        ((k : Real) * Matrix.trace (C * A ^ (k - 1)))) =
    Finset.sum (Finset.range m)
      (fun j => (1 / (Nat.factorial j : Real)) * Matrix.trace (C * A ^ j)) := by
  induction m with
  | zero =>
      simp
  | succ m ih =>
      rw [Finset.sum_range_succ]
      conv_rhs => rw [Finset.sum_range_succ]
      rw [ih]
      congr 1
      simpa [Nat.add_comm, Nat.add_left_comm, Nat.add_assoc, mul_assoc, mul_left_comm,
        mul_comm] using
        (trace_exp_trunc_deriv_weight_succ (x := Matrix.trace (C * A ^ m)) m)

/-- Derivative of the truncated trace exponential with the shifted normalized sum on the right. -/
theorem hasDerivAt_trace_exp_trunc_succ_add_smul_const
    {n m : Nat} (X C : Matrix (Fin n) (Fin n) Real) (t : Real) :
    HasDerivAt
      (fun u : Real =>
        Finset.sum (Finset.range (m + 1))
          (fun k => (1 / (Nat.factorial k : Real)) *
            Matrix.trace ((X + SMul.smul u C) ^ k)))
      (Finset.sum (Finset.range m)
        (fun j => (1 / (Nat.factorial j : Real)) *
          Matrix.trace (C * (X + SMul.smul t C) ^ j)))
      t := by
  have h := hasDerivAt_trace_exp_trunc_add_smul_const (m := m + 1) X C t
  rw [trace_exp_trunc_deriv_sum_eq_shifted (A := X + SMul.smul t C) (C := C)] at h
  exact h

private theorem matrix_norm_one_le_one {n : Nat} :
    ‖(1 : Matrix (Fin n) (Fin n) Real)‖ ≤ 1 := by
  rw [← Matrix.diagonal_one]
  simpa using
    (Matrix.linfty_opNorm_diagonal (m := Fin n) (α := Real) (fun _ : Fin n => (1 : Real))).trans_le
      (pi_norm_const_le (ι := Fin n) (a := (1 : Real)))

private theorem matrix_norm_pow_le_of_norm_le
    {n j : Nat} {A : Matrix (Fin n) (Fin n) Real} {R : Real}
    (hR0 : 0 ≤ R) (hA : ‖A‖ ≤ R) :
    ‖A ^ j‖ ≤ R ^ j := by
  induction j with
  | zero =>
      simpa using (matrix_norm_one_le_one (n := n))
  | succ j ih =>
      calc
        ‖A ^ (j + 1)‖ = ‖A ^ j * A‖ := by rw [pow_succ]
        _ ≤ ‖A ^ j‖ * ‖A‖ := Matrix.linfty_opNorm_mul (A ^ j) A
        _ ≤ R ^ j * R := mul_le_mul ih hA (norm_nonneg A) (pow_nonneg hR0 j)
        _ = R ^ (j + 1) := by rw [pow_succ]

private theorem norm_affine_le_of_mem_Ioo
    {n : Nat} (X C : Matrix (Fin n) (Fin n) Real) {t y : Real}
    (hy : y ∈ Set.Ioo (t - 1) (t + 1)) :
    ‖X + SMul.smul y C‖ ≤ ‖X‖ + (|t| + 1) * ‖C‖ := by
  have hy_abs : |y| ≤ |t| + 1 := by
    rw [abs_le]
    constructor <;> linarith [hy.1, hy.2, le_abs_self t, neg_le_abs t]
  calc
    ‖X + SMul.smul y C‖ ≤ ‖X‖ + ‖SMul.smul y C‖ := norm_add_le X (SMul.smul y C)
    _ = ‖X‖ + |y| * ‖C‖ := by
      congr 1
      change ‖y • C‖ = |y| * ‖C‖
      rw [norm_smul, Real.norm_eq_abs]
    _ ≤ ‖X‖ + (|t| + 1) * ‖C‖ := by gcongr

private theorem trace_exp_shifted_deriv_term_norm_le
    {n j : Nat} (X C : Matrix (Fin n) (Fin n) Real) {t y : Real}
    (hy : y ∈ Set.Ioo (t - 1) (t + 1)) :
    let traceCLM : Matrix (Fin n) (Fin n) Real →L[Real] Real :=
      LinearMap.toContinuousLinearMap (Matrix.traceLinearMap (Fin n) Real Real)
    let R : Real := ‖X‖ + (|t| + 1) * ‖C‖
    ‖(1 / (Nat.factorial j : Real)) *
        Matrix.trace (C * (X + SMul.smul y C) ^ j)‖ ≤
      (‖traceCLM‖ * ‖C‖) * (R ^ j / (Nat.factorial j : Real)) := by
  intro traceCLM R
  have hR0 : 0 ≤ R := by
    dsimp [R]
    positivity
  have hA : ‖X + SMul.smul y C‖ ≤ R := by
    simpa [R] using norm_affine_le_of_mem_Ioo X C hy
  have hpow : ‖(X + SMul.smul y C) ^ j‖ ≤ R ^ j :=
    matrix_norm_pow_le_of_norm_le hR0 hA
  have hmul : ‖C * (X + SMul.smul y C) ^ j‖ ≤ ‖C‖ * R ^ j := by
    exact (Matrix.linfty_opNorm_mul C ((X + SMul.smul y C) ^ j)).trans
      (mul_le_mul_of_nonneg_left hpow (norm_nonneg C))
  have htrace : ‖Matrix.trace (C * (X + SMul.smul y C) ^ j)‖ ≤
      ‖traceCLM‖ * (‖C‖ * R ^ j) := by
    calc
      ‖Matrix.trace (C * (X + SMul.smul y C) ^ j)‖ =
          ‖traceCLM (C * (X + SMul.smul y C) ^ j)‖ := by
            simp [traceCLM, Matrix.traceLinearMap_apply]
      _ ≤ ‖traceCLM‖ * ‖C * (X + SMul.smul y C) ^ j‖ := traceCLM.le_opNorm _
      _ ≤ ‖traceCLM‖ * (‖C‖ * R ^ j) := by
            exact mul_le_mul_of_nonneg_left hmul (norm_nonneg traceCLM)
  have hcoeff_nonneg : 0 ≤ (1 / (Nat.factorial j : Real)) := by positivity
  calc
    ‖(1 / (Nat.factorial j : Real)) *
        Matrix.trace (C * (X + SMul.smul y C) ^ j)‖
        = (1 / (Nat.factorial j : Real)) *
            ‖Matrix.trace (C * (X + SMul.smul y C) ^ j)‖ := by
              rw [norm_mul, Real.norm_of_nonneg hcoeff_nonneg]
    _ ≤ (1 / (Nat.factorial j : Real)) * (‖traceCLM‖ * (‖C‖ * R ^ j)) := by
          exact mul_le_mul_of_nonneg_left htrace hcoeff_nonneg
    _ = (‖traceCLM‖ * ‖C‖) * (R ^ j / (Nat.factorial j : Real)) := by
          ring

/-- Termwise derivative of the shifted trace-exponential tail. -/
theorem hasDerivAt_trace_exp_shifted_term_add_smul_const
    {n j : Nat} (X C : Matrix (Fin n) (Fin n) Real) (t : Real) :
    HasDerivAt
      (fun u : Real =>
        (1 / (Nat.factorial (j + 1) : Real)) *
          Matrix.trace ((X + SMul.smul u C) ^ (j + 1)))
      ((1 / (Nat.factorial j : Real)) *
          Matrix.trace (C * (X + SMul.smul t C) ^ j))
      t := by
  have h :=
    (hasDerivAt_trace_pow_add_smul_const (n := n) (k := j + 1) X C t).const_mul
      (1 / (Nat.factorial (j + 1) : Real))
  exact h.congr_deriv (by
    simpa [Nat.add_sub_cancel] using
      (trace_exp_trunc_deriv_weight_succ
        (x := Matrix.trace (C * (X + SMul.smul t C) ^ j)) j))

/-- The trace of the matrix exponential is the sum of the traced power series. -/
theorem hasSum_trace_exp_series
    {n : Nat} (A : Matrix (Fin n) (Fin n) Real) :
    HasSum
      (fun k : Nat => (1 / (Nat.factorial k : Real)) * Matrix.trace (A ^ k))
      (Matrix.trace (NormedSpace.exp A)) := by
  let traceCLM : Matrix (Fin n) (Fin n) Real →L[Real] Real :=
    LinearMap.toContinuousLinearMap (Matrix.traceLinearMap (Fin n) Real Real)
  have hExp :
      HasSum
        (fun k : Nat => ((Nat.factorial k : Real)⁻¹) • A ^ k)
        (NormedSpace.exp A) :=
    NormedSpace.exp_series_hasSum_exp' (𝕂 := Real) A
  have hTrace :
      HasSum
        (fun k : Nat => ((Nat.factorial k : Real)⁻¹) • traceCLM (A ^ k))
        (traceCLM (NormedSpace.exp A)) := by
    simpa using traceCLM.hasSum hExp
  simpa [traceCLM, one_div, Matrix.traceLinearMap_apply, smul_eq_mul] using hTrace

private theorem summable_trace_exp_shifted_tail_terms
    {n : Nat} (X C : Matrix (Fin n) (Fin n) Real) (t : Real) :
    Summable
      (fun j : Nat =>
        (1 / (Nat.factorial (j + 1) : Real)) *
          Matrix.trace ((X + SMul.smul t C) ^ (j + 1))) := by
  have hfull :
      Summable
        (fun k : Nat =>
          (1 / (Nat.factorial k : Real)) *
            Matrix.trace ((X + SMul.smul t C) ^ k)) :=
    (hasSum_trace_exp_series (A := X + SMul.smul t C)).summable
  have htail := Summable.comp_injective hfull Nat.succ_injective
  simpa [Function.comp_def, Nat.succ_eq_add_one] using htail

private theorem summable_trace_exp_shifted_deriv_majorant
    {n : Nat} (X C : Matrix (Fin n) (Fin n) Real) (t : Real) :
    let traceCLM : Matrix (Fin n) (Fin n) Real →L[Real] Real :=
      LinearMap.toContinuousLinearMap (Matrix.traceLinearMap (Fin n) Real Real)
    let R : Real := ‖X‖ + (|t| + 1) * ‖C‖
    Summable
      (fun j : Nat => ‖traceCLM‖ * ‖C‖ * (R ^ j / (Nat.factorial j : Real))) := by
  intro traceCLM R
  have hpow : Summable (fun j : Nat => R ^ j / (Nat.factorial j : Real)) :=
    Real.summable_pow_div_factorial R
  simpa [mul_assoc] using Summable.mul_left (‖traceCLM‖ * ‖C‖) hpow

/-- Termwise derivative of the shifted trace-exponential tail. -/
theorem hasDerivAt_tsum_trace_exp_shifted_tail_add_smul_const
    {n : Nat} (X C : Matrix (Fin n) (Fin n) Real) (t : Real) :
    HasDerivAt
      (fun z : Real => ∑' j : Nat,
        (1 / (Nat.factorial (j + 1) : Real)) *
          Matrix.trace ((X + SMul.smul z C) ^ (j + 1)))
      (∑' j : Nat,
        (1 / (Nat.factorial j : Real)) *
          Matrix.trace (C * (X + SMul.smul t C) ^ j))
      t := by
  let s : Set Real := Set.Ioo (t - 1) (t + 1)
  let traceCLM : Matrix (Fin n) (Fin n) Real →L[Real] Real :=
    LinearMap.toContinuousLinearMap (Matrix.traceLinearMap (Fin n) Real Real)
  let R : Real := ‖X‖ + (|t| + 1) * ‖C‖
  let u : Nat → Real :=
    fun j => ‖traceCLM‖ * ‖C‖ * (R ^ j / (Nat.factorial j : Real))
  let g : Nat → Real → Real :=
    fun j z =>
      (1 / (Nat.factorial (j + 1) : Real)) *
        Matrix.trace ((X + SMul.smul z C) ^ (j + 1))
  let g' : Nat → Real → Real :=
    fun j z =>
      (1 / (Nat.factorial j : Real)) *
        Matrix.trace (C * (X + SMul.smul z C) ^ j)
  have hu : Summable u := by
    simpa [u, traceCLM, R] using
      summable_trace_exp_shifted_deriv_majorant X C t
  have hs_open : IsOpen s := by
    simpa [s] using (isOpen_Ioo : IsOpen (Set.Ioo (t - 1) (t + 1)))
  have hs_preconnected : IsPreconnected s := by
    simpa [s] using (isPreconnected_Ioo : IsPreconnected (Set.Ioo (t - 1) (t + 1)))
  have ht_mem : t ∈ s := by
    dsimp [s]
    constructor <;> linarith
  have hg : ∀ j : Nat, ∀ y ∈ s, HasDerivAt (g j) (g' j y) y := by
    intro j y hy
    simpa [g, g'] using
      (hasDerivAt_trace_exp_shifted_term_add_smul_const (j := j) X C y)
  have hg' : ∀ j : Nat, ∀ y ∈ s, ‖g' j y‖ ≤ u j := by
    intro j y hy
    have hy' : y ∈ Set.Ioo (t - 1) (t + 1) := by simpa [s] using hy
    simpa [g', u, traceCLM, R] using
      (trace_exp_shifted_deriv_term_norm_le (j := j) X C hy')
  have hg0 : Summable fun j : Nat => g j t := by
    simpa [g] using summable_trace_exp_shifted_tail_terms X C t
  have h :=
    hasDerivAt_tsum_of_isPreconnected
      (u := u) (g := g) (g' := g') (t := s) (y₀ := t) (y := t)
      hu hs_open hs_preconnected hg hg' ht_mem hg0 ht_mem
  simpa [g, g'] using h
/-- The trace of left multiplication of the matrix exponential is the sum of the
traced left-multiplied power series. -/
theorem hasSum_trace_mul_exp_series
    {n : Nat} (A C : Matrix (Fin n) (Fin n) Real) :
    HasSum
      (fun k : Nat => (1 / (Nat.factorial k : Real)) * Matrix.trace (C * A ^ k))
      (Matrix.trace (C * NormedSpace.exp A)) := by
  let leftMulCLM : Matrix (Fin n) (Fin n) Real →L[Real] Matrix (Fin n) (Fin n) Real :=
    LinearMap.toContinuousLinearMap (LinearMap.mulLeft Real C)
  let traceCLM : Matrix (Fin n) (Fin n) Real →L[Real] Real :=
    LinearMap.toContinuousLinearMap (Matrix.traceLinearMap (Fin n) Real Real)
  let traceMulCLM : Matrix (Fin n) (Fin n) Real →L[Real] Real :=
    traceCLM.comp leftMulCLM
  have hExp :
      HasSum
        (fun k : Nat => ((Nat.factorial k : Real)⁻¹) • A ^ k)
        (NormedSpace.exp A) :=
    NormedSpace.exp_series_hasSum_exp' (𝕂 := Real) A
  have hTraceMul :
      HasSum
        (fun k : Nat => ((Nat.factorial k : Real)⁻¹) • traceMulCLM (A ^ k))
        (traceMulCLM (NormedSpace.exp A)) := by
    simpa using traceMulCLM.hasSum hExp
  simpa [traceMulCLM, traceCLM, leftMulCLM, one_div, Matrix.traceLinearMap_apply,
    LinearMap.mulLeft_apply, ContinuousLinearMap.comp_apply, smul_eq_mul] using hTraceMul

/-- `tsum` form of `hasSum_trace_exp_series`. -/
theorem trace_exp_eq_tsum_trace_power
    {n : Nat} (A : Matrix (Fin n) (Fin n) Real) :
    Matrix.trace (NormedSpace.exp A) =
      ∑' k : Nat, (1 / (Nat.factorial k : Real)) * Matrix.trace (A ^ k) := by
  exact (hasSum_trace_exp_series A).tsum_eq.symm

/-- `tsum` form of `hasSum_trace_mul_exp_series`. -/
theorem trace_mul_exp_eq_tsum_trace_mul_power
    {n : Nat} (A C : Matrix (Fin n) (Fin n) Real) :
    Matrix.trace (C * NormedSpace.exp A) =
      ∑' k : Nat, (1 / (Nat.factorial k : Real)) * Matrix.trace (C * A ^ k) := by
  exact (hasSum_trace_mul_exp_series A C).tsum_eq.symm

/-- Derivative of the affine trace exponential along a constant direction. -/
theorem hasDerivAt_trace_exp_add_smul_const
    {n : Nat} (X C : Matrix (Fin n) (Fin n) Real) (t : Real) :
    HasDerivAt
      (fun u : Real => Matrix.trace (NormedSpace.exp (X + SMul.smul u C)))
      (Matrix.trace (C * NormedSpace.exp (X + SMul.smul t C)))
      t := by
  have htail :
      HasDerivAt
        (fun u : Real =>
          Matrix.trace (1 : Matrix (Fin n) (Fin n) Real) +
            ∑' j : Nat,
              (1 / (Nat.factorial (j + 1) : Real)) *
                Matrix.trace ((X + SMul.smul u C) ^ (j + 1)))
        (∑' j : Nat,
          (1 / (Nat.factorial j : Real)) *
            Matrix.trace (C * (X + SMul.smul t C) ^ j))
        t :=
    (hasDerivAt_tsum_trace_exp_shifted_tail_add_smul_const X C t).const_add
      (Matrix.trace (1 : Matrix (Fin n) (Fin n) Real))
  have htrace :
      HasDerivAt
        (fun u : Real => Matrix.trace (NormedSpace.exp (X + SMul.smul u C)))
        (∑' j : Nat,
          (1 / (Nat.factorial j : Real)) *
            Matrix.trace (C * (X + SMul.smul t C) ^ j))
        t := by
    refine htail.congr_of_eventuallyEq (Filter.Eventually.of_forall ?_)
    intro u
    calc
      Matrix.trace (NormedSpace.exp (X + SMul.smul u C))
          = ∑' k : Nat,
              (1 / (Nat.factorial k : Real)) *
                Matrix.trace ((X + SMul.smul u C) ^ k) := by
              simpa using trace_exp_eq_tsum_trace_power (A := X + SMul.smul u C)
      _ = Matrix.trace (1 : Matrix (Fin n) (Fin n) Real) +
            ∑' j : Nat,
              (1 / (Nat.factorial (j + 1) : Real)) *
                Matrix.trace ((X + SMul.smul u C) ^ (j + 1)) := by
            have hsum :
                Summable
                  (fun k : Nat =>
                    (1 / (Nat.factorial k : Real)) *
                      Matrix.trace ((X + SMul.smul u C) ^ k)) :=
              (hasSum_trace_exp_series (A := X + SMul.smul u C)).summable
            simpa [pow_zero, Nat.succ_eq_add_one] using hsum.tsum_eq_zero_add
  exact htrace.congr_deriv
    (trace_mul_exp_eq_tsum_trace_mul_power (A := X + SMul.smul t C) (C := C)).symm



end

end HighDimProb
