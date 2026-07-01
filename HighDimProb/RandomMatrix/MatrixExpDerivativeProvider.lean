import HighDimProb.RandomMatrix.TraceExpDerivative
import HighDimProb.Analysis.SelfAdjointCarrier
import Mathlib.Analysis.Matrix.Spectrum

/-!
# Matrix-exp Frechet derivative provider

This module packages the ambient finite-dimensional Frechet derivative of the
matrix exponential together with its restriction to the self-adjoint carrier.
It provides only the matrix-exp derivative layer needed before any local
inverse route to `CFC.log`.

It does not prove the `CFC.log` derivative, Epstein, Lieb, Tropp, or Matrix
Bernstein.
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

private theorem matrix_conj_pow_of_mul_eq_one
    {n : Nat} (U V A : Matrix (Fin n) (Fin n) Real)
    (hUV : U * V = 1) (hVU : V * U = 1) (k : Nat) :
    (U * A * V) ^ k = U * A ^ k * V := by
  induction k with
  | zero =>
      simp [pow_zero, hUV, mul_assoc]
  | succ k hk =>
      calc
        (U * A * V) ^ (k + 1) = (U * A * V) ^ k * (U * A * V) := by
          rw [pow_succ]
        _ = (U * A ^ k * V) * (U * A * V) := by rw [hk]
        _ = U * A ^ k * (V * U) * A * V := by simp [mul_assoc]
        _ = U * A ^ k * A * V := by simp [hVU, mul_assoc]
        _ = U * A ^ (k + 1) * V := by simp [pow_succ, mul_assoc]

/-- Conjugating both the base point and direction by inverse matrices conjugates
each shifted derivative-series term by the same change of basis. -/
private theorem matrixExpFDerivTerm_conj_apply_of_mul_eq_one
    {n : Nat} (U V A B : Matrix (Fin n) (Fin n) Real)
    (hUV : U * V = 1) (hVU : V * U = 1) (j : Nat) :
    matrixExpFDerivTerm (U * A * V) j (U * B * V) =
      U * matrixExpFDerivTerm A j B * V := by
  rw [matrixExpFDerivTerm_apply, matrixExpFDerivTerm_apply]
  have hsum :
      (Finset.sum (Finset.range (j + 1)) fun i =>
        (U * A * V) ^ (j - i) * (U * B * V) * (U * A * V) ^ i) =
      U * (Finset.sum (Finset.range (j + 1)) fun i =>
        A ^ (j - i) * B * A ^ i) * V := by
    calc
      (Finset.sum (Finset.range (j + 1)) fun i =>
          (U * A * V) ^ (j - i) * (U * B * V) * (U * A * V) ^ i) =
          Finset.sum (Finset.range (j + 1)) (fun i =>
            U * (A ^ (j - i) * B * A ^ i) * V) := by
              refine Finset.sum_congr rfl ?_
              intro i hi
              rw [matrix_conj_pow_of_mul_eq_one U V A hUV hVU (j - i)]
              rw [matrix_conj_pow_of_mul_eq_one U V A hUV hVU i]
              calc
                (U * A ^ (j - i) * V) * (U * B * V) * (U * A ^ i * V) =
                    U * A ^ (j - i) * (V * U) * B * (V * U) * A ^ i * V := by
                      simp [mul_assoc]
                _ = U * A ^ (j - i) * B * A ^ i * V := by
                      simp [hVU, mul_assoc]
                _ = U * (A ^ (j - i) * B * A ^ i) * V := by
                      simp [mul_assoc]
      _ = (Finset.sum (Finset.range (j + 1)) fun i =>
            U * (A ^ (j - i) * B * A ^ i)) * V := by
              rw [← Finset.sum_mul]
      _ = (U * Finset.sum (Finset.range (j + 1)) fun i =>
            A ^ (j - i) * B * A ^ i) * V := by
              rw [← Finset.mul_sum]
      _ = U * (Finset.sum (Finset.range (j + 1)) fun i =>
            A ^ (j - i) * B * A ^ i) * V := by
              rw [mul_assoc]
  calc
    (1 / (Nat.factorial (j + 1) : Real)) •
        (Finset.sum (Finset.range (j + 1)) fun i =>
          (U * A * V) ^ (j - i) * (U * B * V) * (U * A * V) ^ i) =
        (1 / (Nat.factorial (j + 1) : Real)) •
          (U * (Finset.sum (Finset.range (j + 1)) fun i =>
            A ^ (j - i) * B * A ^ i) * V) := by
              rw [hsum]
    _ = U * ((1 / (Nat.factorial (j + 1) : Real)) •
          (Finset.sum (Finset.range (j + 1)) fun i =>
            A ^ (j - i) * B * A ^ i)) * V := by
              simp [mul_assoc]

/-- Entry formula for multiplying a matrix on both sides by powers of the same
real diagonal matrix. This is the finite-dimensional bookkeeping step used by
the diagonal-basis analysis of `matrixExpFDeriv`. -/
private theorem diagonal_pow_mul_mul_diagonal_pow_apply
    {n : Nat} (d : Fin n -> Real) (B : Matrix (Fin n) (Fin n) Real)
    (p q : Fin n) (a b : Nat) :
    (((Matrix.diagonal d) ^ a * B * (Matrix.diagonal d) ^ b) p q) =
      d p ^ a * B p q * d q ^ b := by
  rw [Matrix.diagonal_pow, Matrix.diagonal_pow]
  simp [Matrix.mul_apply, Matrix.diagonal, mul_assoc]

/-- Entry formula for one shifted derivative-series term of the matrix
exponential at a real diagonal base point. -/
private theorem matrixExpFDerivTerm_diagonal_apply
    {n : Nat} (d : Fin n -> Real) (B : Matrix (Fin n) (Fin n) Real)
    (p q : Fin n) (j : Nat) :
    (matrixExpFDerivTerm (Matrix.diagonal d) j B) p q =
      (1 / (Nat.factorial (j + 1) : Real)) *
        (Finset.sum (Finset.range (j + 1)) fun i =>
          d p ^ (j - i) * B p q * d q ^ i) := by
  rw [matrixExpFDerivTerm_apply]
  change (((1 / (Nat.factorial (j + 1) : Real)) •
      (Finset.sum (Finset.range (j + 1)) fun i =>
        (Matrix.diagonal d) ^ (j - i) * B * (Matrix.diagonal d) ^ i)) p q) =
      (1 / (Nat.factorial (j + 1) : Real)) *
        (Finset.sum (Finset.range (j + 1)) fun i =>
          d p ^ (j - i) * B p q * d q ^ i)
  simp only [Matrix.smul_apply, Matrix.sum_apply]
  congr 1
  exact Finset.sum_congr rfl (fun i _hi =>
    diagonal_pow_mul_mul_diagonal_pow_apply d B p q (j - i) i)

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

private theorem matrixExpFDeriv_conj_apply_of_mul_eq_one
    {n : Nat} (U V A B : Matrix (Fin n) (Fin n) Real)
    (hUV : U * V = 1) (hVU : V * U = 1) :
    matrixExpFDeriv (U * A * V) (U * B * V) =
      U * matrixExpFDeriv A B * V := by
  let applyConj :=
    ContinuousLinearMap.apply Real (Matrix (Fin n) (Fin n) Real) (U * B * V)
  let applyBase := ContinuousLinearMap.apply Real (Matrix (Fin n) (Fin n) Real) B
  let conjCLM :=
    ContinuousLinearMap.mulLeftRight Real (Matrix (Fin n) (Fin n) Real) U V
  have hCLMConj : Summable (matrixExpFDerivTerm (U * A * V)) :=
    summable_matrixExpFDerivTerm (U * A * V)
  have hCLMBase : Summable (matrixExpFDerivTerm A) :=
    summable_matrixExpFDerivTerm A
  have hValsBase : Summable (fun j : Nat => matrixExpFDerivTerm A j B) := by
    have h := hCLMBase.map applyBase applyBase.continuous
    simpa [Function.comp_def, applyBase] using h
  have hBaseTsum : tsum (fun j : Nat => matrixExpFDerivTerm A j B) =
      matrixExpFDeriv A B := by
    rw [matrixExpFDeriv]
    exact (by
      simpa [applyBase] using
        (ContinuousLinearMap.map_tsum applyBase hCLMBase).symm)
  calc
    matrixExpFDeriv (U * A * V) (U * B * V) =
        applyConj (tsum (matrixExpFDerivTerm (U * A * V))) := by
          simp [matrixExpFDeriv, applyConj]
    _ = tsum (fun j : Nat => matrixExpFDerivTerm (U * A * V) j (U * B * V)) := by
          simpa [applyConj] using ContinuousLinearMap.map_tsum applyConj hCLMConj
    _ = tsum (fun j : Nat => U * matrixExpFDerivTerm A j B * V) := by
          apply congrArg tsum
          funext j
          exact matrixExpFDerivTerm_conj_apply_of_mul_eq_one U V A B hUV hVU j
    _ = tsum (fun j : Nat => conjCLM (matrixExpFDerivTerm A j B)) := by
          apply congrArg tsum
          funext j
          simp [conjCLM, ContinuousLinearMap.mulLeftRight_apply]
    _ = conjCLM (tsum (fun j : Nat => matrixExpFDerivTerm A j B)) := by
          exact (ContinuousLinearMap.map_tsum conjCLM hValsBase).symm
    _ = U * matrixExpFDeriv A B * V := by
          rw [hBaseTsum]
          simp [conjCLM, ContinuousLinearMap.mulLeftRight_apply]

private theorem matrixExpFDeriv_conj_injective_of_mul_eq_one
    {n : Nat} (U V A : Matrix (Fin n) (Fin n) Real)
    (hUV : U * V = 1) (hVU : V * U = 1)
    (hA : Function.Injective (matrixExpFDeriv A)) :
    Function.Injective (matrixExpFDeriv (U * A * V)) := by
  intro B C hBC
  have hBase : V * (U * A * V) * U = A := by
    calc
      V * (U * A * V) * U = (V * U) * A * (V * U) := by
        simp only [mul_assoc]
      _ = A := by simp [hVU]
  have hBpull :
      matrixExpFDeriv A (V * B * U) =
        V * matrixExpFDeriv (U * A * V) B * U := by
    have h := matrixExpFDeriv_conj_apply_of_mul_eq_one V U (U * A * V) B hVU hUV
    rw [hBase] at h
    simpa [mul_assoc] using h
  have hCpull :
      matrixExpFDeriv A (V * C * U) =
        V * matrixExpFDeriv (U * A * V) C * U := by
    have h := matrixExpFDeriv_conj_apply_of_mul_eq_one V U (U * A * V) C hVU hUV
    rw [hBase] at h
    simpa [mul_assoc] using h
  have hPulled : matrixExpFDeriv A (V * B * U) = matrixExpFDeriv A (V * C * U) := by
    calc
      matrixExpFDeriv A (V * B * U) = V * matrixExpFDeriv (U * A * V) B * U := hBpull
      _ = V * matrixExpFDeriv (U * A * V) C * U := by rw [hBC]
      _ = matrixExpFDeriv A (V * C * U) := hCpull.symm
  have hDir : V * B * U = V * C * U := hA hPulled
  have hBcancel : U * (V * B * U) * V = B := by
    calc
      U * (V * B * U) * V = (U * V) * B * (U * V) := by
        simp only [mul_assoc]
      _ = B := by simp [hUV]
  have hCcancel : U * (V * C * U) * V = C := by
    calc
      U * (V * C * U) * V = (U * V) * C * (U * V) := by
        simp only [mul_assoc]
      _ = C := by simp [hUV]
  calc
    B = U * (V * B * U) * V := hBcancel.symm
    _ = U * (V * C * U) * V := by rw [hDir]
    _ = C := hCcancel

def matrixExpDividedDifferenceSeries (x y : Real) : Real :=
  tsum (fun j : Nat =>
    (1 / (Nat.factorial (j + 1) : Real)) *
      (Finset.sum (Finset.range (j + 1)) fun i => x ^ (j - i) * y ^ i))
/-- On the diagonal of the divided-difference kernel, the coefficient series
collapses to the ordinary scalar exponential. -/
theorem matrixExpDividedDifferenceSeries_self (x : Real) :
    matrixExpDividedDifferenceSeries x x = Real.exp x := by
  rw [matrixExpDividedDifferenceSeries]
  trans tsum (fun j : Nat => x ^ j / (Nat.factorial j : Real))
  · congr
    ext j
    have hsum :
        (Finset.sum (Finset.range (j + 1)) fun i => x ^ (j - i) * x ^ i) =
          (j + 1 : Real) * x ^ j := by
      calc
        (Finset.sum (Finset.range (j + 1)) fun i => x ^ (j - i) * x ^ i) =
            Finset.sum (Finset.range (j + 1)) (fun _i => x ^ j) := by
          refine Finset.sum_congr rfl ?_
          intro i hi
          have hi_le : i <= j := Nat.lt_succ_iff.mp (Finset.mem_range.mp hi)
          rw [← pow_add, Nat.sub_add_cancel hi_le]
        _ = (j + 1 : Real) * x ^ j := by simp [nsmul_eq_mul]
    rw [hsum]
    rw [Nat.factorial_succ]
    push_cast
    have hj : (j : Real) + 1 ≠ 0 := by positivity
    have hf : (Nat.factorial j : Real) ≠ 0 := by positivity
    field_simp [hj, hf]
  · rw [Real.exp_eq_exp_ℝ]
    exact (congrFun (NormedSpace.exp_eq_tsum_div (𝔸 := Real)) x).symm

/-- The diagonal divided-difference coefficient is strictly positive. -/
theorem matrixExpDividedDifferenceSeries_self_pos (x : Real) :
    0 < matrixExpDividedDifferenceSeries x x := by
  rw [matrixExpDividedDifferenceSeries_self]
  exact Real.exp_pos x

/-- The diagonal divided-difference coefficient is nonzero. -/
theorem matrixExpDividedDifferenceSeries_self_ne_zero (x : Real) :
    matrixExpDividedDifferenceSeries x x ≠ 0 :=
  (matrixExpDividedDifferenceSeries_self_pos x).ne'
/-- Scalar exponential tail starting at degree one. -/
private theorem tsum_pow_succ_div_factorial_succ (x : Real) :
    tsum (fun j : Nat => x ^ (j + 1) / (Nat.factorial (j + 1) : Real)) =
      Real.exp x - 1 := by
  let f : Nat -> Real := fun k => x ^ k / (Nat.factorial k : Real)
  have hsum : Summable f := by
    simpa [f] using Real.summable_pow_div_factorial x
  have hsplit := Summable.sum_add_tsum_nat_add (f := f) 1 hsum
  have hexp : Real.exp x = tsum f := by
    rw [Real.exp_eq_exp_ℝ]
    simpa [f] using (congrFun (NormedSpace.exp_eq_tsum_div (𝔸 := Real)) x)
  have htail : tsum (fun j : Nat => f (j + 1)) = tsum f - 1 := by
    have hsum1 : Finset.sum (Finset.range 1) f = 1 := by simp [f]
    linarith
  simp [f, htail, hexp]

/-- Finite geometric divided-difference identity in the orientation used by
`matrixExpDividedDifferenceSeries`, under `x < y`. -/
private theorem finite_geometric_dividedDifference_sum_of_lt {x y : Real}
    (hxy : x < y) (j : Nat) :
    (Finset.sum (Finset.range (j + 1)) fun i => x ^ (j - i) * y ^ i) =
      (y ^ (j + 1) - x ^ (j + 1)) / (y - x) := by
  have hmul := geom_sum₂_mul_of_ge (x := y) (y := x) hxy.le (j + 1)
  have hsum :
      (Finset.sum (Finset.range (j + 1)) fun i => x ^ (j - i) * y ^ i) =
        Finset.sum (Finset.range (j + 1)) (fun i => y ^ i * x ^ (j + 1 - 1 - i)) := by
    refine Finset.sum_congr rfl ?_
    intro i _hi
    rw [Nat.add_sub_cancel]
    ring
  rw [hsum]
  exact eq_div_of_mul_eq (sub_ne_zero.mpr hxy.ne') hmul

/-- Symmetry of the exponential divided-difference coefficient. -/
theorem matrixExpDividedDifferenceSeries_comm (x y : Real) :
    matrixExpDividedDifferenceSeries x y = matrixExpDividedDifferenceSeries y x := by
  rw [matrixExpDividedDifferenceSeries, matrixExpDividedDifferenceSeries]
  congr
  ext j
  congr 1
  rw [← Finset.sum_range_reflect (fun i : Nat => y ^ (j - i) * x ^ i) (j + 1)]
  refine Finset.sum_congr rfl ?_
  intro i hi
  have hi_le : i <= j := Nat.lt_succ_iff.mp (Finset.mem_range.mp hi)
  rw [Nat.add_sub_cancel, Nat.sub_sub_self hi_le]
  ring

/-- Closed form of the exponential divided-difference coefficient when
`x < y`. -/
theorem matrixExpDividedDifferenceSeries_of_lt {x y : Real} (hxy : x < y) :
    matrixExpDividedDifferenceSeries x y = (Real.exp y - Real.exp x) / (y - x) := by
  rw [matrixExpDividedDifferenceSeries]
  trans tsum (fun j : Nat =>
      (y ^ (j + 1) / (Nat.factorial (j + 1) : Real) -
        x ^ (j + 1) / (Nat.factorial (j + 1) : Real)) / (y - x))
  · congr
    ext j
    rw [finite_geometric_dividedDifference_sum_of_lt hxy j]
    have hden : y - x ≠ 0 := sub_ne_zero.mpr hxy.ne'
    have hfac : (Nat.factorial (j + 1) : Real) ≠ 0 := by positivity
    field_simp [hden, hfac]
  · change (tsum (fun j : Nat =>
        (y ^ (j + 1) / (Nat.factorial (j + 1) : Real) -
          x ^ (j + 1) / (Nat.factorial (j + 1) : Real)) * (y - x)⁻¹)) =
        (Real.exp y - Real.exp x) * (y - x)⁻¹
    rw [tsum_mul_right]
    have hy : Summable (fun j : Nat => y ^ (j + 1) / (Nat.factorial (j + 1) : Real)) := by
      let f : Nat -> Real := fun k => y ^ k / (Nat.factorial k : Real)
      have hfull : Summable f := by simpa [f] using Real.summable_pow_div_factorial y
      simpa [f] using ((summable_nat_add_iff (G := Real) (f := f) 1).2 hfull)
    have hx : Summable (fun j : Nat => x ^ (j + 1) / (Nat.factorial (j + 1) : Real)) := by
      let f : Nat -> Real := fun k => x ^ k / (Nat.factorial k : Real)
      have hfull : Summable f := by simpa [f] using Real.summable_pow_div_factorial x
      simpa [f] using ((summable_nat_add_iff (G := Real) (f := f) 1).2 hfull)
    rw [Summable.tsum_sub hy hx]
    rw [tsum_pow_succ_div_factorial_succ y]
    rw [tsum_pow_succ_div_factorial_succ x]
    ring

/-- The exponential divided-difference coefficient is strictly positive for all
real arguments. -/
theorem matrixExpDividedDifferenceSeries_pos (x y : Real) :
    0 < matrixExpDividedDifferenceSeries x y := by
  rcases lt_trichotomy x y with hxy | hxy | hyx
  · rw [matrixExpDividedDifferenceSeries_of_lt hxy]
    exact div_pos (sub_pos.mpr ((Real.exp_lt_exp).2 hxy)) (sub_pos.mpr hxy)
  · subst hxy
    exact matrixExpDividedDifferenceSeries_self_pos x
  · rw [matrixExpDividedDifferenceSeries_comm x y]
    rw [matrixExpDividedDifferenceSeries_of_lt hyx]
    exact div_pos (sub_pos.mpr ((Real.exp_lt_exp).2 hyx)) (sub_pos.mpr hyx)

/-- The exponential divided-difference coefficient is nonzero for all real
arguments. -/
theorem matrixExpDividedDifferenceSeries_ne_zero (x y : Real) :
    matrixExpDividedDifferenceSeries x y ≠ 0 :=
  (matrixExpDividedDifferenceSeries_pos x y).ne'
/-- Entry formula for the full matrix-exponential Frechet derivative at a real
diagonal base point. The coefficient series is the divided-difference form that
will later be used to prove invertibility of the self-adjoint-carrier
derivative. -/
private theorem matrixExpFDeriv_diagonal_apply
    {n : Nat} (d : Fin n -> Real) (B : Matrix (Fin n) (Fin n) Real)
    (p q : Fin n) :
    (matrixExpFDeriv (Matrix.diagonal d) B) p q =
      tsum (fun j : Nat =>
        (1 / (Nat.factorial (j + 1) : Real)) *
          (Finset.sum (Finset.range (j + 1)) fun i =>
            d p ^ (j - i) * B p q * d q ^ i)) := by
  let applyB := ContinuousLinearMap.apply Real (Matrix (Fin n) (Fin n) Real) B
  let entryL : Matrix (Fin n) (Fin n) Real →ₗ[Real] Real :=
    { toFun := fun M : Matrix (Fin n) (Fin n) Real => M p q
      map_add' := by intro X Y; rfl
      map_smul' := by intro c X; rfl }
  let entry : Matrix (Fin n) (Fin n) Real →L[Real] Real :=
    LinearMap.toContinuousLinearMap entryL
  have hCLM : Summable (matrixExpFDerivTerm (Matrix.diagonal d)) :=
    summable_matrixExpFDerivTerm (Matrix.diagonal d)
  have hMat : Summable (fun j : Nat => matrixExpFDerivTerm (Matrix.diagonal d) j B) := by
    have h := hCLM.map applyB applyB.continuous
    simpa [Function.comp_def, applyB] using h
  calc
    (matrixExpFDeriv (Matrix.diagonal d) B) p q =
        entry (applyB (tsum (matrixExpFDerivTerm (Matrix.diagonal d)))) := by
          simp [matrixExpFDeriv, applyB, entry, entryL]
    _ = entry (tsum (fun j : Nat => matrixExpFDerivTerm (Matrix.diagonal d) j B)) := by
          have hmap := ContinuousLinearMap.map_tsum applyB hCLM
          exact congrArg entry (by simpa [applyB] using hmap)
    _ = tsum (fun j : Nat => entry (matrixExpFDerivTerm (Matrix.diagonal d) j B)) := by
          rw [ContinuousLinearMap.map_tsum entry hMat]
    _ = tsum (fun j : Nat =>
          (1 / (Nat.factorial (j + 1) : Real)) *
            (Finset.sum (Finset.range (j + 1)) fun i =>
              d p ^ (j - i) * B p q * d q ^ i)) := by
          congr
          ext j
          change (matrixExpFDerivTerm (Matrix.diagonal d) j B) p q = _
          exact matrixExpFDerivTerm_diagonal_apply d B p q j
/-- Diagonal-basis entry formula for the full matrix-exponential Frechet
derivative, factored through the divided-difference series coefficient. -/
private theorem matrixExpFDeriv_diagonal_apply_eq_dividedDifferenceSeries_mul
    {n : Nat} (d : Fin n -> Real) (B : Matrix (Fin n) (Fin n) Real)
    (p q : Fin n) :
    (matrixExpFDeriv (Matrix.diagonal d) B) p q =
      matrixExpDividedDifferenceSeries (d p) (d q) * B p q := by
  rw [matrixExpFDeriv_diagonal_apply]
  simp [matrixExpDividedDifferenceSeries]
  trans tsum (fun j : Nat =>
      ((1 / (Nat.factorial (j + 1) : Real)) *
        (Finset.sum (Finset.range (j + 1)) fun i => d p ^ (j - i) * d q ^ i)) * B p q)
  · congr
    ext j
    have hsum :
        (Finset.sum (Finset.range (j + 1)) fun i => d p ^ (j - i) * B p q * d q ^ i) =
          (Finset.sum (Finset.range (j + 1)) fun i => d p ^ (j - i) * d q ^ i) * B p q := by
      rw [Finset.sum_mul]
      exact Finset.sum_congr rfl (fun i _hi => by ring)
    rw [hsum]
    ring
  · rw [tsum_mul_right]
    simp [one_div]
/-- The matrix-exponential Frechet derivative at a real diagonal base point is
injective on the full matrix space. In the standard matrix-unit basis, it acts
entrywise by the strictly positive divided-difference coefficients above. -/
private theorem matrixExpFDeriv_diagonal_injective
    {n : Nat} (d : Fin n -> Real) :
    Function.Injective (matrixExpFDeriv (Matrix.diagonal d)) := by
  intro B C hBC
  ext p q
  have hentry : (matrixExpFDeriv (Matrix.diagonal d) B) p q =
      (matrixExpFDeriv (Matrix.diagonal d) C) p q := by
    simpa using congrFun (congrFun hBC p) q
  have hscaled : matrixExpDividedDifferenceSeries (d p) (d q) * B p q =
      matrixExpDividedDifferenceSeries (d p) (d q) * C p q := by
    simpa [matrixExpFDeriv_diagonal_apply_eq_dividedDifferenceSeries_mul] using hentry
  exact mul_left_cancel₀ (matrixExpDividedDifferenceSeries_ne_zero (d p) (d q)) hscaled

/-- Diagonal injectivity of the matrix-exponential Frechet derivative,
transported across an inverse change of basis. This is the ambient form of
the spectral-conjugation transfer needed for the `CFC.log` inverse route. -/
private theorem matrixExpFDeriv_conj_diagonal_injective_of_mul_eq_one
    {n : Nat} (U V : Matrix (Fin n) (Fin n) Real) (d : Fin n -> Real)
    (hUV : U * V = 1) (hVU : V * U = 1) :
    Function.Injective (matrixExpFDeriv (U * Matrix.diagonal d * V)) :=
  matrixExpFDeriv_conj_injective_of_mul_eq_one U V (Matrix.diagonal d) hUV hVU
    (matrixExpFDeriv_diagonal_injective d)

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

/-- Each shifted matrix-exponential derivative term preserves self-adjointness
when evaluated at a self-adjoint base point in a self-adjoint direction. -/
private theorem isSelfAdjoint_matrixExpFDerivTerm_apply
    {n j : Nat} {A B : Matrix (Fin n) (Fin n) Real}
    (hA : IsSelfAdjoint A) (hB : IsSelfAdjoint B) :
    IsSelfAdjoint (matrixExpFDerivTerm A j B) := by
  rw [matrixExpFDerivTerm_apply]
  refine IsSelfAdjoint.smul (IsSelfAdjoint.all _) ?_
  rw [IsSelfAdjoint]
  rw [star_sum]
  simp only [star_mul, star_pow, hA.star_eq, hB.star_eq, mul_assoc]
  rw [(Finset.sum_range_reflect (fun i : Nat => A ^ i * (B * A ^ (j - i))) (j + 1)).symm]
  refine Finset.sum_congr rfl ?_
  intro i hi
  have hi_le : i <= j := Nat.lt_succ_iff.mp (Finset.mem_range.mp hi)
  simp [Nat.sub_sub_self hi_le]

/-- The matrix exponential Frechet derivative preserves self-adjointness when
both the base point and direction are self-adjoint. -/
private theorem isSelfAdjoint_matrixExpFDeriv_apply
    {n : Nat} {A B : Matrix (Fin n) (Fin n) Real}
    (hA : IsSelfAdjoint A) (hB : IsSelfAdjoint B) :
    IsSelfAdjoint (matrixExpFDeriv A B) := by
  have hval : Summable (fun j : Nat => matrixExpFDerivTerm A j B) := by
    have h := (summable_matrixExpFDerivTerm A).map
      (ContinuousLinearMap.apply Real (Matrix (Fin n) (Fin n) Real) B)
      (ContinuousLinearMap.continuous _)
    simpa [Function.comp_def] using h
  have hClosed : IsClosed (selfAdjoint (Matrix (Fin n) (Fin n) Real) :
      Set (Matrix (Fin n) (Fin n) Real)) := by
    simpa [selfAdjoint.mem_iff] using
      (isClosed_eq (continuous_star :
        Continuous fun X : Matrix (Fin n) (Fin n) Real => star X)
        continuous_id : IsClosed {X : Matrix (Fin n) (Fin n) Real | star X = X})
  rw [matrixExpFDeriv]
  change IsSelfAdjoint
    (((ContinuousLinearMap.apply Real (Matrix (Fin n) (Fin n) Real) B)
      (tsum (matrixExpFDerivTerm A))))
  rw [ContinuousLinearMap.map_tsum
    (ContinuousLinearMap.apply Real (Matrix (Fin n) (Fin n) Real) B)
    (summable_matrixExpFDerivTerm A)]
  change Set.Mem (selfAdjoint (Matrix (Fin n) (Fin n) Real) :
      Set (Matrix (Fin n) (Fin n) Real))
    (tsum (fun j : Nat => matrixExpFDerivTerm A j B))
  exact hClosed.mem_of_tendsto hval.hasSum.tendsto_sum_nat
    (Filter.Eventually.of_forall fun m => by
      change IsSelfAdjoint
        (Finset.sum (Finset.range m) fun j => matrixExpFDerivTerm A j B)
      exact isSelfAdjoint_sum (Finset.range m) (fun j _hj =>
        isSelfAdjoint_matrixExpFDerivTerm_apply (A := A) (B := B) hA hB))

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


/-- Matrix exponential as a map on the self-adjoint carrier. -/
def matrixExpSelfAdjoint
    {n : Nat} (A : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
    selfAdjoint (Matrix (Fin n) (Fin n) Real) :=
  Subtype.mk (NormedSpace.exp (A : Matrix (Fin n) (Fin n) Real)) A.2.exp

@[simp]
private theorem matrixExpSelfAdjoint_coe
    {n : Nat} (A : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
    (matrixExpSelfAdjoint A : Matrix (Fin n) (Fin n) Real) =
      NormedSpace.exp (A : Matrix (Fin n) (Fin n) Real) :=
  rfl

/-- The Frechet derivative of matrix exponential, restricted to self-adjoint
directions and codomain. -/
def matrixExpFDerivSelfAdjoint
    {n : Nat} (A : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
    ContinuousLinearMap (RingHom.id Real)
      (selfAdjoint (Matrix (Fin n) (Fin n) Real))
      (selfAdjoint (Matrix (Fin n) (Fin n) Real)) :=
  (selfAdjoint.submoduleContinuousLinearEquiv
      (A := Matrix (Fin n) (Fin n) Real)).symm.toContinuousLinearMap.comp
    (((matrixExpFDeriv (A : Matrix (Fin n) (Fin n) Real)).comp
        (selfAdjoint.subtypeL (A := Matrix (Fin n) (Fin n) Real))).codRestrict
      (selfAdjoint.submodule Real (Matrix (Fin n) (Fin n) Real))
      (fun B => isSelfAdjoint_matrixExpFDeriv_apply A.2 B.2))

@[simp]
private theorem matrixExpFDerivSelfAdjoint_apply_coe
    {n : Nat} (A B : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
    (matrixExpFDerivSelfAdjoint A B : Matrix (Fin n) (Fin n) Real) =
      matrixExpFDeriv (A : Matrix (Fin n) (Fin n) Real)
        (B : Matrix (Fin n) (Fin n) Real) := by
  simp [matrixExpFDerivSelfAdjoint]

/-- Carrier version of diagonal injectivity for the self-adjoint restriction,
stated with an explicit equality to a real diagonal matrix. This avoids adding a
new diagonal self-adjoint carrier constructor while still exposing the exact
bridge needed by spectral-conjugation work. -/
theorem matrixExpFDerivSelfAdjoint_diagonal_injective
    {n : Nat} (D : selfAdjoint (Matrix (Fin n) (Fin n) Real))
    (d : Fin n -> Real)
    (hD : (D : Matrix (Fin n) (Fin n) Real) = Matrix.diagonal d) :
    Function.Injective (matrixExpFDerivSelfAdjoint D) := by
  intro B C hBC
  apply Subtype.ext
  apply matrixExpFDeriv_diagonal_injective d
  have hamb := congrArg (fun X : selfAdjoint (Matrix (Fin n) (Fin n) Real) =>
    (X : Matrix (Fin n) (Fin n) Real)) hBC
  simpa [matrixExpFDerivSelfAdjoint_apply_coe, hD] using hamb

/-- Continuous linear equivalence form of the diagonal self-adjoint carrier
exponential derivative. This is the exact object consumed by the carrier
`CFC.log` inverse-function bridge in the diagonal case. -/
noncomputable def matrixExpFDerivSelfAdjoint_diagonal_equiv
    {n : Nat} (D : selfAdjoint (Matrix (Fin n) (Fin n) Real))
    (d : Fin n -> Real)
    (hD : (D : Matrix (Fin n) (Fin n) Real) = Matrix.diagonal d) :
    selfAdjoint (Matrix (Fin n) (Fin n) Real) ≃L[Real]
      selfAdjoint (Matrix (Fin n) (Fin n) Real) :=
  (LinearEquiv.ofInjectiveEndo
      (matrixExpFDerivSelfAdjoint D).toLinearMap
      (matrixExpFDerivSelfAdjoint_diagonal_injective D d hD)).toContinuousLinearEquiv

@[simp]
theorem matrixExpFDerivSelfAdjoint_diagonal_equiv_toContinuousLinearMap
    {n : Nat} (D : selfAdjoint (Matrix (Fin n) (Fin n) Real))
    (d : Fin n -> Real)
    (hD : (D : Matrix (Fin n) (Fin n) Real) = Matrix.diagonal d) :
    ((matrixExpFDerivSelfAdjoint_diagonal_equiv D d hD :
      selfAdjoint (Matrix (Fin n) (Fin n) Real) ≃L[Real]
        selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
      selfAdjoint (Matrix (Fin n) (Fin n) Real) →L[Real]
        selfAdjoint (Matrix (Fin n) (Fin n) Real)) =
      matrixExpFDerivSelfAdjoint D := by
  ext B
  simp [matrixExpFDerivSelfAdjoint_diagonal_equiv]

/-- Entrywise formula for the inverse of the diagonal self-adjoint carrier
exponential derivative, in multiplicative form.

This is the log-side computation primitive behind `CFCLog.lineDeriv`: applying
`(matrixExpFDerivSelfAdjoint_diagonal_equiv D d hD).symm` divides each entry by
the positive exponential divided-difference coefficient. The multiplicative form
avoids an unnecessary division normalization in downstream spectral transport. -/
theorem matrixExpFDerivSelfAdjoint_diagonal_symm_entry_mul
    {n : Nat} (D B : selfAdjoint (Matrix (Fin n) (Fin n) Real))
    (d : Fin n -> Real)
    (hD : (D : Matrix (Fin n) (Fin n) Real) = Matrix.diagonal d)
    (p q : Fin n) :
    matrixExpDividedDifferenceSeries (d p) (d q) *
      ((((matrixExpFDerivSelfAdjoint_diagonal_equiv D d hD).symm B :
        selfAdjoint (Matrix (Fin n) (Fin n) Real)) : Matrix (Fin n) (Fin n) Real) p q) =
      (B : Matrix (Fin n) (Fin n) Real) p q := by
  let e := matrixExpFDerivSelfAdjoint_diagonal_equiv D d hD
  let R : selfAdjoint (Matrix (Fin n) (Fin n) Real) := e.symm B
  have hForwardEntry :
      ((matrixExpFDerivSelfAdjoint D R : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
          Matrix (Fin n) (Fin n) Real) p q =
        matrixExpDividedDifferenceSeries (d p) (d q) *
          (R : Matrix (Fin n) (Fin n) Real) p q := by
    simp [matrixExpFDerivSelfAdjoint_apply_coe, hD,
      matrixExpFDeriv_diagonal_apply_eq_dividedDifferenceSeries_mul]
  have heCLM :
      (e : ContinuousLinearMap (RingHom.id Real)
        (selfAdjoint (Matrix (Fin n) (Fin n) Real))
        (selfAdjoint (Matrix (Fin n) (Fin n) Real))) =
        matrixExpFDerivSelfAdjoint D := by
    simp [e, matrixExpFDerivSelfAdjoint_diagonal_equiv_toContinuousLinearMap D d hD]
  have hMapEntry :
      ((e R : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
          Matrix (Fin n) (Fin n) Real) p q =
        ((matrixExpFDerivSelfAdjoint D R : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
          Matrix (Fin n) (Fin n) Real) p q := by
    exact congrArg
      (fun F : ContinuousLinearMap (RingHom.id Real)
          (selfAdjoint (Matrix (Fin n) (Fin n) Real))
          (selfAdjoint (Matrix (Fin n) (Fin n) Real)) =>
        ((F R : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
          Matrix (Fin n) (Fin n) Real) p q)
      heCLM
  have hEntryEq :
      ((e R : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
          Matrix (Fin n) (Fin n) Real) p q =
        (B : Matrix (Fin n) (Fin n) Real) p q := by
    have h := e.apply_symm_apply B
    change
      ((e (e.symm B) : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
          Matrix (Fin n) (Fin n) Real) p q =
        (B : Matrix (Fin n) (Fin n) Real) p q
    exact congrArg
      (fun Y : selfAdjoint (Matrix (Fin n) (Fin n) Real) =>
        ((Y : Matrix (Fin n) (Fin n) Real) p q)) h
  calc
    matrixExpDividedDifferenceSeries (d p) (d q) *
        ((((matrixExpFDerivSelfAdjoint_diagonal_equiv D d hD).symm B :
          selfAdjoint (Matrix (Fin n) (Fin n) Real)) : Matrix (Fin n) (Fin n) Real) p q) =
        matrixExpDividedDifferenceSeries (d p) (d q) *
          (R : Matrix (Fin n) (Fin n) Real) p q := by
          rfl
    _ = ((matrixExpFDerivSelfAdjoint D R : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
          Matrix (Fin n) (Fin n) Real) p q := by
          exact hForwardEntry.symm
    _ = ((e R : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
          Matrix (Fin n) (Fin n) Real) p q := by
          exact hMapEntry.symm
    _ = (B : Matrix (Fin n) (Fin n) Real) p q := hEntryEq
theorem matrixExpFDerivSelfAdjoint_conj_diagonal_injective_of_mul_eq_one
    {n : Nat} (X : selfAdjoint (Matrix (Fin n) (Fin n) Real))
    (U V : Matrix (Fin n) (Fin n) Real) (d : Fin n -> Real)
    (hX : (X : Matrix (Fin n) (Fin n) Real) = U * Matrix.diagonal d * V)
    (hUV : U * V = 1) (hVU : V * U = 1) :
    Function.Injective (matrixExpFDerivSelfAdjoint X) := by
  intro B C hBC
  apply Subtype.ext
  apply matrixExpFDeriv_conj_diagonal_injective_of_mul_eq_one U V d hUV hVU
  have hamb := congrArg (fun Y : selfAdjoint (Matrix (Fin n) (Fin n) Real) =>
    (Y : Matrix (Fin n) (Fin n) Real)) hBC
  simpa [matrixExpFDerivSelfAdjoint_apply_coe, hX] using hamb

/-- Continuous linear equivalence form of the conjugated-diagonal
self-adjoint carrier exponential derivative. This is the exact shape needed
by the carrier `CFC.log` inverse-function bridge once a spectral
diagonalization has supplied the conjugation data. -/
noncomputable def matrixExpFDerivSelfAdjoint_conj_diagonal_equiv
    {n : Nat} (X : selfAdjoint (Matrix (Fin n) (Fin n) Real))
    (U V : Matrix (Fin n) (Fin n) Real) (d : Fin n -> Real)
    (hX : (X : Matrix (Fin n) (Fin n) Real) = U * Matrix.diagonal d * V)
    (hUV : U * V = 1) (hVU : V * U = 1) :
    selfAdjoint (Matrix (Fin n) (Fin n) Real) ≃L[Real]
      selfAdjoint (Matrix (Fin n) (Fin n) Real) :=
  (LinearEquiv.ofInjectiveEndo
      (matrixExpFDerivSelfAdjoint X).toLinearMap
      (matrixExpFDerivSelfAdjoint_conj_diagonal_injective_of_mul_eq_one
        X U V d hX hUV hVU)).toContinuousLinearEquiv

@[simp]
theorem matrixExpFDerivSelfAdjoint_conj_diagonal_equiv_toContinuousLinearMap
    {n : Nat} (X : selfAdjoint (Matrix (Fin n) (Fin n) Real))
    (U V : Matrix (Fin n) (Fin n) Real) (d : Fin n -> Real)
    (hX : (X : Matrix (Fin n) (Fin n) Real) = U * Matrix.diagonal d * V)
    (hUV : U * V = 1) (hVU : V * U = 1) :
    ((matrixExpFDerivSelfAdjoint_conj_diagonal_equiv X U V d hX hUV hVU :
      selfAdjoint (Matrix (Fin n) (Fin n) Real) ≃L[Real]
        selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
      selfAdjoint (Matrix (Fin n) (Fin n) Real) →L[Real]
        selfAdjoint (Matrix (Fin n) (Fin n) Real)) =
      matrixExpFDerivSelfAdjoint X := by
  ext B
  simp [matrixExpFDerivSelfAdjoint_conj_diagonal_equiv]

/-- Trace-paired conjugated-diagonal double-sum formula for the inverse of the
self-adjoint carrier exponential derivative.

This is the conjugated-basis companion to
`matrixExpFDerivSelfAdjoint_diagonal_symm_entry_mul`. It transports the inverse
derivative into the diagonal basis via `U`, `V`, then packages the resulting
entrywise divided-difference formula back into a trace pairing. -/
theorem trace_mul_matrixExpFDerivSelfAdjoint_conj_diagonal_symm_eq_sum
    {n : Nat} (X B C : selfAdjoint (Matrix (Fin n) (Fin n) Real))
    (U V : Matrix (Fin n) (Fin n) Real) (d : Fin n -> Real)
    (hX : (X : Matrix (Fin n) (Fin n) Real) = U * Matrix.diagonal d * V)
    (hUV : U * V = 1) (hVU : V * U = 1) :
    Matrix.trace ((B : Matrix (Fin n) (Fin n) Real) *
      (((matrixExpFDerivSelfAdjoint_conj_diagonal_equiv X U V d hX hUV hVU).symm C :
          selfAdjoint (Matrix (Fin n) (Fin n) Real)) : Matrix (Fin n) (Fin n) Real)) =
      Finset.univ.sum (fun p => Finset.univ.sum (fun q =>
        ((V * (B : Matrix (Fin n) (Fin n) Real) * U) q p) *
          (((V * (C : Matrix (Fin n) (Fin n) Real) * U) p q) /
            matrixExpDividedDifferenceSeries (d p) (d q)))) := by
  let e := matrixExpFDerivSelfAdjoint_conj_diagonal_equiv X U V d hX hUV hVU
  let Lsa : selfAdjoint (Matrix (Fin n) (Fin n) Real) := e.symm C
  let L : Matrix (Fin n) (Fin n) Real := (Lsa : Matrix (Fin n) (Fin n) Real)
  let B' : Matrix (Fin n) (Fin n) Real := V * (B : Matrix (Fin n) (Fin n) Real) * U
  let C' : Matrix (Fin n) (Fin n) Real := V * (C : Matrix (Fin n) (Fin n) Real) * U
  let R : Matrix (Fin n) (Fin n) Real := V * L * U
  have hTraceRaw :
      Matrix.trace ((B : Matrix (Fin n) (Fin n) Real) * L) =
        Matrix.trace ((V * (B : Matrix (Fin n) (Fin n) Real) * U) * (V * L * U)) := by
    calc
      Matrix.trace ((B : Matrix (Fin n) (Fin n) Real) * L) =
          Matrix.trace (V * (((B : Matrix (Fin n) (Fin n) Real) * L)) * U) := by
            simpa [Matrix.mul_assoc, hUV] using
              (Matrix.trace_mul_cycle V (((B : Matrix (Fin n) (Fin n) Real) * L)) U).symm
      _ = Matrix.trace ((V * (B : Matrix (Fin n) (Fin n) Real) * U) * (V * L * U)) := by
            congr 1
            calc
              V * (((B : Matrix (Fin n) (Fin n) Real) * L)) * U =
                  V * (B : Matrix (Fin n) (Fin n) Real) * L * U := by
                    simp [Matrix.mul_assoc]
              _ = V * (B : Matrix (Fin n) (Fin n) Real) * (U * V) * L * U := by
                    rw [hUV]
                    simp [Matrix.mul_assoc]
              _ = (V * (B : Matrix (Fin n) (Fin n) Real) * U) * (V * L * U) := by
                    simp [Matrix.mul_assoc]
  have hTrace :
      Matrix.trace ((B : Matrix (Fin n) (Fin n) Real) * L) = Matrix.trace (B' * R) := by
    simpa [B', R] using hTraceRaw
  have hForwardEq : e Lsa = C := by
    exact e.apply_symm_apply C
  have hForward : matrixExpFDerivSelfAdjoint X Lsa = C := by
    change ((e : ContinuousLinearMap (RingHom.id Real)
      (selfAdjoint (Matrix (Fin n) (Fin n) Real))
      (selfAdjoint (Matrix (Fin n) (Fin n) Real))) Lsa) = C
    simpa [e] using hForwardEq
  have hXdiag : V * (X : Matrix (Fin n) (Fin n) Real) * U = Matrix.diagonal d := by
    calc
      V * (X : Matrix (Fin n) (Fin n) Real) * U = V * (U * Matrix.diagonal d * V) * U := by
        rw [hX]
      _ = (V * U) * Matrix.diagonal d * (V * U) := by
        simp [Matrix.mul_assoc]
      _ = Matrix.diagonal d := by
        simp [hVU]
  have hConj : matrixExpFDeriv (Matrix.diagonal d) R = C' := by
    calc
      matrixExpFDeriv (Matrix.diagonal d) R =
          matrixExpFDeriv (V * (X : Matrix (Fin n) (Fin n) Real) * U) (V * L * U) := by
            simpa [R] using congrArg (fun M => matrixExpFDeriv M R) hXdiag.symm
      _ = V * matrixExpFDeriv (X : Matrix (Fin n) (Fin n) Real) L * U := by
            simpa [L, R] using
              matrixExpFDeriv_conj_apply_of_mul_eq_one V U
                (X : Matrix (Fin n) (Fin n) Real) L hVU hUV
      _ = C' := by
            simpa [C', L, matrixExpFDerivSelfAdjoint_apply_coe] using
              congrArg
                (fun Y : selfAdjoint (Matrix (Fin n) (Fin n) Real) =>
                  V * ((Y : Matrix (Fin n) (Fin n) Real)) * U)
                hForward
  change Matrix.trace ((B : Matrix (Fin n) (Fin n) Real) * L) =
      Finset.univ.sum (fun p => Finset.univ.sum (fun q =>
        (B' q p) * ((C' p q) / matrixExpDividedDifferenceSeries (d p) (d q))))
  calc
    Matrix.trace ((B : Matrix (Fin n) (Fin n) Real) * L) = Matrix.trace (B' * R) := hTrace
    _ = Finset.univ.sum (fun p => Finset.univ.sum (fun q => B' p q * R q p)) := by
          simp [Matrix.trace, Matrix.mul_apply]
    _ = Finset.univ.sum (fun p => Finset.univ.sum (fun q => B' q p * R p q)) := by
          rw [Finset.sum_comm]
    _ = Finset.univ.sum (fun p => Finset.univ.sum (fun q =>
          B' q p * ((C' p q) / matrixExpDividedDifferenceSeries (d p) (d q)))) := by
          refine Finset.sum_congr rfl ?_
          intro p hp
          refine Finset.sum_congr rfl ?_
          intro q hq
          have hEntry :
              matrixExpDividedDifferenceSeries (d p) (d q) * R p q = C' p q := by
            calc
              matrixExpDividedDifferenceSeries (d p) (d q) * R p q =
                  (matrixExpFDeriv (Matrix.diagonal d) R) p q := by
                    exact
                      (matrixExpFDeriv_diagonal_apply_eq_dividedDifferenceSeries_mul d R p q).symm
              _ = C' p q := by
                    exact congrFun (congrFun hConj p) q
          have hphi : matrixExpDividedDifferenceSeries (d p) (d q) ≠ 0 :=
            matrixExpDividedDifferenceSeries_ne_zero (d p) (d q)
          have hEntryDiv :
              R p q = (C' p q) / matrixExpDividedDifferenceSeries (d p) (d q) := by
            exact (eq_div_iff hphi).2 (by simpa [mul_comm] using hEntry)
          rw [hEntryDiv]

namespace MatrixExpFDeriv

/-- Preferred short alias for
`trace_mul_matrixExpFDerivSelfAdjoint_conj_diagonal_symm_eq_sum`. -/
theorem conjDiagonalSymmTraceSum
    {n : Nat} (X B C : selfAdjoint (Matrix (Fin n) (Fin n) Real))
    (U V : Matrix (Fin n) (Fin n) Real) (d : Fin n -> Real)
    (hX : (X : Matrix (Fin n) (Fin n) Real) = U * Matrix.diagonal d * V)
    (hUV : U * V = 1) (hVU : V * U = 1) :
    Matrix.trace ((B : Matrix (Fin n) (Fin n) Real) *
      (((matrixExpFDerivSelfAdjoint_conj_diagonal_equiv X U V d hX hUV hVU).symm C :
          selfAdjoint (Matrix (Fin n) (Fin n) Real)) : Matrix (Fin n) (Fin n) Real)) =
      Finset.univ.sum (fun p => Finset.univ.sum (fun q =>
        ((V * (B : Matrix (Fin n) (Fin n) Real) * U) q p) *
          (((V * (C : Matrix (Fin n) (Fin n) Real) * U) p q) /
            matrixExpDividedDifferenceSeries (d p) (d q)))) :=
  trace_mul_matrixExpFDerivSelfAdjoint_conj_diagonal_symm_eq_sum
    X B C U V d hX hUV hVU

end MatrixExpFDeriv

private theorem selfAdjoint_spectral_conj_diagonal_eq
    {n : Nat} (X : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
    (X : Matrix (Fin n) (Fin n) Real) =
      (X.2.isHermitian.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) *
        Matrix.diagonal X.2.isHermitian.eigenvalues *
        star (X.2.isHermitian.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) := by
  simpa [Unitary.conjStarAlgAut_apply] using X.2.isHermitian.spectral_theorem

/-- The self-adjoint carrier exponential derivative is injective at every
self-adjoint base point. The proof packages Mathlib's finite-dimensional
spectral theorem into the conjugated-diagonal transfer already proved above. -/
private theorem matrixExpFDerivSelfAdjoint_spectral_injective
    {n : Nat} (X : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
    Function.Injective (matrixExpFDerivSelfAdjoint X) := by
  refine matrixExpFDerivSelfAdjoint_conj_diagonal_injective_of_mul_eq_one X
    (X.2.isHermitian.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real)
    (star (X.2.isHermitian.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real))
    X.2.isHermitian.eigenvalues ?_ ?_ ?_
  · exact selfAdjoint_spectral_conj_diagonal_eq X
  · simp
  · simp

/-- Continuous linear equivalence form of the self-adjoint carrier exponential
derivative at an arbitrary self-adjoint base point. This is the inverse-function
primitive needed by the general carrier `CFC.log` strict derivative. -/
noncomputable def matrixExpFDerivSelfAdjoint_spectral_equiv
    {n : Nat} (X : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
    ContinuousLinearEquiv (RingHom.id Real)
      (selfAdjoint (Matrix (Fin n) (Fin n) Real))
      (selfAdjoint (Matrix (Fin n) (Fin n) Real)) :=
  (LinearEquiv.ofInjectiveEndo
      (matrixExpFDerivSelfAdjoint X).toLinearMap
      (matrixExpFDerivSelfAdjoint_spectral_injective X)).toContinuousLinearEquiv

/-- Carrier-form Frechet derivative of matrix exponential on the self-adjoint
subspace. This is the self-adjoint carrier restriction of the matrix
exponential only; it is not a `CFC.log` derivative or an Epstein/Lieb/Tropp
statement. -/
theorem hasFDerivAt_matrix_exp_selfAdjoint
    {n : Nat} (A : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
    HasFDerivAt
      (fun X : selfAdjoint (Matrix (Fin n) (Fin n) Real) => matrixExpSelfAdjoint X)
      (matrixExpFDerivSelfAdjoint A)
      A := by
  have hAmbient :
      HasFDerivAt
        (fun X : selfAdjoint (Matrix (Fin n) (Fin n) Real) =>
          NormedSpace.exp (X : Matrix (Fin n) (Fin n) Real))
        ((matrixExpFDeriv (A : Matrix (Fin n) (Fin n) Real)).comp
          (selfAdjoint.subtypeL (A := Matrix (Fin n) (Fin n) Real)))
        A :=
    (hasFDerivAt_matrix_exp (A : Matrix (Fin n) (Fin n) Real)).comp A
      (selfAdjoint.subtypeL (A := Matrix (Fin n) (Fin n) Real)).hasFDerivAt
  exact HasFDerivAt.of_isLittleO (by
    rw [<- Asymptotics.isLittleO_norm_left]
    simpa [matrixExpSelfAdjoint, matrixExpFDerivSelfAdjoint_apply_coe] using
      hAmbient.isLittleO.norm_left)

/-- Carrier-form strict Frechet derivative of matrix exponential on the
self-adjoint subspace. This remains only the matrix-exp side of the future
`CFC.log` derivative route. -/
theorem hasStrictFDerivAt_matrix_exp_selfAdjoint
    {n : Nat} (A : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
    HasStrictFDerivAt
      (fun X : selfAdjoint (Matrix (Fin n) (Fin n) Real) => matrixExpSelfAdjoint X)
      (matrixExpFDerivSelfAdjoint A)
      A := by
  have hAmbient :
      HasStrictFDerivAt
        (fun X : selfAdjoint (Matrix (Fin n) (Fin n) Real) =>
          NormedSpace.exp (X : Matrix (Fin n) (Fin n) Real))
        ((matrixExpFDeriv (A : Matrix (Fin n) (Fin n) Real)).comp
          (selfAdjoint.subtypeL (A := Matrix (Fin n) (Fin n) Real)))
        A :=
    (hasStrictFDerivAt_matrix_exp (A : Matrix (Fin n) (Fin n) Real)).comp A
      (selfAdjoint.subtypeL (A := Matrix (Fin n) (Fin n) Real)).hasStrictFDerivAt
  exact HasStrictFDerivAt.of_isLittleO (by
    rw [<- Asymptotics.isLittleO_norm_left]
    simpa [matrixExpSelfAdjoint, matrixExpFDerivSelfAdjoint_apply_coe] using
      hAmbient.isLittleO.norm_left)

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
