import HighDimProb.Concentration.Dudley

namespace HighDimProbTest

open HighDimProb MeasureTheory

set_option autoImplicit false

#check @HighDimProb.Dudley.Internal.expect_sup'_abs_sub_root_le_sum_level_sup
#check @HighDimProb.Dudley.Internal.expect_sup'_abs_sub_root_le_finiteEntropySum
#check @HighDimProb.Dudley.truncatedBound

/-- Focused support-layer check for the finite terminal-net consumer. -/
example
    {Omega alpha : Type*} [MeasurableSpace Omega] [PseudoMetricSpace alpha]
    {P : Measure Omega} [IsProbabilityMeasure P]
    {X : RandomProcess Omega alpha Real}
    {K : Set alpha} {t0 : alpha} {R sigma : Real} (L : Nat)
    (hK : TotallyBounded K) (ht0 : t0 ∈ K) (hR : 0 < R)
    (hdist : forall t, t ∈ K -> dist t t0 ≤ R)
    (hXMeas : forall t, Measurable (X t))
    (hX : HasSubGaussianMGFIncrements P X sigma) (hsigma : 0 < sigma) :
    ∃ T : Finset alpha, ∃ hT : T.Nonempty,
      (T : Set alpha) ⊆ K ∧
      IsInternalEpsilonNet K (T : Set alpha) (dyadicRadius R L) ∧
      expect P (fun omega => T.sup' hT (fun t => |X t omega - X t0 omega|)) ≤
        4 * sigma * (∫ t in dyadicRadius R (L + 1)..R,
          Real.sqrt (2 * Real.log
            (2 * ((coveringNumber K t).toNat : Real)))) :=
  Dudley.truncatedBound L hK ht0 hR hdist hXMeas hX hsigma

end HighDimProbTest
