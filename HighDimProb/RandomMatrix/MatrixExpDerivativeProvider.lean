import HighDimProb.RandomMatrix.TraceExpDerivative

/-!
# Ambient matrix-exp Frechet derivative provider

This module packages the ambient finite-dimensional Frechet derivative of the
matrix exponential and the small analytic helper layer needed to state it in the
main HighDimProb repository.

It proves only the ambient matrix-exponential derivative and truncated-series
helpers. It does not prove the self-adjoint carrier layer, the `CFC.log`
derivative, Epstein, Lieb, or Tropp.
-/

namespace HighDimProb

open scoped Matrix.Norms.Operator RightActions

noncomputable section

private theorem matrix_norm_one_le_one {n : Nat} :
    norm (1 : Matrix (Fin n) (Fin n) Real) <= 1 := by
  rw [<- Matrix.diagonal_one]
  simpa using
    (Matrix.linfty_opNorm_diagonal (fun _ : Fin n => (1 : Real))).trans_le
      (pi_norm_const_le (a := (1 : Real)))

private theorem matrix_norm_pow_le
    {n j : Nat} (A : Matrix (Fin n) (Fin n) Real) :
    norm (A ^ j) <= norm A ^ j := by
  cases j with
  | zero =>
      simpa using (matrix_norm_one_le_one (n := n))
  | succ j =>
      simpa using (norm_pow_le' A (Nat.succ_pos j))

/-- Applying the continuous-linear-map upgrade of left-then-right
multiplication is just simultaneous left and right multiplication. This bridge
lets matrix-power derivative terms use Mathlib's norm bounds for
`ContinuousLinearMap.mulLeftRight`. -/
@[simp]
private theorem toContinuousLinearMap_mulLeft_comp_mulRight_apply
    {n : Nat} (L R B : Matrix (Fin n) (Fin n) Real) :
    (LinearMap.toContinuousLinearMap
      ((LinearMap.mulLeft Real L).comp (LinearMap.mulRight Real R))) B =
      L * B * R := by
  simp [LinearMap.comp_apply, LinearMap.mulLeft_apply, LinearMap.mulRight_apply,
    mul_assoc]

/-- The continuous-linear-map upgrade of left-then-right multiplication agrees
with Mathlib's norm-friendly `ContinuousLinearMap.mulLeftRight`. -/
private theorem toContinuousLinearMap_mulLeft_comp_mulRight_eq_mulLeftRight
    {n : Nat} (L R : Matrix (Fin n) (Fin n) Real) :
    LinearMap.toContinuousLinearMap
      ((LinearMap.mulLeft Real L).comp (LinearMap.mulRight Real R)) =
      ContinuousLinearMap.mulLeftRight Real (Matrix (Fin n) (Fin n) Real) L R := by
  ext B
  simp [ContinuousLinearMap.mulLeftRight_apply]

/-- The `j`th shifted term in the candidate Frechet-derivative series for the
full matrix exponential.

This indexing matches the derivative contribution of the exponential power term
`X ^ (j + 1) / (j + 1)!`, so each summand keeps the coefficient `1 / (j + 1)!`. -/
def matrixExpFDerivTerm
    {n : Nat} (A : Matrix (Fin n) (Fin n) Real) (j : Nat) :
    ContinuousLinearMap (RingHom.id Real)
      (Matrix (Fin n) (Fin n) Real) (Matrix (Fin n) (Fin n) Real) :=
  SMul.smul (1 / (Nat.factorial (j + 1) : Real))
    (Finset.sum (Finset.range (j + 1)) (fun i =>
      ContinuousLinearMap.mulLeftRight Real (Matrix (Fin n) (Fin n) Real)
        (A ^ (j - i)) (A ^ i)))

@[simp] theorem matrixExpFDerivTerm_apply
    {n : Nat} (A B : Matrix (Fin n) (Fin n) Real) (j : Nat) :
    matrixExpFDerivTerm A j B =
      SMul.smul (1 / (Nat.factorial (j + 1) : Real))
        (Finset.sum (Finset.range (j + 1)) (fun i => A ^ (j - i) * B * A ^ i)) := by
  rw [matrixExpFDerivTerm]
  change SMul.smul (1 / (Nat.factorial (j + 1) : Real))
      ((Finset.sum (Finset.range (j + 1)) fun i =>
        ContinuousLinearMap.mulLeftRight Real (Matrix (Fin n) (Fin n) Real)
          (A ^ (j - i)) (A ^ i)) B) = _
  rw [ContinuousLinearMap.sum_apply]
  simp [ContinuousLinearMap.mulLeftRight_apply]

/-- Norm bound for one shifted derivative-series term of the full matrix
exponential Frechet derivative. -/
theorem norm_matrixExpFDerivTerm_le
    {n : Nat} (A : Matrix (Fin n) (Fin n) Real) (j : Nat) :
    norm (matrixExpFDerivTerm A j) <=
      (j + 1 : Real) * (norm A ^ j) / (Nat.factorial (j + 1) : Real) := by
  let term : Nat ->
      ContinuousLinearMap (RingHom.id Real)
        (Matrix (Fin n) (Fin n) Real) (Matrix (Fin n) (Fin n) Real) :=
    fun i =>
      ContinuousLinearMap.mulLeftRight Real (Matrix (Fin n) (Fin n) Real)
        (A ^ (j - i)) (A ^ i)
  have hcoeff_nonneg : 0 <= (1 / (Nat.factorial (j + 1) : Real)) := by
    positivity
  have hterm :
      forall i, i < j + 1 -> norm (term i) <= norm A ^ j := by
    intro i hi
    have hi_le : i <= j := Nat.lt_succ_iff.mp hi
    have hleft : norm (A ^ (j - i)) <= norm A ^ (j - i) :=
      matrix_norm_pow_le (j := j - i) A
    have hright : norm (A ^ i) <= norm A ^ i :=
      matrix_norm_pow_le (j := i) A
    have hmulpow : norm A ^ (j - i) * norm A ^ i = norm A ^ ((j - i) + i) := by
      rw [pow_add]
    calc
      norm (term i) <= norm (A ^ (j - i)) * norm (A ^ i) := by
        simpa [term] using
          (ContinuousLinearMap.opNorm_mulLeftRight_apply_apply_le
            Real (Matrix (Fin n) (Fin n) Real) (A ^ (j - i)) (A ^ i))
      _ <= norm A ^ (j - i) * norm A ^ i := by
        exact mul_le_mul hleft hright (norm_nonneg _) (pow_nonneg (norm_nonneg A) _)
      _ = norm A ^ ((j - i) + i) := hmulpow
      _ = norm A ^ j := by rw [Nat.sub_add_cancel hi_le]
  calc
    norm (matrixExpFDerivTerm A j)
        = norm (SMul.smul (1 / (Nat.factorial (j + 1) : Real))
            (Finset.sum (Finset.range (j + 1)) term)) := by
            simp [matrixExpFDerivTerm, term]
    _ = norm (1 / (Nat.factorial (j + 1) : Real)) * norm (Finset.sum (Finset.range (j + 1)) term) := by
          simpa using (norm_smul (1 / (Nat.factorial (j + 1) : Real))
            (Finset.sum (Finset.range (j + 1)) term))
    _ = (1 / (Nat.factorial (j + 1) : Real)) * norm (Finset.sum (Finset.range (j + 1)) term) := by
          rw [Real.norm_of_nonneg hcoeff_nonneg]
    _ <= (1 / (Nat.factorial (j + 1) : Real)) *
          Finset.sum (Finset.range (j + 1)) (fun i => norm (term i)) := by
          exact mul_le_mul_of_nonneg_left (norm_sum_le _ _) hcoeff_nonneg
    _ <= (1 / (Nat.factorial (j + 1) : Real)) *
          Finset.sum (Finset.range (j + 1)) (fun _ => norm A ^ j) := by
          refine mul_le_mul_of_nonneg_left ?_ hcoeff_nonneg
          exact Finset.sum_le_sum (fun i hi => hterm i (Finset.mem_range.mp hi))
    _ = (1 / (Nat.factorial (j + 1) : Real)) * ((j + 1 : Real) * norm A ^ j) := by
          simp [nsmul_eq_mul]
    _ = (j + 1 : Real) * (norm A ^ j) / (Nat.factorial (j + 1) : Real) := by
          ring

/-- Exponential-series majorant for `matrixExpFDerivTerm`, used to prove
summability. The finite sum contributes `(j + 1)`, which cancels against
`(j + 1)!`. -/
theorem norm_matrixExpFDerivTerm_le_norm_pow_div_factorial
    {n : Nat} (A : Matrix (Fin n) (Fin n) Real) (j : Nat) :
    norm (matrixExpFDerivTerm A j) <=
      norm A ^ j / (Nat.factorial j : Real) := by
  have hmain := norm_matrixExpFDerivTerm_le (A := A) (j := j)
  have hj_pos : (0 : Real) < j + 1 := by positivity
  have hfac_pos : (0 : Real) < (Nat.factorial j : Real) := by positivity
  calc
    norm (matrixExpFDerivTerm A j) <=
        (j + 1 : Real) * (norm A ^ j) / (Nat.factorial (j + 1) : Real) := hmain
    _ = norm A ^ j / (Nat.factorial j : Real) := by
          rw [Nat.factorial_succ]
          push_cast
          field_simp [hj_pos.ne', hfac_pos.ne']

/-- The shifted derivative-series terms for the full matrix exponential form a
summable series of continuous linear maps. -/
theorem summable_matrixExpFDerivTerm
    {n : Nat} (A : Matrix (Fin n) (Fin n) Real) :
    Summable (matrixExpFDerivTerm A) := by
  refine Summable.of_norm_bounded
    (g := fun j : Nat => norm A ^ j / (Nat.factorial j : Real))
    (Real.summable_pow_div_factorial (norm A)) ?_
  intro j
  exact norm_matrixExpFDerivTerm_le_norm_pow_div_factorial (A := A) (j := j)

/-- Candidate Frechet derivative of the full finite-dimensional matrix
exponential at `A`.

The summability theorem above ensures that this infinite sum of continuous
linear maps is well-defined. -/
def matrixExpFDeriv
    {n : Nat} (A : Matrix (Fin n) (Fin n) Real) :
    ContinuousLinearMap (RingHom.id Real)
      (Matrix (Fin n) (Fin n) Real) (Matrix (Fin n) (Fin n) Real) :=
  tsum (matrixExpFDerivTerm A)

/-- Frechet derivative of `fun X => X ^ k` in the standard noncommutative
cyclic-sum form. -/
theorem hasFDerivAt_matrix_pow_sum
    {n k : Nat} (A : Matrix (Fin n) (Fin n) Real) :
    HasFDerivAt
      (fun X : Matrix (Fin n) (Fin n) Real => X ^ k)
      (LinearMap.toContinuousLinearMap
        (Finset.sum (Finset.range k) fun i =>
          (LinearMap.mulLeft Real (A ^ (k - 1 - i))).comp
            (LinearMap.mulRight Real (A ^ i))))
      A := by
  have hId : HasFDerivAt (fun X : Matrix (Fin n) (Fin n) Real => X)
      (ContinuousLinearMap.id Real (Matrix (Fin n) (Fin n) Real)) A := by
    simpa using (hasFDerivAt_id A)
  have hPowF := hId.fun_pow' k
  refine hPowF.congr_fderiv ?_
  ext H
  simp [ContinuousLinearMap.sum_apply, MulOpposite.smul_eq_mul_unop, mul_assoc]

/-- Frechet derivative of one shifted matrix-exponential series term. -/
private theorem hasFDerivAt_matrix_exp_series_term
    {n j : Nat} (A : Matrix (Fin n) (Fin n) Real) :
    HasFDerivAt
      (fun X : Matrix (Fin n) (Fin n) Real =>
        SMul.smul (1 / (Nat.factorial (j + 1) : Real)) (X ^ (j + 1)))
      (matrixExpFDerivTerm A j)
      A := by
  have hsum :
      LinearMap.toContinuousLinearMap
        (Finset.sum (Finset.range (j + 1)) fun i =>
          (LinearMap.mulLeft Real (A ^ (j + 1 - 1 - i))).comp
            (LinearMap.mulRight Real (A ^ i))) =
      Finset.sum (Finset.range (j + 1)) (fun i =>
        ContinuousLinearMap.mulLeftRight Real (Matrix (Fin n) (Fin n) Real)
          (A ^ (j - i)) (A ^ i)) := by
    ext B
    simp [ContinuousLinearMap.sum_apply,
      ContinuousLinearMap.mulLeftRight_apply, mul_assoc]
  have h :=
    (hasFDerivAt_matrix_pow_sum (A := A) (k := j + 1)).const_smul
      (1 / (Nat.factorial (j + 1) : Real))
  refine h.congr_fderiv ?_
  rw [matrixExpFDerivTerm, hsum]
  rfl

/-- The matrix-exponential power series is summable at every matrix. -/
private theorem summable_matrix_exp_series_full
    {n : Nat} (A : Matrix (Fin n) (Fin n) Real) :
    Summable (fun k : Nat =>
      SMul.smul (1 / (Nat.factorial k : Real)) (A ^ k)) := by
  have h :=
    (@NormedSpace.exp_series_hasSum_exp' Real (Matrix (Fin n) (Fin n) Real)
      _ _ _ _ _ _ A).summable
  simpa [one_div] using h

/-- The shifted tail of the matrix-exponential power series is summable at every
matrix. -/
private theorem summable_matrix_exp_series_tail
    {n : Nat} (A : Matrix (Fin n) (Fin n) Real) :
    Summable (fun j : Nat =>
      SMul.smul (1 / (Nat.factorial (j + 1) : Real)) (A ^ (j + 1))) := by
  have hfull := summable_matrix_exp_series_full A
  simpa [Nat.add_comm, Nat.add_left_comm, Nat.add_assoc] using
    ((summable_nat_add_iff (G := Matrix (Fin n) (Fin n) Real)
      (f := fun k : Nat => SMul.smul (1 / (Nat.factorial k : Real)) (A ^ k)) 1).2
      hfull)

/-- Uniform majorant for the derivative series on an operator-norm ball. -/
private theorem norm_matrixExpFDerivTerm_le_ball_majorant
    {n : Nat} {r : Real}
    {X : Matrix (Fin n) (Fin n) Real}
    (hX : dist X (0 : Matrix (Fin n) (Fin n) Real) < r)
    (j : Nat) :
    norm (matrixExpFDerivTerm X j) <= r ^ j / (Nat.factorial j : Real) := by
  have hXnorm_lt : norm X < r := by
    simpa [dist_eq_norm] using hX
  have hpow : norm X ^ j <= r ^ j := by
    gcongr
  have hfac_nonneg : 0 <= (Nat.factorial j : Real) := by positivity
  calc
    norm (matrixExpFDerivTerm X j) <= norm X ^ j / (Nat.factorial j : Real) :=
      norm_matrixExpFDerivTerm_le_norm_pow_div_factorial (A := X) (j := j)
    _ <= r ^ j / (Nat.factorial j : Real) := by
      exact div_le_div_of_nonneg_right hpow hfac_nonneg

/-- Frechet derivative of the shifted tail of the matrix-exponential power
series. This is the local uniform-convergence step needed for the full
noncommutative matrix exponential derivative. -/
private theorem hasFDerivAt_matrix_exp_series_tail
    {n : Nat} (A : Matrix (Fin n) (Fin n) Real) :
    HasFDerivAt
      (fun X : Matrix (Fin n) (Fin n) Real =>
        tsum (fun j : Nat =>
          SMul.smul (1 / (Nat.factorial (j + 1) : Real)) (X ^ (j + 1))))
      (matrixExpFDeriv A)
      A := by
  let r : Real := norm A + 1
  have hrA : dist A (0 : Matrix (Fin n) (Fin n) Real) < r := by
    simp [r, dist_eq_norm]
  have hu : Summable (fun j : Nat => r ^ j / (Nat.factorial j : Real)) := by
    exact Real.summable_pow_div_factorial r
  have hf : forall (j : Nat), forall X : Matrix (Fin n) (Fin n) Real,
      Membership.mem (Metric.ball (0 : Matrix (Fin n) (Fin n) Real) r) X ->
      HasFDerivAt
        (fun Y : Matrix (Fin n) (Fin n) Real =>
          SMul.smul (1 / (Nat.factorial (j + 1) : Real)) (Y ^ (j + 1)))
        (matrixExpFDerivTerm X j) X := by
    intro j X _hX
    exact hasFDerivAt_matrix_exp_series_term (A := X)
  have hf' : forall (j : Nat), forall X : Matrix (Fin n) (Fin n) Real,
      Membership.mem (Metric.ball (0 : Matrix (Fin n) (Fin n) Real) r) X ->
      norm (matrixExpFDerivTerm X j) <= r ^ j / (Nat.factorial j : Real) := by
    intro j X hX
    exact norm_matrixExpFDerivTerm_le_ball_majorant (X := X) (j := j) (by
      simpa [Metric.mem_ball] using hX)
  have hA_mem : Membership.mem (Metric.ball (0 : Matrix (Fin n) (Fin n) Real) r) A := by
    simpa [Metric.mem_ball] using hrA
  exact hasFDerivAt_tsum_of_isPreconnected hu Metric.isOpen_ball
    (convex_ball (0 : Matrix (Fin n) (Fin n) Real) r).isPreconnected
    hf hf' hA_mem (summable_matrix_exp_series_tail A) hA_mem

/-- Split the full matrix exponential series into its constant term and shifted
tail. -/
private theorem matrix_exp_eq_one_add_series_tail
    {n : Nat} (X : Matrix (Fin n) (Fin n) Real) :
    NormedSpace.exp X =
      1 + tsum (fun j : Nat =>
        SMul.smul (1 / (Nat.factorial (j + 1) : Real)) (X ^ (j + 1))) := by
  let f : Nat -> Matrix (Fin n) (Fin n) Real :=
    fun k => SMul.smul (1 / (Nat.factorial k : Real)) (X ^ k)
  have hfull : Summable f := by
    simpa [f] using summable_matrix_exp_series_full X
  have hsplit := Summable.sum_add_tsum_nat_add (f := f) 1 hfull
  have hexp : NormedSpace.exp X = tsum f := by
    rw [NormedSpace.exp_eq_tsum Real]
    change tsum (fun k : Nat => SMul.smul (Inv.inv (Nat.factorial k : Real)) (X ^ k)) =
      tsum f
    simp [f, one_div]
  calc
    NormedSpace.exp X = tsum f := hexp
    _ = (Finset.sum (Finset.range 1) fun i => f i) + tsum (fun i : Nat => f (i + 1)) := by
      exact hsplit.symm
    _ = 1 + tsum (fun j : Nat =>
        SMul.smul (1 / (Nat.factorial (j + 1) : Real)) (X ^ (j + 1))) := by
      simp [f]
      ext i j
      simp [SMul.smul]

/-- Full noncommutative Frechet derivative of the finite-dimensional matrix
exponential. -/
theorem hasFDerivAt_matrix_exp
    {n : Nat} (A : Matrix (Fin n) (Fin n) Real) :
    HasFDerivAt
      (fun X : Matrix (Fin n) (Fin n) Real => NormedSpace.exp X)
      (matrixExpFDeriv A)
      A := by
  have htail := hasFDerivAt_matrix_exp_series_tail A
  have hconst := htail.const_add (1 : Matrix (Fin n) (Fin n) Real)
  refine hconst.congr_of_eventuallyEq ?_
  exact Filter.Eventually.of_forall (fun X => matrix_exp_eq_one_add_series_tail X)

/-- Strict Frechet derivative of the full finite-dimensional matrix exponential. -/
theorem hasStrictFDerivAt_matrix_exp
    {n : Nat} (A : Matrix (Fin n) (Fin n) Real) :
    HasStrictFDerivAt
      (fun X : Matrix (Fin n) (Fin n) Real => NormedSpace.exp X)
      (matrixExpFDeriv A)
      A := by
  have hAnalytic :
      AnalyticAt Real
        (fun X : Matrix (Fin n) (Fin n) Real => NormedSpace.exp X) A :=
    NormedSpace.exp_analytic A
  have hStrict := hAnalytic.hasStrictFDerivAt
  have hfderiv := (hasFDerivAt_matrix_exp A).fderiv
  simpa [hfderiv] using hStrict

/-- Frechet derivative of the finite truncated matrix-exponential polynomial.

The derivative is the finite weighted sum of the noncommutative matrix-power
 derivatives from `hasFDerivAt_matrix_pow_sum`. -/
theorem hasFDerivAt_matrix_exp_trunc
    {n m : Nat} (A : Matrix (Fin n) (Fin n) Real) :
    HasFDerivAt
      (fun X : Matrix (Fin n) (Fin n) Real =>
        Finset.sum (Finset.range m)
          (fun k => SMul.smul (1 / (Nat.factorial k : Real)) (X ^ k)))
      (Finset.sum (Finset.range m)
        (fun k =>
          SMul.smul (1 / (Nat.factorial k : Real))
            (LinearMap.toContinuousLinearMap
              (Finset.sum (Finset.range k) fun i =>
                (LinearMap.mulLeft Real (A ^ (k - 1 - i))).comp
                  (LinearMap.mulRight Real (A ^ i))))))
      A := by
  refine HasFDerivAt.fun_sum (u := Finset.range m) ?_
  intro k hk
  simpa using
    (hasFDerivAt_matrix_pow_sum (A := A) (k := k)).const_smul
      (1 / (Nat.factorial k : Real))

end

end HighDimProb
