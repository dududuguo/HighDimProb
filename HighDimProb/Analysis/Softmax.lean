import HighDimProb.Analysis.LogSumExp
import Mathlib.MeasureTheory.Function.SpecialFunctions.Basic

set_option autoImplicit false

namespace HighDimProb

open scoped BigOperators

/-!
# Exponential (Gibbs) normalization

Deterministic algebra and measurability for the exponential normalization of a
finite real vector at scale `tau`:

`expNormalized tau z i = exp (z i / tau) / sum_j exp (z j / tau)`.

The denominator is a nonempty finite exponential sum, so it is strictly positive
(reusing `HighDimProb.sum_exp_pos`). This layer proves positivity, the coordinate
sum `1`, the coordinate bound `1`, the squared-coordinate sum bound `1`, shift
invariance, and measurability. It is intentionally probability-free and defined
for every real `tau`; it is the general object underlying softmax attention,
which specializes it to a positive temperature `tau > 0` (see the Attention
example). The probability interface (independence transfer, `MemLp`) is built by
consumers.
-/

/-- Exponential (Gibbs) normalization of a finite real vector at scale `tau`.

`expNormalized tau z i = exp (z i / tau) / sum_j exp (z j / tau)`.

Defined for every `tau : Real` via Lean's `x / 0 = 0` convention: `tau = 0`
collapses every coordinate to `0`, giving the uniform vector, and `tau < 0`
reverses the order, so in general this is an exponential (Gibbs) normalization
rather than an attention temperature. Softmax attention weights are
`expNormalized tau z` at a positive temperature `tau > 0`; the probability-vector
and squared-norm bounds below hold for every `tau`, while genuine attention
temperature and the deferred `1 / (2 * tau)` softmax-Jacobian Lipschitz bound
additionally require `tau > 0`. -/
noncomputable def expNormalized {ι : Type*} [Fintype ι] (tau : Real) (z : ι → Real)
    (i : ι) : Real :=
  Real.exp (z i / tau) / ∑ j, Real.exp (z j / tau)

@[simp]
theorem expNormalized_apply {ι : Type*} [Fintype ι] (tau : Real) (z : ι → Real)
    (i : ι) :
    expNormalized tau z i = Real.exp (z i / tau) / ∑ j, Real.exp (z j / tau) :=
  rfl

/-- The normalization denominator is strictly positive on a nonempty index type. -/
theorem expNormalized_denom_pos {ι : Type*} [Fintype ι] [Nonempty ι] (tau : Real)
    (z : ι → Real) :
    0 < ∑ j, Real.exp (z j / tau) := by
  have h : 0 < ∑ j, Real.exp ((1 / tau) * z j) :=
    sum_exp_pos Finset.univ_nonempty z (1 / tau)
  simpa only [one_div_mul_eq_div] using h

/-- Each normalized coordinate is strictly positive. -/
theorem expNormalized_pos {ι : Type*} [Fintype ι] [Nonempty ι] (tau : Real)
    (z : ι → Real) (i : ι) :
    0 < expNormalized tau z i :=
  div_pos (Real.exp_pos _) (expNormalized_denom_pos tau z)

/-- Each normalized coordinate is nonnegative. -/
theorem expNormalized_nonneg {ι : Type*} [Fintype ι] [Nonempty ι] (tau : Real)
    (z : ι → Real) (i : ι) :
    0 ≤ expNormalized tau z i :=
  (expNormalized_pos tau z i).le

/-- The normalized coordinates sum to `1`. -/
theorem expNormalized_sum {ι : Type*} [Fintype ι] [Nonempty ι] (tau : Real)
    (z : ι → Real) :
    ∑ i, expNormalized tau z i = 1 := by
  unfold expNormalized
  rw [← Finset.sum_div, div_self (ne_of_gt (expNormalized_denom_pos tau z))]

/-- Each normalized coordinate is at most `1`. -/
theorem expNormalized_le_one {ι : Type*} [Fintype ι] [Nonempty ι] (tau : Real)
    (z : ι → Real) (i : ι) :
    expNormalized tau z i ≤ 1 := by
  unfold expNormalized
  rw [div_le_one (expNormalized_denom_pos tau z)]
  exact Finset.single_le_sum (f := fun j => Real.exp (z j / tau))
    (fun j _ => (Real.exp_pos (z j / tau)).le) (Finset.mem_univ i)

/-- The sum of squared normalized coordinates is at most `1`.

Since `0 ≤ p_i ≤ 1` we have `p_i^2 ≤ p_i`, and the coordinates sum to `1`. -/
theorem expNormalized_sq_sum_le_one {ι : Type*} [Fintype ι] [Nonempty ι] (tau : Real)
    (z : ι → Real) :
    ∑ i, expNormalized tau z i ^ 2 ≤ 1 := by
  calc
    ∑ i, expNormalized tau z i ^ 2 ≤ ∑ i, expNormalized tau z i := by
      refine Finset.sum_le_sum (fun i _ => ?_)
      have h0 : 0 ≤ expNormalized tau z i := expNormalized_nonneg tau z i
      have h1 : expNormalized tau z i ≤ 1 := expNormalized_le_one tau z i
      nlinarith [mul_nonneg h0 (sub_nonneg.mpr h1)]
    _ = 1 := expNormalized_sum tau z

/-- Exponential normalization is invariant under adding a constant to every
coordinate. -/
theorem expNormalized_shift_invariant {ι : Type*} [Fintype ι] (tau c : Real)
    (z : ι → Real) :
    expNormalized tau (fun i => z i + c) = expNormalized tau z := by
  have hnum : ∀ j : ι,
      Real.exp ((z j + c) / tau) = Real.exp (z j / tau) * Real.exp (c / tau) :=
    fun j => by rw [add_div, Real.exp_add]
  funext i
  unfold expNormalized
  rw [hnum i, Finset.sum_congr rfl (fun j _ => hnum j), ← Finset.sum_mul,
    mul_div_mul_right _ _ (Real.exp_ne_zero (c / tau))]

/-- Each normalized coordinate is a measurable function of the score vector. -/
theorem measurable_expNormalized_coord {ι : Type*} [Fintype ι] (tau : Real) (i : ι) :
    Measurable (fun z : ι → Real => expNormalized tau z i) := by
  unfold expNormalized
  fun_prop

/-- The exponential-normalization map is measurable. -/
theorem measurable_expNormalized {ι : Type*} [Fintype ι] (tau : Real) :
    Measurable (fun z : ι → Real => expNormalized tau z) :=
  measurable_pi_lambda _ (fun i => measurable_expNormalized_coord tau i)

end HighDimProb
