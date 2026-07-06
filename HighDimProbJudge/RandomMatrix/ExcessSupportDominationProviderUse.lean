import HighDimProb.RandomMatrix.ExcessSupportDominationProvider
import HighDimProb.RandomMatrix.HardboneStatements

theorem excess_support_domination_provider_judge_use {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (hA : HighDimProb.IsSelfAdjointMatrix A) :
    HighDimProb.MatrixExpExcessSupportDomination A 1 hA :=
  HighDimProb.matrixExpExcessSupportDomination_identity hA

theorem excess_support_domination_provider_trace_bound_use {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (hA : HighDimProb.IsSelfAdjointMatrix A)
    (hCoeff : 0 <= Real.exp (HighDimProb.lambdaMaxOrdered A hA) - 1) :
    HighDimProb.traceMatrixExp A <=
      ((n + 1 : Nat) : Real) +
        ((n + 1 : Nat) : Real) *
          (Real.exp (HighDimProb.lambdaMaxOrdered A hA) - 1) := by
  have hDom : HighDimProb.MatrixExpExcessSupportDomination A 1 hA :=
    excess_support_domination_provider_judge_use A hA
  have hSupportPSD :
      HighDimProb.IsPSDMatrix
        (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) Real) := by
    exact HighDimProb.isPSDMatrix_of_posSemidef <| by
      simpa using
        (show Matrix.PosSemidef
          (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) Real) from
            Matrix.PosSemidef.one)
  have hTrace :
      HighDimProb.matrixTrace
          (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) Real) <=
        ((n + 1 : Nat) : Real) := by
    simp [HighDimProb.matrixTrace]
  simpa using
    HighDimProb.traceMatrixExp_excess_supportDim_exp_lambdaMax A 1 (n + 1)
      (Nat.succ_pos n) (le_rfl) hSupportPSD hTrace hA hCoeff hDom
