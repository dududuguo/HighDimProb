import HighDimProb.Distributions.Rademacher
import Mathlib.Probability.Independence.Basic
import Mathlib.Probability.ProductMeasure

/-!
# Finite Rademacher families

This file provides the finite product probability space for independent
canonical Rademacher signs indexed by `Fin n`.
-/

namespace HighDimProb

open MeasureTheory ProbabilityTheory

noncomputable section

/-- Product probability measure for `n` independent canonical Rademacher signs. -/
def rademacherVectorMeasure (n : ℕ) : Measure (Fin n → Bool) :=
  Measure.pi fun _ : Fin n => rademacherMeasure

instance instIsProbabilityMeasure_rademacherVectorMeasure (n : ℕ) :
    IsProbabilityMeasure (rademacherVectorMeasure n) := by
  unfold rademacherVectorMeasure
  infer_instance

/--
The PMF corresponding to the finite Rademacher product measure.

The measure, not the PMF, is the primary proof object because Mathlib's
coordinate-independence theorem is stated for `Measure.pi`.
-/
def rademacherVectorPMF (n : ℕ) : PMF (Fin n → Bool) :=
  (rademacherVectorMeasure n).toPMF

/-- The PMF representation induces the finite Rademacher product measure. -/
theorem rademacherVectorPMF_toMeasure (n : ℕ) :
    (rademacherVectorPMF n).toMeasure = rademacherVectorMeasure n := by
  unfold rademacherVectorPMF
  exact Measure.toPMF_toMeasure (rademacherVectorMeasure n)

/-- The `i`th coordinate Rademacher random variable on the finite product space. -/
def rademacherCoord {n : ℕ} (i : Fin n) :
    RealRandomVariable (Fin n → Bool) :=
  fun ω => rademacher (ω i)

/-- The full coordinate Rademacher vector on the finite product space. -/
def rademacherVector (n : ℕ) : (Fin n → Bool) → Fin n → ℝ :=
  fun ω i => rademacher (ω i)

@[simp]
theorem rademacherVector_apply {n : ℕ} (ω : Fin n → Bool) (i : Fin n) :
    rademacherVector n ω i = rademacherCoord i ω :=
  rfl

/-- Every coordinate Rademacher variable is measurable. -/
theorem isRealRandomVariable_rademacherCoord {n : ℕ} (i : Fin n) :
    IsRealRandomVariable (rademacherVectorMeasure n) (rademacherCoord i) := by
  unfold IsRealRandomVariable IsRandomVariable rademacherCoord rademacher
  fun_prop

/-- Coordinate Rademacher variables are pointwise contained in `[-1, 1]`. -/
theorem rademacherCoord_mem_Icc {n : ℕ} (i : Fin n) (ω : Fin n → Bool) :
    Set.Icc (-1 : ℝ) 1 (rademacherCoord i ω) :=
  rademacher_mem_Icc (ω i)

/-- Each coordinate Rademacher variable has mean zero. -/
theorem integral_rademacherCoord {n : ℕ} (i : Fin n) :
    MeasureTheory.integral (rademacherVectorMeasure n) (rademacherCoord i) = 0 := by
  unfold rademacherVectorMeasure rademacherCoord
  have hmp :
      MeasurePreserving
        (fun ω : Fin n → Bool => ω i)
        (Measure.pi fun _ : Fin n => rademacherMeasure)
        rademacherMeasure := by
    simpa using
      (measurePreserving_eval (fun _ : Fin n => rademacherMeasure) i)
  calc
    MeasureTheory.integral (Measure.pi fun _ : Fin n => rademacherMeasure)
        (fun ω : Fin n → Bool => rademacher (ω i))
        = MeasureTheory.integral
            (Measure.map (fun ω : Fin n → Bool => ω i)
              (Measure.pi fun _ : Fin n => rademacherMeasure))
            rademacher := by
          exact
            (MeasureTheory.integral_map
              (φ := fun ω : Fin n → Bool => ω i)
              (μ := Measure.pi fun _ : Fin n => rademacherMeasure)
              (f := rademacher) hmp.aemeasurable (by
                rw [hmp.map_eq]
                exact isRealRandomVariable_rademacher.aestronglyMeasurable)).symm
    _ = MeasureTheory.integral rademacherMeasure rademacher := by
          rw [hmp.map_eq]
    _ = 0 := integral_rademacher

/-- The finite coordinate Rademacher family is independent under the product measure. -/
theorem iIndepFun_rademacherCoord (n : ℕ) :
    ProbabilityTheory.iIndepFun
      (fun i : Fin n => rademacherCoord i) (rademacherVectorMeasure n) := by
  unfold rademacherVectorMeasure rademacherCoord
  exact
    ProbabilityTheory.iIndepFun_pi
      (μ := fun _ : Fin n => rademacherMeasure)
      (X := fun _ : Fin n => rademacher)
      (fun _ => isRealRandomVariable_rademacher.aemeasurable)

end

end HighDimProb
