import HighDimProb.RandomMatrix.TraceExpLogContinuityProvider
import Mathlib.Analysis.Convex.Deriv

/-!
# Conditional Epstein-to-Lieb bridge

This module does not prove Epstein's theorem. Instead, it packages the exact
finite-dimensional affine-line concavity hypothesis needed to derive the
provider's carrier-native Lieb concavity theorem and the ambient HighDimProb
hardbone statement.
-/

namespace HighDimProb

open HighDimProb
open scoped MatrixOrder Matrix.Norms.L2Operator

noncomputable section

/-- Self-adjointness is preserved along real affine lines. -/
private theorem isSelfAdjointMatrix_add_smul
    {n : Nat} (A C : Matrix (Fin n) (Fin n) Real) (t : Real)
    (hA : IsSelfAdjointMatrix A)
    (hC : IsSelfAdjointMatrix C) :
    IsSelfAdjointMatrix (A + t • C) := by
  have ht : IsSelfAdjoint t := by
    simp [IsSelfAdjoint]
  change (A + t • C).IsHermitian
  exact hA.add (hC.smul ht)

/-- Finite-dimensional affine-line Epstein concavity hypothesis, stated in the
exact form consumed by the provider bridge. -/
abbrev EpsteinAffineLineConcavity : Prop :=
  forall {n : Nat} (H A C : Matrix (Fin n) (Fin n) Real),
    IsSelfAdjointMatrix H ->
    IsSelfAdjointMatrix A ->
    IsSelfAdjointMatrix C ->
    (forall t : Real, t ∈ Set.Icc (0 : Real) 1 ->
      IsStrictlyPositive (A + t • C)) ->
    ConcaveOn Real (Set.Icc (0 : Real) 1)
      (fun t : Real =>
        traceMatrixExp (H + CFC.log (A + t • C)))

/-- The trace-exp/log affine-line restriction is continuous on `[0, 1]` as soon
as the whole line stays in the strictly positive self-adjoint cone. -/
theorem continuousOn_traceMatrixExp_add_cfcLog_affineLine
    {n : Nat} (H A C : Matrix (Fin n) (Fin n) Real)
    (hA : IsSelfAdjointMatrix A)
    (hC : IsSelfAdjointMatrix C)
    (hPos : forall t : Real, t ∈ Set.Icc (0 : Real) 1 ->
      IsStrictlyPositive (A + t • C)) :
    ContinuousOn
      (fun t : Real => traceMatrixExp (H + CFC.log (A + t • C)))
      (Set.Icc (0 : Real) 1) := by
  let s : Set (Matrix (Fin n) (Fin n) Real) :=
    {M : Matrix (Fin n) (Fin n) Real |
      And (IsSelfAdjointMatrix M) (IsStrictlyPositive M)}
  have hAmbient :
      ContinuousOn
        (fun M : Matrix (Fin n) (Fin n) Real =>
          traceMatrixExp (H + CFC.log M))
        s :=
    continuousOn_traceMatrixExp_add_cfcLog_selfAdjoint_strictlyPositive (H := H)
  have hLine :
      ContinuousOn (fun t : Real => A + t • C) (Set.Icc (0 : Real) 1) := by
    simpa using
      (continuous_const.add (continuous_id.smul continuous_const)).continuousOn
  have hMapsTo :
      Set.MapsTo
        (fun t : Real => A + t • C)
        (Set.Icc (0 : Real) 1)
        s := by
    intro t ht
    exact ⟨isSelfAdjointMatrix_add_smul A C t hA hC, hPos t ht⟩
  simpa [s] using hAmbient.comp hLine hMapsTo

/-- Fixed affine-line concavity from scalar second-derivative control.

This is the exact one-dimensional analytic bridge needed to reduce
`EpsteinAffineLineConcavity` to a derivative/Hessian theorem for
`t ↦ tr exp (H + log (A + t C))` on a strictly positive affine line. -/
theorem concaveOn_traceMatrixExp_add_cfcLog_affineLine_of_hasDerivWithinAt2_nonpos
    {n : Nat} (H A C : Matrix (Fin n) (Fin n) Real)
    (hA : IsSelfAdjointMatrix A)
    (hC : IsSelfAdjointMatrix C)
    (hPos : forall t : Real, t ∈ Set.Icc (0 : Real) 1 ->
      IsStrictlyPositive (A + t • C))
    {f' f'' : Real -> Real}
    (hf' : forall t : Real, t ∈ Set.Ioo (0 : Real) 1 ->
      HasDerivWithinAt
        (fun s : Real => traceMatrixExp (H + CFC.log (A + s • C)))
        (f' t)
        (Set.Ioo (0 : Real) 1)
        t)
    (hf'' : forall t : Real, t ∈ Set.Ioo (0 : Real) 1 ->
      HasDerivWithinAt f' (f'' t) (Set.Ioo (0 : Real) 1) t)
    (hf''_nonpos : forall t : Real, t ∈ Set.Ioo (0 : Real) 1 -> f'' t <= 0) :
    ConcaveOn Real (Set.Icc (0 : Real) 1)
      (fun t : Real => traceMatrixExp (H + CFC.log (A + t • C))) := by
  refine concaveOn_of_hasDerivWithinAt2_nonpos (D := Set.Icc (0 : Real) 1) (f' := f') (f'' := f'')
    (convex_Icc (0 : Real) 1) ?_ ?_ ?_ ?_
  · exact continuousOn_traceMatrixExp_add_cfcLog_affineLine H A C hA hC hPos
  · simpa using hf'
  · simpa using hf''
  · simpa using hf''_nonpos

/-- Fixed affine-line concavity from ordinary scalar second-derivative control.

This is the same bridge as
`concaveOn_traceMatrixExp_add_cfcLog_affineLine_of_hasDerivWithinAt2_nonpos`,
but with ordinary `HasDerivAt` hypotheses. Analytic proofs often produce this
shape on the open interval before restricting to `Set.Ioo (0 : Real) 1`.
-/
theorem concaveOn_traceMatrixExp_add_cfcLog_affineLine_of_hasDerivAt2_nonpos
    {n : Nat} (H A C : Matrix (Fin n) (Fin n) Real)
    (hA : IsSelfAdjointMatrix A)
    (hC : IsSelfAdjointMatrix C)
    (hPos : forall t : Real, t ∈ Set.Icc (0 : Real) 1 ->
      IsStrictlyPositive (A + t • C))
    {f' f'' : Real -> Real}
    (hf' : forall t : Real, t ∈ Set.Ioo (0 : Real) 1 ->
      HasDerivAt
        (fun s : Real => traceMatrixExp (H + CFC.log (A + s • C)))
        (f' t)
        t)
    (hf'' : forall t : Real, t ∈ Set.Ioo (0 : Real) 1 ->
      HasDerivAt f' (f'' t) t)
    (hf''_nonpos : forall t : Real, t ∈ Set.Ioo (0 : Real) 1 -> f'' t <= 0) :
    ConcaveOn Real (Set.Icc (0 : Real) 1)
      (fun t : Real => traceMatrixExp (H + CFC.log (A + t • C))) :=
  concaveOn_traceMatrixExp_add_cfcLog_affineLine_of_hasDerivWithinAt2_nonpos
    H A C hA hC hPos
    (fun t ht => (hf' t ht).hasDerivWithinAt)
    (fun t ht => (hf'' t ht).hasDerivWithinAt)
    hf''_nonpos

/-- Global Epstein affine-line concavity from linewise derivative/Hessian
control.

This is the proof-facing form of the remaining analytic target: prove the
linewise derivatives and the nonpositivity of the scalar second derivative, and
the exact `EpsteinAffineLineConcavity` hypothesis consumed downstream follows.
-/
theorem epsteinAffineLineConcavity_of_hasDerivWithinAt2_nonpos
    (hDeriv : forall {n : Nat} (H A C : Matrix (Fin n) (Fin n) Real),
      IsSelfAdjointMatrix H ->
      IsSelfAdjointMatrix A ->
      IsSelfAdjointMatrix C ->
      (forall t : Real, t ∈ Set.Icc (0 : Real) 1 ->
        IsStrictlyPositive (A + t • C)) ->
      exists f' f'' : Real -> Real,
        (forall t : Real, t ∈ Set.Ioo (0 : Real) 1 ->
          HasDerivWithinAt
            (fun s : Real => traceMatrixExp (H + CFC.log (A + s • C)))
            (f' t)
            (Set.Ioo (0 : Real) 1)
            t) ∧
        (forall t : Real, t ∈ Set.Ioo (0 : Real) 1 ->
          HasDerivWithinAt f' (f'' t) (Set.Ioo (0 : Real) 1) t) ∧
        (forall t : Real, t ∈ Set.Ioo (0 : Real) 1 -> f'' t <= 0)) :
    EpsteinAffineLineConcavity := by
  intro n H A C hH hA hC hPos
  rcases hDeriv H A C hH hA hC hPos with ⟨f', f'', hf', hf'', hf''_nonpos⟩
  exact
    concaveOn_traceMatrixExp_add_cfcLog_affineLine_of_hasDerivWithinAt2_nonpos
      H A C hA hC hPos hf' hf'' hf''_nonpos

/-- Global Epstein affine-line concavity from ordinary linewise derivative/Hessian
control.

This wrapper is intended for the remaining analytic Epstein target when it is
proved with ordinary `HasDerivAt` statements on the open interval.
-/
theorem epsteinAffineLineConcavity_of_hasDerivAt2_nonpos
    (hDeriv : forall {n : Nat} (H A C : Matrix (Fin n) (Fin n) Real),
      IsSelfAdjointMatrix H ->
      IsSelfAdjointMatrix A ->
      IsSelfAdjointMatrix C ->
      (forall t : Real, t ∈ Set.Icc (0 : Real) 1 ->
        IsStrictlyPositive (A + t • C)) ->
      exists f' f'' : Real -> Real,
        (forall t : Real, t ∈ Set.Ioo (0 : Real) 1 ->
          HasDerivAt
            (fun s : Real => traceMatrixExp (H + CFC.log (A + s • C)))
            (f' t)
            t) ∧
        (forall t : Real, t ∈ Set.Ioo (0 : Real) 1 ->
          HasDerivAt f' (f'' t) t) ∧
        (forall t : Real, t ∈ Set.Ioo (0 : Real) 1 -> f'' t <= 0)) :
    EpsteinAffineLineConcavity := by
  intro n H A C hH hA hC hPos
  rcases hDeriv H A C hH hA hC hPos with ⟨f', f'', hf', hf'', hf''_nonpos⟩
  exact
    concaveOn_traceMatrixExp_add_cfcLog_affineLine_of_hasDerivAt2_nonpos
      H A C hA hC hPos hf' hf'' hf''_nonpos

private theorem affineLine_eq_segment
    {n : Nat} (A B : selfAdjoint (Matrix (Fin n) (Fin n) Real)) (t : Real) :
    (A : Matrix (Fin n) (Fin n) Real) + t • ((B : Matrix (Fin n) (Fin n) Real) - (A : Matrix (Fin n) (Fin n) Real)) =
      ((((1 - t) • A + t • B : selfAdjoint (Matrix (Fin n) (Fin n) Real)) : Matrix (Fin n) (Fin n) Real)) := by
  ext i j
  simp [sub_eq_add_neg]
  ring

private theorem affineLine_eq_weighted
    {n : Nat} (A B : selfAdjoint (Matrix (Fin n) (Fin n) Real)) {a b : Real} (hab : a + b = 1) :
    (A : Matrix (Fin n) (Fin n) Real) + b • ((B : Matrix (Fin n) (Fin n) Real) - (A : Matrix (Fin n) (Fin n) Real)) =
      (((a • A + b • B : selfAdjoint (Matrix (Fin n) (Fin n) Real)) : Matrix (Fin n) (Fin n) Real)) := by
  calc
    (A : Matrix (Fin n) (Fin n) Real) + b • ((B : Matrix (Fin n) (Fin n) Real) - (A : Matrix (Fin n) (Fin n) Real)) =
        ((((1 - b) • A + b • B : selfAdjoint (Matrix (Fin n) (Fin n) Real)) : Matrix (Fin n) (Fin n) Real)) := by
          simpa using affineLine_eq_segment A B b
    _ = (((a • A + b • B : selfAdjoint (Matrix (Fin n) (Fin n) Real)) : Matrix (Fin n) (Fin n) Real)) := by
          have ha : a = 1 - b := by linarith
          simp [ha]

private theorem affineLine_strictlyPositive
    {n : Nat} {A B : selfAdjoint (Matrix (Fin n) (Fin n) Real)}
    (hA : A ∈ selfAdjointStrictlyPositiveSet n)
    (hB : B ∈ selfAdjointStrictlyPositiveSet n) :
    forall t : Real, t ∈ Set.Icc (0 : Real) 1 ->
      IsStrictlyPositive ((A : Matrix (Fin n) (Fin n) Real) + t • ((B : Matrix (Fin n) (Fin n) Real) - (A : Matrix (Fin n) (Fin n) Real))) := by
  intro t ht
  have hSegment :
      (((1 - t) • A + t • B : selfAdjoint (Matrix (Fin n) (Fin n) Real)) ∈
        selfAdjointStrictlyPositiveSet n) :=
    (convex_selfAdjointStrictlyPositiveSet n) hA hB (by linarith [ht.2]) ht.1
      (by linarith)
  simpa [affineLine_eq_segment A B t] using hSegment

/-- Conditional carrier Lieb concavity from a finite-dimensional Epstein
affine-line theorem. -/
theorem liebTraceExpConcavity_selfAdjointCarrier_analytic_of_epsteinAffineLine
    (hEpstein : EpsteinAffineLineConcavity)
    {n : Nat} (H : Matrix (Fin n) (Fin n) Real) :
    IsSelfAdjointMatrix H ->
      ConcaveOn Real (selfAdjointStrictlyPositiveSet n)
        (fun M : selfAdjoint (Matrix (Fin n) (Fin n) Real) =>
          traceMatrixExp (H + CFC.log (M : Matrix (Fin n) (Fin n) Real))) := by
  intro hH
  constructor
  · exact convex_selfAdjointStrictlyPositiveSet n
  · intro A hA B hB a b ha hb hab
    let C : Matrix (Fin n) (Fin n) Real := (B : Matrix (Fin n) (Fin n) Real) - (A : Matrix (Fin n) (Fin n) Real)
    have hC : IsSelfAdjointMatrix C := by
      dsimp [C]
      simpa using B.2.sub A.2
    have hSegPos :
        forall t : Real, t ∈ Set.Icc (0 : Real) 1 ->
          IsStrictlyPositive ((A : Matrix (Fin n) (Fin n) Real) + t • C) := by
      simpa [C] using affineLine_strictlyPositive hA hB
    let g : Real -> Real := fun t : Real =>
      traceMatrixExp (H + CFC.log ((A : Matrix (Fin n) (Fin n) Real) + t • C))
    have hSegConcave :
        ConcaveOn Real (Set.Icc (0 : Real) 1) g := by
      simpa [g] using hEpstein H (A : Matrix (Fin n) (Fin n) Real) C hH A.2 hC hSegPos
    have h0 : (0 : Real) ∈ Set.Icc (0 : Real) 1 := by
      simp
    have h1 : (1 : Real) ∈ Set.Icc (0 : Real) 1 := by
      simp
    have hSegIneq : a • g 0 + b • g 1 ≤ g b := by
      simpa using hSegConcave.2 h0 h1 ha hb hab
    have hAtOne : (A : Matrix (Fin n) (Fin n) Real) + C = (B : Matrix (Fin n) (Fin n) Real) := by dsimp [C]; abel
    have hAtWeighted :
        (A : Matrix (Fin n) (Fin n) Real) + b • C = (((a • A + b • B : selfAdjoint (Matrix (Fin n) (Fin n) Real)) : Matrix (Fin n) (Fin n) Real)) := by simpa [C] using (affineLine_eq_weighted (A := A) (B := B) (a := a) (b := b) hab)
    simpa [g, one_smul, hAtOne, hAtWeighted] using hSegIneq

/-- Conditional exact main hardbone witness from the same Epstein affine-line
theorem. -/
theorem liebTraceExpConcavity_of_epsteinAffineLine
    (hEpstein : EpsteinAffineLineConcavity)
    {n : Nat} (H : Matrix (Fin n) (Fin n) Real) :
    liebTraceExpConcavity_statement H :=
  liebTraceExpConcavity_of_selfAdjointCarrier H
    (liebTraceExpConcavity_selfAdjointCarrier_analytic_of_epsteinAffineLine
      hEpstein H)

/-- Exact Jensen statement supplied from the same explicit Epstein affine-line
hypothesis.

The statement still has HighDimProb's original Lieb-concavity argument slot,
but this provider witness ignores that slot and uses `hEpstein` instead. This
is the form consumed by main-repo Tropp chain statements. -/
theorem liebJensenTraceExp_statement_of_epsteinAffineLine
    {Omega : Type*} [MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} [MeasureTheory.IsProbabilityMeasure P]
    (hEpstein : EpsteinAffineLineConcavity)
    {n : Nat}
    (H : Matrix (Fin n) (Fin n) Real)
    (Y : RandomMatrix Omega n n) :
    liebJensenTraceExp_statement (P := P) H Y := by
  intro _hConcave
  exact
    (liebJensenTraceExp_statement_of_liebConcavity (P := P) H Y)
      (liebTraceExpConcavity_of_epsteinAffineLine hEpstein H)

/-- Direct Jensen inequality from the explicit Epstein affine-line hypothesis.

This is the same inequality as `liebJensenTraceExp_statement`, but with the
Lieb-concavity premise discharged by `hEpstein`. -/
theorem liebJensenTraceExp_of_epsteinAffineLine
    {Omega : Type*} [MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} [MeasureTheory.IsProbabilityMeasure P]
    (hEpstein : EpsteinAffineLineConcavity)
    {n : Nat}
    (H : Matrix (Fin n) (Fin n) Real)
    (Y : RandomMatrix Omega n n)
    (hH : IsSelfAdjointMatrix H)
    (hYsa : forall omega, IsSelfAdjointMatrix (Y omega))
    (hYpos : forall omega, IsStrictlyPositive (Y omega))
    (hInt : IntegrableRandomMatrix P Y)
    (hMeanSA : IsSelfAdjointMatrix (matrixExpect P Y))
    (hMeanPos : IsStrictlyPositive (matrixExpect P Y))
    (hTraceInt : IntegrableRealRandomVariable P
      (fun omega => traceMatrixExp (H + CFC.log (Y omega)))) :
    expect P (fun omega => traceMatrixExp (H + CFC.log (Y omega))) <=
      traceMatrixExp (H + CFC.log (matrixExpect P Y)) :=
  (liebJensenTraceExp_statement_of_epsteinAffineLine (P := P) hEpstein H Y)
    (liebTraceExpConcavity_of_epsteinAffineLine hEpstein H)
    hH hYsa hYpos hInt hMeanSA hMeanPos hTraceInt

end

end HighDimProb