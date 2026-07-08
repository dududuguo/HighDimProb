import HighDimProb.RandomMatrix.Expectation
import HighDimProb.RandomMatrix.HardboneStatements
import HighDimProb.RandomMatrix.TraceExp
import HighDimProb.Analysis.SelfAdjointPositiveDomain
import HighDimProb.Analysis.OpenJensen
import Mathlib.Analysis.Convex.Integral
import Mathlib.Analysis.CStarAlgebra.ContinuousFunctionalCalculus.Instances
import Mathlib.Analysis.CStarAlgebra.ContinuousFunctionalCalculus.Basic
import Mathlib.Analysis.Matrix.HermitianFunctionalCalculus
import Mathlib.Analysis.CStarAlgebra.Matrix
import Mathlib.Topology.Instances.Matrix

/-!
# Trace-exp Jensen bridge

This module proves a reusable Jensen bridge on an explicit closed convex
domain contained in the positive self-adjoint cone, together with the exact
open-domain wrapper that consumes the existing Lieb concavity statement.
-/

namespace HighDimProb

open HighDimProb
open MeasureTheory
open scoped MatrixOrder Matrix.Norms.L2Operator

noncomputable section

/-- Carrier-native Lieb concavity wrapper on the strictly positive self-adjoint
domain. -/
theorem liebTraceExpConcavity_selfAdjointCarrier
    {n : Nat} (H : Matrix (Fin n) (Fin n) Real)
    (hConcave : liebTraceExpConcavity_statement H)
    (hH : IsSelfAdjointMatrix H) :
    ConcaveOn Real (selfAdjointStrictlyPositiveSet n)
      (fun M : selfAdjoint (Matrix (Fin n) (Fin n) Real) =>
        traceMatrixExp (H + CFC.log (M : Matrix (Fin n) (Fin n) Real))) := by
  refine ⟨convex_selfAdjointStrictlyPositiveSet n, ?_⟩
  intro x hx y hy a b ha hb hab
  have hxAmbient :
      (x : Matrix (Fin n) (Fin n) Real) ∈
        {M : Matrix (Fin n) (Fin n) Real |
          IsSelfAdjointMatrix M ∧ IsStrictlyPositive M} :=
    And.intro x.2 hx
  have hyAmbient :
      (y : Matrix (Fin n) (Fin n) Real) ∈
        {M : Matrix (Fin n) (Fin n) Real |
          IsSelfAdjointMatrix M ∧ IsStrictlyPositive M} :=
    And.intro y.2 hy
  simpa using (hConcave hH).2 hxAmbient hyAmbient ha hb hab

/-- Recover the exact HighDimProb Lieb concavity statement from a carrier-native
concavity theorem on `selfAdjoint` matrices.

This is the reverse transport needed if a future Mathlib theorem is most
naturally stated on the `selfAdjoint` carrier. -/
theorem liebTraceExpConcavity_of_selfAdjointCarrier
    {n : Nat} (H : Matrix (Fin n) (Fin n) Real)
    (hCarrier :
      IsSelfAdjointMatrix H ->
        ConcaveOn Real (selfAdjointStrictlyPositiveSet n)
          (fun M : selfAdjoint (Matrix (Fin n) (Fin n) Real) =>
            traceMatrixExp (H + CFC.log (M : Matrix (Fin n) (Fin n) Real)))) :
    liebTraceExpConcavity_statement H := by
  intro hH
  let s : Set (Matrix (Fin n) (Fin n) Real) :=
    {M : Matrix (Fin n) (Fin n) Real |
      IsSelfAdjointMatrix M ∧ IsStrictlyPositive M}
  let g : Matrix (Fin n) (Fin n) Real -> Real :=
    fun M => traceMatrixExp (H + CFC.log M)
  let gSA : selfAdjoint (Matrix (Fin n) (Fin n) Real) -> Real :=
    fun M => traceMatrixExp (H + CFC.log (M : Matrix (Fin n) (Fin n) Real))
  have hCarrierConcave := hCarrier hH
  refine ⟨?_, ?_⟩
  · intro x hx y hy a b ha hb hab
    let xSA : selfAdjoint (Matrix (Fin n) (Fin n) Real) := ⟨x, hx.1⟩
    let ySA : selfAdjoint (Matrix (Fin n) (Fin n) Real) := ⟨y, hy.1⟩
    have hxSA : xSA ∈ selfAdjointStrictlyPositiveSet n := hx.2
    have hySA : ySA ∈ selfAdjointStrictlyPositiveSet n := hy.2
    have hxySA :
        a • xSA + b • ySA ∈ selfAdjointStrictlyPositiveSet n :=
      hCarrierConcave.1 hxSA hySA ha hb hab
    refine And.intro ?_ ?_
    · simpa [xSA, ySA] using (a • xSA + b • ySA).2
    · simpa [xSA, ySA] using hxySA
  · intro x hx y hy a b ha hb hab
    let xSA : selfAdjoint (Matrix (Fin n) (Fin n) Real) := ⟨x, hx.1⟩
    let ySA : selfAdjoint (Matrix (Fin n) (Fin n) Real) := ⟨y, hy.1⟩
    have hxSA : xSA ∈ selfAdjointStrictlyPositiveSet n := hx.2
    have hySA : ySA ∈ selfAdjointStrictlyPositiveSet n := hy.2
    simpa [s, g, gSA, xSA, ySA] using
      (hCarrierConcave.2 hxSA hySA ha hb hab)

/-- Exact equivalence between the ambient HighDimProb Lieb concavity contract
and its carrier-native `selfAdjoint` form. -/
theorem liebTraceExpConcavity_statement_iff_selfAdjointCarrier
    {n : Nat} (H : Matrix (Fin n) (Fin n) Real) :
    liebTraceExpConcavity_statement H ↔
      IsSelfAdjointMatrix H ->
        ConcaveOn Real (selfAdjointStrictlyPositiveSet n)
          (fun M : selfAdjoint (Matrix (Fin n) (Fin n) Real) =>
            traceMatrixExp (H + CFC.log (M : Matrix (Fin n) (Fin n) Real))) := by
  constructor
  · intro hConcave hH
    exact liebTraceExpConcavity_selfAdjointCarrier H hConcave hH
  · intro hCarrier
    exact liebTraceExpConcavity_of_selfAdjointCarrier H hCarrier

/-- Jensen bridge for a closed convex subset of the positive self-adjoint cone.

The theorem consumes the existing Lieb concavity statement and the repository's
entrywise matrix expectation / integrability API. The extra hypothesis is the
continuity of the trace-log-exponential integrand on the chosen closed convex
set. -/
theorem liebJensenTraceExp_of_closedConvexSubset
    {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {n : Nat}
    (H : Matrix (Fin n) (Fin n) Real)
    (Y : RandomMatrix Omega n n)
    (s : Set (Matrix (Fin n) (Fin n) Real))
    (hsClosed : IsClosed s)
    (hsConvex : Convex Real s)
    (hsSubset : Set.Subset s (fun M : Matrix (Fin n) (Fin n) Real =>
      And (IsSelfAdjointMatrix M) (IsStrictlyPositive M)))
    (hConcave : liebTraceExpConcavity_statement H)
    (hH : IsSelfAdjointMatrix H)
    (hYmem : forall omega, Y omega ∈ s)
    (hInt : IntegrableRandomMatrix P Y)
    (hTraceInt : IntegrableRealRandomVariable P
      (fun omega => traceMatrixExp (H + CFC.log (Y omega))))
    (hGCont : ContinuousOn (fun M : Matrix (Fin n) (Fin n) Real =>
      traceMatrixExp (H + CFC.log M)) s) :
    expect P (fun omega => traceMatrixExp (H + CFC.log (Y omega))) <=
      traceMatrixExp (H + CFC.log (matrixExpect P Y)) := by
  let g : Matrix (Fin n) (Fin n) Real -> Real :=
    fun M => traceMatrixExp (H + CFC.log M)

  have hConcaveS : ConcaveOn Real s g := (hConcave hH).subset hsSubset hsConvex

  have hIntY : Integrable (fun omega => Y omega) P :=
    integrable_matrix_of_integrableRandomMatrix (P := P) (A := Y) hInt

  have hIntG : Integrable (fun omega => g (Y omega)) P := by
    change Integrable (fun omega => traceMatrixExp (H + CFC.log (Y omega))) P
    exact hTraceInt

  have hJensen :=
    hConcaveS.le_map_integral hGCont hsClosed (ae_of_all _ hYmem) hIntY hIntG

  have hExpectEq : matrixExpect P Y = ∫ omega, Y omega ∂P :=
    matrixExpect_eq_integral (P := P) (A := Y) hInt

  have hJensen' :
      expect P (fun omega => traceMatrixExp (H + CFC.log (Y omega))) <=
        traceMatrixExp (H + CFC.log (∫ omega, Y omega ∂P)) := by
    change ∫ omega, traceMatrixExp (H + CFC.log (Y omega)) ∂P <=
      traceMatrixExp (H + CFC.log (∫ omega, Y omega ∂P))
    exact hJensen

  rw [hExpectEq]
  exact hJensen'

/-- Exact Jensen wrapper consuming the existing Lieb concavity statement and
the provider's self-adjoint strictly positive carrier infrastructure. -/
theorem liebJensenTraceExp_statement_of_liebConcavity
    {Omega : Type*} [MeasurableSpace Omega]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {n : Nat}
    (H : Matrix (Fin n) (Fin n) Real)
    (Y : RandomMatrix Omega n n) :
    liebJensenTraceExp_statement (P := P) H Y := by
  intro hConcave hH hYsa hYpos hInt _hMeanSA hMeanPos hTraceInt
  let F : Omega -> selfAdjoint (Matrix (Fin n) (Fin n) Real) :=
    fun omega =>
      (Subtype.mk (Y omega) (hYsa omega) : selfAdjoint (Matrix (Fin n) (Fin n) Real))
  let g : selfAdjoint (Matrix (Fin n) (Fin n) Real) -> Real := fun M =>
    traceMatrixExp (H + CFC.log (M : Matrix (Fin n) (Fin n) Real))

  have hIntY : Integrable (fun omega => Y omega) P :=
    integrable_matrix_of_integrableRandomMatrix (P := P) (A := Y) hInt
  have hFint : Integrable F P := by
    exact
      selfAdjoint.integrable_mk_of_integrable_coe
        (A := Matrix (Fin n) (Fin n) Real)
        (F := fun omega => Y omega) hIntY fun omega => hYsa omega
  have hFmem :
      Filter.Eventually
        (fun omega => Set.Mem (selfAdjointStrictlyPositiveSet n) (F omega))
        (MeasureTheory.ae P) :=
    Filter.Eventually.of_forall fun omega => hYpos omega
  have hgInt : Integrable (fun omega => g (F omega)) P := by
    change Integrable (fun omega => traceMatrixExp (H + CFC.log (Y omega))) P
    exact hTraceInt
  have hMeanEq :
      ((MeasureTheory.integral P F : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
          Matrix (Fin n) (Fin n) Real) = matrixExpect P Y := by
    calc
      ((MeasureTheory.integral P F : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
          Matrix (Fin n) (Fin n) Real)
          = MeasureTheory.integral P
              (fun omega =>
                ((F omega : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
                  Matrix (Fin n) (Fin n) Real)) :=
            selfAdjoint.coe_integral hFint
      _ = MeasureTheory.integral P (fun omega => Y omega) := by
        rfl
      _ = matrixExpect P Y := by
        symm
        exact matrixExpect_eq_integral (P := P) (A := Y) hInt
  have hMeanMem :
      Set.Mem (selfAdjointStrictlyPositiveSet n)
        (MeasureTheory.integral P F : selfAdjoint (Matrix (Fin n) (Fin n) Real)) := by
    change IsStrictlyPositive
      (((MeasureTheory.integral P F : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
        Matrix (Fin n) (Fin n) Real))
    rw [hMeanEq]
    exact hMeanPos

  have hJensen :
      MeasureTheory.integral P (fun omega => g (F omega)) <=
        g (MeasureTheory.integral P F) := by
    exact
      @ConcaveOn.le_map_integral_of_mem_open
        Omega
        (selfAdjoint (Matrix (Fin n) (Fin n) Real))
        inferInstance
        inferInstance
        inferInstance
        (selfAdjoint.instCompleteSpaceSelfAdjoint (A := Matrix (Fin n) (Fin n) Real))
        (selfAdjoint.instFiniteDimensionalSelfAdjoint (A := Matrix (Fin n) (Fin n) Real))
        P
        inferInstance
        (selfAdjointStrictlyPositiveSet n)
        F
        g
        (liebTraceExpConcavity_selfAdjointCarrier H hConcave hH)
        (isOpen_selfAdjointStrictlyPositiveSet n)
        hFmem
        hFint
        (by
          change Integrable (fun omega => g (F omega)) P
          exact hgInt)
        hMeanMem

  have leftEq :
      MeasureTheory.integral P (fun omega => g (F omega)) =
        expect P (fun omega => traceMatrixExp (H + CFC.log (Y omega))) := by
    rfl
  have rightEq :
      g (MeasureTheory.integral P F) =
        traceMatrixExp (H + CFC.log (matrixExpect P Y)) := by
    change traceMatrixExp
        (H +
          CFC.log
            (((MeasureTheory.integral P F : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
              Matrix (Fin n) (Fin n) Real))) =
      traceMatrixExp (H + CFC.log (matrixExpect P Y))
    rw [hMeanEq]

  calc
    expect P (fun omega => traceMatrixExp (H + CFC.log (Y omega)))
        = MeasureTheory.integral P (fun omega => g (F omega)) := leftEq.symm
    _ <= g (MeasureTheory.integral P F) := hJensen
    _ = traceMatrixExp (H + CFC.log (matrixExpect P Y)) := rightEq

end

end HighDimProb
