import HighDimProb.RandomMatrix.CFCLogDerivativeProvider
import HighDimProb.RandomMatrix.LogResolventProvider

/-!
# Weighted `CFC.log` to resolvent-kernel cutoff adapter

This module adds a small bridge between the strictly-positive `CFC.log`
first-derivative API and the existing finite-cutoff resolvent-kernel API.

It does not prove cutoff removal, an improper-integral representation, the
Epstein sign theorem, Lieb concavity, or Matrix Bernstein. The remainder term
stays explicit.
-/

namespace HighDimProb

open scoped MatrixOrder Matrix.Norms.Operator

noncomputable section

namespace LogResolvent

/-- Explicit finite-cutoff remainder between the reciprocal exponential
divided-difference kernel and the finite resolvent-kernel cutoff integral in
the eigenbasis of the strictly positive base point. -/
noncomputable def derivSAAtCutoffRemainder
    {n : Nat} (M B C : CFCLog.Carrier n) (T : Real) : Real :=
  let U : Matrix (Fin n) (Fin n) Real := M.2.isHermitian.eigenvectorUnitary
  let eig : Fin n -> Real := M.2.isHermitian.eigenvalues
  Finset.univ.sum (fun p => Finset.univ.sum (fun q =>
    ((star U * (B : Matrix (Fin n) (Fin n) Real) * U) q p) *
      ((star U * (C : Matrix (Fin n) (Fin n) Real) * U) p q) *
      ((matrixExpDividedDifferenceSeries (Real.log (eig p)) (Real.log (eig q)))⁻¹ -
        (∫ s in (0 : Real)..T, Inv.inv (eig p + s) * Inv.inv (eig q + s)))))

/-- Fixed-cutoff adapter from the carrier pointwise `CFC.log` derivative to the
resolvent-kernel cutoff package. The remainder stays explicit as the spectral
sum of reciprocal divided-difference minus finite-cutoff kernel terms. -/
theorem trace_mul_derivSAAt_eq_cutoffKernel_add_remainder
    {n : Nat} (M B C : CFCLog.Carrier n)
    (hPos : Set.Mem (selfAdjointStrictlyPositiveSet n) M)
    {T : Real} (hT : 0 <= T) :
    Matrix.trace ((B : Matrix (Fin n) (Fin n) Real) *
      ((CFCLog.derivSAAt M C : CFCLog.Carrier n) : Matrix (Fin n) (Fin n) Real)) =
      traceMulResolventKernelCutoff
          (M : Matrix (Fin n) (Fin n) Real)
          (B : Matrix (Fin n) (Fin n) Real)
          (C : Matrix (Fin n) (Fin n) Real)
          T +
        derivSAAtCutoffRemainder M B C T := by
  let U : Matrix (Fin n) (Fin n) Real := M.2.isHermitian.eigenvectorUnitary
  let eig : Fin n -> Real := M.2.isHermitian.eigenvalues
  let d : Fin n -> Real := fun i => Real.log (eig i)
  let W : Fin n -> Fin n -> Real := fun p q =>
    ((star U * (B : Matrix (Fin n) (Fin n) Real) * U) q p) *
      ((star U * (C : Matrix (Fin n) (Fin n) Real) * U) p q)
  let I : Fin n -> Fin n -> Real := fun p q =>
    ∫ s in (0 : Real)..T, Inv.inv (eig p + s) * Inv.inv (eig q + s)
  let Phi : Fin n -> Fin n -> Real := fun p q =>
    matrixExpDividedDifferenceSeries (d p) (d q)
  have hUV : U * star U = 1 := by
    simp [U]
  have hVU : star U * U = 1 := by
    simp [U]
  have hLogDiag :
      (cfcLogSelfAdjoint M : Matrix (Fin n) (Fin n) Real) =
        U * Matrix.diagonal d * star U := by
    change cfc Real.log (M : Matrix (Fin n) (Fin n) Real) =
      U * Matrix.diagonal (fun i => Real.log (eig i)) * star U
    rw [M.2.isHermitian.cfc_eq Real.log, Matrix.IsHermitian.cfc, Unitary.conjStarAlgAut_apply]
    rfl
  have hLift :
      ((matrixExpFDerivSelfAdjoint_conj_diagonal_equiv
          (cfcLogSelfAdjoint M) U (star U) d hLogDiag hUV hVU).symm C) =
        CFCLog.derivSAAt M C := by
    apply (matrixExpFDerivSelfAdjoint_conj_diagonal_injective_of_mul_eq_one
      (X := cfcLogSelfAdjoint M) (U := U) (V := star U) (d := d) hLogDiag hUV hVU)
    have hForward :
        matrixExpFDerivSelfAdjoint (cfcLogSelfAdjoint M)
          ((matrixExpFDerivSelfAdjoint_conj_diagonal_equiv
            (cfcLogSelfAdjoint M) U (star U) d hLogDiag hUV hVU).symm C) = C := by
      let e := matrixExpFDerivSelfAdjoint_conj_diagonal_equiv
        (cfcLogSelfAdjoint M) U (star U) d hLogDiag hUV hVU
      change (e : CFCLog.DerivOp n) (e.symm C) = C
      exact e.apply_symm_apply C
    simpa using hForward.trans (CFCLog.expFDeriv_derivSAAt M C).symm
  have hDeriv :
      Matrix.trace ((B : Matrix (Fin n) (Fin n) Real) *
        ((CFCLog.derivSAAt M C : CFCLog.Carrier n) : Matrix (Fin n) (Fin n) Real)) =
        Finset.univ.sum (fun p => Finset.univ.sum (fun q =>
          W p q * (Phi p q)⁻¹)) := by
    calc
      Matrix.trace ((B : Matrix (Fin n) (Fin n) Real) *
          ((CFCLog.derivSAAt M C : CFCLog.Carrier n) : Matrix (Fin n) (Fin n) Real)) =
          Matrix.trace ((B : Matrix (Fin n) (Fin n) Real) *
            (((matrixExpFDerivSelfAdjoint_conj_diagonal_equiv
              (cfcLogSelfAdjoint M) U (star U) d hLogDiag hUV hVU).symm C :
                selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
              Matrix (Fin n) (Fin n) Real)) := by
            simp [hLift]
      _ = Finset.univ.sum (fun p => Finset.univ.sum (fun q =>
            W p q * (Phi p q)⁻¹)) := by
            simpa [W, Phi, U, d, eig, div_eq_mul_inv, mul_assoc, mul_left_comm, mul_comm]
              using
                (MatrixExpFDeriv.conjDiagonalSymmTraceSum
                  (X := cfcLogSelfAdjoint M) (B := B) (C := C)
                  (U := U) (V := star U) (d := d) hLogDiag hUV hVU)
  have hIsymm : ∀ p q : Fin n, I p q = I q p := by
    intro p q
    refine intervalIntegral.integral_congr ?_
    intro s _hs
    simp [mul_comm]
  have hKernel :
      traceMulResolventKernelCutoff
          (M : Matrix (Fin n) (Fin n) Real)
          (B : Matrix (Fin n) (Fin n) Real)
          (C : Matrix (Fin n) (Fin n) Real)
          T =
        Finset.univ.sum (fun p => Finset.univ.sum (fun q => W p q * I p q)) := by
    calc
      traceMulResolventKernelCutoff
          (M : Matrix (Fin n) (Fin n) Real)
          (B : Matrix (Fin n) (Fin n) Real)
          (C : Matrix (Fin n) (Fin n) Real)
          T =
          Finset.univ.sum (fun p => Finset.univ.sum (fun q =>
            ((star U * (B : Matrix (Fin n) (Fin n) Real) * U) p q) *
              ((star U * (C : Matrix (Fin n) (Fin n) Real) * U) q p) *
              I p q)) := by
            simpa [U, eig, I] using
              (kernelCutoffSum
                (A := (M : Matrix (Fin n) (Fin n) Real))
                (B := (B : Matrix (Fin n) (Fin n) Real))
                (C := (C : Matrix (Fin n) (Fin n) Real))
                M.2.isHermitian
                (by simpa using hPos)
                hT)
      _ = Finset.univ.sum (fun p => Finset.univ.sum (fun q =>
            ((star U * (B : Matrix (Fin n) (Fin n) Real) * U) q p) *
              ((star U * (C : Matrix (Fin n) (Fin n) Real) * U) p q) *
              I q p)) := by
            rw [Finset.sum_comm]
      _ = Finset.univ.sum (fun p => Finset.univ.sum (fun q =>
            W p q * I p q)) := by
            refine Finset.sum_congr rfl ?_
            intro p _hp
            refine Finset.sum_congr rfl ?_
            intro q _hq
            rw [(hIsymm p q).symm]
  calc
    Matrix.trace ((B : Matrix (Fin n) (Fin n) Real) *
        ((CFCLog.derivSAAt M C : CFCLog.Carrier n) : Matrix (Fin n) (Fin n) Real)) =
        Finset.univ.sum (fun p => Finset.univ.sum (fun q =>
          W p q * I p q + W p q * ((Phi p q)⁻¹ - I p q))) := by
            rw [hDeriv]
            refine Finset.sum_congr rfl ?_
            intro p _hp
            refine Finset.sum_congr rfl ?_
            intro q _hq
            ring
    _ = Finset.univ.sum (fun p =>
          (Finset.univ.sum (fun q => W p q * I p q) +
            Finset.univ.sum (fun q => W p q * ((Phi p q)⁻¹ - I p q)))) := by
            refine Finset.sum_congr rfl ?_
            intro p _hp
            rw [Finset.sum_add_distrib]
    _ = Finset.univ.sum (fun p => Finset.univ.sum (fun q => W p q * I p q)) +
          Finset.univ.sum (fun p => Finset.univ.sum (fun q =>
            W p q * ((Phi p q)⁻¹ - I p q))) := by
            rw [Finset.sum_add_distrib]
    _ =
        traceMulResolventKernelCutoff
            (M : Matrix (Fin n) (Fin n) Real)
            (B : Matrix (Fin n) (Fin n) Real)
            (C : Matrix (Fin n) (Fin n) Real)
            T +
          derivSAAtCutoffRemainder M B C T := by
            rw [hKernel]
            unfold derivSAAtCutoffRemainder
            dsimp [W, I, Phi, U, eig]

/-- The same fixed-cutoff adapter for the named affine-line derivative field. -/
theorem trace_mul_lineDerivSA_eq_cutoffKernel_add_remainder
    {n : Nat} (A B C : CFCLog.Carrier n) (t : Real)
    (hPos : Set.Mem (selfAdjointStrictlyPositiveSet n) (A + SMul.smul t C))
    {T : Real} (hT : 0 <= T) :
    Matrix.trace ((B : Matrix (Fin n) (Fin n) Real) *
      ((CFCLog.lineDerivSA A C t : CFCLog.Carrier n) : Matrix (Fin n) (Fin n) Real)) =
      traceMulResolventKernelCutoff
          ((A + SMul.smul t C) : Matrix (Fin n) (Fin n) Real)
          (B : Matrix (Fin n) (Fin n) Real)
          (C : Matrix (Fin n) (Fin n) Real)
          T +
        derivSAAtCutoffRemainder (A + SMul.smul t C) B C T := by
  simpa [CFCLog.lineDerivSA_eq_derivSAAt] using
    (trace_mul_derivSAAt_eq_cutoffKernel_add_remainder
      (M := A + SMul.smul t C) (B := B) (C := C) hPos hT)

/-- Ambient-matrix form of the fixed-cutoff adapter for `CFCLog.lineDeriv`.

This is still a weighted self-adjoint bridge with an explicit remainder; it is
not a cutoff-removal theorem. -/
theorem trace_mul_lineDeriv_eq_cutoffKernel_add_remainder
    {n : Nat} (A B C : Matrix (Fin n) (Fin n) Real)
    (hA : IsSelfAdjointMatrix A) (hB : IsSelfAdjointMatrix B) (hC : IsSelfAdjointMatrix C)
    (t : Real) (hPos : IsStrictlyPositive (A + SMul.smul t C))
    {T : Real} (hT : 0 <= T) :
    Matrix.trace (B * CFCLog.lineDeriv A C hA hC t) =
      traceMulResolventKernelCutoff (A + SMul.smul t C) B C T +
        derivSAAtCutoffRemainder
          ({ val := A + SMul.smul t C
             , property := CFCLog.selfAdjoint_add_smul A C t hA hC } : CFCLog.Carrier n)
          ({ val := B, property := hB } : CFCLog.Carrier n)
          ({ val := C, property := hC } : CFCLog.Carrier n)
          T := by
  let Asa : CFCLog.Carrier n := { val := A, property := hA }
  let Bsa : CFCLog.Carrier n := { val := B, property := hB }
  let Csa : CFCLog.Carrier n := { val := C, property := hC }
  have hPosCarrier : Set.Mem (selfAdjointStrictlyPositiveSet n) (Asa + SMul.smul t Csa) := by
    simpa [Asa, Csa] using hPos
  simpa [Asa, Bsa, Csa, CFCLog.lineDeriv] using
    (trace_mul_lineDerivSA_eq_cutoffKernel_add_remainder
      (A := Asa) (B := Bsa) (C := Csa) (t := t) hPosCarrier hT)

end LogResolvent

end

end HighDimProb
