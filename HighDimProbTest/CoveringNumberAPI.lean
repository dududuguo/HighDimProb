import HighDimProb.Geometry

namespace HighDimProbTest

open HighDimProb
open scoped BigOperators ENNReal NNReal Topology

#check l1Ball
#check coveringNumber_euclideanBall_le
#check coveringNumber_l1Ball_le

example {ι : Type*} [Nonempty ι] [Fintype ι] {R eps : ℝ}
    (hR : 0 ≤ R) (heps : 0 < eps) :
    coveringNumber (Metric.closedBall (0 : EuclideanSpace ℝ ι) R) eps ≤
      (Nat.ceil ((1 + 2 * R / eps) ^ Fintype.card ι) : ENat) := by
  exact coveringNumber_euclideanBall_le hR heps

example {ι : Type*} [Nonempty ι] [Fintype ι] {R eps : ℝ}
    (hR : 0 ≤ R) (heps : 0 < eps) :
    coveringNumber (l1Ball (ι := ι) R) eps ≤
      (Nat.ceil ((1 + 4 * R / eps) ^ Fintype.card ι) : ENat) := by
  exact coveringNumber_l1Ball_le hR heps

example {ι : Type*} [Nonempty ι] [Fintype ι] {R eps : ℝ}
    (heps : 0 < eps) :
    ∃ N : Finset (EuclideanSpace ℝ ι),
      IsInternalEpsilonNet (Metric.closedBall (0 : EuclideanSpace ℝ ι) R)
        (N : Set (EuclideanSpace ℝ ι)) (eps / 2) := by
  obtain ⟨N, hN, _, _⟩ :=
    exists_finset_isInternalEpsilonNet_of_totallyBounded
      (by linarith : 0 < eps / 2)
      (by simpa using
        (isCompact_closedBall (0 : EuclideanSpace ℝ ι) R).totallyBounded)
  exact ⟨N, hN⟩

example {ι : Type*} [Nonempty ι] [Fintype ι] :
    (0 : EuclideanSpace ℝ ι) ∈ l1Ball 0 := by
  simp [l1Ball]

end HighDimProbTest
