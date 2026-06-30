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

/-- Tropp history/current-step independence from finite-family independence and
explicit measurability of the matrix-valued summands.

This is the smallest honest independence bridge for the conditioning exact
chain: `iIndepFun X P` alone is not enough to use Mathlib's finite-sum
independence lemmas on matrix-valued families, so the measurable family members
stay explicit in the statement. -/
theorem troppHistoryStepIndependent_of_iIndepFun_of_measurable
    {Omega : Type*} [mOmega : MeasurableSpace Omega]
    {P : MeasureTheory.Measure Omega} {m n : Nat}
    (theta : Real)
    (X : Fin m -> RandomMatrix Omega n n)
    (K : Fin m -> Matrix (Fin n) (Fin n) Real)
    (hIndep : ProbabilityTheory.iIndepFun X P)
    (hMeas : forall i, Measurable (X i)) :
    forall i,
      @ProbabilityTheory.IndepFun Omega _ _ mOmega _ _
        (@troppStateHistory Omega mOmega m n theta X K i)
        (@troppCurrentRandomStep Omega mOmega m n theta X i) P := by
  letI : MeasurableAdd₂ (Matrix (Fin n) (Fin n) Real) := by
    refine ⟨?_⟩
    refine measurable_pi_lambda _ ?_
    intro r
    refine measurable_pi_lambda _ ?_
    intro c
    have hfst :
        Measurable
          (fun p : Matrix (Fin n) (Fin n) Real × Matrix (Fin n) (Fin n) Real =>
            p.1 r c) := by
      exact (measurable_pi_apply c).comp
        ((measurable_pi_apply r).comp measurable_fst)
    have hsnd :
        Measurable
          (fun p : Matrix (Fin n) (Fin n) Real × Matrix (Fin n) (Fin n) Real =>
            p.2 r c) := by
      exact (measurable_pi_apply c).comp
        ((measurable_pi_apply r).comp measurable_snd)
    simpa [Matrix.add_apply] using hfst.add hsnd
  intro i
  have hScale :
      Measurable fun M : Matrix (Fin n) (Fin n) Real => SMul.smul theta M := by
    refine measurable_pi_lambda _ ?_
    intro r
    refine measurable_pi_lambda _ ?_
    intro c
    have hEntry :
        Measurable fun M : Matrix (Fin n) (Fin n) Real => M r c := by
      exact (measurable_pi_apply c).comp (measurable_pi_apply r)
    simpa [smul_eq_mul] using (measurable_const.mul hEntry)
  have hScaled :
      ProbabilityTheory.iIndepFun (scaledRandomMatrixFamily theta X) P := by
    simpa [scaledRandomMatrixFamily, scaledRandomMatrix] using
      hIndep.comp
        (fun _ : Fin m =>
          fun M : Matrix (Fin n) (Fin n) Real => SMul.smul theta M)
        (fun _ => hScale)
  have hScaledMeas :
      forall j, Measurable (scaledRandomMatrixFamily theta X j) := by
    intro j
    simpa [scaledRandomMatrixFamily, scaledRandomMatrix] using
      hScale.comp (hMeas j)
  have hmem : i ∉ Finset.univ.filter fun j : Fin m =>
      ((i.succ : Fin (m + 1)) : Nat) <= (j : Nat) := by
    intro hi
    have hle : ((i.succ : Fin (m + 1)) : Nat) <= (i : Nat) := by
      simpa using (Finset.mem_filter.mp hi).2
    exact Nat.not_succ_le_self _ hle
  have hSuffixIndepSum :
      ProbabilityTheory.IndepFun
        ((Finset.univ.filter fun j : Fin m =>
            ((i.succ : Fin (m + 1)) : Nat) <= (j : Nat)).sum
          fun j => scaledRandomMatrixFamily theta X j)
        (scaledRandomMatrixFamily theta X i) P :=
    hScaled.indepFun_finset_sum_of_notMem hScaledMeas
      (s := Finset.univ.filter fun j : Fin m =>
        ((i.succ : Fin (m + 1)) : Nat) <= (j : Nat))
      (i := i) hmem
  have hSuffixEq :
      randomMatrixSuffixSum (scaledRandomMatrixFamily theta X) i.succ =
        (Finset.univ.filter fun j : Fin m =>
            ((i.succ : Fin (m + 1)) : Nat) <= (j : Nat)).sum
          fun j => scaledRandomMatrixFamily theta X j := by
    ext omega r c
    simp [randomMatrixSuffixSum, comparisonMatrixSuffixSum, Matrix.sum_apply]
  have hSuffixIndep :
      ProbabilityTheory.IndepFun
        (randomMatrixSuffixSum (scaledRandomMatrixFamily theta X) i.succ)
        (scaledRandomMatrixFamily theta X i) P := by
    simpa [hSuffixEq] using hSuffixIndepSum
  have hAdd :
      Measurable fun A : Matrix (Fin n) (Fin n) Real =>
        troppComparisonHistory K i + A := by
    refine measurable_pi_lambda _ ?_
    intro r
    refine measurable_pi_lambda _ ?_
    intro c
    have hEntry :
        Measurable fun A : Matrix (Fin n) (Fin n) Real => A r c := by
      exact (measurable_pi_apply c).comp (measurable_pi_apply r)
    simpa [Function.comp] using (measurable_const.add hEntry)
  have hHist :
      ProbabilityTheory.IndepFun
        (fun omega => troppComparisonHistory K i + troppRandomHistory theta X i omega)
        (troppCurrentRandomStep theta X i) P := by
    simpa [troppRandomHistory, troppCurrentRandomStep, troppStateHistory] using
      hSuffixIndep.comp hAdd measurable_id
  simpa [troppStateHistory] using hHist

end

end HighDimProb
