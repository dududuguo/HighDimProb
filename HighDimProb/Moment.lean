import HighDimProb.Lp

/-!
# Moment vocabulary

Early moment infrastructure is intentionally phrased through Mathlib `MemLp`.
-/

namespace HighDimProb

open MeasureTheory

noncomputable section

/-- A real random variable has finite `p`-moment when it belongs to `L^p(P)`. -/
abbrev HasFiniteMoment {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) (p : ENNReal) : Prop :=
  MemLpRealRandomVariable P X p

/-- Moment-size vocabulary reusing Mathlib's extended `L^p` seminorm. -/
abbrev momentSeminorm {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) (p : ENNReal) : ENNReal :=
  realLpNorm P X p

@[simp]
theorem hasFiniteMoment_iff {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) (p : ENNReal) :
    HasFiniteMoment P X p ↔ MemLp X p P :=
  Iff.rfl

@[simp]
theorem momentSeminorm_def {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) (p : ENNReal) :
    momentSeminorm P X p = eLpNorm X p P :=
  rfl

end

end HighDimProb
