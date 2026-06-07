import Mathlib.Analysis.Matrix.Order
import HighDimProb.RandomMatrix.Spectral

namespace HighDimProb

open scoped MatrixOrder

#check SpectralUpperBound
#check RayleighUpperBound
#check lambdaMaxOrdered
#check lambdaMaxOrdered_eq_eigenvalues₀_zero
#check lambdaMaxOrdered_is_greatest_eigenvalue
#check LambdaMaxOrderedPSDUpperBound
#check matrixQuadraticForm_le_lambdaMaxOrdered_of_lambdaMaxOrderedPSDUpperBound
#check rayleighUpperBound_of_spectralUpperBound
#check quadraticFormUpperTailEvent_subset_scalarUpperTailEvent_of_rayleighUpperBound
#check quadraticFormUpperTailEvent_subset_matrixUpperBoundTailEvent_of_rayleighUpperBound
#check quadraticFormUpperTailEvent_subset_matrixUpperBoundTailEvent_of_spectralUpperBound
#check IsSelfAdjointMatrix

#check Matrix.IsHermitian.eigenvalues₀
#check Matrix.IsHermitian.eigenvalues₀_antitone
#check Matrix.IsHermitian.eigenvalues
#check Matrix.IsHermitian.spectrum_real_eq_range_eigenvalues
#check Matrix.IsHermitian.posSemidef_iff_eigenvalues_nonneg
#check Matrix.le_iff
#check Matrix.nonneg_iff_posSemidef
#check Matrix.posSemidef_iff_isHermitian_and_spectrum_nonneg
#check le_algebraMap_of_spectrum_le
#check CFC.le_one
#check Matrix.IsHermitian.cfc_eq
#check Matrix.IsHermitian.spectral_theorem
#check Matrix.IsHermitian.eigenvectorUnitary
#check Matrix.IsHermitian.isSelfAdjoint
#check Algebra.algebraMap_eq_smul_one

example {n : Nat} {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    (hA : IsSelfAdjointMatrix A) :
    A ≤ algebraMap Real (Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
      (lambdaMaxOrdered A hA) := by
  classical
  apply le_algebraMap_of_spectrum_le
  · intro x hx
    rw [hA.spectrum_real_eq_range_eigenvalues] at hx
    rcases hx with ⟨i, rfl⟩
    dsimp [lambdaMaxOrdered, Matrix.IsHermitian.eigenvalues]
    exact hA.eigenvalues₀_antitone (Fin.zero_le _)
  · exact hA.isSelfAdjoint

example {n : Nat} {A : Matrix (Fin (n + 1)) (Fin (n + 1)) Real}
    (hA : IsSelfAdjointMatrix A) :
    SpectralUpperBound A (lambdaMaxOrdered A hA) := by
  classical
  have hle :
      A ≤ algebraMap Real (Matrix (Fin (n + 1)) (Fin (n + 1)) Real)
        (lambdaMaxOrdered A hA) := by
    apply le_algebraMap_of_spectrum_le
    · intro x hx
      rw [hA.spectrum_real_eq_range_eigenvalues] at hx
      rcases hx with ⟨i, rfl⟩
      dsimp [lambdaMaxOrdered, Matrix.IsHermitian.eigenvalues]
      exact hA.eigenvalues₀_antitone (Fin.zero_le _)
    · exact hA.isSelfAdjoint
  simpa [SpectralUpperBound, Algebra.algebraMap_eq_smul_one] using
    (Matrix.le_iff.mp hle)

end HighDimProb
