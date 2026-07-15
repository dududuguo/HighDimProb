import HighDimProb.RandomVariable
import HighDimProb.Lp

/-!
# Expectation

HighDimProb uses Mathlib integral notation for expectations. The alias in this file is only a
lightweight ergonomic wrapper for real-valued random variables.

Verified Wikipedia references:
* Expected value: https://en.wikipedia.org/wiki/Expected_value
* Law of the unconscious statistician: https://en.wikipedia.org/wiki/Law_of_the_unconscious_statistician
-/

namespace HighDimProb

open MeasureTheory

noncomputable section

/--
Expectation of a real-valued random variable, as a Mathlib integral.

Formula reference: expectation is represented as an integral,
`E[X] = integral X dP`; see https://en.wikipedia.org/wiki/Expected_value
-/
abbrev expect {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) : ℝ :=
  ∫ ω, X ω ∂P

@[simp]
theorem expect_def {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) :
    expect P X = ∫ ω, X ω ∂P :=
  rfl

/-- Expectation commutes with finite sums of integrable real random variables. -/
theorem expect_finset_sum {Ω ι : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} {s : Finset ι} {X : ι → RealRandomVariable Ω}
    (hX : ∀ i, i ∈ s → IntegrableRealRandomVariable P (X i)) :
    expect P (fun ω => ∑ i ∈ s, X i ω) =
      ∑ i ∈ s, expect P (X i) := by
  change (∫ ω, ∑ i ∈ s, X i ω ∂P) =
    ∑ i ∈ s, ∫ ω, X i ω ∂P
  exact MeasureTheory.integral_finset_sum s hX

end

end HighDimProb
