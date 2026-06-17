import HighDimProb.RandomMatrix.TraceExp

/-!
# Prefix-state Tropp bookkeeping usage

This examples-only file shows the finite prefix/suffix and trace-exponential
endpoint APIs used by the conditional-step Tropp route. It reuses the core
sum and endpoint lemmas without introducing new finite-sum definitions or
analytic Tropp assumptions.
-/

namespace HighDimProb.Examples.RandomMatrix.PrefixStateTroppUsage

open MeasureTheory

noncomputable section

/-- The full random sum can be viewed as the final random prefix. -/
theorem prefixState_randomMatrixSum_last_usage {Omega : Type*}
    [MeasurableSpace Omega] {m n : Nat}
    (X : Fin m -> RandomMatrix Omega n n) :
    randomMatrixSum X = randomMatrixPrefixSum X (Fin.last m) := by
  exact randomMatrixSum_eq_prefixSum_last X

/-- The final prefix of the scaled family is the full scaled random sum. -/
theorem prefixState_scaledRandomMatrixSum_last_usage {Omega : Type*}
    [MeasurableSpace Omega] {m n : Nat} (theta : Real)
    (X : Fin m -> RandomMatrix Omega n n) :
    randomMatrixPrefixSum (scaledRandomMatrixFamily theta X) (Fin.last m) =
      randomMatrixSum (scaledRandomMatrixFamily theta X) := by
  exact randomMatrixPrefixSum_last (scaledRandomMatrixFamily theta X)

/-- The trace-exponential endpoint form used for a scaled random prefix state. -/
theorem prefixState_scaledTraceExpPrefix_last_usage {Omega : Type*}
    [MeasurableSpace Omega] {m n : Nat} (theta : Real)
    (X : Fin m -> RandomMatrix Omega n n) :
    (fun omega =>
      traceMatrixExp
        (randomMatrixPrefixSum
          (scaledRandomMatrixFamily theta X) (Fin.last m) omega)) =
      fun omega =>
        traceMatrixExp
          (randomMatrixSum (scaledRandomMatrixFamily theta X) omega) := by
  exact
    traceMatrixExp_randomMatrixPrefixSum_last
      (scaledRandomMatrixFamily theta X)

/-- The trace-exponential endpoint form used for a deterministic comparison prefix. -/
theorem prefixState_traceExpComparisonPrefix_last_usage {Omega : Type*} {m n : Nat}
    (K : Fin m -> Matrix (Fin n) (Fin n) Real) :
    (fun _omega : Omega =>
      traceMatrixExp (comparisonMatrixPrefixSum K (Fin.last m))) =
      fun _omega : Omega =>
        traceMatrixExp (Finset.univ.sum fun i : Fin m => K i) := by
  exact traceMatrixExp_comparisonMatrixPrefixSum_last K

/-- Random prefix successor bookkeeping for adjacent conditional states. -/
theorem prefixState_randomPrefix_succ_usage {Omega : Type*}
    [MeasurableSpace Omega] {m n : Nat}
    (X : Fin m -> RandomMatrix Omega n n) (i : Fin m) :
    randomMatrixPrefixSum X i.succ =
      fun omega => randomMatrixPrefixSum X i.castSucc omega + X i omega := by
  exact randomMatrixPrefixSum_succ X i

/-- Deterministic comparison prefix successor bookkeeping. -/
theorem prefixState_comparisonPrefix_succ_usage {m n : Nat}
    (K : Fin m -> Matrix (Fin n) (Fin n) Real) (i : Fin m) :
    comparisonMatrixPrefixSum K i.succ =
      comparisonMatrixPrefixSum K i.castSucc + K i := by
  exact comparisonMatrixPrefixSum_succ K i

/-- Deterministic comparison suffix peeling bookkeeping. -/
theorem prefixState_comparisonSuffix_succ_usage {m n : Nat}
    (K : Fin m -> Matrix (Fin n) (Fin n) Real) (i : Fin m) :
    comparisonMatrixSuffixSum K i.castSucc =
      K i + comparisonMatrixSuffixSum K i.succ := by
  exact comparisonMatrixSuffixSum_succ K i

end

end HighDimProb.Examples.RandomMatrix.PrefixStateTroppUsage
