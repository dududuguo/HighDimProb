import HighDimProb.RandomMatrix.CFCLogDerivativeProvider
import HighDimProb.RandomMatrix.EpsteinDerivativeProvider
import HighDimProb.RandomMatrix.RelativeEntropyLeftRightRepresentationProvider
import HighDimProb.RandomMatrix.TraceExpDomainProvider
import Mathlib.Analysis.Convex.Deriv

/-!
# Golden--Thompson provider

This module proves the exact finite-dimensional real self-adjoint
Golden--Thompson statement. It applies the tangent inequality for the proved
Epstein/Lieb concavity theorem along the strictly positive segment from the
identity to exp B.
-/

namespace HighDimProb

open Set
open scoped MatrixOrder Matrix.Norms.Operator RightActions

noncomputable section

/-- The exact Golden--Thompson statement, obtained from the proved Epstein/Lieb
concavity theorem by taking the tangent at the identity. -/
theorem goldenThompsonTraceExp
    {n : Nat} (A B : Matrix (Fin n) (Fin n) Real) :
    goldenThompsonTraceExp_statement A B := by
  classical
  intro hA hB
  let E := matrixExp B
  let C := E - (1 : Matrix (Fin n) (Fin n) Real)
  have hOne : IsSelfAdjointMatrix
      (1 : Matrix (Fin n) (Fin n) Real) := by
    simp [IsSelfAdjointMatrix]
  have hE : IsSelfAdjointMatrix E :=
    isSelfAdjointMatrix_matrixExp hB
  have hC : IsSelfAdjointMatrix C := hE.sub hOne
  have hPos : forall t : Real, t ∈ Set.Icc 0 1 ->
      IsStrictlyPositive
        ((1 : Matrix (Fin n) (Fin n) Real) + t • C) := by
    intro t ht
    let I : selfAdjoint (Matrix (Fin n) (Fin n) Real) :=
      { val := 1, property := hOne }
    let Esa : selfAdjoint (Matrix (Fin n) (Fin n) Real) :=
      { val := E, property := hE }
    have hI : I ∈ selfAdjointStrictlyPositiveSet n :=
      isStrictlyPositive_one
    have hEsp : Esa ∈ selfAdjointStrictlyPositiveSet n :=
      matrixExp_isStrictlyPositive_of_selfAdjoint hB
    have hconv :=
      (convex_selfAdjointStrictlyPositiveSet n) hI hEsp
        (sub_nonneg.mpr ht.2) ht.1 (by ring)
    rw [show
      (1 : Matrix (Fin n) (Fin n) Real) + t • C =
        ((1 - t) • (1 : Matrix (Fin n) (Fin n) Real) + t • E) by
          dsimp [C]
          module]
    exact hconv
  let f : Real -> Real := fun t =>
    traceMatrixExp
      (A + CFC.log ((1 : Matrix (Fin n) (Fin n) Real) + t • C))
  have hConc : ConcaveOn Real (Set.Icc 0 1) f := by
    simpa [f] using
      (epsteinAffineLineConcavity_of_leftRight
        A (1 : Matrix (Fin n) (Fin n) Real) C hA hOne hC hPos)
  have hlog0 :
      HasDerivAt
        (fun s : Real =>
          CFC.log ((1 : Matrix (Fin n) (Fin n) Real) + s • C))
        C 0 := by
    have h := CFCLog.hasDerivAt_line
      (1 : Matrix (Fin n) (Fin n) Real) C hOne hC
      (hPos 0 (show (0 : Real) ∈ Set.Icc 0 1 by
        constructor <;> norm_num))
    convert h using 1
    exact (CFCLog.lineDeriv_one_zero C hOne hC).symm
  have hDeriv :
      HasDerivAt f (Matrix.trace (C * matrixExp A)) 0 := by
    have h :=
      hasDerivAt_traceMatrixExp_add_cfcLog_affineLine_of_hasDerivAt_cfcLog
        A (1 : Matrix (Fin n) (Fin n) Real) C hlog0
    have hbase :
        (1 : Matrix (Fin n) (Fin n) Real) +
            SMul.smul (0 : Real) C = 1 := by
      ext i j
      simp [SMul.smul]
    rw [hbase, CFC.log_one, add_zero] at h
    simpa [f, matrixExp] using h
  have hslope :=
    hConc.slope_le_of_hasDerivAt
      (show (0 : Real) ∈ Set.Icc 0 1 by constructor <;> norm_num)
      (show (1 : Real) ∈ Set.Icc 0 1 by constructor <;> norm_num)
      (show (0 : Real) < 1 by norm_num)
      hDeriv
  have hline :
      f 1 <= f 0 + Matrix.trace (C * matrixExp A) := by
    norm_num [slope] at hslope
    simpa [matrixExp, add_comm] using hslope
  have hlogE : CFC.log E = B :=
    matrixExpLogSelfAdjointNormalization B hB
  have hEnd : f 1 = traceMatrixExp (A + B) := by
    dsimp [f]
    rw [show
      (1 : Matrix (Fin n) (Fin n) Real) + (1 : Real) • C = E by
        simp [C],
      hlogE]
  have hStart : f 0 = traceMatrixExp A := by
    dsimp [f]
    rw [zero_smul, add_zero, CFC.log_one, add_zero]
  rw [hEnd, hStart] at hline
  calc
    traceMatrixExp (A + B) <=
        traceMatrixExp A + Matrix.trace (C * matrixExp A) := hline
    _ = matrixTrace (matrixExp A * matrixExp B) := by
      change Matrix.trace (matrixExp A) +
          Matrix.trace ((matrixExp B - 1) * matrixExp A) =
        Matrix.trace (matrixExp A * matrixExp B)
      rw [Matrix.trace_mul_comm (matrixExp A) (matrixExp B)]
      simp [sub_mul]

end

end HighDimProb