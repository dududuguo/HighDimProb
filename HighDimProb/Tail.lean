import HighDimProb.RandomVariable

/-!
# Tail events
-/

namespace HighDimProb

open MeasureTheory

/-- Upper-tail event `{ω | t ≤ X ω}` for a real random variable. -/
def upperTailEvent {Ω : Type*} [MeasurableSpace Ω]
    (X : RealRandomVariable Ω) (t : ℝ) : Event Ω :=
  {ω | t ≤ X ω}

/-- Lower-tail event `{ω | X ω ≤ t}` for a real random variable. -/
def lowerTailEvent {Ω : Type*} [MeasurableSpace Ω]
    (X : RealRandomVariable Ω) (t : ℝ) : Event Ω :=
  {ω | X ω ≤ t}

/-- Absolute-tail event `{ω | t ≤ |X ω|}` for a real random variable. -/
def absTailEvent {Ω : Type*} [MeasurableSpace Ω]
    (X : RealRandomVariable Ω) (t : ℝ) : Event Ω :=
  {ω | t ≤ |X ω|}

/-- Upper-tail probability `P {ω | t ≤ X ω}`. -/
def upperTailProb {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) (t : ℝ) : ENNReal :=
  P (upperTailEvent X t)

/-- Lower-tail probability `P {ω | X ω ≤ t}`. -/
def lowerTailProb {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) (t : ℝ) : ENNReal :=
  P (lowerTailEvent X t)

/-- Absolute-tail probability `P {ω | t ≤ |X ω|}`. -/
def absTailProb {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) (t : ℝ) : ENNReal :=
  P (absTailEvent X t)

@[simp]
theorem mem_upperTailEvent {Ω : Type*} [MeasurableSpace Ω]
    (X : RealRandomVariable Ω) (t : ℝ) (ω : Ω) :
    ω ∈ upperTailEvent X t ↔ t ≤ X ω :=
  Iff.rfl

@[simp]
theorem mem_lowerTailEvent {Ω : Type*} [MeasurableSpace Ω]
    (X : RealRandomVariable Ω) (t : ℝ) (ω : Ω) :
    ω ∈ lowerTailEvent X t ↔ X ω ≤ t :=
  Iff.rfl

@[simp]
theorem mem_absTailEvent {Ω : Type*} [MeasurableSpace Ω]
    (X : RealRandomVariable Ω) (t : ℝ) (ω : Ω) :
    ω ∈ absTailEvent X t ↔ t ≤ |X ω| :=
  Iff.rfl

/-- A measurable real random variable has measurable upper-tail events. -/
theorem measurableSet_upperTailEvent {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} {X : RealRandomVariable Ω} (hX : IsRealRandomVariable P X) (t : ℝ) :
    MeasurableSet (upperTailEvent X t) :=
  hX measurableSet_Ici

/-- A measurable real random variable has measurable lower-tail events. -/
theorem measurableSet_lowerTailEvent {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} {X : RealRandomVariable Ω} (hX : IsRealRandomVariable P X) (t : ℝ) :
    MeasurableSet (lowerTailEvent X t) :=
  hX measurableSet_Iic

/-- A measurable real random variable has measurable absolute-tail events. -/
theorem measurableSet_absTailEvent {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} {X : RealRandomVariable Ω} (hX : IsRealRandomVariable P X) (t : ℝ) :
    MeasurableSet (absTailEvent X t) :=
  (continuous_abs.measurable.comp hX) measurableSet_Ici

/-- HighDimProb event-form version of `measurableSet_upperTailEvent`. -/
theorem isMeasurableEvent_upperTailEvent {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} {X : RealRandomVariable Ω} (hX : IsRealRandomVariable P X) (t : ℝ) :
    IsMeasurableEvent (upperTailEvent X t) :=
  measurableSet_upperTailEvent hX t

/-- HighDimProb event-form version of `measurableSet_lowerTailEvent`. -/
theorem isMeasurableEvent_lowerTailEvent {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} {X : RealRandomVariable Ω} (hX : IsRealRandomVariable P X) (t : ℝ) :
    IsMeasurableEvent (lowerTailEvent X t) :=
  measurableSet_lowerTailEvent hX t

/-- HighDimProb event-form version of `measurableSet_absTailEvent`. -/
theorem isMeasurableEvent_absTailEvent {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} {X : RealRandomVariable Ω} (hX : IsRealRandomVariable P X) (t : ℝ) :
    IsMeasurableEvent (absTailEvent X t) :=
  measurableSet_absTailEvent hX t

@[simp]
theorem upperTailProb_def {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) (t : ℝ) :
    upperTailProb P X t = P (upperTailEvent X t) :=
  rfl

@[simp]
theorem lowerTailProb_def {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) (t : ℝ) :
    lowerTailProb P X t = P (lowerTailEvent X t) :=
  rfl

@[simp]
theorem absTailProb_def {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : RealRandomVariable Ω) (t : ℝ) :
    absTailProb P X t = P (absTailEvent X t) :=
  rfl

end HighDimProb
