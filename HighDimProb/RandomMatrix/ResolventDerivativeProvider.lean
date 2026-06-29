import HighDimProb.RandomMatrix.CStarBridge
import Mathlib.Analysis.Calculus.FDeriv.Mul

/-!
# Short inverse and trace-resolvent derivative provider layer

This module upstreams the small affine-line inverse/resolvent derivative bridges
needed before any log-resolvent representation or Epstein sign work.

It proves only inverse and trace-resolvent derivative identities. It does not
prove a log-resolvent representation, an Epstein sign theorem, Lieb concavity,
or Matrix Bernstein.
-/

namespace HighDimProb

open scoped MatrixOrder Matrix.Norms.Operator

noncomputable section

private def traceMulLeftCLM {n : Nat} (B : Matrix (Fin n) (Fin n) Real) :
    ContinuousLinearMap (RingHom.id Real)
      (Matrix (Fin n) (Fin n) Real) Real :=
  (LinearMap.toContinuousLinearMap (Matrix.traceLinearMap (Fin n) Real Real)).comp
    (LinearMap.toContinuousLinearMap (LinearMap.mulLeft Real B))

private theorem hasFDerivAt_trace_mul_left
    {n : Nat} (B X : Matrix (Fin n) (Fin n) Real) :
    HasFDerivAt
      (fun Y : Matrix (Fin n) (Fin n) Real => Matrix.trace (B * Y))
      (traceMulLeftCLM B)
      X := by
  simpa [traceMulLeftCLM, ContinuousLinearMap.comp_apply,
    Matrix.traceLinearMap_apply, LinearMap.mulLeft_apply] using
    (traceMulLeftCLM B).hasFDerivAt

/-- Affine-line derivative of matrix inversion.

This is the first resolvent-route leaf: later proofs can specialize `C` to the
identity matrix to obtain derivatives of `t -> (A + t * 1)^(-1)`.
-/
theorem hasDerivAt_inverse_affineLine
    {n : Nat} (A C : Matrix (Fin n) (Fin n) Real) {t : Real}
    (hUnit : IsUnit (A + SMul.smul t C)) :
    HasDerivAt
      (fun s : Real => Inv.inv (A + SMul.smul s C))
      (-((Inv.inv (A + SMul.smul t C)) * C * Inv.inv (A + SMul.smul t C)))
      t := by
  have hLine : HasDerivAt (fun s : Real => A + SMul.smul s C) C t := by
    simpa using ((hasDerivAt_id (x := t)).smul_const C).const_add A
  cases hUnit with
  | intro u hu =>
      have hRingInv :=
        @hasFDerivAt_ringInverse Real _ (Matrix (Fin n) (Fin n) Real) _ _ _ u
      have hRingInv' :
          HasFDerivAt
            (Ring.inverse : Matrix (Fin n) (Fin n) Real -> Matrix (Fin n) (Fin n) Real)
            (-ContinuousLinearMap.mulLeftRight Real
              (Matrix (Fin n) (Fin n) Real) (Inv.inv u) (Inv.inv u))
            (A + SMul.smul t C) := by
        simpa [hu] using hRingInv
      have hInvBase := hRingInv'.comp_hasDerivAt t hLine
      have hInv :
          HasDerivAt
            (fun s : Real => Ring.inverse (A + SMul.smul s C))
            ((-ContinuousLinearMap.mulLeftRight Real
                (Matrix (Fin n) (Fin n) Real) (Inv.inv u) (Inv.inv u)) C)
            t := by
        simpa [Function.comp_def] using hInvBase
      simpa [Matrix.nonsing_inv_eq_ringInverse, hu,
        ContinuousLinearMap.mulLeftRight_apply, mul_assoc] using hInv

/-- Strict positivity is enough to apply the affine-line inverse derivative,
since a strictly positive matrix is automatically a unit. -/
theorem hasDerivAt_inverse_affineLine_of_strictlyPositive
    {n : Nat} (A C : Matrix (Fin n) (Fin n) Real) {t : Real}
    (hPos : IsStrictlyPositive (A + SMul.smul t C)) :
    HasDerivAt
      (fun s : Real => Inv.inv (A + SMul.smul s C))
      (-((Inv.inv (A + SMul.smul t C)) * C * Inv.inv (A + SMul.smul t C)))
      t := by
  exact hasDerivAt_inverse_affineLine A C hPos.isUnit

/-- Cyclic trace normalization for the four-factor resolvent derivative kernel.

This is a thin wrapper around `Matrix.trace_mul_cycle` specialized to the exact
shape that appears in
`hasDerivAt_trace_mul_inverse_affineLine_general`. -/
theorem trace_resolvent_derivative_cycle
    {n : Nat} (B C R : Matrix (Fin n) (Fin n) Real) :
    Matrix.trace (B * R * C * R) = Matrix.trace (R * B * R * C) := by
  simpa [Matrix.mul_assoc] using Matrix.trace_mul_cycle (B * R) C R

/-- Negated form of `trace_resolvent_derivative_cycle`. -/
theorem neg_trace_resolvent_derivative_cycle
    {n : Nat} (B C R : Matrix (Fin n) (Fin n) Real) :
    -Matrix.trace (B * R * C * R) = -Matrix.trace (R * B * R * C) := by
  simpa using congrArg (fun x : Real => -x) (trace_resolvent_derivative_cycle B C R)

/-- General trace-resolvent derivative along an affine line.

This is the reusable trace bridge for the resolvent route. It does not claim
any log-integral, Epstein, Lieb, or trace-concavity statement. -/
theorem hasDerivAt_trace_mul_inverse_affineLine_general
    {n : Nat} (A B C : Matrix (Fin n) (Fin n) Real) {t : Real}
    (hUnit : IsUnit (A + SMul.smul t C)) :
    HasDerivAt
      (fun s : Real => Matrix.trace (B * Inv.inv (A + SMul.smul s C)))
      (-Matrix.trace
        (B * Inv.inv (A + SMul.smul t C) * C * Inv.inv (A + SMul.smul t C)))
      t := by
  have hInv := hasDerivAt_inverse_affineLine A C hUnit
  have hTraceMul := hasFDerivAt_trace_mul_left B (Inv.inv (A + SMul.smul t C))
  have hComp := hTraceMul.comp_hasDerivAt t hInv
  simpa [traceMulLeftCLM, ContinuousLinearMap.comp_apply,
    Matrix.traceLinearMap_apply, LinearMap.mulLeft_apply, mul_assoc] using hComp

/-- Sign-facing cyclic form of the affine-line trace-resolvent derivative.

This repackages `hasDerivAt_trace_mul_inverse_affineLine_general` into the
normal form `-trace (R * B * R * C)` used by the next resolvent-sign MVP. -/
theorem hasDerivAt_trace_mul_inverse_affineLine_general_neg_cycle
    {n : Nat} (A B C : Matrix (Fin n) (Fin n) Real) {t : Real}
    (hUnit : IsUnit (A + SMul.smul t C)) :
    HasDerivAt
      (fun s : Real => Matrix.trace (B * Inv.inv (A + SMul.smul s C)))
      (-Matrix.trace
        (Inv.inv (A + SMul.smul t C) * B * Inv.inv (A + SMul.smul t C) * C))
      t := by
  convert
      (hasDerivAt_trace_mul_inverse_affineLine_general
        (A := A) (B := B) (C := C) (t := t) hUnit) using 1
  simpa [Matrix.mul_assoc] using
    (neg_trace_resolvent_derivative_cycle B C (Inv.inv (A + SMul.smul t C))).symm

/-- Strict positivity is enough for the sign-facing cyclic trace-resolvent
derivative, since a strictly positive matrix is automatically a unit. -/
theorem hasDerivAt_trace_mul_inverse_affineLine_general_neg_cycle_of_strictlyPositive
    {n : Nat} (A B C : Matrix (Fin n) (Fin n) Real) {t : Real}
    (hPos : IsStrictlyPositive (A + SMul.smul t C)) :
    HasDerivAt
      (fun s : Real => Matrix.trace (B * Inv.inv (A + SMul.smul s C)))
      (-Matrix.trace
        (Inv.inv (A + SMul.smul t C) * B * Inv.inv (A + SMul.smul t C) * C))
      t := by
  exact hasDerivAt_trace_mul_inverse_affineLine_general_neg_cycle A B C hPos.isUnit

/-- Strict positivity is enough for the general trace-resolvent derivative,
since a strictly positive matrix is automatically a unit. -/
theorem hasDerivAt_trace_mul_inverse_affineLine_general_of_strictlyPositive
    {n : Nat} (A B C : Matrix (Fin n) (Fin n) Real) {t : Real}
    (hPos : IsStrictlyPositive (A + SMul.smul t C)) :
    HasDerivAt
      (fun s : Real => Matrix.trace (B * Inv.inv (A + SMul.smul s C)))
      (-Matrix.trace
        (B * Inv.inv (A + SMul.smul t C) * C * Inv.inv (A + SMul.smul t C)))
      t := by
  exact hasDerivAt_trace_mul_inverse_affineLine_general A B C hPos.isUnit

/-- Identity-line specialization of
`hasDerivAt_trace_mul_inverse_affineLine_general`. -/
theorem hasDerivAt_trace_mul_inverse_affineLine
    {n : Nat} (A B : Matrix (Fin n) (Fin n) Real) {t : Real}
    (hUnit : IsUnit (A + SMul.smul t (1 : Matrix (Fin n) (Fin n) Real))) :
    HasDerivAt
      (fun s : Real => Matrix.trace
        (B * Inv.inv (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real))))
      (-Matrix.trace
        (B * Inv.inv (A + SMul.smul t (1 : Matrix (Fin n) (Fin n) Real)) *
          Inv.inv (A + SMul.smul t (1 : Matrix (Fin n) (Fin n) Real))))
      t := by
  simpa [mul_assoc] using
    (hasDerivAt_trace_mul_inverse_affineLine_general
      (A := A) (B := B) (C := (1 : Matrix (Fin n) (Fin n) Real)) (t := t) hUnit)

/-- Strict positivity is enough for the identity-line trace-resolvent
derivative, since a strictly positive matrix is automatically a unit. -/
theorem hasDerivAt_trace_mul_inverse_affineLine_of_strictlyPositive
    {n : Nat} (A B : Matrix (Fin n) (Fin n) Real) {t : Real}
    (hPos : IsStrictlyPositive
      (A + SMul.smul t (1 : Matrix (Fin n) (Fin n) Real))) :
    HasDerivAt
      (fun s : Real => Matrix.trace
        (B * Inv.inv (A + SMul.smul s (1 : Matrix (Fin n) (Fin n) Real))))
      (-Matrix.trace
        (B * Inv.inv (A + SMul.smul t (1 : Matrix (Fin n) (Fin n) Real)) *
          Inv.inv (A + SMul.smul t (1 : Matrix (Fin n) (Fin n) Real))))
      t := by
  exact hasDerivAt_trace_mul_inverse_affineLine A B hPos.isUnit

end

end HighDimProb
