import HighDimProb.RandomMatrix.CFCLogResolventKernelProvider

/-!
# Same-eigenbasis simplifications for the explicit `CFC.log` resolvent remainder

This module only simplifies the explicit finite-cutoff remainder from
`LogResolvent.derivSAAtCutoffRemainder` when the multiplier and probe direction
are diagonal in the eigenbasis of the positive base point.

It does not remove the cutoff, prove a sign, or claim Epstein/Lieb/Tropp.
-/

namespace HighDimProb

open scoped MatrixOrder Matrix.Norms.Operator

noncomputable section

namespace LogResolvent

/-- If the multiplier and probe direction are diagonal in the eigenbasis of the
base point, the explicit cutoff remainder collapses to a single eigenvalue sum.

The cutoff integral remains explicit. This is a concrete same-eigenbasis
specialization, not a cutoff-removal theorem. -/
theorem derivSAAtCutoffRemainder_eq_sum_conjDiagonal
    {n : Nat} (M B C : CFCLog.Carrier n) (T : Real)
    {b c : Fin n -> Real}
    (hB : star (M.2.isHermitian.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) *
        (B : Matrix (Fin n) (Fin n) Real) *
        (M.2.isHermitian.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) =
      Matrix.diagonal b)
    (hC : star (M.2.isHermitian.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) *
        (C : Matrix (Fin n) (Fin n) Real) *
        (M.2.isHermitian.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) =
      Matrix.diagonal c) :
    derivSAAtCutoffRemainder M B C T =
      Finset.univ.sum (fun i =>
        b i * c i *
          ((matrixExpDividedDifferenceSeries
              (Real.log (M.2.isHermitian.eigenvalues i))
              (Real.log (M.2.isHermitian.eigenvalues i)))⁻¹ -
            (∫ s in (0 : Real)..T,
              Inv.inv (M.2.isHermitian.eigenvalues i + s) *
                Inv.inv (M.2.isHermitian.eigenvalues i + s)))) := by
  let eig : Fin n -> Real := M.2.isHermitian.eigenvalues
  let F : Fin n -> Fin n -> Real := fun p q =>
    (matrixExpDividedDifferenceSeries (Real.log (eig p)) (Real.log (eig q)))⁻¹ -
      (∫ s in (0 : Real)..T, Inv.inv (eig p + s) * Inv.inv (eig q + s))
  unfold derivSAAtCutoffRemainder
  dsimp [eig, F]
  rw [hB, hC]
  refine Finset.sum_congr rfl ?_
  intro p _hp
  classical
  rw [Finset.sum_eq_single p]
  · simp [Matrix.diagonal]
  · intro q _hq hqp
    simp [Matrix.diagonal, hqp]
  · simp [Matrix.diagonal]

/-- Under strict positivity, the same-eigenbasis remainder simplifies further:
the diagonal reciprocal divided-difference coefficient becomes the reciprocal
eigenvalue of the positive base point.

The finite-cutoff kernel integral is still explicit. -/
theorem derivSAAtCutoffRemainder_eq_sum_inv_sub_kernel_conjDiagonal_of_strictlyPositive
    {n : Nat} (M B C : CFCLog.Carrier n)
    (hPos : Set.Mem (selfAdjointStrictlyPositiveSet n) M)
    (T : Real)
    {b c : Fin n -> Real}
    (hB : star (M.2.isHermitian.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) *
        (B : Matrix (Fin n) (Fin n) Real) *
        (M.2.isHermitian.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) =
      Matrix.diagonal b)
    (hC : star (M.2.isHermitian.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) *
        (C : Matrix (Fin n) (Fin n) Real) *
        (M.2.isHermitian.eigenvectorUnitary : Matrix (Fin n) (Fin n) Real) =
      Matrix.diagonal c) :
    derivSAAtCutoffRemainder M B C T =
      Finset.univ.sum (fun i =>
        b i * c i *
          (Inv.inv (M.2.isHermitian.eigenvalues i) -
            (∫ s in (0 : Real)..T,
              Inv.inv (M.2.isHermitian.eigenvalues i + s) *
                Inv.inv (M.2.isHermitian.eigenvalues i + s)))) := by
  have hEigPos : ∀ i, 0 < M.2.isHermitian.eigenvalues i := by
    exact M.2.isHermitian.posDef_iff_eigenvalues_pos.mp
      (Matrix.isStrictlyPositive_iff_posDef.mp (by simpa using hPos))
  rw [derivSAAtCutoffRemainder_eq_sum_conjDiagonal (M := M) (B := B) (C := C) (T := T) hB hC]
  refine Finset.sum_congr rfl ?_
  intro i _hi
  rw [matrixExpDividedDifferenceSeries_self, Real.exp_log (hEigPos i)]

end LogResolvent

end

end HighDimProb
