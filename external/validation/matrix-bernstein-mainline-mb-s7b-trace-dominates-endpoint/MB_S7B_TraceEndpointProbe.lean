import HighDimProb.RandomMatrix.TraceExp

namespace HighDimProb

open MeasureTheory
open scoped Matrix.Norms.L2Operator MatrixOrder Pointwise

#check lambdaMaxOrdered
#check lambdaMaxOrdered_eq_eigenvalues₀_zero
#check lambdaMaxOrdered_is_greatest_eigenvalue
#check lambdaMaxOrdered_smul_of_nonneg
#check matrixTrace
#check matrixTrace_apply
#check Matrix.trace
#check Matrix.PosSemidef
#check Matrix.PosSemidef.trace_nonneg
#check matrixTrace_nonneg_of_posSemidef
#check matrixExp_posSemidef_of_selfAdjoint
#check traceMatrixExp
#check Matrix.IsHermitian.trace_eq_sum_eigenvalues
#check Matrix.IsHermitian.posSemidef_iff_eigenvalues_nonneg
#check Matrix.PosSemidef.eigenvalues_nonneg
#check Matrix.IsHermitian.eigenvalues₀
#check Matrix.IsHermitian.eigenvalues₀_antitone
#check Matrix.IsHermitian.eigenvalues
#check Matrix.IsHermitian.eigenvalues_mem_spectrum_real
#check Matrix.IsHermitian.spectrum_real_eq_range_eigenvalues
#check Finset.sum_nonneg
#check Finset.single_le_sum
#check Fintype.equivOfCardEq

private theorem probe_lambdaMaxOrdered_le_trace_of_posSemidef
    {n : Nat} {B : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    (hB : IsSelfAdjointMatrix B)
    (hPSD : Matrix.PosSemidef B) :
    lambdaMaxOrdered B hB <= Matrix.trace B := by
  classical
  let e : Fin (Fintype.card (Fin (n + 1))) ≃ Fin (n + 1) :=
    Fintype.equivOfCardEq (by simp)
  have htrace : Matrix.trace B = ∑ i, (hB.eigenvalues i : Real) :=
    hB.trace_eq_sum_eigenvalues
  have hnonneg : ∀ i : Fin (n + 1), 0 <= hB.eigenvalues i := by
    intro i
    exact hPSD.eigenvalues_nonneg i
  have hterm :
      hB.eigenvalues (e 0) <= ∑ i, hB.eigenvalues i := by
    exact Finset.single_le_sum (by
      intro j _hj
      exact hnonneg j) (Finset.mem_univ (e 0))
  simpa [lambdaMaxOrdered, Matrix.IsHermitian.eigenvalues, e, htrace] using hterm

end HighDimProb

