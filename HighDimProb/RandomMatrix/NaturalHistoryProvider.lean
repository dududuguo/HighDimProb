import HighDimProb.RandomMatrix.HardboneStatements

/-!
# Natural-history measurability provider

This module proves the smallest suffix-entry measurability bridge needed by
the Tropp natural-history statement. It does not prove independence or
conditional expectation.
-/

namespace HighDimProb

open HighDimProb
open MeasureTheory
open scoped BigOperators

noncomputable section

/-- Natural-history measurability from explicit suffix-entry measurability.

This is the smallest honest bridge for the Tropp natural-history statement:
the deterministic comparison prefix is constant, and the random suffix is a
finite sum of explicitly measurable suffix entries. It does not prove
independence or conditional expectation. -/
theorem troppNaturalHistoryMeasurable_of_suffix_entry_measurable
    {Omega : Type*} [MeasurableSpace Omega] {m n : Nat}
    (theta : Real)
    (X : Fin m -> HighDimProb.RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real)
    (mHist : Fin m -> MeasurableSpace Omega)
    (hSuffix : forall i : Fin m,
      forall j : Fin m,
        ((i.succ : Fin (m + 1)) : Nat) <= (j : Nat) ->
          forall r c,
            @Measurable Omega Real (mHist i) inferInstance
              (fun omega => X j omega r c)) :
    HighDimProb.troppNaturalHistoryMeasurable_statement theta X K mHist := by
  intro _hHistSub i r c
  have hComp : @Measurable Omega Real (mHist i) inferInstance
      (fun omega => HighDimProb.troppComparisonHistory K i r c) :=
    measurable_const
  have hRand : @Measurable Omega Real (mHist i) inferInstance
      (fun omega => HighDimProb.troppRandomHistory theta X i omega r c) := by
    simpa [HighDimProb.troppRandomHistory, HighDimProb.randomMatrixSuffixSum,
      HighDimProb.comparisonMatrixSuffixSum, HighDimProb.scaledRandomMatrixFamily,
      Matrix.sum_apply]
      using
        (Finset.measurable_sum
          (s := Finset.univ.filter fun j : Fin m =>
            ((i.succ : Fin (m + 1)) : Nat) <= (j : Nat))
          (f := fun j : Fin m => fun omega => theta * X j omega r c)
          (hf := by
            intro j hj
            have hj' : ((i.succ : Fin (m + 1)) : Nat) <= (j : Nat) := by
              simpa using hj
            exact (hSuffix i j hj' r c).const_mul theta))
  simpa [HighDimProb.troppStateHistory] using hComp.add hRand

end

end HighDimProb
