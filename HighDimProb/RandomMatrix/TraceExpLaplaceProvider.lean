import HighDimProb.RandomMatrix.ConcentrationStatements

/-!
# Trace-exp to Laplace provider bridges

This module proves the smallest exact bridge from the real bounded-Bernstein
trace-MGF form to its lintegral form, then packages that bridge into the thin
Laplace contracts used downstream.

It does not prove trace-MGF bounds, tail-event domination, theta optimization,
or Matrix Bernstein.
-/

namespace HighDimProb

open MeasureTheory

noncomputable section

/-- Real-to-lintegral conversion for the bounded-Bernstein trace-MGF target.

This is the narrow bridge from the real semantic bound to the lintegral form
consumed by the Laplace layer. It only uses the explicit integrability and
pointwise nonnegativity hypotheses required by `ENNReal.ofReal`. -/
theorem traceMGFBernsteinVarianceProxyBoundLIntegral_of_real
    {Omega : Type*} [MeasurableSpace Omega] {n : Nat}
    (P : Measure Omega) (Y : RandomMatrix Omega n n)
    (V : Matrix (Fin n) (Fin n) Real) (theta R : Real)
    (hInt : IntegrableRealRandomVariable P (traceExpIntegrand Y theta))
    (hNonneg : forall omega, 0 <= traceExpIntegrand Y theta omega)
    (hReal : TraceMGFBernsteinVarianceProxyBound P Y V theta R) :
    TraceMGFBernsteinVarianceProxyBoundLIntegral P Y V theta R := by
  have hReal' :
      traceExpMoment P Y theta <=
        traceMatrixExp (SMul.smul (bernsteinMGFCoeff theta R) V) := by
    simpa [TraceMGFBernsteinVarianceProxyBound, TraceMGFBound] using hReal
  unfold TraceMGFBernsteinVarianceProxyBoundLIntegral TraceMGFBoundLIntegral
  rw [traceExpMomentLIntegral_eq_ofReal_traceExpMoment
      (P := P) (Y := Y) (theta := theta) hInt hNonneg]
  exact ENNReal.ofReal_le_ofReal hReal'

/-- Thin Laplace contract from the lintegral bounded-Bernstein trace-MGF
target to the quadratic-form upper-tail bound. -/
theorem matrixBernsteinTraceMGFToLaplaceContract
    {Omega : Type*} [MeasurableSpace Omega] {I : Type*} [Fintype I] {n : Nat}
    (P : Measure Omega) (A : I -> RandomMatrix Omega n n)
    (theta t R : Real) :
    matrixBernsteinTraceMGFToLaplaceContract_statement P A theta t R := by
  intro hMeas hSubset hBound
  exact quadraticFormUpperTail_laplace_bound_of_traceMGFBernsteinVarianceProxyBoundLIntegral
    (randomMatrixSum A) (matrixVarianceProxy P A) theta t R hMeas hSubset hBound

/-- Thin Laplace contract under the bounded-Bernstein primitives.

The real bounded-Bernstein premise is first converted to the lintegral form by
`traceMGFBernsteinVarianceProxyBoundLIntegral_of_real`, then the same Laplace
bridge is reused. -/
theorem matrixBernsteinTraceMGFToLaplaceContract_under_primitives
    {Omega : Type*} [MeasurableSpace Omega] (P : Measure Omega)
    [IsProbabilityMeasure P] {I : Type*} [Fintype I] {n : Nat}
    (A : I -> RandomMatrix Omega n n) (theta t R : Real) :
    matrixBernsteinTraceMGFToLaplaceContract_under_primitives_statement
      P A theta t R := by
  intro hMeas hSubset hInt hNonneg hReal
  have hLInt :
      TraceMGFBernsteinVarianceProxyBoundLIntegral P (randomMatrixSum A)
        (matrixVarianceProxy P A) theta R :=
    traceMGFBernsteinVarianceProxyBoundLIntegral_of_real
      (P := P) (Y := randomMatrixSum A) (V := matrixVarianceProxy P A)
      (theta := theta) (R := R) hInt hNonneg hReal
  exact matrixBernsteinTraceMGFToLaplaceContract
    (P := P) (A := A) theta t R hMeas hSubset hLInt

end

end HighDimProb
