import HighDimProb.RandomMatrix.TraceExpLogContinuityProvider
import HighDimProb.RandomMatrix.MatrixExpDerivativeProvider
import Mathlib.Analysis.Calculus.InverseFunctionTheorem.FDeriv

/-!
# Local-inverse prerequisites for the CFC logarithm

This module records the part of the `CFC.log` affine-line derivative route that
is currently available from provider and Mathlib APIs. It does not prove a
derivative of `CFC.log`; instead, it packages continuity, the local
`exp (log M) = M` right-inverse identity on the strictly positive self-adjoint
carrier, the carrier `log (exp X) = X` left-inverse identity, and the
conditional inverse-function-theorem bridge from a supplied exponential-derivative
equivalence to strict differentiability of carrier `CFC.log`.
-/

namespace HighDimProb

open HighDimProb Filter
open scoped MatrixOrder Matrix.Norms.L2Operator Matrix.Norms.Operator

noncomputable section

/-- Carrier-native continuity of the matrix `CFC.log` map on the strictly
positive self-adjoint domain. -/
theorem continuousOn_cfcLog_selfAdjointCarrier_strictlyPositive {n : Nat} :
    ContinuousOn
      (fun M : selfAdjoint (Matrix (Fin n) (Fin n) Real) =>
        CFC.log (M : Matrix (Fin n) (Fin n) Real))
      (selfAdjointStrictlyPositiveSet n) := by
  let s : Set (Matrix (Fin n) (Fin n) Real) :=
    {M | And (IsSelfAdjointMatrix M) (IsStrictlyPositive M)}
  have hAmbient :
      ContinuousOn (fun M : Matrix (Fin n) (Fin n) Real => CFC.log M) s :=
    continuousOn_cfcLog_selfAdjoint_strictlyPositive
  have hSubtype :
      ContinuousOn
        (fun M : selfAdjoint (Matrix (Fin n) (Fin n) Real) =>
          (M : Matrix (Fin n) (Fin n) Real))
        (selfAdjointStrictlyPositiveSet n) :=
    continuous_subtype_val.continuousOn
  have hMapsTo :
      Set.MapsTo
        (fun M : selfAdjoint (Matrix (Fin n) (Fin n) Real) =>
          (M : Matrix (Fin n) (Fin n) Real))
        (selfAdjointStrictlyPositiveSet n) s := by
    intro M hM
    exact And.intro
      (show IsSelfAdjointMatrix (M : Matrix (Fin n) (Fin n) Real) from M.2)
      hM
  simpa [s] using hAmbient.comp hSubtype hMapsTo

/-- Pointwise continuity of matrix `CFC.log` at a strictly positive
self-adjoint carrier point. -/
theorem continuousAt_cfcLog_selfAdjointCarrier_of_strictlyPositive {n : Nat}
    {A : selfAdjoint (Matrix (Fin n) (Fin n) Real)}
    (hA : Set.Mem (selfAdjointStrictlyPositiveSet n) A) :
    ContinuousAt (fun M : selfAdjoint (Matrix (Fin n) (Fin n) Real) =>
      CFC.log (M : Matrix (Fin n) (Fin n) Real)) A := by
  exact continuousOn_cfcLog_selfAdjointCarrier_strictlyPositive.continuousAt
    ((isOpen_selfAdjointStrictlyPositiveSet n).mem_nhds hA)

/-- Carrier-native `CFC.log`, valued in the self-adjoint subspace. -/
def cfcLogSelfAdjoint
    {n : Nat} (A : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
    selfAdjoint (Matrix (Fin n) (Fin n) Real) :=
  ⟨CFC.log (A : Matrix (Fin n) (Fin n) Real),
    isSelfAdjointMatrix_cfc_log (show IsSelfAdjointMatrix
      (A : Matrix (Fin n) (Fin n) Real) from A.2)⟩

@[simp]
theorem cfcLogSelfAdjoint_coe
    {n : Nat} (A : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
    (cfcLogSelfAdjoint A : Matrix (Fin n) (Fin n) Real) =
      CFC.log (A : Matrix (Fin n) (Fin n) Real) :=
  rfl

/-- On the strictly positive self-adjoint carrier domain, matrix exponential is
pointwise a right inverse to the carrier `CFC.log` map. -/
theorem matrixExpSelfAdjoint_cfcLogSelfAdjoint_eq_of_strictlyPositive {n : Nat}
    {A : selfAdjoint (Matrix (Fin n) (Fin n) Real)}
    (hA : Set.Mem (selfAdjointStrictlyPositiveSet n) A) :
    matrixExpSelfAdjoint (cfcLogSelfAdjoint A) = A := by
  ext i j
  simpa [matrixExpSelfAdjoint, cfcLogSelfAdjoint] using
    congrFun (congrFun (CFC.exp_log (A : Matrix (Fin n) (Fin n) Real) hA) i) j

/-- On a neighborhood of a strictly positive self-adjoint carrier point,
`CFC.log` is a right inverse to matrix exponential. -/
theorem eventually_exp_cfcLog_selfAdjointCarrier_eq_of_strictlyPositive {n : Nat}
    {A : selfAdjoint (Matrix (Fin n) (Fin n) Real)}
    (hA : Set.Mem (selfAdjointStrictlyPositiveSet n) A) :
    Filter.Eventually
      (fun M : selfAdjoint (Matrix (Fin n) (Fin n) Real) =>
        NormedSpace.exp (CFC.log (M : Matrix (Fin n) (Fin n) Real)) =
          (M : Matrix (Fin n) (Fin n) Real))
      (nhds A) := by
  filter_upwards [(isOpen_selfAdjointStrictlyPositiveSet n).mem_nhds hA] with M hM
  exact CFC.exp_log (M : Matrix (Fin n) (Fin n) Real) hM

/-- Carrier-form neighborhood version of `exp (log M) = M` on the strictly
positive self-adjoint domain. -/
theorem eventually_matrixExpSelfAdjoint_cfcLogSelfAdjoint_eq_of_strictlyPositive {n : Nat}
    {A : selfAdjoint (Matrix (Fin n) (Fin n) Real)}
    (hA : Set.Mem (selfAdjointStrictlyPositiveSet n) A) :
    Filter.Eventually
      (fun M : selfAdjoint (Matrix (Fin n) (Fin n) Real) =>
        matrixExpSelfAdjoint (cfcLogSelfAdjoint M) = M)
      (nhds A) := by
  filter_upwards [(isOpen_selfAdjointStrictlyPositiveSet n).mem_nhds hA] with M hM
  exact matrixExpSelfAdjoint_cfcLogSelfAdjoint_eq_of_strictlyPositive hM

/-- On the self-adjoint carrier, `CFC.log` is pointwise a left inverse to matrix
exponential. This is the inverse-function-theorem bookkeeping counterpart to
`matrixExpSelfAdjoint_cfcLogSelfAdjoint_eq_of_strictlyPositive`. -/
theorem cfcLogSelfAdjoint_matrixExpSelfAdjoint_eq
    {n : Nat} (A : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
    cfcLogSelfAdjoint (matrixExpSelfAdjoint A) = A := by
  ext i j
  simpa [matrixExpSelfAdjoint, cfcLogSelfAdjoint] using
    congrFun (congrFun (CFC.log_exp (a := (A : Matrix (Fin n) (Fin n) Real)) A.2) i) j

/-- Neighborhood form of `log (exp X) = X` on the self-adjoint carrier. -/
theorem eventually_cfcLogSelfAdjoint_matrixExpSelfAdjoint_eq
    {n : Nat} {A : selfAdjoint (Matrix (Fin n) (Fin n) Real)} :
    Filter.Eventually
      (fun X : selfAdjoint (Matrix (Fin n) (Fin n) Real) =>
        cfcLogSelfAdjoint (matrixExpSelfAdjoint X) = X)
      (nhds A) :=
  Filter.Eventually.of_forall cfcLogSelfAdjoint_matrixExpSelfAdjoint_eq

@[simp]
private theorem matrixExpFDerivSelfAdjoint_apply_coe
    {n : Nat} (A B : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
    (matrixExpFDerivSelfAdjoint A B : Matrix (Fin n) (Fin n) Real) =
      matrixExpFDeriv (A : Matrix (Fin n) (Fin n) Real)
        (B : Matrix (Fin n) (Fin n) Real) := by
  simp [matrixExpFDerivSelfAdjoint]

@[simp]
theorem matrixExpFDerivSelfAdjoint_spectral_equiv_toContinuousLinearMap
    {n : Nat} (X : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
    ((matrixExpFDerivSelfAdjoint_spectral_equiv X :
      ContinuousLinearEquiv (RingHom.id Real)
        (selfAdjoint (Matrix (Fin n) (Fin n) Real))
        (selfAdjoint (Matrix (Fin n) (Fin n) Real))) :
      ContinuousLinearMap (RingHom.id Real)
        (selfAdjoint (Matrix (Fin n) (Fin n) Real))
        (selfAdjoint (Matrix (Fin n) (Fin n) Real))) =
      matrixExpFDerivSelfAdjoint X := by
  ext B
  simp [matrixExpFDerivSelfAdjoint_spectral_equiv]



/-- Conditional inverse-function-theorem bridge for the carrier `CFC.log` map at
`matrixExpSelfAdjoint X`.

The hard input is explicit: the Frechet derivative of matrix exponential on the
self-adjoint carrier must already be packaged as a continuous linear
equivalence. This theorem only connects that invertibility primitive to the
local-left-inverse API. -/
theorem hasStrictFDerivAt_cfcLogSelfAdjoint_at_matrixExpSelfAdjoint_of_equiv
    {n : Nat} (X : selfAdjoint (Matrix (Fin n) (Fin n) Real))
    (e : selfAdjoint (Matrix (Fin n) (Fin n) Real) ≃L[Real]
      selfAdjoint (Matrix (Fin n) (Fin n) Real))
    (he : (e : selfAdjoint (Matrix (Fin n) (Fin n) Real) →L[Real]
        selfAdjoint (Matrix (Fin n) (Fin n) Real)) =
      matrixExpFDerivSelfAdjoint X) :
    HasStrictFDerivAt
      (fun M : selfAdjoint (Matrix (Fin n) (Fin n) Real) => cfcLogSelfAdjoint M)
      (e.symm : selfAdjoint (Matrix (Fin n) (Fin n) Real) →L[Real]
        selfAdjoint (Matrix (Fin n) (Fin n) Real))
      (matrixExpSelfAdjoint X) := by
  have hExpPos : Set.Mem (selfAdjointStrictlyPositiveSet n) (matrixExpSelfAdjoint X) := by
    have hNonneg : 0 <= NormedSpace.exp (X : Matrix (Fin n) (Fin n) Real) :=
      IsSelfAdjoint.exp_nonneg X.2
    have hUnit : IsUnit (NormedSpace.exp (X : Matrix (Fin n) (Fin n) Real)) :=
      Matrix.isUnit_exp (X : Matrix (Fin n) (Fin n) Real)
    simpa [matrixExpSelfAdjoint] using hUnit.isStrictlyPositive hNonneg
  have hCont : ContinuousAt
      (fun M : selfAdjoint (Matrix (Fin n) (Fin n) Real) => cfcLogSelfAdjoint M)
      (matrixExpSelfAdjoint X) := by
    rw [ContinuousAt, tendsto_subtype_rng]
    exact continuousAt_cfcLog_selfAdjointCarrier_of_strictlyPositive hExpPos
  have hExp :
      HasStrictFDerivAt
        (fun Y : selfAdjoint (Matrix (Fin n) (Fin n) Real) => matrixExpSelfAdjoint Y)
        (e : selfAdjoint (Matrix (Fin n) (Fin n) Real) →L[Real]
          selfAdjoint (Matrix (Fin n) (Fin n) Real))
        (cfcLogSelfAdjoint (matrixExpSelfAdjoint X)) := by
    simpa [he, cfcLogSelfAdjoint_matrixExpSelfAdjoint_eq X] using
      hasStrictFDerivAt_matrix_exp_selfAdjoint X
  exact HasStrictFDerivAt.of_local_left_inverse
    (𝕜 := Real)
    (E := selfAdjoint (Matrix (Fin n) (Fin n) Real))
    (F := selfAdjoint (Matrix (Fin n) (Fin n) Real))
    (f := fun Y : selfAdjoint (Matrix (Fin n) (Fin n) Real) => matrixExpSelfAdjoint Y)
    (f' := e)
    (g := fun M : selfAdjoint (Matrix (Fin n) (Fin n) Real) => cfcLogSelfAdjoint M)
    (a := matrixExpSelfAdjoint X)
    hCont hExp
    (eventually_matrixExpSelfAdjoint_cfcLogSelfAdjoint_eq_of_strictlyPositive hExpPos)

/-- Conditional inverse-function-theorem bridge for the carrier `CFC.log` map at
a strictly positive self-adjoint point. -/
theorem hasStrictFDerivAt_cfcLogSelfAdjoint_of_strictlyPositive_of_equiv
    {n : Nat} {A : selfAdjoint (Matrix (Fin n) (Fin n) Real)}
    (hA : Set.Mem (selfAdjointStrictlyPositiveSet n) A)
    (e : selfAdjoint (Matrix (Fin n) (Fin n) Real) ≃L[Real]
      selfAdjoint (Matrix (Fin n) (Fin n) Real))
    (he : (e : selfAdjoint (Matrix (Fin n) (Fin n) Real) →L[Real]
        selfAdjoint (Matrix (Fin n) (Fin n) Real)) =
      matrixExpFDerivSelfAdjoint (cfcLogSelfAdjoint A)) :
    HasStrictFDerivAt
      (fun M : selfAdjoint (Matrix (Fin n) (Fin n) Real) => cfcLogSelfAdjoint M)
      (e.symm : selfAdjoint (Matrix (Fin n) (Fin n) Real) →L[Real]
        selfAdjoint (Matrix (Fin n) (Fin n) Real))
      A := by
  have h := hasStrictFDerivAt_cfcLogSelfAdjoint_at_matrixExpSelfAdjoint_of_equiv
    (X := cfcLogSelfAdjoint A) e he
  simpa [matrixExpSelfAdjoint_cfcLogSelfAdjoint_eq_of_strictlyPositive hA] using h

/-- General carrier `CFC.log` strict derivative at an exponential self-adjoint
point. The spectral theorem supplies the exponential-derivative equivalence, so
this theorem no longer requires explicit diagonalization data from callers. -/
theorem hasStrictFDerivAt_cfcLogSelfAdjoint_at_matrixExpSelfAdjoint
    {n : Nat} (X : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
    HasStrictFDerivAt
      (fun M : selfAdjoint (Matrix (Fin n) (Fin n) Real) => cfcLogSelfAdjoint M)
      ((matrixExpFDerivSelfAdjoint_spectral_equiv X).symm :
        ContinuousLinearMap (RingHom.id Real)
          (selfAdjoint (Matrix (Fin n) (Fin n) Real))
          (selfAdjoint (Matrix (Fin n) (Fin n) Real)))
      (matrixExpSelfAdjoint X) := by
  exact hasStrictFDerivAt_cfcLogSelfAdjoint_at_matrixExpSelfAdjoint_of_equiv
    X (matrixExpFDerivSelfAdjoint_spectral_equiv X)
    (matrixExpFDerivSelfAdjoint_spectral_equiv_toContinuousLinearMap X)

/-- General carrier `CFC.log` strict derivative at any strictly positive
self-adjoint carrier point. This is the current inverse-function-route MVP; it
still does not by itself prove the scalar affine-line derivative, Epstein
concavity, Lieb, or Tropp. -/
theorem hasStrictFDerivAt_cfcLogSelfAdjoint_of_strictlyPositive
    {n : Nat} {A : selfAdjoint (Matrix (Fin n) (Fin n) Real)}
    (hA : Set.Mem (selfAdjointStrictlyPositiveSet n) A) :
    HasStrictFDerivAt
      (fun M : selfAdjoint (Matrix (Fin n) (Fin n) Real) => cfcLogSelfAdjoint M)
      ((matrixExpFDerivSelfAdjoint_spectral_equiv (cfcLogSelfAdjoint A)).symm :
        ContinuousLinearMap (RingHom.id Real)
          (selfAdjoint (Matrix (Fin n) (Fin n) Real))
          (selfAdjoint (Matrix (Fin n) (Fin n) Real)))
      A := by
  exact hasStrictFDerivAt_cfcLogSelfAdjoint_of_strictlyPositive_of_equiv hA
    (matrixExpFDerivSelfAdjoint_spectral_equiv (cfcLogSelfAdjoint A))
    (matrixExpFDerivSelfAdjoint_spectral_equiv_toContinuousLinearMap
      (cfcLogSelfAdjoint A))

/- Short namespace for the affine-line `CFC.log` derivative API.

The declarations in this namespace are proof-facing bookkeeping entry points
for new Epstein sprint work. In particular, `DerivOp` names the pointwise
carrier derivative operator only; it is not intended as a stable codomain for a
second-level Frechet derivative without a deliberate topology/API redesign. -/
namespace CFCLog

/-- Self-adjoint carrier used by the `CFCLog` derivative API. -/
abbrev Carrier (n : Nat) : Type := selfAdjoint (Matrix (Fin n) (Fin n) Real)

/-- Pointwise logarithm derivative operator on the self-adjoint carrier.
This is a local bookkeeping abbreviation for evaluated derivative operators,
not a public second-level derivative codomain. -/
abbrev DerivOp (n : Nat) := Carrier n →L[Real] Carrier n

/-- Self-adjointness is preserved along real affine lines in the ambient
HighDimProb matrix vocabulary. -/
theorem selfAdjoint_add_smul
    {n : Nat} (A C : Matrix (Fin n) (Fin n) Real) (t : Real)
    (hA : IsSelfAdjointMatrix A) (hC : IsSelfAdjointMatrix C) :
    IsSelfAdjointMatrix (A + t • C) := by
  have ht : IsSelfAdjoint t := by
    simp [IsSelfAdjoint]
  change (A + t • C).IsHermitian
  exact hA.add (hC.smul ht)

/-- Pointwise self-adjoint-carrier logarithm derivative operator at `M`, defined
as the inverse of the Frechet derivative of matrix exponential at `CFC.log M`.
At strictly positive `M`, `CFCLog.hasStrictFDerivAt_derivSAAt` identifies this
operator with the strict derivative of carrier `CFC.log`. -/
noncomputable def derivSAAt
    {n : Nat} (M : Carrier n) : DerivOp n :=
  ((matrixExpFDerivSelfAdjoint_spectral_equiv (cfcLogSelfAdjoint M)).symm :
    DerivOp n)

/-- At a strictly positive self-adjoint point, `CFCLog.derivSAAt` is the strict
Frechet derivative of the carrier `CFC.log` map. -/
theorem hasStrictFDerivAt_derivSAAt
    {n : Nat} {M : Carrier n}
    (hM : Set.Mem (selfAdjointStrictlyPositiveSet n) M) :
    HasStrictFDerivAt
      (fun N : Carrier n => cfcLogSelfAdjoint N)
      (derivSAAt M)
      M := by
  simpa [derivSAAt] using
    hasStrictFDerivAt_cfcLogSelfAdjoint_of_strictlyPositive hM

/-- Applying the exponential Frechet derivative to the pointwise `CFC.log`
derivative operator recovers the original self-adjoint direction. -/
theorem expFDeriv_derivSAAt
    {n : Nat} (M D : Carrier n) :
    matrixExpFDerivSelfAdjoint (cfcLogSelfAdjoint M) (derivSAAt M D) = D := by
  let e := matrixExpFDerivSelfAdjoint_spectral_equiv (cfcLogSelfAdjoint M)
  have he :
      (e : DerivOp n) =
        matrixExpFDerivSelfAdjoint (cfcLogSelfAdjoint M) := by
    simp [e]
  change matrixExpFDerivSelfAdjoint (cfcLogSelfAdjoint M)
    ((e.symm : DerivOp n) D) = D
  rw [← he]
  exact e.apply_symm_apply D

/-- The pointwise `CFC.log` derivative operator is the inverse of the
self-adjoint-carrier exponential Frechet derivative. -/
theorem derivSAAt_expFDeriv
    {n : Nat} (M D : Carrier n) :
    derivSAAt M
      (matrixExpFDerivSelfAdjoint (cfcLogSelfAdjoint M) D) = D := by
  let e := matrixExpFDerivSelfAdjoint_spectral_equiv (cfcLogSelfAdjoint M)
  have he :
      (e : DerivOp n) =
        matrixExpFDerivSelfAdjoint (cfcLogSelfAdjoint M) := by
    simp [e]
  change
    ((e.symm : DerivOp n)
      (matrixExpFDerivSelfAdjoint (cfcLogSelfAdjoint M) D)) = D
  rw [← he]
  exact e.symm_apply_apply D

/-- Carrier derivative vector for `CFC.log` along a self-adjoint affine line. -/
noncomputable def lineDerivSA
    {n : Nat} (A C : Carrier n) (t : Real) : Carrier n :=
  derivSAAt (A + t • C) C

/-- Definitional form of the carrier affine-line logarithm velocity. -/
@[simp]
theorem lineDerivSA_eq_derivSAAt
    {n : Nat} (A C : Carrier n) (t : Real) :
    lineDerivSA A C t = derivSAAt (A + t • C) C := rfl

/-- Differentiability of `CFCLog.lineDerivSA` is exactly differentiability of the
pointwise derivative operator after evaluating it on the affine-line direction.
This is a bookkeeping equivalence; it does not prove that differentiability. -/
theorem hasDerivAt_lineDerivSA_iff
    {n : Nat} (A C : Carrier n) {t : Real} {G : Carrier n} :
    HasDerivAt (fun s : Real => lineDerivSA A C s) G t ↔
      HasDerivAt (fun s : Real => derivSAAt (A + s • C) C) G t := by
  rfl

/-- Backwards-compatible descriptive name for `CFCLog.hasDerivAt_lineDerivSA_iff`. -/
theorem hasDerivAt_lineDerivSA_iff_derivSAAt_eval
    {n : Nat} (A C : Carrier n) {t : Real} {G : Carrier n} :
    HasDerivAt (fun s : Real => lineDerivSA A C s) G t ↔
      HasDerivAt (fun s : Real => derivSAAt (A + s • C) C) G t :=
  hasDerivAt_lineDerivSA_iff A C

/-- Turn the evaluated-field derivative into the derivative of `CFCLog.lineDerivSA`. -/
theorem hasDerivAt_lineDerivSA_of_hasDerivAt_eval
    {n : Nat} (A C : Carrier n) {t : Real} {G : Carrier n}
    (h : HasDerivAt (fun s : Real => derivSAAt (A + s • C) C) G t) :
    HasDerivAt (fun s : Real => lineDerivSA A C s) G t :=
  (hasDerivAt_lineDerivSA_iff A C).2 h

/-- Extract the evaluated-field derivative from a derivative of `CFCLog.lineDerivSA`. -/
theorem hasDerivAt_eval_of_hasDerivAt_lineDerivSA
    {n : Nat} (A C : Carrier n) {t : Real} {G : Carrier n}
    (h : HasDerivAt (fun s : Real => lineDerivSA A C s) G t) :
    HasDerivAt (fun s : Real => derivSAAt (A + s • C) C) G t :=
  (hasDerivAt_lineDerivSA_iff A C).1 h

/-- `CFCLog.lineDerivSA` is the inverse image of the affine-line direction under
 the self-adjoint-carrier Frechet derivative of matrix exponential at the
 carrier logarithm. -/
theorem lineDerivSA_forward_matrixExpFDeriv
    {n : Nat} (A C : Carrier n) (t : Real) :
    matrixExpFDerivSelfAdjoint (cfcLogSelfAdjoint (A + SMul.smul t C))
      (lineDerivSA A C t) = C := by
  change matrixExpFDerivSelfAdjoint (cfcLogSelfAdjoint (A + SMul.smul t C))
    (derivSAAt (A + SMul.smul t C) C) = C
  exact expFDeriv_derivSAAt (M := A + SMul.smul t C) (D := C)

/-- Ambient matrix form of the affine-line `CFC.log` derivative vector. -/
noncomputable def lineDeriv
    {n : Nat} (A C : Matrix (Fin n) (Fin n) Real)
    (hA : IsSelfAdjointMatrix A) (hC : IsSelfAdjointMatrix C) (t : Real) :
    Matrix (Fin n) (Fin n) Real :=
  (lineDerivSA
    ({ val := A, property := hA } : Carrier n)
    ({ val := C, property := hC } : Carrier n)
    t : Carrier n)

/-- Coerce a carrier-valued derivative of `CFCLog.lineDerivSA` to the ambient
matrix space. Use this when the next analytic input is already stated with the
named carrier field rather than the unfolded `derivSAAt` expression. -/
theorem hasDerivAt_lineDerivSA_coe
    {n : Nat} (A C : Carrier n) {t : Real} {G : Carrier n}
    (h : HasDerivAt (fun s : Real => lineDerivSA A C s) G t) :
    HasDerivAt
      (fun s : Real => (lineDerivSA A C s : Matrix (Fin n) (Fin n) Real))
      (G : Matrix (Fin n) (Fin n) Real)
      t := by
  have hcoerce :=
    (selfAdjoint.subtypeL (A := Matrix (Fin n) (Fin n) Real)).hasFDerivAt.comp_hasDerivAt
      t h
  simpa [selfAdjoint.subtypeL_apply] using hcoerce

/-- Ambient `CFCLog.lineDeriv` derivative from the named carrier field
`CFCLog.lineDerivSA`. -/
theorem hasDerivAt_lineDeriv_of_lineDerivSA
    {n : Nat} (A C : Matrix (Fin n) (Fin n) Real)
    (hA : IsSelfAdjointMatrix A) (hC : IsSelfAdjointMatrix C)
    {t : Real} {G : Carrier n}
    (h : HasDerivAt
      (fun s : Real =>
        lineDerivSA
          ({ val := A, property := hA } : Carrier n)
          ({ val := C, property := hC } : Carrier n)
          s)
      G
      t) :
    HasDerivAt
      (fun s : Real => lineDeriv A C hA hC s)
      (G : Matrix (Fin n) (Fin n) Real)
      t := by
  let Asa : Carrier n := { val := A, property := hA }
  let Csa : Carrier n := { val := C, property := hC }
  have h' : HasDerivAt (fun s : Real => lineDerivSA Asa Csa s) G t := by
    simpa [Asa, Csa] using h
  simpa [Asa, Csa, lineDeriv] using
    (hasDerivAt_lineDerivSA_coe (A := Asa) (C := Csa) h')
/-- Ambient-matrix form of `hasDerivAt_lineDerivSA_of_hasDerivAt_eval`.
This is the preferred bridge from a derivative of the evaluated pointwise
operator field to a derivative of the matrix-valued packaged logarithm velocity. -/
theorem hasDerivAt_lineDerivSA_coe_of_hasDerivAt_eval
    {n : Nat} (A C : Carrier n) {t : Real} {G : Carrier n}
    (h : HasDerivAt (fun s : Real => derivSAAt (A + s • C) C) G t) :
    HasDerivAt
      (fun s : Real => (lineDerivSA A C s : Matrix (Fin n) (Fin n) Real))
      (G : Matrix (Fin n) (Fin n) Real)
      t := by
  exact hasDerivAt_lineDerivSA_coe A C
    (hasDerivAt_lineDerivSA_of_hasDerivAt_eval A C h)

/-- Ambient `CFCLog.lineDeriv` derivative from the evaluated carrier field.
This is the proof-facing bridge needed by the Epstein second-derivative route. -/
theorem hasDerivAt_lineDeriv_of_hasDerivAt_eval
    {n : Nat} (A C : Matrix (Fin n) (Fin n) Real)
    (hA : IsSelfAdjointMatrix A) (hC : IsSelfAdjointMatrix C)
    {t : Real} {G : Carrier n}
    (h : HasDerivAt
      (fun s : Real =>
        derivSAAt
          (({ val := A, property := hA } : Carrier n) +
            s • ({ val := C, property := hC } : Carrier n))
          ({ val := C, property := hC } : Carrier n))
      G
      t) :
    HasDerivAt
      (fun s : Real => lineDeriv A C hA hC s)
      (G : Matrix (Fin n) (Fin n) Real)
      t := by
  let Asa : Carrier n := { val := A, property := hA }
  let Csa : Carrier n := { val := C, property := hC }
  have h' : HasDerivAt (fun s : Real => derivSAAt (Asa + s • Csa) Csa) G t := by
    simpa [Asa, Csa] using h
  exact hasDerivAt_lineDeriv_of_lineDerivSA A C hA hC
    (hasDerivAt_lineDerivSA_of_hasDerivAt_eval Asa Csa h')

/-- The ambient affine-line `CFC.log` derivative vector is self-adjoint. -/
theorem isSelfAdjoint_lineDeriv
    {n : Nat} (A C : Matrix (Fin n) (Fin n) Real)
    (hA : IsSelfAdjointMatrix A) (hC : IsSelfAdjointMatrix C) (t : Real) :
    IsSelfAdjointMatrix (lineDeriv A C hA hC t) := by
  simpa [lineDeriv] using
    (lineDerivSA
      ({ val := A, property := hA } : Carrier n)
      ({ val := C, property := hC } : Carrier n)
      t).2.isHermitian

/-- Ambient form of `lineDerivSA_forward_matrixExpFDeriv`. Applying the
 Frechet derivative of matrix exponential at `CFC.log (A + t • C)` to the
 packaged logarithm derivative returns the original affine-line direction. -/
theorem lineDeriv_forward_matrixExpFDeriv
    {n : Nat} (A C : Matrix (Fin n) (Fin n) Real)
    (hA : IsSelfAdjointMatrix A) (hC : IsSelfAdjointMatrix C) (t : Real) :
    matrixExpFDeriv (CFC.log (A + SMul.smul t C))
      (lineDeriv A C hA hC t) = C := by
  let Asa : Carrier n := { val := A, property := hA }
  let Csa : Carrier n := { val := C, property := hC }
  have h := congrArg
    (fun X : Carrier n =>
      (X : Matrix (Fin n) (Fin n) Real))
    (lineDerivSA_forward_matrixExpFDeriv (A := Asa) (C := Csa) t)
  simpa only [Asa, Csa, lineDeriv, cfcLogSelfAdjoint_coe,
    matrixExpFDerivSelfAdjoint_apply_coe] using h

/-- Carrier-valued affine-line derivative of `CFC.log` on the strictly positive
self-adjoint cone. -/
theorem hasDerivAt_lineSA
    {n : Nat} (A C : Carrier n) {t : Real}
    (hPos : Set.Mem (selfAdjointStrictlyPositiveSet n) (A + t • C)) :
    HasDerivAt
      (fun s : Real => cfcLogSelfAdjoint (A + s • C))
      (lineDerivSA A C t)
      t := by
  have hlog := hasStrictFDerivAt_derivSAAt hPos
  have hline : HasDerivAt (fun s : Real => A + s • C) C t := by
    simpa using
      ((hasDerivAt_const (x := t) (c := A)).add
        ((hasDerivAt_id (x := t)).smul_const C))
  simpa [lineDerivSA] using
    hlog.hasFDerivAt.comp_hasDerivAt t hline

/-- Matrix-valued affine-line derivative of `CFC.log` on strictly positive
self-adjoint affine lines. This is the exact `HasDerivAt` shape consumed by the
Epstein derivative chain in `TraceExp.EpsteinDerivative`. -/
theorem hasDerivAt_line
    {n : Nat} (A C : Matrix (Fin n) (Fin n) Real)
    (hA : IsSelfAdjointMatrix A) (hC : IsSelfAdjointMatrix C)
    {t : Real}
    (hPos : IsStrictlyPositive (A + t • C)) :
    HasDerivAt
      (fun s : Real => CFC.log (A + s • C))
      (lineDeriv A C hA hC t)
      t := by
  let Asa : Carrier n := { val := A, property := hA }
  let Csa : Carrier n := { val := C, property := hC }
  have hPosCarrier : Set.Mem (selfAdjointStrictlyPositiveSet n) (Asa + t • Csa) := by
    simpa [Asa, Csa] using hPos
  have hcarrier :=
    hasDerivAt_lineSA (A := Asa) (C := Csa) hPosCarrier
  have hcoerce :=
    (selfAdjoint.subtypeL (A := Matrix (Fin n) (Fin n) Real)).hasFDerivAt.comp_hasDerivAt
      t hcarrier
  simpa [Asa, Csa, lineDeriv, lineDerivSA,
    cfcLogSelfAdjoint_coe, selfAdjoint.subtypeL_apply] using hcoerce

end CFCLog

/-- Uniform existential derivative package for the `CFC.log` affine line on an
open interval where the self-adjoint line is strictly positive.

This is a convenience wrapper for older first-derivative Epstein reductions. The
preferred explicit derivative vector remains `CFCLog.lineDeriv`, available via
`CFCLog.hasDerivAt_line`. -/
theorem exists_hasDerivAt_cfcLog_affineLine_of_strictlyPositive
    {n : Nat} (A C : Matrix (Fin n) (Fin n) Real)
    (hA : IsSelfAdjointMatrix A) (hC : IsSelfAdjointMatrix C)
    (hPos : forall t : Real, Set.Mem (Set.Icc (0 : Real) 1) t ->
      IsStrictlyPositive (A + SMul.smul t C)) :
    Exists fun G : Real -> Matrix (Fin n) (Fin n) Real =>
      forall t : Real, Set.Mem (Set.Ioo (0 : Real) 1) t ->
        HasDerivAt
          (fun s : Real => CFC.log (A + SMul.smul s C))
          (G t)
          t := by
  refine Exists.intro (fun t : Real => CFCLog.lineDeriv A C hA hC t) ?_
  intro t ht
  exact CFCLog.hasDerivAt_line A C hA hC
    (hPos t (Set.Ioo_subset_Icc_self ht))

/-- Existential compatibility wrapper for the affine-line `CFC.log` derivative.

Prefer `CFCLog.hasDerivAt_line` when the explicit derivative vector is useful;
this theorem packages the same fact in the older `∃ G, HasDerivAt ... G t`
shape used by first-derivative Epstein reductions. -/
theorem hasDerivAt_cfcLog_affineLine_of_strictlyPositive
    {n : Nat} {A C : Matrix (Fin n) (Fin n) Real}
    (hA : IsSelfAdjointMatrix A) (hC : IsSelfAdjointMatrix C)
    {t : Real} (hPos : IsStrictlyPositive (A + t • C)) :
    ∃ G : Matrix (Fin n) (Fin n) Real,
      HasDerivAt (fun s : Real => CFC.log (A + s • C)) G t := by
  exact ⟨CFCLog.lineDeriv A C hA hC t,
    CFCLog.hasDerivAt_line A C hA hC hPos⟩


end

end HighDimProb
