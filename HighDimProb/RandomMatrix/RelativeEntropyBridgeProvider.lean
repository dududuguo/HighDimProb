import HighDimProb.RandomMatrix.EpsteinProvider

/-!
# Relative-entropy carrier-to-Epstein bridge

This module transports strict-positive self-adjoint carrier concavity for
`A |-> traceMatrixExp (H + CFC.log A)` to the ambient
`EpsteinAffineLineConcavity` contract. The hard concavity premise remains
explicit; this does not prove relative-entropy joint convexity, Gibbs, Epstein,
or Lieb.
-/

namespace HighDimProb

open scoped MatrixOrder Matrix.Norms.L2Operator

noncomputable section

/-- Transport carrier concavity on the strictly positive self-adjoint domain
back to the ambient affine-line Epstein contract. This is a pure domain/coercion
wrapper: it does not prove relative entropy joint convexity, Gibbs, or Epstein
itself. -/
theorem epsteinAffineLineConcavity_of_liebTraceExpConcavity_selfAdjointCarrier
    (hCarrier :
      forall {n : Nat} (H : Matrix (Fin n) (Fin n) Real),
        IsSelfAdjointMatrix H ->
          ConcaveOn Real (selfAdjointStrictlyPositiveSet n)
            (fun A : selfAdjoint (Matrix (Fin n) (Fin n) Real) =>
              traceMatrixExp (H + CFC.log (A : Matrix (Fin n) (Fin n) Real)))) :
    EpsteinAffineLineConcavity := by
  intro n H A C hH hA hC hPos
  let linePoint : Real -> selfAdjoint (Matrix (Fin n) (Fin n) Real) := fun t =>
    Subtype.mk (A + SMul.smul t C) (by
      have ht : IsSelfAdjoint t := by
        simp [IsSelfAdjoint]
      change (A + SMul.smul t C).IsHermitian
      exact hA.add (hC.smul ht))
  have hCarrierConcave := hCarrier H hH
  constructor
  . simpa using convex_Icc (0 : Real) 1
  . intro x hx y hy a b ha hb hab
    have hxLine : Set.Mem (selfAdjointStrictlyPositiveSet n) (linePoint x) := by
      simpa [linePoint] using hPos x hx
    have hyLine : Set.Mem (selfAdjointStrictlyPositiveSet n) (linePoint y) := by
      simpa [linePoint] using hPos y hy
    have hLineIneq := hCarrierConcave.2 hxLine hyLine ha hb hab
    have hWeighted :
        (((SMul.smul a (linePoint x) + SMul.smul b (linePoint y) :
            selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
            Matrix (Fin n) (Fin n) Real)) =
          A + SMul.smul (a * x + b * y) C := by
      ext i j
      change a * (A i j + x * C i j) + b * (A i j + y * C i j) =
        A i j + (a * x + b * y) * C i j
      ring_nf
      have hCoeff : a * A i j + A i j * b = A i j := by
        calc
          a * A i j + A i j * b = (a + b) * A i j := by ring
          _ = A i j := by rw [hab]; ring
      linarith [hCoeff]
    have hxEval :
        traceMatrixExp (H + CFC.log ((linePoint x : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
          Matrix (Fin n) (Fin n) Real)) =
          traceMatrixExp (H + CFC.log (A + SMul.smul x C)) := by
      rfl
    have hyEval :
        traceMatrixExp (H + CFC.log ((linePoint y : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
          Matrix (Fin n) (Fin n) Real)) =
          traceMatrixExp (H + CFC.log (A + SMul.smul y C)) := by
      rfl
    calc
      a * traceMatrixExp (H + CFC.log (A + SMul.smul x C)) +
          b * traceMatrixExp (H + CFC.log (A + SMul.smul y C))
          = a * traceMatrixExp
              (H +
                CFC.log
                  (((linePoint x : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
                    Matrix (Fin n) (Fin n) Real))) +
            b * traceMatrixExp
              (H +
                CFC.log
                  (((linePoint y : selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
                    Matrix (Fin n) (Fin n) Real))) := by
              rw [hxEval, hyEval]
      _ <= traceMatrixExp
            (H +
              CFC.log
                ((((SMul.smul a (linePoint x) + SMul.smul b (linePoint y) :
                    selfAdjoint (Matrix (Fin n) (Fin n) Real)) :
                    Matrix (Fin n) (Fin n) Real)))) := by
              simpa [smul_eq_mul] using hLineIneq
      _ = traceMatrixExp (H + CFC.log (A + SMul.smul (a * x + b * y) C)) := by
            rw [hWeighted]

end

end HighDimProb