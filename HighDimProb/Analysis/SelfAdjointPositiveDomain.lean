import Mathlib.Analysis.CStarAlgebra.Matrix
import Mathlib.Analysis.CStarAlgebra.ContinuousFunctionalCalculus.Unital
import Mathlib.Analysis.Normed.Algebra.Spectrum
import HighDimProb.Analysis.SelfAdjointCarrier
import Mathlib.Analysis.Matrix.Order

/-!
# Strictly positive self-adjoint matrix domain

This module packages the strictly positive real matrix domain in the
`selfAdjoint` carrier used by the provider's Jensen-side transport work.

It only exposes carrier/domain wrappers and small reusable set-level API.
It does not prove any Lieb/Jensen exact statement.
-/

noncomputable section

namespace HighDimProb

open Set Topology
open scoped MatrixOrder Matrix.Norms.L2Operator
open Matrix

/-- The strictly positive real self-adjoint matrices, viewed in the
`selfAdjoint` carrier. -/
abbrev selfAdjointStrictlyPositiveSet (n : Nat) :
    Set (selfAdjoint (Matrix (Fin n) (Fin n) ℝ)) :=
  { M | IsStrictlyPositive (M : Matrix (Fin n) (Fin n) ℝ) }

@[simp]
theorem mem_selfAdjointStrictlyPositiveSet {n : Nat}
    {M : selfAdjoint (Matrix (Fin n) (Fin n) ℝ)} :
    M ∈ selfAdjointStrictlyPositiveSet n ↔
      IsStrictlyPositive (M : Matrix (Fin n) (Fin n) ℝ) :=
  Iff.rfl

@[simp]
theorem mem_selfAdjointStrictlyPositiveSet_iff_posDef {n : Nat}
    {M : selfAdjoint (Matrix (Fin n) (Fin n) ℝ)} :
    M ∈ selfAdjointStrictlyPositiveSet n ↔
      ((M : Matrix (Fin n) (Fin n) ℝ)).PosDef := by
  rw [mem_selfAdjointStrictlyPositiveSet, Matrix.isStrictlyPositive_iff_posDef]

/-- The carrier-form strictly positive domain is convex. -/
theorem convex_selfAdjointStrictlyPositiveSet (n : Nat) :
    Convex ℝ (selfAdjointStrictlyPositiveSet n) := by
  classical
  intro x hx y hy a b ha hb hab
  have hxpd : ((x : Matrix (Fin n) (Fin n) ℝ)).PosDef :=
    (mem_selfAdjointStrictlyPositiveSet_iff_posDef).mp hx
  have hypd : ((y : Matrix (Fin n) (Fin n) ℝ)).PosDef :=
    (mem_selfAdjointStrictlyPositiveSet_iff_posDef).mp hy
  by_cases ha0 : a = 0
  · have hb1 : b = 1 := by nlinarith [hab, ha0]
    subst ha0 hb1
    simpa using hy
  · by_cases hb0 : b = 0
    · have ha1 : a = 1 := by nlinarith [hab, hb0]
      subst hb0 ha1
      simpa using hx
    · have ha_pos : 0 < a := lt_of_le_of_ne ha (Ne.symm ha0)
      have hb_pos : 0 < b := lt_of_le_of_ne hb (Ne.symm hb0)
      have hsum :
          (a • ((x : Matrix (Fin n) (Fin n) ℝ)) +
              b • ((y : Matrix (Fin n) (Fin n) ℝ))).PosDef :=
        (hxpd.smul ha_pos).add (hypd.smul hb_pos)
      exact (mem_selfAdjointStrictlyPositiveSet_iff_posDef).mpr hsum

private theorem isOpen_matrix_strictlyPositiveOnSelfAdjointCarrier (n : Nat) :
    IsOpen {M : selfAdjoint (Matrix (Fin n) (Fin n) ℝ) |
      spectrum ℝ (M : Matrix (Fin n) (Fin n) ℝ) ⊆ Ioi (0 : ℝ)} := by
  let f : selfAdjoint (Matrix (Fin n) (Fin n) ℝ) → Set ℝ :=
    fun M => spectrum ℝ (M : Matrix (Fin n) (Fin n) ℝ)
  have hf : UpperHemicontinuous f := by
    simpa [f] using
      (upperHemicontinuous_spectrum ℝ (Matrix (Fin n) (Fin n) ℝ)).comp continuous_subtype_val
  exact (upperHemicontinuous_iff_isOpen_preimage_Iic.mp hf) (Ioi (0 : ℝ)) isOpen_Ioi

/-- The strictly positive self-adjoint carrier domain is open. -/
theorem isOpen_selfAdjointStrictlyPositiveSet (n : Nat) :
    IsOpen (selfAdjointStrictlyPositiveSet n) := by
  rw [show selfAdjointStrictlyPositiveSet n =
      {M : selfAdjoint (Matrix (Fin n) (Fin n) ℝ) |
        spectrum ℝ (M : Matrix (Fin n) (Fin n) ℝ) ⊆ Ioi (0 : ℝ)} from by
        ext M
        change IsStrictlyPositive (M : Matrix (Fin n) (Fin n) ℝ) ↔
          spectrum ℝ (M : Matrix (Fin n) (Fin n) ℝ) ⊆ Ioi (0 : ℝ)
        simpa using
          (StarOrderedRing.isStrictlyPositive_iff_spectrum_pos
            (a := (M : Matrix (Fin n) (Fin n) ℝ)) M.2)]
  exact isOpen_matrix_strictlyPositiveOnSelfAdjointCarrier n

end HighDimProb