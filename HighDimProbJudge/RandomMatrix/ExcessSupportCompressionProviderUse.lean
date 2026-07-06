import HighDimProb.RandomMatrix.ExcessSupportCompressionProvider
import HighDimProb.RandomMatrix.HardboneStatements

open scoped MatrixOrder

theorem excess_support_compression_provider_judge_use {n : Nat}
    (A support : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (hA : HighDimProb.IsSelfAdjointMatrix A)
    (hDom : HighDimProb.MatrixExpSupportDomination A support hA)
    (hSupportLeOne :
      support <= (1 : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)) :
    HighDimProb.MatrixExpExcessSupportDomination A support hA :=
  HighDimProb.matrixExpExcessSupportDomination_of_supportDomination_of_support_le_one
    hA hDom hSupportLeOne

theorem excess_support_compression_provider_identity_use {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (hA : HighDimProb.IsSelfAdjointMatrix A) :
    HighDimProb.MatrixExpExcessSupportDomination A 1 hA :=
  excess_support_compression_provider_judge_use A 1 hA
    (HighDimProb.matrixExpSupportDomination_identity A hA)
    le_rfl

theorem excess_support_compression_provider_trace_bound_use {n : Nat}
    (A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
    (hA : HighDimProb.IsSelfAdjointMatrix A)
    (hCoeff : 0 <= Real.exp (HighDimProb.lambdaMaxOrdered A hA) - 1) :
    HighDimProb.traceMatrixExp A <=
      ((n + 1 : Nat) : Real) +
        ((n + 1 : Nat) : Real) *
          (Real.exp (HighDimProb.lambdaMaxOrdered A hA) - 1) := by
  have hDom : HighDimProb.MatrixExpExcessSupportDomination A 1 hA :=
    excess_support_compression_provider_identity_use A hA
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
