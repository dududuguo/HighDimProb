import HighDimProb.RandomMatrix.TraceExp

/-!
# Conditional-state endpoint usage

This examples-only file packages the local state endpoint equalities needed by
the conditional-step Matrix Bernstein route. It deliberately does not bundle
Tropp, Lieb, CFC, independence, integrability, or finite-family primitive
assumptions.
-/

namespace HighDimProb.Examples.RandomMatrix.ConditionalStateEndpointUsage

open MeasureTheory

noncomputable section

/-- Example-local endpoint data for the conditional-step route.

The fields choose the local `state`, `H`, and `Z` convention. The zero and
last endpoints are intentionally stated with final prefixes so examples can
reuse the core trace-exponential endpoint wrappers to reach the full sums. -/
structure ConditionalStateEndpointData {Omega : Type*} [MeasurableSpace Omega]
    {m n : Nat}
    (state : Fin (m + 1) -> RealRandomVariable Omega)
    (X : Fin m -> RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real)
    (theta : Real)
    (H Z : Fin m -> RandomMatrix Omega n n) : Prop where
  hStateZero :
    state 0 =
      fun omega =>
        traceMatrixExp
          (randomMatrixPrefixSum
            (scaledRandomMatrixFamily theta X) (Fin.last m) omega)
  hStateLast :
    state (Fin.last m) =
      fun _omega : Omega =>
        traceMatrixExp (comparisonMatrixPrefixSum K (Fin.last m))
  hStateLeft :
    forall i,
      state i.castSucc =
        fun omega => traceMatrixExp (H i omega + Z i omega)
  hStateRight :
    forall i,
      state i.succ =
        fun omega => traceMatrixExp (H i omega + K i)

/-- The zero endpoint reaches the full scaled random sum via the core wrapper. -/
theorem conditionalState_endpoint_zero_usage {Omega : Type*}
    [MeasurableSpace Omega] {m n : Nat}
    {state : Fin (m + 1) -> RealRandomVariable Omega}
    {X : Fin m -> RandomMatrix Omega n n}
    {K : Fin m -> Matrix (Fin n) (Fin n) Real}
    {theta : Real} {H Z : Fin m -> RandomMatrix Omega n n}
    (h : ConditionalStateEndpointData state X K theta H Z) :
    state 0 =
      fun omega =>
        traceMatrixExp
          (randomMatrixSum (scaledRandomMatrixFamily theta X) omega) := by
  calc
    state 0 =
        (fun omega =>
          traceMatrixExp
            (randomMatrixPrefixSum
              (scaledRandomMatrixFamily theta X) (Fin.last m) omega)) := h.hStateZero
    _ = (fun omega =>
          traceMatrixExp
            (randomMatrixSum (scaledRandomMatrixFamily theta X) omega)) := by
          exact
            traceMatrixExp_randomMatrixPrefixSum_last
              (scaledRandomMatrixFamily theta X)

/-- The last endpoint reaches the full comparison sum via the core wrapper. -/
theorem conditionalState_endpoint_last_usage {Omega : Type*}
    [MeasurableSpace Omega] {m n : Nat}
    {state : Fin (m + 1) -> RealRandomVariable Omega}
    {X : Fin m -> RandomMatrix Omega n n}
    {K : Fin m -> Matrix (Fin n) (Fin n) Real}
    {theta : Real} {H Z : Fin m -> RandomMatrix Omega n n}
    (h : ConditionalStateEndpointData state X K theta H Z) :
    state (Fin.last m) =
      fun _omega : Omega =>
        traceMatrixExp (Finset.univ.sum fun i : Fin m => K i) := by
  calc
    state (Fin.last m) =
        (fun _omega : Omega =>
          traceMatrixExp (comparisonMatrixPrefixSum K (Fin.last m))) := h.hStateLast
    _ = (fun _omega : Omega =>
          traceMatrixExp (Finset.univ.sum fun i : Fin m => K i)) := by
          exact traceMatrixExp_comparisonMatrixPrefixSum_last K

/-- Projection for the left adjacent state identification. -/
theorem conditionalState_endpoint_left_usage {Omega : Type*}
    [MeasurableSpace Omega] {m n : Nat}
    {state : Fin (m + 1) -> RealRandomVariable Omega}
    {X : Fin m -> RandomMatrix Omega n n}
    {K : Fin m -> Matrix (Fin n) (Fin n) Real}
    {theta : Real} {H Z : Fin m -> RandomMatrix Omega n n}
    (h : ConditionalStateEndpointData state X K theta H Z) (i : Fin m) :
    state i.castSucc =
      fun omega => traceMatrixExp (H i omega + Z i omega) :=
  h.hStateLeft i

/-- Projection for the right adjacent state identification. -/
theorem conditionalState_endpoint_right_usage {Omega : Type*}
    [MeasurableSpace Omega] {m n : Nat}
    {state : Fin (m + 1) -> RealRandomVariable Omega}
    {X : Fin m -> RandomMatrix Omega n n}
    {K : Fin m -> Matrix (Fin n) (Fin n) Real}
    {theta : Real} {H Z : Fin m -> RandomMatrix Omega n n}
    (h : ConditionalStateEndpointData state X K theta H Z) (i : Fin m) :
    state i.succ =
      fun omega => traceMatrixExp (H i omega + K i) :=
  h.hStateRight i

end

end HighDimProb.Examples.RandomMatrix.ConditionalStateEndpointUsage
