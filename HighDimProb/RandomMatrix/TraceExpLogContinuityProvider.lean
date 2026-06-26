import HighDimProb.RandomMatrix.MatrixLogProvider
import HighDimProb.Analysis.SelfAdjointCarrier
import HighDimProb.Analysis.SelfAdjointPositiveDomain
import HighDimProb.RandomMatrix.TraceExpJensenProvider
import Mathlib.Analysis.SpecialFunctions.ContinuousFunctionalCalculus.ExpLog.Basic
import Mathlib.Topology.Algebra.Module.FiniteDimension

/-!
# Log continuity for the trace-exp Jensen bridge

This module packages the raw continuity facts needed to remove the explicit
continuity hypothesis from the provider's closed-convex Jensen bridge. The
exact open-domain Jensen statement is proved in `TraceExp.Jensen`; this module
keeps the continuity facts reusable for smaller closed-domain variants.
-/

namespace HighDimProb

open HighDimProb
open MeasureTheory
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator Matrix.Norms.Operator

noncomputable section

private theorem continuous_realMatrixToCStarMatrix {n : Nat} :
    Continuous (fun M : Matrix (Fin n) (Fin n) Real =>
      HighDimProb.realMatrixToCStarMatrix M) := by
  have hMapEntries : Continuous (fun A : Matrix (Fin n) (Fin n) Real =>
      A.map (algebraMap Real Complex)) := by
    fun_prop
  change Continuous (fun A : Matrix (Fin n) (Fin n) Real =>
    CStarMatrix.ofMatrix (A.map (algebraMap Real Complex)))
  simpa [CStarMatrix.ofMatrix_eq_ofMatrixL] using
    (CStarMatrix.ofMatrixL.continuous.comp hMapEntries)

private def cstarMatrixToRealMatrix {n : Nat}
    (A : CStarMatrix (Fin n) (Fin n) Complex) :
    Matrix (Fin n) (Fin n) Real :=
  fun i j => Complex.re (A i j)

@[simp] private theorem cstarMatrixToRealMatrix_realMatrixToCStarMatrix {n : Nat}
    (A : Matrix (Fin n) (Fin n) Real) :
    cstarMatrixToRealMatrix (HighDimProb.realMatrixToCStarMatrix A) = A := by
  ext i j
  simp [cstarMatrixToRealMatrix, HighDimProb.realMatrixToCStarMatrix]

private theorem continuous_cstarMatrixToRealMatrix {n : Nat} :
    Continuous (fun A : CStarMatrix (Fin n) (Fin n) Complex =>
      cstarMatrixToRealMatrix A) := by
  change Continuous (fun A : CStarMatrix (Fin n) (Fin n) Complex =>
    fun i => fun j => Complex.re (A i j))
  fun_prop

/-- The real-matrix CFC logarithm is continuous on the self-adjoint strictly
positive domain, proved by transporting to `CStarMatrix`, using Mathlib's
CStar-side continuity theorem there, and pulling back through the existing
provider log bridge. -/
theorem continuousOn_cfcLog_selfAdjoint_strictlyPositive {n : Nat} :
    ContinuousOn (fun M : Matrix (Fin n) (Fin n) Real => CFC.log M)
      {M : Matrix (Fin n) (Fin n) Real |
        And (IsSelfAdjointMatrix M) (IsStrictlyPositive M)} := by
  let s : Set (Matrix (Fin n) (Fin n) Real) :=
    {M | And (IsSelfAdjointMatrix M) (IsStrictlyPositive M)}
  have hLift : ContinuousOn (fun M : Matrix (Fin n) (Fin n) Real =>
      HighDimProb.realMatrixToCStarMatrix M) s :=
    continuous_realMatrixToCStarMatrix.continuousOn
  have hCStarLog : ContinuousOn (fun A : CStarMatrix (Fin n) (Fin n) Complex =>
      CFC.log A)
      {A : CStarMatrix (Fin n) (Fin n) Complex |
        And (IsSelfAdjoint A) (IsUnit A)} :=
    CFC.continuousOn_log
  have hLogLift : ContinuousOn (fun M : Matrix (Fin n) (Fin n) Real =>
      CFC.log (HighDimProb.realMatrixToCStarMatrix M)) s :=
    hCStarLog.comp hLift (by
      intro M hM
      exact And.intro
        (HighDimProb.isSelfAdjoint_realMatrixToCStarMatrix hM.1)
        ((realMatrixToCStar_strictlyPositive hM.2).isUnit))
  have hRecoverLog : ContinuousOn (fun M : Matrix (Fin n) (Fin n) Real =>
      cstarMatrixToRealMatrix
        (CFC.log (HighDimProb.realMatrixToCStarMatrix M))) s :=
    continuous_cstarMatrixToRealMatrix.continuousOn.comp hLogLift
      (by
        intro M hM
        exact Set.mem_univ _)
  refine hRecoverLog.congr ?_
  intro M hM
  ext i j
  have hBack := realMatrixToCStar_log hM.1.isSelfAdjoint hM.2
  have hEntry := congrFun (congrFun hBack i) j
  simpa [cstarMatrixToRealMatrix] using congrArg Complex.re hEntry

/-- The trace-exponential Jensen integrand is continuous on the self-adjoint
strictly positive domain. -/
theorem continuousOn_traceMatrixExp_add_cfcLog_selfAdjoint_strictlyPositive
    {n : Nat} (H : Matrix (Fin n) (Fin n) Real) :
    ContinuousOn (fun M : Matrix (Fin n) (Fin n) Real =>
      traceMatrixExp (H + CFC.log M))
      {M : Matrix (Fin n) (Fin n) Real |
        And (IsSelfAdjointMatrix M) (IsStrictlyPositive M)} := by
  let s : Set (Matrix (Fin n) (Fin n) Real) :=
    {M | And (IsSelfAdjointMatrix M) (IsStrictlyPositive M)}
  have hLog : ContinuousOn (fun M : Matrix (Fin n) (Fin n) Real => CFC.log M) s :=
    continuousOn_cfcLog_selfAdjoint_strictlyPositive
  have hAddH : Continuous (fun A : Matrix (Fin n) (Fin n) Real => H + A) :=
    continuous_const.add continuous_id
  have hAddLog : ContinuousOn (fun M : Matrix (Fin n) (Fin n) Real => H + CFC.log M) s :=
    hAddH.continuousOn.comp hLog (by
      intro M hM
      exact Set.mem_univ _)
  have hTraceExp : Continuous (fun A : Matrix (Fin n) (Fin n) Real => traceMatrixExp A) := by
    change Continuous (fun A : Matrix (Fin n) (Fin n) Real =>
      Matrix.trace (NormedSpace.exp A))
    fun_prop
  simpa [s] using
    (hTraceExp.continuousOn.comp hAddLog (by
      intro M hM
      exact Set.mem_univ _))

/-- Carrier-native continuity wrapper for the trace-exp/log Jensen integrand on
the strictly positive self-adjoint domain. -/
theorem continuousOn_traceMatrixExp_add_cfcLog_selfAdjointCarrier_strictlyPositive
    {n : Nat} (H : Matrix (Fin n) (Fin n) Real) :
    ContinuousOn
      (fun M : selfAdjoint (Matrix (Fin n) (Fin n) Real) =>
        traceMatrixExp (H + CFC.log (M : Matrix (Fin n) (Fin n) Real)))
      (selfAdjointStrictlyPositiveSet n) := by
  let s : Set (Matrix (Fin n) (Fin n) Real) :=
    {M | And (IsSelfAdjointMatrix M) (IsStrictlyPositive M)}
  have hAmbient :
      ContinuousOn
        (fun M : Matrix (Fin n) (Fin n) Real =>
          traceMatrixExp (H + CFC.log M))
        s :=
    continuousOn_traceMatrixExp_add_cfcLog_selfAdjoint_strictlyPositive (H := H)
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

/-- Closed-convex Jensen bridge without an explicit continuity hypothesis.

The continuity side condition is discharged by
`continuousOn_traceMatrixExp_add_cfcLog_selfAdjoint_strictlyPositive` together
with the existing subset hypothesis into the positive self-adjoint domain.
-/
theorem liebJensenTraceExp_of_closedConvexSubset_autoContinuous
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
    (hYmem : forall omega, Set.Mem s (Y omega))
    (hInt : IntegrableRandomMatrix P Y)
    (hTraceInt : IntegrableRealRandomVariable P
      (fun omega => traceMatrixExp (H + CFC.log (Y omega)))) :
    expect P (fun omega => traceMatrixExp (H + CFC.log (Y omega))) <=
      traceMatrixExp (H + CFC.log (matrixExpect P Y)) := by
  exact liebJensenTraceExp_of_closedConvexSubset
    (H := H) (Y := Y) (s := s) hsClosed hsConvex hsSubset hConcave hH hYmem
    hInt hTraceInt
    ((continuousOn_traceMatrixExp_add_cfcLog_selfAdjoint_strictlyPositive
      (H := H)).mono hsSubset)

end

end HighDimProb
