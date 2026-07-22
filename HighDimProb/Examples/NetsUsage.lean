import HighDimProb.MetricEntropy

/-!
# Epsilon nets, separated sets, and metric entropy

This example follows the standard one-scale argument used throughout metric
entropy: a maximal separated subset is an internal net, a finite internal net
bounds the covering number, and packing and covering numbers control one
another. For the multiscale continuation, see
`HighDimProb.Examples.EmpiricalProcessNetUsage`.
-/

namespace HighDimProb.Examples.NetsUsage

/-- `IsEpsilonNet` is the real-radius interface to Mathlib's metric-cover
predicate. -/
example {α : Type*} [PseudoMetricSpace α] (K N : Set α) (ε : ℝ) :
    IsEpsilonNet K N ε ↔ Metric.IsCover (epsilonRadius ε) K N :=
  isEpsilonNet_iff K N ε

/-- A maximal separated subset cannot leave an uncovered point: adding such a
point would preserve separation and contradict maximality. -/
example {α : Type*} [PseudoMetricSpace α]
    {K N : Set α} {ε : ℝ}
    (hN : MaximalEpsilonSeparatedIn K N ε) :
    IsInternalEpsilonNet K N ε :=
  isInternalEpsilonNet_of_maximalEpsilonSeparatedIn hN

/-- If the maximal separated subset is finite, its cardinality is an explicit
upper bound for the internal covering number. -/
example {α : Type*} [PseudoMetricSpace α]
    {K N : Set α} {ε : ℝ}
    (hN : MaximalEpsilonSeparatedIn K N ε) (hNfin : N.Finite) :
    coveringNumber K ε ≤ (N.ncard : ENat) := by
  exact coveringNumber_le_card_of_isInternalEpsilonNet
    (isInternalEpsilonNet_of_maximalEpsilonSeparatedIn hN) hNfin

/-- Packing and covering numbers sandwich one another, with the usual factor
of two in one direction. -/
example {α : Type*} [PseudoMetricSpace α] (K : Set α) (ε : ℝ) :
    packingNumber K (2 * ε) ≤ coveringNumber K ε ∧
      coveringNumber K ε ≤ packingNumber K ε :=
  packingCoveringInequality K ε

/-- Total boundedness gives an optimal finite internal net whose cardinality is
exactly the covering number. -/
example {α : Type*} [PseudoMetricSpace α]
    {K : Set α} {ε : ℝ} (hε : 0 < ε) (hK : TotallyBounded K) :
    ∃ N : Finset α,
      IsInternalEpsilonNet K (N : Set α) ε ∧
      coveringNumber K ε = (N.card : ENat) ∧
      N.card = (coveringNumber K ε).toNat :=
  exists_finset_isInternalEpsilonNet_of_totallyBounded hε hK

end HighDimProb.Examples.NetsUsage
