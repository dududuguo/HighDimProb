import Mathlib
import Mathlib.Topology.Algebra.Module.Star

/-!
# Self-adjoint carrier bridge

This module bridges the two Mathlib carriers used for real self-adjoint elements:
`selfAdjoint A` and the subtype carrier of `selfAdjoint.submodule Real A`.
-/

noncomputable section

namespace selfAdjoint

section Carrier

variable {A : Type*}
variable [NormedAddCommGroup A] [NormedSpace Real A]
variable [StarAddMonoid A] [StarModule Real A]

instance : ContinuousENorm (selfAdjoint A) where
  toENorm := inferInstance
  continuous_enorm :=
    (continuous_enorm : Continuous fun a : A => enorm a).comp continuous_subtype_val

instance : ContinuousENorm (selfAdjoint.submodule Real A) where
  toENorm := inferInstance
  continuous_enorm :=
    (continuous_enorm : Continuous fun a : A => enorm a).comp continuous_subtype_val

/-- The self-adjoint carrier inherits continuous real scalar multiplication
from the ambient normed real vector space. This lets finite-dimensional linear
equivalences on `selfAdjoint A` upgrade to continuous linear equivalences. -/
instance instContinuousSMulSelfAdjoint : ContinuousSMul Real (selfAdjoint A) :=
  Topology.IsInducing.continuousSMul (g := fun x : selfAdjoint A => (x : A))
    (f := fun r : Real => r) Topology.IsInducing.subtypeVal continuous_id (by intro c x; rfl)

omit [NormedSpace Real A] [StarModule Real A] in
theorem isClosed [ContinuousStar A] : IsClosed (selfAdjoint A : Set A) := by
  simpa [selfAdjoint.mem_iff] using
    (isClosed_eq (continuous_star : Continuous fun a : A => star a) continuous_id :
      IsClosed {a : A | star a = a})

instance instCompleteSpaceSelfAdjoint
    [CompleteSpace A] [ContinuousStar A] : CompleteSpace (selfAdjoint A) := by
  let hClosed : IsClosed (selfAdjoint A : Set A) := selfAdjoint.isClosed (A := A)
  exact hClosed.completeSpace_coe
/-- Continuous linear equivalence between `selfAdjoint A` and the subtype carrier
of `selfAdjoint.submodule Real A`. -/
@[simps!]
def submoduleContinuousLinearEquiv :
    ContinuousLinearEquiv (RingHom.id Real) (selfAdjoint A) (selfAdjoint.submodule Real A) where
  toLinearEquiv :=
    { toFun := fun x => Subtype.mk x.1 x.2
      invFun := fun x => Subtype.mk x.1 x.2
      left_inv := fun _ => rfl
      right_inv := fun _ => rfl
      map_add' := fun _ _ => rfl
      map_smul' := fun _ _ => rfl }
  continuous_toFun := continuous_subtype_val.subtype_mk _
  continuous_invFun := continuous_subtype_val.subtype_mk _

instance instFiniteDimensionalSelfAdjoint [FiniteDimensional Real A] :
    FiniteDimensional Real (selfAdjoint A) := by
  letI : FiniteDimensional Real (selfAdjoint.submodule Real A) :=
    FiniteDimensional.finiteDimensional_submodule (selfAdjoint.submodule Real A)
  exact LinearEquiv.finiteDimensional
    (submoduleContinuousLinearEquiv (A := A)).toLinearEquiv.symm

@[simp]
theorem coe_submoduleContinuousLinearEquiv_apply (x : selfAdjoint A) :
    ((submoduleContinuousLinearEquiv (A := A) x : selfAdjoint.submodule Real A) : A) = x :=
  rfl

@[simp]
theorem coe_submoduleContinuousLinearEquiv_symm_apply (x : selfAdjoint.submodule Real A) :
    ((submoduleContinuousLinearEquiv (A := A)).symm x : A) = x :=
  rfl

/-- The coercion from `selfAdjoint A` to `A` as a continuous linear map. -/
def subtypeL : ContinuousLinearMap (RingHom.id Real) (selfAdjoint A) A :=
  (selfAdjoint.submodule Real A).subtypeL.comp
    (submoduleContinuousLinearEquiv (A := A)).toContinuousLinearMap

@[simp]
theorem subtypeL_apply (x : selfAdjoint A) : subtypeL (A := A) x = (x : A) :=
  rfl

section Integral

variable {X : Type*}
variable [MeasurableSpace X] {mu : MeasureTheory.Measure X}

/-- Lift ambient Bochner integrability into the `selfAdjoint` carrier when all values are
pointwise self-adjoint. -/
theorem integrable_mk_of_integrable_coe
    [ContinuousAdd A] [ContinuousStar A] [ContinuousConstSMul Real A]
    [Invertible (2 : Real)]
    {F : X -> A} (hF : MeasureTheory.Integrable F mu) (hSA : forall x, IsSelfAdjoint (F x)) :
    MeasureTheory.Integrable (fun x => ((Subtype.mk (F x) (hSA x)) : selfAdjoint A)) mu := by
  have hpart :
      MeasureTheory.Integrable (fun x => selfAdjointPartL (R := Real) (A := A) (F x)) mu :=
    (selfAdjointPartL (R := Real) (A := A)).integrable_comp hF
  refine hpart.congr <| Filter.Eventually.of_forall fun x => ?_
  simpa [selfAdjointPartL] using (hSA x).selfAdjointPart_apply (R := Real)

variable [CompleteSpace A]

theorem coe_integral [hSA : CompleteSpace (selfAdjoint A)] {F : X -> selfAdjoint A}
    (hF : MeasureTheory.Integrable F mu) :
    ((MeasureTheory.integral mu F : selfAdjoint A) : A) =
      MeasureTheory.integral mu (fun x => (F x : A)) := by
  simpa [subtypeL_apply] using
    (@ContinuousLinearMap.integral_comp_comm X (selfAdjoint A) A _ mu Real _ _ _ _ _ _ _ _ hSA
      (subtypeL (A := A)) F hF).symm

end Integral

end Carrier

section Part

variable {A : Type*}
variable [NormedAddCommGroup A] [NormedSpace Real A]
variable [StarAddMonoid A] [StarModule Real A]
variable [ContinuousAdd A] [ContinuousStar A] [ContinuousConstSMul Real A]
variable [Invertible (2 : Real)]

/-- `selfAdjointPartL` retargeted to the submodule carrier. -/
def partSubmoduleL : ContinuousLinearMap (RingHom.id Real) A (selfAdjoint.submodule Real A) :=
  (submoduleContinuousLinearEquiv (A := A)).toContinuousLinearMap.comp
    (selfAdjointPartL (R := Real) (A := A))

@[simp]
theorem coe_partSubmoduleL_apply (x : A) :
    ((partSubmoduleL (A := A) x : selfAdjoint.submodule Real A) : A) =
      ((selfAdjointPartL (R := Real) (A := A) x : selfAdjoint A) : A) :=
  rfl

end Part

end selfAdjoint
